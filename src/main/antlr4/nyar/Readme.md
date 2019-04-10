









Tuple 字面量已被移除, 任何情况下都直接使用 list 即可.

```antlr
tupleLiteral  : LS (single (Comma single)*)? Comma? RS;
single        : (STRING | NUMBER | BOOL);
```