# Chasing types in Haskell

## Introduction

*Type chasing* is a situation you find yourself in when trying to come up with a solution to a, usually polymorphic, function's definition in Haskell. Having worked out a function's signature, all that remains is to write the function's implementation driven by those types. But instead, you're driven to tears.


## The setup

This is the exact content of my editor that has frustrated me for too long.

```hs
kapp :: (((a -> b) -> r) -> r)    -- ContT r m (a -> b)
     -> ((a -> r) -> r)           -- ContT r m a
     -> ((b -> r) -> r)           -- ContT r m b
```

I was trying to implement this, arbitrarily named, `kapp` function above, which is actually based on the `ContT`'s instance for Applicative class' `<*>` method, found in the `transformers` package here: https://hackage.haskell.org/package/transformers-0.5.6.2/docs/src/Control.Monad.Trans.Cont.html#line-168

```hs
-- (from transformers package)

-- ContT as a monad transformer
newtype ContT r m a = ContT { runContT :: (a -> m r) -> m r }

-- ConT's Applicative instance
instance Applicative (ContT r m) where
  (<*>) :: ContT r m (a -> b) -> ContT r m a -> ContT r m b
  f <*> v = ContT $ \ c -> runContT f $ \ g -> runContT v (c . g)
```

Apart from the type parameter `m`, the two implementation should be fairly the same, save for ContT's re/un/wrapping. Staring some more at `kmap` but failing to find a way forward, I've switched to staring at the solution (`<*>` above). It was particularly frustrating how they knew to introduce that lambda there but apply it way over there. And the other lambda as well. It was exactly these lambda introductions that reminded me of the inference rules in propositional logic, specifically implication introduction, so I've decided to Curry-Howard the shit out of this thing.

## Logical derivation

In proposition (and other) logic, inference rule of implication introduction states that if you assume a `p` and work your way to a `q`, then you can conclude `p => q`. Instead of comming up with an example for implication introduction, it's better if we return to the problem at hand and demonstrate it there.

```hs
kapp :: (((a -> b) -> r) -> r)    -- h
     -> ((a -> r) -> r)           -- k
     -> (b -> r)                  -- g
     -> r
kapp h k g = -- how now brown cow
```

Summary:
* we have 3 function arguments bound to params `h`, `k`, `g`
  - `h :: ((a -> b) -> r) -> r`
  - `k :: (a -> r) -> r`
  - `g :: b -> r`
* we need to produce:
  - `r` type

The 3 args are the 3 propositions that are given, and we need to come up with the conclusion `r`. The form of this function is great for conversion to logical derivation because everything needed to solve this is already there i.e. (peeking at the solution) we know some arbitrary Prelude function won't be comming to save the day. Also, since the types are bare function types they translate directly into implication forms.

The derivation diagram:

```
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
```

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

I was hoping this derivation form would reveal more so that the implementation of a function's definition would be compressed into a series of forced steps. But anyway, it seems as a helpful aid when you're stuck with an equation.

When doing a derivation, you can assume anything. Each assumption gets indented a level to the right as a reminder that you can only use the given propositions and the formulas from the same level as that assumption; also, it reminds that an assumption would have to be discharged.

When discharging a particular assumption, the form that is written on a line is always the same: first write that assumption, followed by an implication sign, followed by whatever formula was on the previous line (the line directly above the implication introduction). The justification given is called the *implication introduction*, abbreviated by `->I`, along with the range indicating its scope.

*Implication elimination*, or `->E` or `MP` (modus ponens), is equivalent to function application: having an implication `a -> b` and an `a`, you can conclude a `b`.

## Back to the function

```hs
kapp :: (((a -> b) -> r) -> r)    -- h
     -> ((a -> r) -> r)           -- k
     -> (b -> r)                  -- g
     -> r
kapp h k g = h (\f -> k (\x -> g (f x)))
```

The derivation with code reference :

```
4 │ ┌(a -> b)¹        assumption¹              . a -> b      :: f
5 │ │ ┌a²             assumption²              . . a         :: x
6 │ │ │b              MP 4,5                   . . b         :: f x
7 │ │ │r              MP 3,6                   . . r         :: g (f x)
8 │ │ a² -> r         ->i 5-7 (discharging¹)   . a -> r      :: c
9 │ │ r               MP 2,8                   . r           :: k c
10│(a -> b)¹ -> r     ->i 4-9 (discharging²)   (a -> b) -> r :: d
11│r                  MP 1,11                  r             :: h d
```

It's not crystal clear, but after some exercises, definitions of similar functions get much easier and the reasons behind the particular steps in an implementation more clear.

The logical derivation seems a useful technic to be aware of when stuck with an appropriate equation. It may even be a basis for a tool that automatically produces a solution for a type-driven equation (since everything is given and no external i.e. arbitrary Prelude functions are used, plus the types dictate the order of function applications). There remains the issue of where exactly to introduce a lambda i.e. how to translate the implication introduction into code.
