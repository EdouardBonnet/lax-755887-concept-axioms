import Lax755887.PersistentQueue

/-!
---
title: Persistent queues — false conclusion
type: theorem
---
This deliberately false application claim is derived only from the unchecked contract. A checked conditional derivation must not mark this statement proven.
-/

namespace Lax755887.PersistentQueueClaim

open Lax755887.PersistentQueue

axiom repeated_dequeue_linear :
    ∃ C : ℕ, ∀ n, totalWork (List.replicate (n + 1) (dequeue n)) ≤ C * (n + 1)

end Lax755887.PersistentQueueClaim
