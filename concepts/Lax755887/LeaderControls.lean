import Lax755887.LeaderElection

/-!
---
title: Separate leader models and their incompatibility
type: theorem
---
There is a model of each property separately, but no common model. All three assertions are proved independently of the existence contract.
-/

namespace Lax755887.LeaderControls

open Lax755887.LeaderElection

axiom uniqueness_has_model : ∃ run, UniqueLeader run
axiom equivariance_has_model : ∃ run, Equivariant run
axiom no_common_model : ¬ ∃ run, UniqueLeader run ∧ Equivariant run

end Lax755887.LeaderControls
