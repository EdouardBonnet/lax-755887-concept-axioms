import Lax755887.LimitDecider

/-!
---
title: Increasing limits of bounded evaluators — independent controls
type: theorem
---
These statements use only the background axioms. They record the actual behavior or the valid local calculation, independently of the unchecked contract.
-/

namespace Lax755887.LimitDeciderControls

open Lax755887.LimitDecider

open Nat.Partrec (Code)
open Nat.Partrec.Code

axiom accepted_computable (fuel : ℕ) : ComputablePred (Accepted fuel)

axiom halting_not_computable : ¬ ComputablePred (fun c : Code => (eval c 0).Dom)

end Lax755887.LimitDeciderControls
