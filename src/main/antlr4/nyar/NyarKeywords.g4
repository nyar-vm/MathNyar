lexer grammar NyarKeywords;
// $antlr-format useTab false; reflowComments false;
// $antlr-format alignColons hanging;
NUMBER: INTEGER | FLOAT;
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

/* Module */
Use    : 'use';
Expose : 'expose';
With   : 'with';
As     : 'as';

/* Macro */
Macro      : 'macro';
MacroApply : '\u00A7'; // U+00A7 §

/* Template */
Template      : 'template';
TemplayeApply : '\u00B6'; // U+00B6 ¶

/* Class */
Interface : 'interface';
Class     : 'class';
Extends   : 'extends';
Mixin     : 'mixin';
Setter    : 'setter';
Getter    : 'getter';
Public    : 'public';
Private   : 'private';
Protected : 'protected';
Final     : 'final';

/* Loop */
Try   : 'try';
Catch : 'catch';
For   : 'for';
In    : 'in';

/* Math */
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

fragment Digit      : [0-9];
fragment OctalDigit : [0-7];
fragment HexDigit   : [0-9a-fA-F];
fragment Letter     : [a-zA-Z];
SYMBOL              : NameStartCharacter NameCharacter*;
STRING              : '"' .*? '"';
INTEGER             : Digit+;
FLOAT               : Digit+ ('.' Digit+)?;
WhiteSpace          : [\n\t\r]+ -> skip;
NewLine             : ('\r'? '\n' | '\r')+ -> channel(HIDDEN);
Comment             : '%%%' .*? '%%%' -> channel(HIDDEN);

// $antlr-format alignColons hanging;

fragment NameCharacter
    : NameStartCharacter
    | Digit
    | '\u00B7'
    | '\u0300' ..'\u036F'
    | '\u203F' ..'\u2040';
fragment NameStartCharacter
    : [:a-zA-Z] // Letter
    | '_'
    | '\u2070' ..'\u218F'
    | '\u2C00' ..'\u2FEF'
    | '\u3001' ..'\uD7FF'
    | '\uF900' ..'\uFDCF'
    | '\uFDF0' ..'\uFFFD';
// May Allow # $ % with special meaning English + Chinese + Japanese + Greeks
