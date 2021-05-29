# Inference rules




## Conjunction

p   q             p ∧ q        p ∧ q
----- ∧I          ----- ∧E₁    ----- ∧E₂
p ∧ q               p            q


## Conditional

 [p]¹
  ⫶
  q               p   p → q
------ →I¹       ----------- →E or MP
p → q                 q


## Disjunction

                                      [p]ⁱ   [q]ⁱ
                                      ⫶        ⫶
  p           q               p ∧ q   r       r
----- ∨I₁   ----- ∨I₂         ------------------- ∨Eᵢ where i = [1..2]
p ∨ q       p ∨ q                     r


## Negation

 [p]¹
  ⫶
  ⊥               p  ¬p
------ ¬I¹       ------- ¬E
 ¬p                 ⊥


## Absurdity

  ⊥
----- ⊥I
  p


## ID, RAA, Contradiction

  p            ⊥              ¬p -> ⊥
----- ID     ----- CTR       --------- RAA
  p            p                p
