import Mathlib

/-!
---
title: Increasing limits of bounded evaluators — definitions
type: definition
---
Bounded acceptance is computable and increases with fuel. Its union is the halting predicate; computability does not pass to this increasing limit.
-/

namespace Lax755887.LimitDecider

open Nat.Partrec (Code)
open Nat.Partrec.Code

def Accepted (fuel : ℕ) (code : Code) : Prop := (evaln fuel code 0).isSome = true

end Lax755887.LimitDecider
