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
block_statement: LL statement+? RL; //@Inline
expr_block: block_statement | expression; //@Inline
/*====================================================================================================================*/
empty_statement: eos; //@Inline
eos: Semicolon;
/*====================================================================================================================*/
expression_statement
    : expression (Comma expression)* eos?; //@Inline
type_statement
    : left = SYMBOL op = TypeAnnotation right = expression; //@Inline
function_apply: SYMBOL LS function_params? RS; //@Inline
function_params: expression (Comma expression)*;
// High computing priority in the front
expression
    : type_statement                                                    # TypeStatement
    | function_apply                                                    # FunctionApply
    | op = pre_ops right = expression                                   # PrefixExpression
    | left = expression op = bit_ops right = expression                 # BinaryLike
    | left = expression op = logic_ops right = expression               # LogicLike
    | <assoc = right> left = expression op = pow_ops right = expression # PowerLike
    | left = expression op = mul_ops right = expression                 # MultiplyLike
    | left = expression op = add_ops right = expression                 # PlusLike
    | left = expression op = list_ops right = expression                # ListLike
    | id = function_apply op = lazy_assign expr = assignable            # LazyAssign
    | <assoc = right> id = assignLHS op = assign_ops expr = assignable  # OperatorAssign
    | data = tupleLiteral                                               # Tuple
    | data = listLiteral                                                # List
    | data = dictLiteral                                                # Dict
    | atom = STRING                                                     # String
    | atom = NUMBER                                                     # Number
    | atom = SYMBOL                                                     # Symbol
    | LS expression RS                                                  # PriorityExpression;
add_ops: Plus | Minus; //@Inline
pre_ops: Plus | Minus | Not; //@Inline
bit_ops: LeftShift | RightShift; //@Inline
logic_ops
    : Equal
    | NotEqual
    | Equivalent
    | NotEquivalent
    | Grater
    | GraterEqual
    | Less
    | LessEqual; //@Inline
pow_ops: Power | Surd; //@Inline
mul_ops
    : Divide
    | Times
    | Multiply
    | Kronecker
    | TensorProduct; //@Inline
list_ops: Concat | LeftShift | RightShift; //@Inline
/*====================================================================================================================*/
assign_statement
    : op = assign_mods id = assignLHS expr = assignable eos?; //@Inline
assignable: (expression | block_statement);
assignLHS
    : SYMBOL                                         # SymbolAssign
    | LS (assignPass (Comma assignPass)*)? Comma? RS # TupleAssign
    | SYMBOL LM Integer RM                           # ListAssign
    | SYMBOL LS Identifier RS                        # FunctionAssign;
assignPass: Tilde | SYMBOL;
assign_ops
    : Assign
    | PlusTo
    | MinusFrom
    | LetAssign
    | FinalAssign; //@Inline
lazy_assign: DelayedAssign;
assign_mods: Let | Final;
/*====================================================================================================================*/
module_statement
    : Using module = vaildModule
    | Using module = vaildModule As alias = SYMBOL
    | Using source = vaildModule With name = SYMBOL
    | Using module = vaildModule LL expression_statement+? RL; //@Inline
vaildModule: SYMBOL (Dot SYMBOL)*?;
controlModule: Times | Power;
/*====================================================================================================================*/
macroStatement: Macro expression eos;
templateStatement: Template expression eos;
interfaceStatement: Interface expression eos;
classStatement: Class expression eos;
/*====================================================================================================================*/
if_statement
    : If condition elseif (Else expr_block)? eos?; //@Inline
condition: LS? expression expr_block RS?;
elseif: (Else If condition)*;
/*====================================================================================================================*/
//TODO: USE expr_block
try_statement
    : Try block_statement finalProduction
    | Try block_statement (catchProduction finalProduction?); //@Inline
catchProduction: Catch LS? SYMBOL RS? block_statement;
finalProduction: Final block_statement;
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
tupleLiteral : LS (single (Comma single)*)? Comma? RS;
single       : (STRING | NUMBER | BOOL);
dictLiteral  : LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue:
    key = (NUMBER | STRING | SYMBOL) Colon value = element # KeyValue;
listLiteral   : LM (element (Comma? element)*)? Comma? RM;
element       : (expression | dictLiteral | listLiteral);
signedInteger : (Plus | Minus)? Integer;
//FIXME: replace NUMBER with signedInteger
/*====================================================================================================================*/
LineComment : Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment : Comment .*? Comment -> channel(HIDDEN);
SYMBOL      : Identifier (Dot Identifier)*;
WhiteSpace  : [\t\r\n \u000C]+ -> skip;
NewLine     : ('\r'? '\n' | '\r')+ -> skip;