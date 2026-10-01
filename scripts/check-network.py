#!/usr/bin/env python3
"""Assert exact dependencies and the least-fixed-point result of the local build."""
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
out = json.loads((root / 'build-output.json').read_text())
N = 'Lax755887'
P = N + 'Proofs'
expected = {
    'PersistentQueue.repeated_dequeue_linear': 'PersistentQueueContract.telescoping',
    'ReusedKey.every_attacker_is_unbiased': 'ReusedKeyContract.parallel_composition',
    'LimitDecider.halting_is_computable': 'LimitDeciderContract.monotone_limit',
    'Stuttering.machine_terminates': 'StutteringContract.termination_transfer',
    'LeaderElection.contracts_conflict': 'LeaderContract.exists_protocol',
    'MergeCost.cost_axiom_is_inconsistent': 'MergeCost.linearMergeCost',
    'CircularClaims.first_from_second': 'CircularClaims.second',
    'CircularClaims.second_from_first': 'CircularClaims.first',
    'CircularClaims.first_from_itself': 'CircularClaims.first',
}
statements = {s['id'] for c in out['concepts'] for s in c['statements']}
proofs = out['proofs']
assert len(out['concepts']) == 24
assert len(statements) == 26
assert len(proofs) == 21
for p in proofs:
    short = p['id'].removeprefix(P + '.')
    assumptions = [N + '.' + expected[short]] if short in expected else []
    assert p['assumptions'] == assumptions, (p['id'], p['assumptions'], assumptions)
assert {p['id'].removeprefix(P + '.') for p in proofs} >= set(expected)
proven = set()
while True:
    after = proven | {p['conclusion'] for p in proofs if set(p['assumptions']) <= proven}
    if after == proven:
        break
    proven = after
expectations = json.loads((root / 'audit/expected-status.json').read_text())
controls = set(expectations['proven'])
assert statements == controls | set(expectations['open'])
assert not controls & set(expectations['open'])
assert {c['id'] for c in out['concepts'] if not c['statements']} == set(expectations['definitions'])
assert proven == controls, (proven - controls, controls - proven)
assert len(proven) == 12
assert len(statements - proven) == 14
summary = dict(concepts=len(out['concepts']), statements=len(statements), proofs=len(proofs),
               proven=sorted(proven), unproven=sorted(statements - proven),
               conditionalProofs=len(expected), groundedProofs=len(proofs) - len(expected))
(root / 'audit' / 'results').mkdir(exist_ok=True)
(root / 'audit' / 'results' / 'network.json').write_text(json.dumps(summary, indent=2) + '\n')
print('PASS: 12 grounded controls; all 14 false/circular statements remain unproven; 9 exact conditional dependencies.')
