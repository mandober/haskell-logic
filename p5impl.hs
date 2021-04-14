kapp :: (((a -> b) -> r) -> r)    -- h
     -> ((a -> r) -> r)           -- k
     -> (b -> r)                  -- g
     -> r
kapp h k g = h (\f -> k (\x -> g (f x)))
