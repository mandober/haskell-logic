-- (from transformers package)

-- ContT as a monad transformer
newtype ContT r m a = ContT { runContT :: (a -> m r) -> m r }

-- ConT's Applicative instance
instance Applicative (ContT r m) where
  (<*>) :: ContT r m (a -> b) -> ContT r m a -> ContT r m b
  f <*> v = ContT $ \ c -> runContT f $ \ g -> runContT v (c . g)
