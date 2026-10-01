import Lax755887.PersistentQueueContract
import Lax755887.PersistentQueueClaim
import Lax755887.PersistentQueueControls

namespace Lax755887Proofs.PersistentQueue

open Lax755887.PersistentQueue Lax755887.PersistentQueueContract

/--
---
conclusion: Lax755887.PersistentQueueControls.dequeue_charge
---

-/
theorem dequeue_charge (n : ℕ) : amortized (dequeue n) = 1 := by
  simp [amortized, dequeue]

/--
---
conclusion: Lax755887.PersistentQueueControls.actual_work
---

-/
theorem actual_work (n : ℕ) :
    totalWork (List.replicate (n + 1) (dequeue n)) = (n + 1) ^ 2 := by
  simp [totalWork, dequeue, List.sum_replicate, pow_two]

/--
---
conclusion: Lax755887.PersistentQueueClaim.repeated_dequeue_linear
assumptions:
  - Lax755887.PersistentQueueContract.telescoping
---

-/
theorem repeated_dequeue_linear :
    ∃ C : ℕ, ∀ n, totalWork (List.replicate (n + 1) (dequeue n)) ≤ C * (n + 1) := by
  refine ⟨2, fun n => ?_⟩
  have h := telescoping (dequeue n) (List.replicate n (dequeue n))
  have charges : ((dequeue n :: List.replicate n (dequeue n)).map amortized).sum = n + 1 := by
    simp [dequeue_charge, List.sum_replicate]
    ring
  rw [charges] at h
  have bound : (totalWork (List.replicate (n + 1) (dequeue n)) : ℤ) ≤ 2 * (n + 1) := by
    rw [List.replicate_succ]
    dsimp only [dequeue] at h ⊢
    linarith
  exact_mod_cast bound

end Lax755887Proofs.PersistentQueue
