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
