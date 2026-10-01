import Lax755887.LeaderElection

/-!
---
title: An equivariant unique-leader protocol
type: theorem
---
This deliberately false existence claim packages the two original contracts into a proposition. The original data axiom `protocol : Protocol` and the axiom depending on that object are tested separately as invalid concept declarations.
-/

namespace Lax755887.LeaderContract

open Lax755887.LeaderElection

axiom exists_protocol : ∃ run, UniqueLeader run ∧ Equivariant run

end Lax755887.LeaderContract
