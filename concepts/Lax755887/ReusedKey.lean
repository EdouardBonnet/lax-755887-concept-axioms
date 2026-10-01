import Mathlib

/-!
---
title: Reusing a one-bit encryption pad — definitions
type: definition
---
Equal marginal distributions do not determine a joint distribution. The composition contract deliberately omits a condition on joint randomness.
-/

namespace Lax755887.ReusedKey

def probability (event : Bool → Bool) : ℚ :=
  ((if event false then 1 else 0) + (if event true then 1 else 0)) / 2

def SameLaw {α : Type} (X Y : Bool → α) : Prop :=
  ∀ test : α → Bool, probability (fun k => test (X k)) = probability (fun k => test (Y k))

def transcript (secret key : Bool) : Bool × Bool := (key, Bool.xor key secret)

def success (guess : Bool × Bool → Bool) : ℚ :=
  (probability (fun k => !(guess (transcript false k))) +
    probability (fun k => guess (transcript true k))) / 2

end Lax755887.ReusedKey
