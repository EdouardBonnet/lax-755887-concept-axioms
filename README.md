# Concept-axiom stress test

Lax submission **lax-755887**, based on
[AxiomsAreNonsense](https://github.com/Shreyas4991/AxiomsAreNonsense/tree/5b95b8b23ea8215f2011469054071fee48812e72)
at commit `5b95b8b23ea8215f2011469054071fee48812e72`.
No submission or registration is needed to run this experiment.

## Observed result

Tested on 2026-10-01 with the **current Lax checkout at `c730f81`**, including
the requirement that concept axiom types inhabit `Prop`, Lean **4.33.0**, and
the manifest's pinned mathlib revision. `lax build --replay` passed:
24 concepts, 26 statements, 21 proofs. The independently recomputed proof
network contains **12 proven controls and 14 unproven statements**. Every
conditional proof has precisely its expected concept-axiom dependency.

| Example | Deliberately unchecked assumption | Observed consequence |
| --- | --- | --- |
| Persistent queue | Telescoping without adjacent-potential compatibility | False linear bound remains open; exact quadratic cost is proven |
| Reused key | Compose equal marginals using the same randomness | False attacker-success claim remains open; XOR success is proven |
| Limit decider | Computability passes to an increasing union | Halting decidability remains open; its negation is proven |
| Stuttering | Abstract well-foundedness allows unbounded stuttering | Concrete termination remains open; a concrete two-cycle is proven |
| Leader election | A common model of uniqueness and equivariance exists | `False` remains open; separate models and no common model are proven |
| Merge cost | Uniform linear bound on work `k * 2^k` | `False` remains open; impossibility of the bound is proven |
| Added circular controls | Two claims imply each other; one implies itself | Both claims remain open |

Here "proven" means grounded in the permitted background axioms by the
least fixed point of the proof network. A checked implication from an open
contract is a conditional proof, not a grounded conclusion. Concepts for the
contracts, conclusions, and controls are separate so this distinction is
visible in the preview graph. Proof annotations assert exact expected
assumptions, which Lax cross-checks against its own collector.

These examples do **not** exhibit a failure of that design. They do illustrate
why merely compiling a theorem is insufficient, and why reviewers must check
a contract's actual meaning and missing hypotheses. This is a finite stress
test, not a general soundness proof of the validator.

## Validation probes

The probe script constructs isolated temporary submissions, without changing
the accepted concepts or invoking `lax submit`.

* **Original leader interface:** rejected under `statement-type` for the
  data-valued `protocol` axiom and under `axiom-free` because
  `rotation_equivariance` uses that axiom in its type.
  The accepted preview instead uses the proposition
  `∃ run, UniqueLeader run ∧ Equivariant run`. This packaging change is explicit;
  it is not a claim that the original interface passes Lax.
* **Dependent proposition:** choosing a natural number from a propositional
  axiom, then mentioning it in another statement, is rejected under `axiom-free`.
* **Hidden imported dependencies:** 32 structures indexed by a witness chosen
  from the false merge-cost axiom are rejected. On this exact naming and Lean
  version, Lean omits the dependency for `S4`, `S10`, `S12`, and `S22` and their
  imported statement uses. Lax reports the missing dependency, including on
  those statement uses. Its independent collector does not trust Lean's
  exported axiom cache.
* **Bare data axiom:** `axiom chosen : Nat` is rejected under `statement-type`.
  This tests the propositional-type restriction independently of the
  dependent-statement restriction. An initial run with the older installed
  CLI 0.1.50 accepted this probe; the current checkout closes that gap.
  The older transcripts are retained in `audit/results/cli-0.1.50/`.

The separately preserved upstream `#guard_msgs` example reproduces the
[Lean imported-axiom reporting bug](https://github.com/leanprover/lean4/issues/15226)
on 4.33.0. Its original source targeted 4.34.1. Only the import path was changed
for the local two-file layout. This is a diagnostic false negative, not an
assumption-free proof of `False` or an accepted Lax exploit.

## Reproduce and preview

```sh
lax build --replay
python3 scripts/check-network.py
python3 scripts/check-lean-audit.py
python3 scripts/probe-validation.py
lax serve . --port 8123
```

For the adjacent development checkout used in this experiment, use
`node ../lax/bin/lax.js build --replay`,
`python3 scripts/probe-validation.py --lax ../lax/bin/lax.js`, and
`node ../lax/bin/lax.js serve . --port 8123`. The installed CLI may lag this
checkout. The probe expectations require all four invalid packages to be
rejected, including the bare data axiom. Generated transcripts and the
network summary are under `audit/results/`; probe workspaces are under `/tmp`
and their locations appear in `validation.json`.

With the preview running, `node scripts/check-preview.mjs` checks all 21 proof
page badges and all 26 statement source statuses in Chrome, and saves a
screenshot. It uses the adjacent website checkout's `playwright-core`; set
`PLAYWRIGHT_MODULE`, `CHROME`, or `PREVIEW_URL` to override the local defaults.

The local preview is at <http://localhost:8123/lax-755887/> while the server is running.
The archive page is <https://laxarchive.org/lax-755887/>.
The upstream examples are credited through the abstract, bibliography, and
this document. The source examples use Lean 4.34.1; the accepted adaptations
were checked in the active Lax environment, 4.33.0.
