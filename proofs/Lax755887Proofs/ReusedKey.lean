import Lax755887.ReusedKeyContract
import Lax755887.ReusedKeyClaim
import Lax755887.ReusedKeyControls

namespace Lax755887Proofs.ReusedKey

open Lax755887.ReusedKey Lax755887.ReusedKeyContract

/--
---
conclusion: Lax755887.ReusedKeyControls.rekey
---

-/
theorem rekey {α : Type} (f : Bool → α) : SameLaw f (fun k => f (!k)) := by
  intro test
  simp [probability, add_comm]

/--
---
conclusion: Lax755887.ReusedKeyControls.complement
---

-/
theorem complement (event : Bool → Bool) :
    probability (fun k => !(event k)) = 1 - probability event := by
  cases h₀ : event false <;> cases h₁ : event true <;>
    norm_num [probability, h₀, h₁]

/--
---
conclusion: Lax755887.ReusedKeyControls.xor_attack_succeeds
---

-/
theorem xor_attack_succeeds : success (fun c => Bool.xor c.1 c.2) = 1 := by
  norm_num [success, probability, transcript]

/--
---
conclusion: Lax755887.ReusedKeyClaim.every_attacker_is_unbiased
assumptions:
  - Lax755887.ReusedKeyContract.parallel_composition
---

-/
theorem every_attacker_is_unbiased : ∀ guess, success guess = 1 / 2 := by
  intro guess
  have marginal : SameLaw (fun k : Bool => k) (fun k : Bool => !k) := rekey id
  have joint := parallel_composition id id id (fun k => !k) (fun _ => rfl) marginal
  have observed : probability (fun k => guess (transcript false k)) =
      probability (fun k => guess (transcript true k)) := by
    simpa [transcript] using joint guess
  unfold success
  rw [complement, observed]
  ring

end Lax755887Proofs.ReusedKey
