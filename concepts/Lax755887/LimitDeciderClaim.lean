import Lax755887.LimitDecider

/-!
---
title: Increasing limits of bounded evaluators — false conclusion
type: theorem
---
This deliberately false application claim is derived only from the unchecked contract. A checked conditional derivation must not mark this statement proven.
-/

namespace Lax755887.LimitDeciderClaim

open Lax755887.LimitDecider

open Nat.Partrec (Code)
open Nat.Partrec.Code

axiom halting_is_computable : ComputablePred (fun c : Code => (eval c 0).Dom)

end Lax755887.LimitDeciderClaim
