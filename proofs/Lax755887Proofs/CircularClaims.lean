import Lax755887.CircularClaims

namespace Lax755887Proofs.CircularClaims

/--
---
conclusion: Lax755887.CircularClaims.first
assumptions:
  - Lax755887.CircularClaims.second
---

-/
theorem first_from_second : False := Lax755887.CircularClaims.second

/--
---
conclusion: Lax755887.CircularClaims.second
assumptions:
  - Lax755887.CircularClaims.first
---

-/
theorem second_from_first : False := Lax755887.CircularClaims.first

/--
---
conclusion: Lax755887.CircularClaims.first
assumptions:
  - Lax755887.CircularClaims.first
---

-/
theorem first_from_itself : False := Lax755887.CircularClaims.first

end Lax755887Proofs.CircularClaims
