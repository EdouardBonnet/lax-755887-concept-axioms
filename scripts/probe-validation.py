#!/usr/bin/env python3
"""Run intentionally invalid packages in temporary repositories; never submit."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--lax', default='lax', help='Lax executable; use the current development checkout when needed')
args = parser.parse_args()
LAX = str(Path(args.lax).resolve()) if '/' in args.lax else args.lax
LAX_COMMAND = ['node', LAX] if LAX.endswith('.js') else [LAX]
ROOT = Path(__file__).resolve().parents[1]
N = 'Lax755887'
RESULTS = ROOT / 'audit' / 'results'
RESULTS.mkdir(exist_ok=True)

def run(args, cwd, **kwargs):
    return subprocess.run(args, cwd=cwd, text=True, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, **kwargs)

def module(name, body, imports=''):
    return f'''{imports}
/-!
---
title: Validation probe {name}
type: test
---
Intentionally invalid concept used to test the validator.
-/
namespace {N}.{name}
{body}
end {N}.{name}
'''

probes = {
    'leader-original': ({
        'LeaderElection': (ROOT / 'concepts' / N / 'LeaderElection.lean').read_text(),
        'OriginalLeader': module('OriginalLeader', f'''open {N}.LeaderElection
axiom protocol : Protocol
axiom rotation_equivariance : Equivariant protocol.run''', f'import {N}.LeaderElection'),
    }, ['statement-type', 'axiom-free']),
    'data-axiom-only': ({
        'Data': module('Data', 'axiom chosen : Nat'),
    }, ['statement-type']),
    'dependent-proposition': ({
        'Dependent': module('Dependent', '''axiom witness : ∃ n : Nat, n = 0
noncomputable def selected : Nat := Classical.choose witness
axiom selected_is_zero : selected = 0'''),
    }, ['axiom-free']),
    'hidden-import': ({
        'Hidden': module('Hidden', '''axiom linearMergeCost : ∃ C : Nat, ∀ k : Nat, k * 2 ^ k ≤ C * 2 ^ k
noncomputable def pick : Nat := Classical.choose linearMergeCost
''' + '\n'.join(f'structure S{i} where\n  x : Fin (pick + 1)\n' for i in range(32))),
        'HiddenUse': module('HiddenUse', '\n'.join(f'axiom usesS{i} : {N}.Hidden.S{i} → True' for i in range(32)), f'import {N}.Hidden'),
    }, ['axiom-free']),
}
summary = []
for name, (modules, expected) in probes.items():
    dest = Path(tempfile.mkdtemp(prefix='lax-axioms-' + name + '-'))
    for file in ['manifest.yaml', 'abstract.md', 'LICENSE', '.gitignore']:
        shutil.copy2(ROOT / file, dest / file)
    for package in ['concepts', 'proofs']:
        pkg = dest / package
        pkg.mkdir()
        for file in ['lakefile.toml', 'lean-toolchain', 'lake-manifest.json']:
            shutil.copy2(ROOT / package / file, pkg / file)
        (pkg / '.lake').mkdir()
        shutil.copy2(ROOT / package / '.lake/package-overrides.json', pkg / '.lake/package-overrides.json')
    (dest / 'concepts' / N).mkdir()
    for mod, content in modules.items():
        (dest / 'concepts' / N / (mod + '.lean')).write_text(content)
    (dest / 'concepts' / (N + '.lean')).write_text(''.join(f'import {N}.{mod}\n' for mod in modules))
    (dest / 'proofs' / (N + 'Proofs.lean')).write_text('')
    for cmd in [['git', 'init', '-q'], ['git', 'add', '.'], ['git', 'commit', '-qm', 'Local validation probe']]:
        result = run(cmd, dest)
        if result.returncode:
            raise RuntimeError(result.stdout)
    result = run(LAX_COMMAND + ['build', '--only', 'concepts', '--no-color', '-v'], dest)
    (RESULTS / (name + '.log')).write_text(result.stdout)
    passed = result.returncode != 0 and all(rule in result.stdout for rule in expected)
    if name == 'hidden-import':
        query = dest / 'ImportedAudit.lean'
        query.write_text(f'import {N}.HiddenUse\n' + ''.join(f'#print axioms {N}.Hidden.S{i}\n#print axioms {N}.HiddenUse.usesS{i}\n' for i in range(32)))
        diagnostic = run(['lake', 'env', 'lean', str(query)], dest / 'concepts')
        (RESULTS / 'hidden-import-lean-report.log').write_text(diagnostic.stdout)
        assert diagnostic.returncode == 0, diagnostic.stdout
        for i in [4, 10, 12, 22]:
            assert f"'{N}.Hidden.S{i}' does not depend on any axioms" in diagnostic.stdout
            assert f'concept declaration {N}.HiddenUse.usesS{i} depends on axiom {N}.Hidden.linearMergeCost' in result.stdout
    row = dict(probe=name, expectedRules=expected, exitCode=result.returncode,
               passed=passed, workspace=str(dest))
    summary.append(row)
    print(json.dumps(row), flush=True)
    if not passed:
        print(result.stdout, flush=True)
(RESULTS / 'validation.json').write_text(json.dumps(summary, indent=2) + '\n')
assert all(row['passed'] for row in summary), 'Unexpected validation result'
