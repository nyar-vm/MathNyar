





## Nyar(Vanilla)

- 后缀为 `nyar`


Tuple 字面量已被移除, 任何情况下都直接使用 list 即可.

```antlr
tupleLiteral  : LS (single (Comma single)*)? Comma? RS;
single        : (STRING | NUMBER | BOOL);
```






## NyarNorm(Valkyrie)

后缀为 `.nr`

- 句末必须加 ; 或 ;;
- 优先使用 Unicode 符号
- index 只能使用 [[ ]]
- 浮点数两边必须都写上数字
- 必须标注类型, 返回类型一般是 return as 形式
- return 使用函数宏形式
- 必须标注控制流
- 必须展开非限制宏
- 必须使用 `{ }` 或者 `: end` 组合

```
var a:
	1 as Integer
end
```

```
var a,b:
	return(
		1 as Integer,
		"1" as String,
	)
end
```
