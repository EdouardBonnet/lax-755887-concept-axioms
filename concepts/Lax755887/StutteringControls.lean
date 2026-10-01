import Lax755887.Stuttering

/-!
---
title: Termination with abstract stuttering — independent controls
type: theorem
---
These statements use only the background axioms. They record the actual behavior or the valid local calculation, independently of the unchecked contract.
-/

namespace Lax755887.StutteringControls

open Lax755887.Stuttering

axiom terminal_cycle : tick (tick (0, false)) = (0, false) := rfl

end Lax755887.StutteringControls
