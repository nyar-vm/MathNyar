(* Unit 类型 *)
(* Integer 类型 *)
(* Nyar 是不考虑空格和换行的, 如果不加 ;; 分隔会被解释成一整个表达式 *)
0
0
0
127
65536
2147483648
9223372036854775808
(* decimal *)
(* Decimal 类型 *)
(*  ParserError: 
    0.0
*)
(*  ParserError: 
    0.
*)
(*  ParserError: 
    .0
*)
(*  ParserError: 
    3210.0
*)
123
(*  ParserError: 
    3210.
*)
(*  ParserError: 
    .0
*)
123
(* exponent *)
(*  ParserError: 
    2*^2
*)
(*  ParserError: 
    0b0
*)
(* integer *)
(*  ParserError: 
    0o0
*)
(* integer *)
(*  ParserError: 
    0x0
*)
(* integer *)
(* Boolean 类型 *)
True
False
(* Null 类型 *)
Null
(* type Null: Optional(Nothing) *)
(* Nothing 类型 *)
(*  ParserError: 
    [1,2,3]
*)
{Null, Nothing}
null
(* 空表 *)
{ }
(* List *)
null
(* HashMap *)
(* 注意列表前需要加 ;; 分隔, 否则会被解释为 index *)
(*  ParserError: 
    [1]
*)
null
{1}
(* 简单表 *)
{1, 2, 3, null, null}
null
(* 嵌套 *)
{1, 2, 3, {null, null}}
null