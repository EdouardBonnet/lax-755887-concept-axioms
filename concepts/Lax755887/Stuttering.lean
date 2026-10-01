import Mathlib

/-!
---
title: Termination with abstract stuttering — definitions
type: definition
---
A concrete step may leave the abstract state unchanged. Abstract well-foundedness does not rule out infinitely many such steps.
-/

namespace Lax755887.Stuttering

abbrev State := ℕ × Bool

def tick (s : State) : State := if s.2 then (s.1 - 1, false) else (s.1, true)

def Step (next current : State) : Prop := next = tick current

end Lax755887.Stuttering
