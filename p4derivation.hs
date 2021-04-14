{-
The derivation diagram:

┌──┬──────────────────────┬────────────────────────┐
│1 │ ((a -> b) -> r) -> r │ proposition            │
│2 │ (a -> r) -> r        │ proposition            │
│3 │ b -> r               │ proposition            │
╞══╪══════════════════════╪════════════════════════╡
│4 │ ┌ (a -> b)¹          │ assumption¹            │
│5 │ │ ┌ a²               │ assumption²            │
│6 │ │ │ b                │ MP 4,5                 │
│7 │ │ │ r                │ MP 3,6                 │
│8 │ │ a² -> r            │ ->i 5-7 (discharging¹) │
│9 │ │ r                  │ MP 2,8                 │
│10│ (a -> b)¹ -> r       │ ->i 4-9 (discharging²) │
│11│ r                    │ MP 1,11                │
└──┴──────────────────────┴────────────────────────┘

We need to come up with the conclusion `r`. Lines 1-3 are given. So we start the solution on line 4.
4. We assume `(a -> b)`
5. We make another assumption `a`
6. Modus ponens: if we have `(a -> b)` (4) and an `a` (5), we can conclude `b`
7. Modus ponens: `(b -> r)` (3) and `b` (6), we conclude `r`
8. Discharging assumption 2, we obtain `(a -> r)`
9. Modus ponens: `(a -> r) -> r` (2) and `(a -> r)` (8), produce `r`
10. Discharging assumption 1, obtain `((a -> b) -> r)`
11. Modus ponens: `((a -> b) -> r) -> r` (1) and above (10) give `r`

And that `r` is the conclusion we sought. QED.
-}