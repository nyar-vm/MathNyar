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
blockStatement: LL statement+? RL;
expr_block: blockStatement | expression;
/*====================================================================================================================*/
emptyStatement: eos;
eos: Semicolon;
/*====================================================================================================================*/
expressionStatement: expression (Comma expression)* eos?;
expression // High computing priority in the front
    : op = Prefix_ops expression                                        # PrefixExpression
    | left = expression op = Bit_ops right = expression                 # Binary_Like
    | left = expression op = Logic_ops right = expression               # Logic_Like
    | <assoc = right> left = expression op = Pow_ops right = expression # Power_Like
    | left = expression op = Mul_ops right = expression                 # Multiply_Like
    | left = expression op = Add_ops right = expression                 # Plus_Like
    | left = expression op = List_ops right = expression                # List_Like
    | <assoc = right> id = SYMBOL op = AssignPrefix expr = expression   # OperatorAssignExpression
    | atom = STRING                                                     # String
    | atom = NUMBER                                                     # Number
    | atom = SYMBOL                                                     # Symbol
    | LS expression RS                                                  # PriorityExpression;
/*====================================================================================================================*/
//FIXME: a=2
assignStatement
    : op = AssignPrefix id = SYMBOL expr = expression eos?     # ModifierAssignExpression
    | op = AssignPrefix id = SYMBOL expr = blockStatement eos? # ModifierAssignBlock;
/*====================================================================================================================*/
ifStatement: If condition elseif (Else expr_block)? eos?;
elseif: (Else If condition)*;
condition: LS? expression expr_block RS?;
/*====================================================================================================================*/
tryStatement
    : Try blockStatement finalProduction
    | Try blockStatement (catchProduction finalProduction?);
//TODO: USE expr_block
catchProduction: Catch LS? SYMBOL RS? blockStatement;
finalProduction: Final blockStatement;
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
//FIXME:keyvalue:(STRING|SYMBOL|Integer) Colon element;
dataLiteral : (list | dict);
dict        : LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue    : (STRING | SYMBOL | NUMBER) Colon element;
list        : LM (element (Comma? element)*)? Comma? RM;
element     : (expression | list | dict);
/*====================================================================================================================*/
LineComment : Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment : Comment .*? Comment -> channel(HIDDEN);
WhiteSpace  : [\t\r\n \u000C]+ -> skip;
NewLine     : ('\r'? '\n' | '\r')+ -> skip;
SYMBOL      : NameStartCharacter NameCharacter*; //Try JS | Julia
NUMBER      : (Integer | Float);
BOOL        : (True | False);
STRING      : SimpleString;