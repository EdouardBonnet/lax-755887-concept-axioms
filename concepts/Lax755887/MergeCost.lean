

/-!
---
title: A uniform linear bound on merge costs
type: theorem
---
At input size $2^k$, the work is $k 2^k$. The assertion of a uniform linear bound is deliberately false. It is the axiom used by the imported-dependency example.
-/

namespace Lax755887.MergeCost

axiom linearMergeCost : ∃ C : Nat, ∀ k : Nat, k * 2 ^ k ≤ C * 2 ^ k

end Lax755887.MergeCost
