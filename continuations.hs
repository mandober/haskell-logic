-- continuations

-- continuation function type
type ContF r a = (a -> r) -> r

-- continuation newtype
newtype Cont r a = Cont { runCont :: (a -> r) -> r }

-- continuation monad transformer
newtype ContT r m a = ContT { runContT :: (a -> m r) -> m r }

-- continuation in terms of MT
newtype ContI r a = ContT r Identity a


newtype Cont a = Cont { runCont :: forall r. (a -> r) -> r }


type ContF    r   a =                     (a ->   r) ->   r   -- function type
newtype Cont  r   a = Cont  { runCont  :: (a ->   r) ->   r } -- newtype
newtype ContT r m a = ContT { runContT :: (a -> m r) -> m r } -- ContT MT
newtype ContI r   a = ContT r Identity a                      -- i.t.o ContT

type Cont a = forall r. (a -> r) -> r

newtype Cont a = Cont { unCont :: forall r. (a -> r) -> r }
