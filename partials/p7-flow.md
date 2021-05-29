Flow diagram for fmap-like function

```
get at this 'a'
     ↓
    (a -> r) -> r
     ↓
     a -> b     turn 'a' into 'b'
          ↓
          b -> r      turn 'b' into 'r'
                 ↘
                   r
reassembling the cont (b -> r) -> r without raising suspicion
```
