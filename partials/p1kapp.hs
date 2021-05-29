kapp :: (((a -> b) -> r) -> r)    -- ContT r m (a -> b)
     -> ((a -> r) -> r)           -- ContT r m a
     -> ((b -> r) -> r)           -- ContT r m b
