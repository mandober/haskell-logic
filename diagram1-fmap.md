The diagram of the Functor's fmap-like function

```hs
-- continuation function type
type ContF r a = (a -> r) -> r

-- continuation monad transformer
newtype ContT r m a = ContT { runContT :: (a -> m r) -> m r }

-- continuation type in terms of monad transformer
newtype ContI r a = ContT r Identity a

-- continuation as newtype
newtype Cont r a = Cont { runCont :: (a -> r) -> r }

cont :: forall a. (a -> (forall r. (a -> r) -> r))

```


```js

```




-- ----------------------------------------------------------------------------
-- Continuation function type: Functor
-- ----------------------------------------------------------------------------
kmap :: (a -> b) -> ((a -> r) -> r) -> ((b -> r) -> r)
-- kmap f k g = k \x -> g $ f x
-- kmap f k g = k $ g . f
-- kmap f k g = k $ (. f) g
kmap f k = (k $) . (. f)

{-
kmap :: (a -> b) -> ((a -> r) -> r) -> ((b -> r) -> r)
kmap :: (a -> b) -> ((a -> r) -> r) -> (b -> r) -> r
kmap :: (a -> b)           -- f
     -> ((a -> r) -> r)    -- k
     -> (b -> r)           -- g
     -> r

kmap f k =                 --                         :: r
    \g ->                  -- \g -> k $ \x -> g (f x) :: (b -> r)
      k $                  --       k $ \x -> g (f x) :: r
        \x ->              --           \x -> g $ f x :: a -> r
          g $              --                 g $ f x :: r
            f x            --                     f x :: b

kmap f k g = k $ \a -> g $ f a
kmap f k g = k $ g . f



fmap: r |- a -> b, (a -> r) -> r, b -> r
┌──┬─────────────────────────────┬──────────────────┐
│1 │ a -> b                    f │ proposition      │
│2 │ (a -> r) -> r             k │ proposition      │
│3 │ b -> r                    g │ proposition      │
╞══╪═════════════════════════════╪══════════════════╡
│0 │ r                           │ conclusion       │
╞══╪═════════════════════════════╪══════════════════╡
│4 │ ┌ a¹                      x │ assumption [¹]   │
│5 │ │ b                         │ ->E 1,4          │
│6 │ │ r                         │ ->E 3,5          │
│7 │ (a¹ -> r)                   │ ->I 4-6    [¹]   │
│8 │ r                           │ ->E 2,7          │
└──┴─────────────────────────────┴──────────────────┘
fmap :: (a -> b) -> ((a -> r) -> r) -> ((b -> r) -> r)
fmap f k g = k \x -> g $ f x

-}

-- ----------------------------------------------------------------------------
-- Continuation function type: Applicative
-- ----------------------------------------------------------------------------
kapp :: (((a -> b) -> r) -> r) -> ((a -> r) -> r) -> ((b -> r) -> r)
kapp h k g = h $ (k $) . (g .)


{- 
-- -- kapp h k g = h $ \f -> k $ \x -> g $ f x
-- -- kapp h k g = h $ \f -> k $ \x -> g . f $ x
-- -- kapp h k g = h $ \f -> k $ g . f
-- -- kapp h k g = h $ \f -> k $ g . f
--    kapp h k g = h $ \f -> k $ (g .) f
-- -- kapp h k g = h $ (k $) . (g .)

-}





{-
(<*>) :: (((a -> b) -> r) -> r) -> ((a -> r) -> r) -> ((b -> r) -> r)
(<*>) :: (((a -> b) -> r) -> r) -> ((a -> r) -> r) -> (b -> r) -> r
(<*>) :: (((a -> b) -> r) -> r)
      -> ((a -> r) -> r)
      -> (b -> r)
      -> r
(<*>) h k g = h \f -> k \x -> g $ f x
(<*>) h k g = h \f -> k \x -> g . f $ x
(<*>) h k g = h \f -> k $ g . f
(<*>) h k g = h \f -> k $ g . f


-}



{-
(<*>): r |- ((a -> b) -> r) -> r, (a -> r) -> r, b -> r
┌──┬─────────────────────────────┬──────────────────┐
│1 │ ((a -> b) -> r) -> r      h │ proposition      │
│2 │ (a -> r) -> r             k │ proposition      │
│3 │ b -> r                    g │ proposition      │
╞══╪═════════════════════════════╪══════════════════╡
│0 │ r                           │ conclusion       │
╞══╪═════════════════════════════╪══════════════════╡
│4 │ ┌ (a -> b)¹               f │ assumption [¹]   │
│5 │ │ ┌ a²                    x │ assumption   [²] │
│6 │ │ │ b                       │ ->E 4,5          │
│7 │ │ │ r                       │ ->E 3,6          │
│8 │ │ a² -> r                   │ ->I 5-7      [²] │
│9 │ │ r                         │ ->E 2,8          │
│10│ (a -> b)¹ -> r              │ ->I 4-9    [¹]   │
│11│ r                           │ ->E 1,11         │
└──┴─────────────────────────────┴──────────────────┘
(<*>) :: (((a -> b) -> r) -> r) -> ((a -> r) -> r) -> ((b -> r) -> r)
(<*>) h k g = h \f -> k \x -> g $ f x



(>>=): r |- (a -> r) -> r, a -> (b -> r) -> r, b -> r
┌──┬─────────────────────────────┬──────────────────┐
│1 │ (a -> r) -> r             k │ proposition      │
│2 │ a -> (b -> r) -> r        h │ proposition      │
│3 │ b -> r                    g │ proposition      │
╞══╪═════════════════════════════╪══════════════════╡
│0 │ r                           │ conclusion       │
╞══╪═════════════════════════════╪══════════════════╡
│4 │ ┌ a¹                      x │ assumption [¹]   │
│5 │ │ (b -> r) -> r             │ ->E 4,2          │
│6 │ │ r                         │ ->E 5,3          │
│7 │ (a¹ -> r)                   │ ->I 4-6    [¹]   │
│8 │ r                           │ ->E 1,7          │
└──┴─────────────────────────────┴──────────────────┘
(>>=) :: ((a -> r) -> r) -> (a -> ((b -> r) -> r)) -> ((b -> r) -> r)
(>>=) k h g = k \a -> h a g

-}
