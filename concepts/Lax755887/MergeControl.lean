

/-!
---
title: No uniform linear bound on merge costs
type: theorem
---
Taking $k=C+1$ refutes the proposed uniform bound without assuming the cost contract.
-/

namespace Lax755887.MergeControl

axiom no_linear_bound : ¬ ∃ C : Nat, ∀ k : Nat, k * 2 ^ k ≤ C * 2 ^ k

end Lax755887.MergeControl
