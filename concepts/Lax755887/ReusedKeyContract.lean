import Lax755887.ReusedKey

/-!
---
title: Reusing a one-bit encryption pad — unchecked contract
type: theorem
---
Equal marginal distributions do not determine a joint distribution. The composition contract deliberately omits a condition on joint randomness.

This is an intentionally false contract, retained as an open proof obligation.
-/

namespace Lax755887.ReusedKeyContract

open Lax755887.ReusedKey

axiom parallel_composition {α β : Type} (X X' : Bool → α) (Y Y' : Bool → β) :
  SameLaw X X' → SameLaw Y Y' →
    SameLaw (fun k => (X k, Y k)) (fun k => (X' k, Y' k))

end Lax755887.ReusedKeyContract
