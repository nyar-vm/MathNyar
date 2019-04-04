grammar Nyar;
import NyarOperators, NyarKeywords;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
program: elements? EOF;
elements: element+;
element: Expose? statement;
statement: block | emptyStatement | expressionStatement;
//=========================================================================================================
block: '{' statements? '}';
statements: statement+;
//=========================================================================================================
emptyStatement: Semicolon;
//=========================================================================================================
expressionStatement: expressionSequence EOS;
expressionSequence: expression (',' expression)*;
expression // High computing priority in the front
    : left = expression op = BinaryOperator right = expression            # Binary_Like
    | left = expression op = LogicOperator right = expression             # Logic_Like
    | <assoc = right> left = expression op = PowerLike right = expression # Power_Like
    | left = expression op = MultiplyLike right = expression              # Multiply_Like
    | left = expression op = PlusLike right = expression                  # Plus_Like
    | left = expression op = ListOperator right = expression              # List_Like
    | atom = STRING                                                       # String
    | atom = NUMBER                                                       # Number
    | atom = SYMBOL                                                       # Symbol
    | LS expression RS                                                    # PriorityOperation;

EOS: Semicolon | EOF;
WhiteSpace          : [ \n\t\r]+ -> skip;
NewLine             : ('\r'? '\n' | '\r')+ -> skip;
Comment             : '%%%' .*? '%%%' -> channel(HIDDEN);
// $antlr-format alignColons trailing;
//list : LM (expression Comma?)* RM; record : LL (keyValue Comma?)* RL; keyValue : key = SYMBOL
// Colon value = expression; mathAlias : alias = MathConstant;