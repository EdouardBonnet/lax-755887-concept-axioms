import Lax755887.Stuttering

/-!
---
title: Termination with abstract stuttering — unchecked contract
type: theorem
---
A concrete step may leave the abstract state unchanged. Abstract well-foundedness does not rule out infinitely many such steps.

This is an intentionally false contract, retained as an open proof obligation.
-/

namespace Lax755887.StutteringContract

open Lax755887.Stuttering

axiom termination_transfer {A B : Type} (concrete : A → A → Prop)
    (abstract : B → B → Prop) (view : A → B) (terminates : WellFounded abstract)
    (simulation : ∀ s t, concrete t s → view t = view s ∨ abstract (view t) (view s)) :
    WellFounded concrete

end Lax755887.StutteringContract
