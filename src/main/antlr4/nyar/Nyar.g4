grammar Nyar;
import NyarOperators, NyarKeywords;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
program: elements? EOF;
elements: element+;
element: statement | functionDeclaration;

statement
    : expression EOS            # singleStatement
    | SYMBOL '=' expression EOS # assignStatement;
expression // High computing priority in the front
    : left = expression op = BinaryOperator right = expression            # Binary_Like
    | left = expression op = LogicOperator right = expression             # Logic_Like
    | <assoc = right> left = expression op = PowerLike right = expression # Power_Like
    | left = expression op = MultiplyLike right = expression              # Multiply_Like
    | left = expression op = AddLike right = expression                   # Plus_Like
    | left = expression op = ListOperator right = expression              # List_Like
    | atom = STRING                                                       # String
    | atom = NUMBER                                                       # Number
    | atom = SYMBOL                                                       # Symbol
    | LS expression RS                                                    # PriorityOperation;

functionDeclaration
    : Type SYMBOL '(' formalParameterList? ')' '{' functionBody '}';

/// FormalParameterList : / SYMBOL / FormalParameterList , SYMBOL
formalParameterList: SYMBOL ( ',' SYMBOL)*;

/// FunctionBody : / SourceElements?
functionBody: elements?;
EOS: Semicolon | EOF;
// $antlr-format alignColons trailing;
//list : LM (expression Comma?)* RM; record : LL (keyValue Comma?)* RL; keyValue : key = SYMBOL
// Colon value = expression; mathAlias : alias = MathConstant;