grammar Nyar;
import NyarOperators, NyarKeywords;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
program: statement* EOF;
//elementList: elision? expression ( ',' elision? expression)*;
statement: block | emptyStatement | expressionStatement;
/*====================================================================================================================*/
block: '{' statement+? '}';
/*====================================================================================================================*/
emptyStatement: eos;
eos: Semicolon;
/*====================================================================================================================*/
expressionStatement: expression (',' expression)* eos?;
expression // High computing priority in the front
    : op = prefix_ops expression                                        # PrefixExpression
    | left = expression op = bit_ops right = expression                 # Binary_Like
    | left = expression op = logic_ops right = expression               # Logic_Like
    | <assoc = right> left = expression op = pow_ops right = expression # Power_Like
    | left = expression op = mul_ops right = expression                 # Multiply_Like
    | left = expression op = add_ops right = expression                 # Plus_Like
    | left = expression op = list_ops right = expression                # List_Like
    | left = expression op = assign_ops right = expression              # Assignment
    | atom = STRING                                                     # String
    | atom = NUMBER                                                     # Number
    | atom = SYMBOL                                                     # Symbol
    | '(' expression ')'                                                # PriorityExpression;
assign_ops
    : Assign
    | DelayedAssign
    | PlusTo
    | MinusFrom
    | LetAssign
    | FinalAssign;
prefix_ops: Plus | Minus | Bang;
bit_ops: LeftShift | RightShift;
logic_ops
    : Equal
    | NotEqual
    | Equivalent
    | NotEquivalent
    | Grater
    | GraterEqual
    | Less
    | LessEqual;
pow_ops: Power | Root;
mul_ops: Divide | Times | Multiply | Kronecker | TensorProduct;
add_ops: Plus | Minus;
list_ops: Concat;
/*====================================================================================================================*/
// literalSatement: arrayLiteral; arrayLiteral: '[' elementList? ','? elision? ']'; elision: ','+;

// $antlr-format alignColons trailing;
//list : LM (expression Comma?)* RM; record : LL (keyValue Comma?)* RL; keyValue : key = SYMBOL
// Colon value = expression; mathAlias : alias = MathConstant;