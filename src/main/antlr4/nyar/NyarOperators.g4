lexer grammar NyarOperators;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
Prefix_ops: Plus | Minus | Bang;
Bit_ops: LeftShift | RightShift;
Logic_ops
    : Equal
    | NotEqual
    | Equivalent
    | NotEquivalent
    | Grater
    | GraterEqual
    | Less
    | LessEqual;
Pow_ops: Power | Surd;
Mul_ops: Divide | Times | Multiply | Kronecker | TensorProduct;
Add_ops: Plus | Minus;
List_ops: Concat;
Assign_ops
    : Assign
    | PlusTo
    | MinusFrom
    | LetAssign
    | FinalAssign;
Lazy_assign: DelayedAssign;
MathConstant
    : Pi
    | E
    | I
    | EulerGamma
    | Plank
    | Reciprocal
    | IntegerField
    | RealField
    | ComplexField;
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

// Angle Brackets
Import     : '<<<' | '\u22D8'; // U+22D8 ⋘
Export     : '>>>' | '\u22D9'; // U+22D9 ⋙
LeftShift  : '<<' | '\u226A'; // U+226A ≪
RightShift : '>>' | '\u226B'; // U+226B ≫
Less       : '<';
Grater     : '>';

/* Remark
 Comment %%% defined in Keywords
 String " defined in Keywords
 */

// Six Basic Arithmetic
Increase : '++';
Plus     : '+';
//Unknow1      : '\u2295'; //U+2295 ⊕
Decrease : '--';
Minus    : '-';
//Unknow2      : '\u2296'; //U+2296 ⊖
NullSequence : '***';
Sequence     : '**';
Times        : '*';
Remainder    : '//';
Divide       : '/';
//Unknow4      : '\u2298'; //U+2298 ⊘
Quotient  : '\u00F7'; //U+00F7 ÷
Comment   : '%%%';
Output    : '%%';
Mod       : '%';
BaseInput : '^^';
Power     : '^';
Surd      : '\u221A'; //U+221A √

//Logic Operators
Equivalent    : '===';
Equal         : '==';
Assign        : '=';
NotEqual      : '!=' | '\u2260'; //U+2260 ≠
NotEquivalent : '=!=';
GraterEqual   : '>=';
LessEqual     : '<=';
Bar2          : '||';
Bar           : '|';
// ∧(2227) & && ∨(2228) ∩(2229) ∪(222A)

DelayedAssign : ':=' | '\u2254'; //U+2254 ≔
LetAssign     : '@=';
FinalAssign   : '#=';
PlusTo        : '+=';
MinusFrom     : '-=';
//SetTimesTo : '*='; SetDivideFrom : '/='; SetModTo : '%='; SetPowerTo : '^='; Clean : '=.';

//Lambda
SlotSequence      : '##';
Shebang           : '#!';
Slot              : '#';
PostfixFunction   : '$$';
AnonymousFunction : '$';
Curry             : '@@@';
Apply             : '@@';
At                : '@';

// Other Repeating Operators
Type      : '::' | '\u2237'; //U+2237 ∷
Colon     : ':';
Semicolon : ';';

// Single Operators
Quote     : '`';
Bang      : '!';
Ellipsis  : '...';
Dot       : '.';
Comma     : ',';
Quotation : '\'';

//
Map    : '/@';
MapAll : '//@';

// Arrow Symbol
To    : '->' | '\u2192'; //U+2192 →
Infer : '=>' | '\u27F9'; //U+27F9 ⟹
Concat  : '~~';
Unknow5 : '<->';
Unknow6 : '<=>' | '\u27FA'; //U+27FA ⟺

// Linear algebra LinearPlus : '|+'; LinearSubtract : '|-'; LinearTimes : '|*'; LinearDivide : '|/';
// LinearMod : '|%'; LinearPower : '|^';
Multiply      : '\u00D7'; // U+00D7 ×
Kronecker     : '\u2297'; // U+2297 ⊗
TensorProduct : '\u2299'; // U+2299 ⊙

/* Math Constant */
Pi           : '\u213C'; //U+213C ℼ
E            : '\u2147'; //U+2147 ⅇ
I            : '\u2148'; //U+2148 ⅈ
EulerGamma   : '\u213D'; //U+213D ℽ
Plank        : '\u210E'; //U+210E ℎ
Reciprocal   : '\u215F'; //U+215F ⅟
Derivative   : '\u2146'; //U+2146 ⅆ
IntegerField : '\u2124'; //U+2124 ℤ
RealField    : '\u211D'; //U+211D ℝ
ComplexField : '\u2102'; //U+2102 ℂ
