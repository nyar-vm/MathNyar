grammar Nyar;
// $antlr-format columnLimit 128;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
program: statement* EOF;
statement
    : emptyStatement
    | importStatement eos?
    | typeStatement eos?
    | assignStatment eos?
    | branchStatement eos?
    | loopStatement eos?
    | tryStatement eos?
    | traitStatement eos?
    | classStatement eos?
    | expression eos?
    | data eos?;
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
emptyStatement : eos | Separate;
eos            : Semicolon;
Separate       : ';;';
Semicolon      : ';' | '\uFF1B'; //U+FF1B ；
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
importStatement
    : Using module = moduleName importController?       # ModuleInclude
    | Using module = moduleName As alias = Identifier   # ModuleAlias
    | Using source = moduleName With? name = Identifier # ModuleSymbol
    | Using source = moduleName With? idTuples          # ModuleSymbols
    | Using source = moduleName Dot idTuples            # ModuleSymbols
    | Using dict                                        # ModuleResolve;
moduleName: symbol | symbol (Dot symbol);
// $antlr-format alignColons trailing;
idTuples         : '{' Identifier (Comma Identifier)* '}';
importController : Times | Power;
As               : 'as';
With             : 'with';
Using            : 'using';
Instance         : 'instance';
Times            : '*';
Power            : '^';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
blockStatement: '{' expression* '}' | Colon expression* End | Colon expression;
// $antlr-format alignColons trailing;
End   : 'end';
Colon : ':' | '\uFF1A'; //U+FF1A ：
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
expressionStatement
    : expression (Comma expression)*
    | '(' expression (Comma expression)* ')';
expression
    : functionCall                                                      # FunctionApply
    | left = expression Dot right = symbol                              # GetterApply
    | left = expression Dot right = functionCall                        # MethodApply
    | left = expression right = index                                   # IndexApply
    | assignStatment                                                    # AssignApply
    | left = identifier right = string                                  # SpecialString
    | left = expression As right = typeExpression                       # TypeConversion
    | op = pre_ops right = expression                                   # PrefixExpression
    | left = expression op = pst_ops                                    # PostfixExpression
    | left = expression op = bit_ops right = expression                 # BinaryLike
    | left = expression op = lgk_ops right = expression                 # LogicLike
    | left = expression op = cpr_ops right = expression                 # CompareLike
    | <assoc = right> left = expression op = pow_ops right = expression # PowerLike
    | left = expression op = mul_ops right = expression                 # MultiplyLike
    | left = expression op = add_ops right = expression                 # PlusLike
    | left = expression op = list_ops right = expression                # ListLike
    | atom = data                                                       # DataLiteral
    | '(' expression ')'                                                # PriorityExpression
    | controller                                                        # ControlExpression
    | f = expression BitAnd                                             # SlotCatch;
//  | left = number right = expression                                  # SpaceExpression
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
functionCall : symbols? last = symbol '(' (arguments (Comma arguments)*)? ')';
controller   : Return expressionStatement | Pass | Break;
Pass         : 'pass';
Return       : 'return';
Break        : 'break';
Throw        : 'throw';
Comma        : ',' | '\uFF0C'; //U+FF0C ，
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
arguments: expression | functionCall | data;
typeStatement
    : Type symbol Colon typeExpression End?
    | Type symbol '{' typeExpression '}'?;
typeExpression
    : symbols '(' (typeExpression (Comma typeExpression)*)? ')'
    | symbols '<' (typeExpression (Comma typeExpression)*)? '>'
    | typeExpression (BitOr | BitAnd) typeExpression
    | typeExpression '[' ']'
    | symbols (Nullable | Times)?
    | integer;
typeSuffix: (Tilde | Meets) typeExpression;
parameter
    : typeExpression? symbol
    | typeExpression? symbol Times
    | typeExpression? symbol KeyValues
    | typeExpression? symbol Nullable;
// $antlr-format alignColons trailing;
Type      : 'type';
BitOr     : '|';
BitAnd    : '&';
Nullable  : '?';
KeyValues : '**';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
assignStatment
    : Val assignLHS assignRHS                                               # AssignValue
    | Var assignLHS assignRHS                                               # AssignVariable
    | Def assignLHS assignRHS                                               # AssignDefer
    | Def symbol '(' parameter (Comma parameter)* ')' typeSuffix? assignRHS # AssignFunction
    | symbol '(' parameter (Comma parameter)* ')' typeSuffix? Set assignRHS # AssignFunction
    | assignLHS Set assignRHS                                               # AssignValue
    | assignLHS Vable assignRHS                                             # AssignVariable
    | assignLHS Delay assignRHS                                             # AssignDefer;
assignLHS
    : symbol typeSuffix?                       # AssignSingleSymbol
    | maybeSymbol (Comma maybeSymbol)*         # AssignTupleSymbol
    | '(' maybeSymbol (Comma maybeSymbol)* ')' # AssignTupleSymbol
    | symbols                                  # AssignMaybeSetter
    | symbols index                            # AssignMaybeIndex;
assignRHS
    : expression
    | data
    | '{' expression* '}'
    | Colon expression* End
    | Colon expression
    | expressionStatement
    | statement;
maybeSymbol: symbol typeSuffix? # AssignTupleOne | Tilde # AssignTupleShadow;
symbols: (symbol | symbolName) (Dot symbol)*;
symbolName: symbol (Name symbol)*;
// $antlr-format alignColons trailing;
Val   : 'val';
Var   : 'var';
Let   : 'let';
Def   : 'def';
Set   : '=';
Vable : '.=' | '\u2250'; //U+2250 ≐
Name  : '::' | '\u2237'; //U+2237 ∷
Delay : ':=' | '\u2254'; //U+2254 ≔
/*====================================================================================================================*/
data       : number | string | special | symbols | list | matrix | dict | index | solt;
number     : complex | exponent | decimal | integer | Binary | Octal | Hexadecimal;
dict       : '{' (keyValue (Comma keyValue)*)? Comma? '}';
keyValue   : key = keyValid Colon value = element;
keyValid   : integer | symbol | string;
list       : '[' listLine? Comma? ']';
listLine   : element (Comma? element)*;
element    : data | expression | blockStatement;
matrix     : '[' listLine (eos listLine)* eos? ']';
index      : '[' indexValid (Comma? indexValid)* ']';
indexValid : (symbol | integer) Colon?;
Plus       : '+';
Minus      : '-';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
branchStatement
    : If condition expr_or_block if_else?            # IfSingle
    | If condition expr_or_block if_elseif* if_else? # IfNested
    | Switch condition expr_or_block                 # SwitchStatement
    | Match condition expr_or_block                  # MatchStatement;
expr_or_block: expression | blockStatement;
condition: expression | '(' expression ')';
if_else: Else expr_or_block # ElseStatement;
if_elseif: Else If condition Then? expr_or_block # ElseIfStatement;
// $antlr-format alignColons trailing;
If     : 'if';
Else   : 'else';
Then   : 'then';
Switch : 'switch';
Match  : 'match';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
tryStatement
    : Try blockStatement finalProduction
    | Try blockStatement (catchProduction finalProduction?);
catchProduction: Catch symbol blockStatement | Catch '(' symbol ')' blockStatement;
finalProduction: Final blockStatement;
// $antlr-format alignColons trailing;
Try   : 'try';
Catch : 'catch';
Final : 'final';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
loopStatement
    : For '(' for_inline1 ')' expr_or_block      # ForLoop
    | For Identifier In expression expr_or_block # ForInLoop
    | While condition expr_or_block              # WhileLoop
    | Do expr_or_block                           # DoLoop;
for_inline1: init = expression Comma cond = expression Comma inc = expression;
// $antlr-format alignColons trailing;
In    : 'in';
For   : 'for';
While : 'while';
Do    : 'do';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
traitStatement: Trait symbol classExtends? classMeets? classBody;
classStatement: Class symbol classExtends? classMeets? classBody;
classExtends: Extends symbol+ | '(' symbol (Comma symbol)* ')';
classMeets: Meets symbol+ | Tilde symbol | Tilde '(' symbol (Comma symbol)* ')';
classBody
    : '{' classExpression* '}'
    | Colon classExpression* End
    | Colon classExpression;
classExpression: identifier classAttribute eos?;
classAttribute
    : symbol typeSuffix?
    | symbol typeSuffix? blockStatement
    | symbol '(' parameter* ')' typeSuffix? (Colon 'pass')?
    | symbol '(' parameter* ')' typeSuffix? blockStatement;
// $antlr-format alignColons trailing;
Tilde   : '~';
Trait   : 'trait';
Class   : 'class';
Extends : 'extends';
Meets   : 'meets';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
complex
    : (exponent | decimal | integer) 'i' # QuaternionI
    | (exponent | decimal | integer) 'j' # QuaternionJ
    | (exponent | decimal | integer) 'k' # QuaternionK;
base: integer Base identifier;
exponent
    : integer Exponent integer                         # IntegerExponent
    | (decimal | integer) Exponent (decimal | integer) # DecimalExponent;
// $antlr-format alignColons trailing;
/* TODO:特殊进制输入*/
decimal          : Decimal;
integer          : Integer;
Decimal          : Integer Dot Digit* | Dot Digit+;
Binary           : BinHead Bin+;
Octal            : OcHead Oct+;
Hexadecimal      : HexHead Hex+;
Integer          : [0]| [1-9] Digit*;
Exponent         : '*^';
Base             : '/^';
fragment Bin     : [01];
fragment BinHead : '0b';
fragment Oct     : [0-7];
fragment OcHead  : '0o';
fragment Digit   : [0-9];
fragment Hex     : [0-9a-fA-F];
fragment HexHead : '0x';
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
string
    : StringEscapeBlock  # StringEscapeBlock
    | StringEscapeSingle # StringEscapeSingle
    | StringEmpty        # StringEmpty;
// $antlr-format alignColons trailing;
StringEscapeBlock   : S6 CharLevel1+? S6;
StringEscapeSingle  : S2 CharLevel2+? S2;
StringEmpty         : S6 S6 | S2 S2;
Escape              : '\\';
fragment S6         : '"""';
fragment S2         : '"';
fragment CharLevel1 : Escape . | ~[\\];
fragment CharLevel2 : Escape . | ~["\\];
/*====================================================================================================================*/
special                 : True | False | Null | Nothing;
identifier              : 'i' | 'j' | 'k' | Val | Var | Def | Let | Identifier | Integer;
symbol                  : 'i' | 'j' | 'k' | Symbol | Identifier;
solt                    : Sharp n = Integer? | Sharp id = Identifier;
True                    : 'true';
False                   : 'false';
Null                    : 'null';
Nothing                 : 'nothing';
Identifier              : Letter+;
Symbol                  : NameStartCharacter NameCharacter*;
Sharp                   : '#';
Dot                     : '.';
Underline               : '_';
fragment Letter         : [a-zA-Z];
fragment EmojiCharacter : [\p{Emoji}];
// $antlr-format alignColons hanging;
fragment NameStartCharacter
    : (Underline | Letter)
    | [\p{Latin}]
    | [\p{Han}]
    | [\p{Hiragana}]
    | [\p{Katakana}]
    | [\p{Greek}];
fragment NameCharacter: NameStartCharacter | Digit;
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
Shebang            : '#!' -> channel(HIDDEN);
Comment            : '%%%';
LineComment        : Shebang ~[\r\n]+ -> channel(HIDDEN);
PartComment        : Comment .*? Comment -> channel(HIDDEN);
NewLine            : ('\r'? '\n' | '\r')+ -> skip;
WhiteSpace         : UnicodeWS+ -> skip;
fragment UnicodeWS : [\p{White_Space}];
/*====================================================================================================================*/
// $antlr-format alignColons hanging;
add_ops: Plus | Minus;
pre_ops: Plus | Minus | BitNot | LogicNot | Reciprocal | Increase;
pst_ops: Increase | BitNot | DoubleBang | Decrease;
bit_ops: LeftShift | RightShift;
lgk_ops: LogicAnd | LogicNot | LogicOr | LogicXor;
cpr_ops
    : (Equal | NotEqual | Equivalent | NotEquivalent)
    | (Grater | GraterEqual | Less | LessEqual)
    | (LogicAnd | LogicOr);
pow_ops: Power | Surd;
mul_ops: Divide | Times | Multiply | Kronecker | TensorProduct;
list_ops: Concat | LeftShift | RightShift | Increase;
// $antlr-format alignColons trailing;
/* <> */
Import      : '<<<' | '\u22D8'; //U+22D8 ⋘
LeftShift   : '<<' | '\u226A'; //U+226A ≪
LessEqual   : '<=';
Less        : '<';
Export      : '>>>' | '\u22D9'; //U+22D9 ⋙
RightShift  : '>>' | '\u226B'; //U+226B ≫
GraterEqual : '>=';
Grater      : '>';
/* +-÷ */
Increase      : '++';
PlusTo        : '+=';
LogicXor      : '\u2295'; //U+2295 ⊕
Decrease      : '--';
MinusFrom     : '-=';
NullSequence  : '***';
Multiply      : '\u00D7'; //U+00D7 ×
Kronecker     : '\u2297'; //U+2297 ⊗
TensorProduct : '\u2299'; //U+2299 ⊙
MapAll        : '//@';
Remainder     : '//';
Map           : '/@';
Divide        : '/';
Quotient      : '\u00F7'; //U+00F7 ÷
Output        : '%%';
Mod           : '%';
/* ^√ */
BaseInput : '^^';
Surd      : '\u221A'; //U+221A √
/* =~ */
Equivalent    : '===';
NotEquivalent : '=!=';
Equal         : '=='; //≡
Infer         : '=>' | '\u27F9'; //U+27F9 ⟹
Concat        : '~~';
Destruct      : '~=';
/* |&! */
LogicOr    : '||' | '\u2227'; //U+2227 ∧
LogicAnd   : '&&' | '\u2228'; //U+2228 ∨
DoubleBang : '!!';
NotEqual   : '!=' | '\u2260'; //U+2260 ≠
BitNot     : '!' | '\uFF01'; //U+FF01 ！
LogicNot   : DoubleBang | '\u00AC'; //U+00AC ¬
Elvis      : ':?';
/* $ @ */
PostfixFunction : '$';
Curry           : '@@@';
Apply           : '@@';
LetAssign       : '@=';
At              : '@';
/* upper lower*/
Quote     : '`';
Acute     : '\u00B4'; // U+00B4 ´
Quotation : '\'';
Ellipsis  : '...'; //…
DOT       : '\u22C5'; //U+22C5 ⋅
/* Prefix */
Reciprocal : '\u215F'; //U+215F ⅟
/* Postfix */
Degree    : '\u00B0'; //U+00B0 °
Transpose : '\u1D40'; //U+1D40 ᵀ
Hermitian : '\u1D34'; //U+1D34 ᴴ
/* TypeLiteral */
FieldComplex  : '\u2102'; //U+2102 ℂ
FieldReal     : '\u211D'; //U+211D ℝ
FieldUnsigned : '\u2124'; //U+2124 ℤ
FieldBool     : '\u{1D539}'; // U+1D539 𝔹
FieldInteger  : '\u{1D540}'; // U+1D540 𝕀
FieldString   : '\u{1D54A}'; // U+1D54A 𝕊
/* Other */
Section  : '\u00A7'; //U+00A7 §
Pilcrow  : '\u00B6'; //U+00B6 ¶
Currency : '\u00A4'; //U+00A4 ¤
Element  : '\u2208'; //U+2208 ∈
