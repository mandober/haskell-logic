kapp :: (((a -> b) -> r) -> r)    -- h
     -> ((a -> r) -> r)           -- k
     -> (b -> r)                  -- g
     -> r
kapp h k g = -- how now brown cow

{-
Summary:
* we have 3 function arguments bound to params `h`, `k`, `g`
  - `h :: ((a -> b) -> r) -> r`
  - `k :: (a -> r) -> r`
  - `g :: b -> r`
* we need to produce:
  - `r` type
-}
