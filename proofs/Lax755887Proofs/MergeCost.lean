import Lax755887.MergeCost
import Lax755887.MergeClaim
import Lax755887.MergeControl

namespace Lax755887Proofs.MergeCost

/--
---
conclusion: Lax755887.MergeControl.no_linear_bound
---

-/
theorem no_linear_bound : ¬ ∃ C : Nat, ∀ k : Nat, k * 2 ^ k ≤ C * 2 ^ k := by
  rintro ⟨C, bound⟩
  have impossible : C + 1 ≤ C :=
    Nat.le_of_mul_le_mul_right (bound (C + 1)) (Nat.two_pow_pos (C + 1))
  exact Nat.not_le_of_lt (Nat.lt_succ_self C) impossible

/--
---
conclusion: Lax755887.MergeClaim.cost_axiom_is_inconsistent
assumptions:
  - Lax755887.MergeCost.linearMergeCost
---

-/
theorem cost_axiom_is_inconsistent : False :=
  no_linear_bound Lax755887.MergeCost.linearMergeCost

end Lax755887Proofs.MergeCost
