import Lax755887.ReusedKey

/-!
---
title: Reusing a one-bit encryption pad — false conclusion
type: theorem
---
This deliberately false application claim is derived only from the unchecked contract. A checked conditional derivation must not mark this statement proven.
-/

namespace Lax755887.ReusedKeyClaim

open Lax755887.ReusedKey

axiom every_attacker_is_unbiased : ∀ guess, success guess = 1 / 2

end Lax755887.ReusedKeyClaim
