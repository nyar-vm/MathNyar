lexer grammar NyarKeywords;
// $antlr-format useTab false; reflowComments false;
// $antlr-format alignColons trailing;

fragment Digit              : [0-9];
fragment OctalDigit         : [0-7];
fragment HexDigit           : [0-9a-fA-F];
fragment Letter             : [a-zA-Z];
fragment Unicode_WhiteSpace : [\p{White_Space}];
fragment SimpleString       : '"' .*? '"';
fragment EmojiCharacter     : [\p{Emoji}];
fragment NameStartCharacter : Letter | '_';
fragment NameCharacter      : NameStartCharacter | Digit;

/* Module */
Using  : 'using';
Expose : 'expose';
With   : 'with';
As     : 'as';

/* Macro */
Macro : 'macro';

/* Template */
Template : 'template';

/* Class */
Interface : 'interface';
Class     : 'class';
Extend   : 'extend';
Implement : 'implement';

/* Access Control */
Setter    : 'setter';
Getter    : 'getter';
Public    : 'public';
Private   : 'private';
Protected : 'protected';
Final     : 'final';

/* Function */
Let   : 'let';
Type: 'type';

/* Condition */
If   : 'if';
Else : 'else';

/* Loop */
Try   : 'try';
Catch : 'catch';
For   : 'for';
In    : 'in';

/* Constant */
True  : 'true';
False : 'false';

BOOL        : True | False;
STRING      : SimpleString;
Identifier  : NameStartCharacter NameCharacter*; //Try JS | Julia
NUMBER      : Integer | Float;
Float       : Digit+ '.' Digit* | '.' Digit+;
Integer     : Digit+;
//UNICODE_ID : [\p{General_Category=Other_Letter}]*; May Allow # $ % with special meaning English +
// Chinese + Japanese + Greeks