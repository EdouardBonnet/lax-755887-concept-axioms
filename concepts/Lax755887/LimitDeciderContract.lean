import Lax755887.LimitDecider

/-!
---
title: Increasing limits of bounded evaluators — unchecked contract
type: theorem
---
Bounded acceptance is computable and increases with fuel. Its union is the halting predicate; computability does not pass to this increasing limit.

This is an intentionally false contract, retained as an open proof obligation.
-/

namespace Lax755887.LimitDeciderContract

open Lax755887.LimitDecider

open Nat.Partrec (Code)
open Nat.Partrec.Code

axiom monotone_limit (p : ℕ → Code → Prop)
    (step : ∀ n c, p n c → p (n + 1) c)
    (deciders : ∀ n, ComputablePred (p n)) : ComputablePred (fun c => ∃ n, p n c)

end Lax755887.LimitDeciderContract
