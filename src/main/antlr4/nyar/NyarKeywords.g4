lexer grammar NyarKeywords;
STRING: SimpleString;
NUMBER: Integer | Float;
// $antlr-format useTab false; reflowComments false;
// $antlr-format alignColons hanging;
AssignPrefix: Let | Final;
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

/* Function */
Let : 'let';

/* Condition */
If   : 'if';
Else : 'else';

/* Loop */
Try   : 'try';
Catch : 'catch';
For   : 'for';
In    : 'in';

fragment Digit         : [0-9];
fragment OctalDigit    : [0-7];
fragment HexDigit      : [0-9a-fA-F];
fragment Letter        : [a-zA-Z];
fragment UNICODE_WS    : [\p{White_Space}];
fragment NameCharacter : NameStartCharacter | Digit;
WhiteSpace             : [\t\r\n \u000C]+ -> skip;
NewLine                : ('\r'? '\n' | '\r')+ -> skip;
Comment                : '%%%' .*? '%%%' -> channel(HIDDEN);
SYMBOL                 : NameStartCharacter NameCharacter*;
SimpleString           : '"' .*? '"';
Integer                : Digit+;
Float                  : Digit+ ('.' Digit+)?;
EMOJI                  : [\u{1F4A9}\u{1F926}]; // note Unicode code points > U+FFFF
UNICODE_ID:
    [\p{Alpha}\p{General_Category=Other_Letter}] [\p{Alnum}\p{General_Category=Other_Letter}]*;
fragment NameStartCharacter : [:a-zA-Z] | '_';
// $antlr-format alignColons hanging;
// May Allow # $ % with special meaning English + Chinese + Japanese + Greeks