grammar Nyar;
import NyarOperators, NyarKeywords;
// $antlr-format useTab false ;reflowComments false; columnLimit 9999;
// $antlr-format alignColons hanging;
program: statement* EOF;
//elementList: elision? expression ( ',' elision? expression)*;
statement
    : block
    | emptyStatement
    | expressionStatement
    | assignStatement
    | ifStatement
    | tryStatement;
/*====================================================================================================================*/
block: '{' statement+? '}';
expr_block: block | expression;
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
    | left = expression op = add_ops right = expression                 # Plus_Like
    | left = expression op = List_ops right = expression                # List_Like
    | <assoc = right> id = SYMBOL op = AssignPrefix expr = expression   # OperatorAssignExpression
    | atom = STRING                                                     # String
    | atom = NUMBER                                                     # Number
    | atom = SYMBOL                                                     # Symbol
    | '(' expression ')'                                                # PriorityExpression;
/*====================================================================================================================*/
assignStatement
    : op = AssignPrefix id = SYMBOL expr = expression eos? # ModifierAssignExpression
    | op = AssignPrefix id = SYMBOL expr = block eos?      # ModifierAssignBlock;
/*====================================================================================================================*/
ifStatement: If condition elseif (Else expr_block)? eos?;
elseif: (Else If condition)*;
condition: '('? expression expr_block ')'?;
/*====================================================================================================================*/
tryStatement
    : Try block finalProduction
    | Try block ( catchProduction finalProduction?);
//TODO: USE expr_block
catchProduction: Catch '('? SYMBOL ')'? block;
finalProduction: Final block;
// literalSatement: arrayLiteral; arrayLiteral: '[' elementList? ','? elision? ']'; elision: ','+;
// $antlr-format alignColons trailing;
//list : LM (expression Comma?)* RM; record : LL (keyValue Comma?)* RL; keyValue : key = SYMBOL
// Colon value = expression; mathAlias : alias = MathConstant
/*====================================================================================================================*/
LineComment : Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment : Comment .*? Comment -> channel(HIDDEN);
WhiteSpace  : [\t\r\n \u000C]+ -> skip;
NewLine     : ('\r'? '\n' | '\r')+ -> skip;