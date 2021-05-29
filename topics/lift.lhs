> module Survey.Applicatives () where

unary
> liftA :: Applicative f => (a -> b) -> f a -> f b
> liftA f a = pure f <*> a

binary
> liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
> liftA2 f a b = f <$> a <*> b

ternary
> liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
> liftA3 f a b c = f <$> a <*> b <*> c
