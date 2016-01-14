
module _ where

open import Common.Prelude hiding (_>>=_; _<$>_)
open import Common.Reflection
open import Common.TC

infixr 1 _>>=_
_>>=_ = bindTC

infixl 8 _<$>_
_<$>_ : ∀ {a b} {A : Set a} {B : Set b} → (A → B) → TC A → TC B
f <$> m = m >>= λ x → returnTC (f x)

unEl : Type → Term
unEl (el _ v) = v

macro
  default : Tactic
  default hole =
    unEl <$> inferType hole >>= λ
    { (def (quote Nat) []) → unify hole (lit (nat 42))
    ; (def (quote Bool) []) → unify hole (con (quote false) [])
    ; (meta x _) → blockOnMeta x
    ; _ → typeError "No default"
    }

aNat : Nat
aNat = default

aBool : Bool
aBool = default

alsoNat : Nat
soonNat : _
soonNat = default
alsoNat = soonNat
