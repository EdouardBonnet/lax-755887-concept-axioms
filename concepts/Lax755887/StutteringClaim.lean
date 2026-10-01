import Lax755887.Stuttering

/-!
---
title: Termination with abstract stuttering — false conclusion
type: theorem
---
This deliberately false application claim is derived only from the unchecked contract. A checked conditional derivation must not mark this statement proven.
-/

namespace Lax755887.StutteringClaim

open Lax755887.Stuttering

axiom machine_terminates : WellFounded Step

end Lax755887.StutteringClaim
