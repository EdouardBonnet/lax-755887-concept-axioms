import Lax755887.PersistentQueue

/-!
---
title: Persistent queues — independent controls
type: theorem
---
These statements use only the background axioms. They record the actual behavior or the valid local calculation, independently of the unchecked contract.
-/

namespace Lax755887.PersistentQueueControls

open Lax755887.PersistentQueue

axiom dequeue_charge (n : ℕ) : amortized (dequeue n) = 1

axiom actual_work (n : ℕ) :
    totalWork (List.replicate (n + 1) (dequeue n)) = (n + 1) ^ 2

end Lax755887.PersistentQueueControls
