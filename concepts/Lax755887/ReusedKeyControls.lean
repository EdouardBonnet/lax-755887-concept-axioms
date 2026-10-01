import Lax755887.ReusedKey

/-!
---
title: Reusing a one-bit encryption pad — independent controls
type: theorem
---
These statements use only the background axioms. They record the actual behavior or the valid local calculation, independently of the unchecked contract.
-/

namespace Lax755887.ReusedKeyControls

open Lax755887.ReusedKey

axiom rekey {α : Type} (f : Bool → α) : SameLaw f (fun k => f (!k))

axiom complement (event : Bool → Bool) :
    probability (fun k => !(event k)) = 1 - probability event

axiom xor_attack_succeeds : success (fun c => Bool.xor c.1 c.2) = 1

end Lax755887.ReusedKeyControls
