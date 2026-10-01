import Mathlib

/-!
---
title: Persistent queues — definitions
type: definition
---
Repeated calls may reuse one queue and spend its potential more than once. The telescoping contract deliberately omits compatibility of adjacent potentials.
-/

namespace Lax755887.PersistentQueue

structure Charge where
  work : ℕ
  before : ℕ
  after : ℕ

def amortized (s : Charge) : ℤ := s.work + s.after - s.before

def totalWork (trace : List Charge) : ℕ := (trace.map Charge.work).sum

def dequeue (n : ℕ) : Charge := ⟨n + 1, n, 0⟩

end Lax755887.PersistentQueue
