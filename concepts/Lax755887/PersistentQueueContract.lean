import Lax755887.PersistentQueue

/-!
---
title: Persistent queues — unchecked contract
type: theorem
---
Repeated calls may reuse one queue and spend its potential more than once. The telescoping contract deliberately omits compatibility of adjacent potentials.

This is an intentionally false contract, retained as an open proof obligation.
-/

namespace Lax755887.PersistentQueueContract

open Lax755887.PersistentQueue

axiom telescoping (first : Charge) (rest : List Charge) :
  (totalWork (first :: rest) : ℤ) ≤
    ((first :: rest).map amortized).sum + first.before

end Lax755887.PersistentQueueContract
