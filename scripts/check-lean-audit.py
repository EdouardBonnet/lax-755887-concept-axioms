#!/usr/bin/env python3
"""Reproduce the upstream diagnostic bug on the submission's Lean version."""
import os
from pathlib import Path
import subprocess
import tempfile
root = Path(__file__).resolve().parents[1]
version = (root / 'concepts/lean-toolchain').read_text().strip()
with tempfile.TemporaryDirectory(prefix='lax-axioms-lean-audit-') as d:
    commands = [
        ['elan', 'run', version, 'lean', '-o', str(Path(d) / 'HiddenAxiomLibrary.olean'), 'audit/HiddenAxiomLibrary.lean'],
        ['elan', 'run', version, 'lean', 'audit/HiddenAxiomAudit.lean'],
    ]
    for command in commands:
        subprocess.run(command, cwd=root, env={**os.environ, 'LEAN_PATH': d}, check=True)
print('PASS: upstream #guard_msgs reproduce the false-negative imported axiom reports on ' + version)
