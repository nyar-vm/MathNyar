grammar Nyar;
import NyarOperators, NyarKeywords;
// $antlr-format useTab false ;reflowComments false; columnLimit 9999;
// $antlr-format alignColons hanging;
program: statement* EOF;
statement
    : emptyStatement
    | dataLiteral
    | blockStatement
    | expressionStatement
    | assignStatement
    | ifStatement
    | tryStatement;
/*====================================================================================================================*/
blockStatement: '{' statement+? '}';
expr_block: blockStatement | expression;
/*====================================================================================================================*/
emptyStatement: eos;
eos: Semicolon;
/*====================================================================================================================*/
expressionStatement: expression (',' expression)* eos?;
expression // High computing priority in the front
    : op = Prefix_ops expression                                        # PrefixExpression
    | left = expression op = Bit_ops right = expression                 # Binary_Like
    | left = expression op = Logic_ops right = expression               # Logic_Like
    | <assoc = right> left = expression op = Pow_ops right = expression # Power_Like
    | left = expression op = Mul_ops right = expression                 # Multiply_Like
    | left = expression op = Add_ops right = expression                 # Plus_Like
    | <assoc = right> id = SYMBOL op = AssignPrefix expr = expression   # OperatorAssignExpression
    | atom = STRING                                                     # String
    | atom = NUMBER                                                     # Number
    | atom = SYMBOL                                                     # Symbol
    | '(' expression ')'                                                # PriorityExpression;
/*====================================================================================================================*/
assignStatement
    : op = AssignPrefix id = SYMBOL expr = expression eos?     # ModifierAssignExpression
    | op = AssignPrefix id = SYMBOL expr = blockStatement eos? # ModifierAssignBlock;
/*====================================================================================================================*/
ifStatement: If condition elseif (Else expr_block)? eos?;
elseif: (Else If condition)*;
condition: '('? expression expr_block ')'?;
/*====================================================================================================================*/
tryStatement
    : Try blockStatement finalProduction
    | Try blockStatement (catchProduction finalProduction?);
//TODO: USE expr_block
catchProduction: Catch '('? SYMBOL ')'? blockStatement;
finalProduction: Final blockStatement;
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
dataLiteral : array | object;
object      : '{' (keyvalue (',' keyvalue)*)? '}'; //FIXME: {a:1}
keyvalue    : (STRING | SYMBOL | Integer) ':' expression;
array       : '[' elementList? ','* ']'; //FIXME: [a+1]
elementList : expression (','+ expression)*;
/*====================================================================================================================*/
LineComment : Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment : Comment .*? Comment -> channel(HIDDEN);
WhiteSpace  : [\t\r\n \u000C]+ -> skip;
NewLine     : ('\r'? '\n' | '\r')+ -> skip;