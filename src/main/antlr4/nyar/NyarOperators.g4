lexer grammar NyarOperators;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons trailing;
// Brackets Pair
LS     : '(';
RS     : ')';
LM     : '[';
RM     : ']';
LL     : '{';
RL     : '}';
LCeil  : '\u2308'; //U+02308 ⌈
RCeil  : '\u2309'; //U+02309 ⌉
LFloor : '\u230A'; //U+0230A ⌊
RFloor : '\u230B'; //U+0230B ⌋
LAngle : '<|' | '\u27E8'; //U+027E8 ⟨
RAngle : '|>' | '\u27E9'; //U+027E9 ⟩
LQuote : '\u201C'; //U+2018 ‘ U+201C “
RQuote : '\u201D'; //U+2019 ’ U+201D ”

// Angle Brackets
Import          : '<<<' | '\u22D8'; //U+22D8 
LeftShift       : '<<' | '\u226A'; //U+226A ≪
LessEqual       : '<=';
Less            : '<';
Export          : '>>>' | '\u22D9'; //U+22D9 ⋙
RightShift      : '>>' | '\u226B'; //U+226B ≫
GraterEqual     : '>=';
Grater          : '>';
Increase        : '++';
PlusTo          : '+=';
Plus            : '+';
Decrease        : '--';
MinusFrom       : '-=';
To              : '->' | '\u2192'; //U+2192 →
Minus           : '-';
NullSequence    : '***';
Sequence        : '**';
Times           : '*';
Remainder       : '//';
Divide          : '/';
Degree          : '\u00B0'; //U+00B0 °
Quotient        : '\u00F7'; //U+00F7 ÷
Comment         : '%%%';
Output          : '%%';
Mod             : '%';
BaseInput       : '^^';
Power           : '^';
Surd            : '\u221A'; //U+221A √
Equivalent      : '===';
NotEquivalent   : '=!=';
Equal           : '==';
Infer           : '=>' | '\u27F9'; //U+27F9 ⟹
Assign          : '=';
LogicOr         : '||' | '\u2016'; //U+2016 ‖
Or              : '|'; // ∧(2227) & && ∨(2228) ∩(2229) ∪(222A)
LogicAnd        : '&&';
And             : '&';
NotEqual        : '!=' | '\u2260'; //U+2260 ≠
LogicNot        : '!' | '\uFF01'; //U+FF01 ！
Not             : '\u00AC'; //U+00AC ¬
Shebang         : '#!';
PostfixFunction : '$';
Curry           : '@@@';
Apply           : '@@';
LetAssign       : '@=';
At              : '@';
TypeAnnotation  : '::' | '\u2237'; //U+2237 ∷
DelayedAssign   : ':=' | '\u2254'; //U+2254 ≔
Colon           : ':' | '\uFF1A'; //U+FF1A ：
Semicolon       : ';' | '\uFF1B'; //U+FF1B ；
Quote           : '`';
Acute           : '\u00B4'; // U+00B4 ´
Ellipsis        : '...';
FinalAssign     : '.=';
Dot             : '.' | '\u3002'; //U+3002 。
Comma           : ',' | '\uFF0C'; //U+FF0C ，
Quotation       : '\'';
Map             : '/@';
MapAll          : '//@';
Concat          : '~~';
Destruct        : '~=';
Tilde           : '~';
Multiply        : '\u00D7'; //U+00D7 ×
Kronecker       : '\u2297'; //U+2297 ⊗
TensorProduct   : '\u2299'; //U+2299 ⊙
Section         : '\u00A7'; //U+00A7 §
Pilcrow         : '\u00B6'; //U+00B6 ¶
Currency        : '\u00A4'; //U+00A4 ¤
