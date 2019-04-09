grammar Nyar;
import NyarKeywords, NyarOperators;
// $antlr-format useTab false ;reflowComments false; 
// $antlr-format alignColons hanging;
program: statement* EOF;
statement
    : empty_element      # EmptyElement
    | block_element      # BlockElement
    | expression_element # ExpressionElement
    | assign_element     # AssignElement
    | if_element         # IfElement
    | try_element        # TryElement
    | module_element     # ModuleElement;
/*====================================================================================================================*/
block_element: LL statement+? RL;
expr_block: block_element | expression;
/*====================================================================================================================*/
empty_element: eos # EmptyStatement;
eos: Semicolon;
/*====================================================================================================================*/
expression_element
    : expression (Comma expression)* eos? # ExpressionStatement;
expression // High computing priority in the front
    : op = pre_ops right = expression                                    # PrefixExpression
    | left = expression op = bit_ops right = expression                  # BinaryLike
    | left = expression op = logic_ops right = expression                # LogicLike
    | <assoc = right> left = expression op = pow_ops right = expression  # PowerLike
    | left = expression op = mul_ops right = expression                  # MultiplyLike
    | left = expression op = add_ops right = expression                  # PlusLike
    | left = expression op = list_ops right = expression                 # ListLike
    | <assoc = right> id = assignTuple op = assign_ops expr = assignable # OperatorAssign
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
list_ops: Concat;
/*====================================================================================================================*/
assign_ops
    : Assign
    | PlusTo
    | MinusFrom
    | LetAssign
    | FinalAssign;
lazy_assign: DelayedAssign;
Assign_mods: Let | Final;
assignable: (expression | block_element);
assign_element
    : op = Assign_mods id = assignTuple expr = assignable eos? # ModifierAssign;
assignTuple
    : (SYMBOL | LS (assignPass (Comma assignPass)*)? Comma? RS);
assignPass: Tilde | SYMBOL;
/*====================================================================================================================*/
module_element
    : Using module = vaildModule
    | Using module = vaildModule As alias = SYMBOL
    | Using source = vaildModule With name = SYMBOL
    | Using module = vaildModule LL expression_element+? RL;
vaildModule: SYMBOL (Dot SYMBOL)*?;
controlModule: Times | Power;
/*====================================================================================================================*/
macroStatement: Macro expression eos;
templateStatement: Template expression eos;
interfaceStatement: Interface expression eos;
classStatement: Class expression eos;
/*====================================================================================================================*/
if_element: If condition elseif (Else expr_block)? eos?;
condition: LS? expression expr_block RS?;
elseif: (Else If condition)*;
/*====================================================================================================================*/
try_element //TODO: USE expr_block
    : Try block_element finalProduction
    | Try block_element (catchProduction finalProduction?);
catchProduction: Catch LS? SYMBOL RS? block_element;
finalProduction: Final block_element;
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
