import Lax755887.LeaderContract
import Lax755887.LeaderClaim
import Lax755887.LeaderControls

namespace Lax755887Proofs.LeaderElection

open Lax755887.LeaderElection

/--
---
conclusion: Lax755887.LeaderControls.uniqueness_has_model
---

-/
theorem uniqueness_has_model : ∃ run, UniqueLeader run := by
  refine ⟨fun _ i => decide (i = 0), fun _ => ?_⟩
  exact ⟨0, rfl, fun i hi => of_decide_eq_true hi⟩

/--
---
conclusion: Lax755887.LeaderControls.equivariance_has_model
---

-/
theorem equivariance_has_model : ∃ run, Equivariant run := ⟨id, fun _ => rfl⟩

/--
---
conclusion: Lax755887.LeaderControls.no_common_model
---

-/
theorem no_common_model : ¬ ∃ run, UniqueLeader run ∧ Equivariant run := by
  rintro ⟨run, elects, rotation_equivariance⟩
  let initial : State := fun _ => false
  have unchanged : rotate initial = initial := rfl
  have fixed : run initial = rotate (run initial) := by
    simpa only [unchanged] using rotation_equivariance initial
  obtain ⟨leader, elected, unique⟩ := elects initial
  have neighbor : run initial (next leader) = true := by
    have same := congrFun fixed leader
    exact same.symm.trans elected
  have impossible : next leader = leader := unique (next leader) neighbor
  fin_cases leader <;> norm_num [next, Fin.ext_iff] at impossible

/--
---
conclusion: Lax755887.LeaderClaim.contracts_conflict
assumptions:
  - Lax755887.LeaderContract.exists_protocol
---

-/
theorem contracts_conflict : False :=
  no_common_model Lax755887.LeaderContract.exists_protocol

end Lax755887Proofs.LeaderElection
