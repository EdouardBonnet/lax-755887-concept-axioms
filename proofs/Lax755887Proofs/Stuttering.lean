import Lax755887.StutteringContract
import Lax755887.StutteringClaim
import Lax755887.StutteringControls

namespace Lax755887Proofs.Stuttering

open Lax755887.Stuttering Lax755887.StutteringContract

/--
---
conclusion: Lax755887.StutteringControls.terminal_cycle
---

-/
theorem terminal_cycle : tick (tick (0, false)) = (0, false) := rfl

/--
---
conclusion: Lax755887.StutteringClaim.machine_terminates
assumptions:
  - Lax755887.StutteringContract.termination_transfer
---

-/
theorem machine_terminates : WellFounded Step := by
  apply termination_transfer Step (· < ·) Prod.fst Nat.lt_wfRel.wf
  rintro ⟨n, phase⟩ next rfl
  cases phase with
  | false => exact Or.inl rfl
  | true =>
    by_cases h : n = 0
    · left; simp [tick, h]
    · right; dsimp [tick]; omega

end Lax755887Proofs.Stuttering
