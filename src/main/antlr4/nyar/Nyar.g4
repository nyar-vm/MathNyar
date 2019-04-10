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
    | module_statement     # ModuleStatement
    | class_statement      # ClassStatement;
/*====================================================================================================================*/
block_statement: LL statement+? RL; //@Inline
expr_block: block_statement | expression;
/*====================================================================================================================*/
empty_statement: eos; //@Inline
eos: Semicolon;
symbol: Identifier (Dot Identifier)*;
/*====================================================================================================================*/
expression_statement
    : expression (Comma expression)* eos?; //@Inline
type_statement
    : left = Identifier TypeAnnotation right = expression # TypeAssign
    | Type left = Identifier right = expression           # TypeAssign;
function_apply: symbol LS function_params? RS;
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
    | id = function_apply op = assign_lazy expr = assignable            # LazyAssign
    | <assoc = right> id = assign_lhs op = assign_ops expr = assignable # OperatorAssign
    | data = listLiteral                                                # List
    | left = expression data = indexLiteral                             # Index
    | data = dictLiteral                                                # Dict
    | atom = STRING                                                     # String
    | atom = NUMBER                                                     # Number
    | atom = symbol                                                     # SymbolExpression
    | LS expression RS                                                  # PriorityExpression;
add_ops: Plus | Minus; //@Inline
pre_ops: Plus | Minus | Not | LogicNot; //@Inline
bit_ops: LeftShift | RightShift; //@Inline
logic_ops
    : Equal
    | NotEqual
    | Equivalent
    | NotEquivalent
    | Grater
    | GraterEqual
    | Less
    | LessEqual
    | LogicAnd
    | LogicOr; //@Inline
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
    : op = assign_modifier id = assign_lhs expr = assignable eos?; //@Inline
assignable: (expression | block_statement);
assign_lhs
    : Identifier LS Identifier RS                      # AssignFunction
    | Identifier                                       # AssignValue
    | Identifier (Dot Identifier)+                     # AssignAttribute
    | LS (assign_pass (Comma assign_pass)*)? Comma? RS # AssignWithTuple
    | Identifier LM Integer RM                         # AssignWithList;
assign_pass: Tilde | symbol;
assign_ops
    : Assign
    | PlusTo
    | MinusFrom
    | LetAssign
    | FinalAssign; //@Inline
assign_lazy: DelayedAssign;
assign_modifier: Let | Final;
/*====================================================================================================================*/
module_statement
    : Using module = symbol module_controller? eos?           # ModuleInclude
    | Using module = symbol As alias = Identifier eos?        # ModuleAlias
    | Using source = symbol With name = Identifier eos?       # ModuleSymbol
    | Using module = symbol LL expression_statement+? RL eos? # ModuleResolve;
module_controller: Times | Power;
/*====================================================================================================================*/
class_statement
    : Class id = Identifier class_implement? class_define eos?               # ClassBase
    | Class id = Identifier class_fathers class_implement? class_define eos? # ClassWithFather;
class_fathers
    : Extend father = symbol          # ClassFather
    | LS father = symbol RS           # ClassFather
    | LS (symbol (Comma symbol)+)? RS # ClassFathers;
class_implement: (Implement | Colon) symbol # ClassImplement;
class_define: LL expression RL # ClassDefine;
/*====================================================================================================================*/
interfaceStatement: Interface expression eos;
/*====================================================================================================================*/
templateStatement: Template expression eos;
/*====================================================================================================================*/
macroStatement: Macro expression eos;
/*====================================================================================================================*/
if_statement
    : If condition (Else expr_block)? eos?        # SingleIf
    | If condition elseif (Else expr_block)? eos? # NestedIf;
condition: LS? expression expr_block RS? # ConditionStatement;
elseif: (Else If condition)*;
/*====================================================================================================================*/
try_statement
    : Try block_statement finalProduction
    | Try block_statement (catchProduction finalProduction?); //@Inline
catchProduction: Catch LS? symbol RS? block_statement;
finalProduction: Final block_statement;
//TODO: USE expr_block
/*====================================================================================================================*/
// $antlr-format alignColons trailing;
dictLiteral   : LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue      : key = key_valid Colon value = element;
key_valid     : (NUMBER | STRING | symbol);
listLiteral   : LM (element (Comma? element)*)? Comma? RM;
element       : (expression | dictLiteral | listLiteral);
indexLiteral  : LM index_valid (Comma? index_valid)+? RM;
index_valid   : (symbol | Integer) Colon?;
signedInteger : (Plus | Minus)? Integer;
//FIXME: replace NUMBER with signedInteger
/*====================================================================================================================*/
LineComment : Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment : Comment .*? Comment -> channel(HIDDEN);
WhiteSpace  : [\t\r\n \u000C]+ -> skip;
NewLine     : ('\r'? '\n' | '\r')+ -> skip;