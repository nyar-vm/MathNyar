grammar Nyar;
import NyarKeywords, NyarOperators;
// $antlr-format useTab false ;reflowComments false; 
// $antlr-format alignColons hanging;
program: statement* EOF;
statement
    : empty_statement      # EmptyStatement
    | block_statement      # BlockStatement
    | expression_statement # ExpressionStatement
    | assign_statement     # AssignStatement
    | if_statement         # IfStatement
    | try_statement        # TryStatement
    | module_statement     # ModuleStatement;
/*====================================================================================================================*/
block_statement: LL statement+? RL;
expr_block: block_statement | expression;
/*====================================================================================================================*/
empty_statement: eos;
eos: Semicolon;
/*====================================================================================================================*/
expression_statement: expression (Comma expression)* eos?;
expression // High computing priority in the front
    : op = pre_ops right = expression                                    # PrefixExpression
    | left = expression op = bit_ops right = expression                  # BinaryLike
    | left = expression op = logic_ops right = expression                # LogicLike
    | <assoc = right> left = expression op = pow_ops right = expression  # PowerLike
    | left = expression op = mul_ops right = expression                  # MultiplyLike
    | left = expression op = add_ops right = expression                  # PlusLike
    | left = expression op = Llist_ops right = expression                # ListLike
    | <assoc = right> id = assignTuple op = Assign_ops expr = assignable # OperatorAssign
    | data = tupleLiteral                                                # Tuple
    | data = listLiteral                                                 # List
    | data = dictLiteral                                                 # Dict
    | atom = STRING                                                      # String
    | atom = NUMBER                                                      # Number
    | atom = SYMBOL                                                      # Symbol
    | LS expression RS                                                   # PriorityExpression;
add_ops: Plus | Minus;
pre_ops: Plus | Minus | Not;
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
pow_ops: Power | Surd;
mul_ops: Divide | Times | Multiply | Kronecker | TensorProduct;
Llist_ops: Concat;
/*====================================================================================================================*/
Assign_ops
    : Assign
    | PlusTo
    | MinusFrom
    | LetAssign
    | FinalAssign;
Lazy_assign: DelayedAssign;
Assign_mods: Let | Final;
assignable: (expression | block_statement);
assign_statement
    : op = Assign_mods id = assignTuple expr = assignable eos? # ModifierAssign;
assignTuple
    : (SYMBOL | LS (assignPass (Comma assignPass)*)? Comma? RS);
assignPass: Tilde | SYMBOL;
/*====================================================================================================================*/
module_statement
    : Using module = vaildModule
    | Using module = vaildModule As alias = SYMBOL
    | Using source = vaildModule With name = SYMBOL
    | Using module = vaildModule LL expression_statement+? RL;
vaildModule: SYMBOL (Dot SYMBOL)*?;
controlModule: Times | Power;
/*====================================================================================================================*/
macroStatement: Macro expression eos;
templateStatement: Template expression eos;
interfaceStatement: Interface expression eos;
classStatement: Class expression eos;
/*====================================================================================================================*/
if_statement: If condition elseif (Else expr_block)? eos?;
condition: LS? expression expr_block RS?;
elseif: (Else If condition)*;
/*====================================================================================================================*/
try_statement //TODO: USE expr_block
    : Try block_statement finalProduction
    | Try block_statement (catchProduction finalProduction?);
catchProduction: Catch LS? SYMBOL RS? block_statement;
finalProduction: Final block_statement;
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
tupleLiteral  : LS (single (Comma single)*)? Comma? RS;
single        : (STRING | NUMBER | BOOL);
dictLiteral   : LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue      : (NUMBER | STRING | SYMBOL) Colon element;
listLiteral   : LM (element (Comma? element)*)? Comma? RM;
element       : (expression | dictLiteral | listLiteral);
signedInteger : (Plus | Minus)? Integer;
//FIXME: replace NUMBER with signedInteger
/*====================================================================================================================*/
LineComment : Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment : Comment .*? Comment -> channel(HIDDEN);
WhiteSpace  : [\t\r\n \u000C]+ -> skip;
NewLine     : ('\r'? '\n' | '\r')+ -> skip;
