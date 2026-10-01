import Mathlib

/-!
---
title: Leader election on a three-cycle
type: definition
---
A protocol selects a unique position. Equivariance means that rotating the input rotates the output by the same amount. A uniform input cannot support both properties.
-/

namespace Lax755887.LeaderElection

abbrev State := Fin 3 → Bool

def next (i : Fin 3) : Fin 3 := ⟨(i.val + 1) % 3, Nat.mod_lt _ (by decide)⟩
def rotate (s : State) : State := fun i => s (next i)
def UniqueLeader (run : State → State) : Prop := ∀ s, ∃! i, run s i = true
def Equivariant (run : State → State) : Prop := ∀ s, run (rotate s) = rotate (run s)

structure Protocol where
  run : State → State
  elects : UniqueLeader run

end Lax755887.LeaderElection
