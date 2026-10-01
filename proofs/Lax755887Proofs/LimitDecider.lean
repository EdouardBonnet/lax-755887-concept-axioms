import Lax755887.LimitDeciderContract
import Lax755887.LimitDeciderClaim
import Lax755887.LimitDeciderControls

namespace Lax755887Proofs.LimitDecider

open Lax755887.LimitDecider Lax755887.LimitDeciderContract

open Nat.Partrec (Code)
open Nat.Partrec.Code

/--
---
conclusion: Lax755887.LimitDeciderControls.accepted_computable
---

-/
theorem accepted_computable (fuel : ℕ) : ComputablePred (Accepted fuel) := by
  have h := Primrec.option_isSome.to_comp.comp
    (primrec_evaln.to_comp.comp ((Computable.const fuel).pair Computable.id |>.pair (Computable.const 0)))
  unfold Accepted
  apply Computable.computablePred
  simpa using h

/--
---
conclusion: Lax755887.LimitDeciderControls.halting_not_computable
---

-/
theorem halting_not_computable : ¬ ComputablePred (fun c : Code => (eval c 0).Dom) := ComputablePred.halting_problem 0

/--
---
conclusion: Lax755887.LimitDeciderClaim.halting_is_computable
assumptions:
  - Lax755887.LimitDeciderContract.monotone_limit
---

-/
theorem halting_is_computable : ComputablePred (fun c : Code => (eval c 0).Dom) := by
  have monotone : ∀ n c, Accepted n c → Accepted (n + 1) c := by
    intro n c h
    obtain ⟨value, hv⟩ := Option.isSome_iff_exists.mp h
    apply Option.isSome_iff_exists.mpr
    exact ⟨value, evaln_mono (Nat.le_succ n) hv⟩
  apply (monotone_limit Accepted monotone accepted_computable).of_eq
  intro c
  constructor
  · rintro ⟨fuel, h⟩
    obtain ⟨value, hv⟩ := Option.isSome_iff_exists.mp h
    exact (evaln_sound hv).1
  · intro h
    obtain ⟨fuel, hv⟩ := evaln_complete.mp (Part.get_mem h)
    exact ⟨fuel, Option.isSome_iff_exists.mpr ⟨_, hv⟩⟩

end Lax755887Proofs.LimitDecider
