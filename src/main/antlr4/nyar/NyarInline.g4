grammar NyarInline;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
import NyarKeywords, NyarOperators;
program: statement* EOF;
statement
    : (eos)                                                    # EmptyStatement
    | ( LL statement+? RL)                                     # BlockStatement
    | (expression (Comma expression)* eos?)                    # ExpressionStatement
    | (op = assign_mods id = assignLHS expr = assignable eos?) # AssignStatement
    | if_statement                                             # IfStatement
    | (
        Try ( LL statement+? RL) finalProduction
        | Try (LL statement+? RL) (
            catchProduction finalProduction?
        )
    )                  # TryStatement
    | module_statement # ModuleStatement;
expr_block: ( LL statement+? RL) | expression;
eos: Semicolon;
symbol: Identifier (Dot Identifier)*;
function_apply: symbol LS function_params? RS;
function_params: expression (Comma expression)*;
expression
    : (left = Identifier op = TypeAnnotation right = expression)         # TypeStatement
    | function_apply                                                     # FunctionApply
    | op = (Plus | Minus | Not) right = expression                       # PrefixExpression
    | left = expression op = (LeftShift | RightShift) right = expression # BinaryLike
    | left = expression op = (
        Equal
        | NotEqual
        | Equivalent
        | NotEquivalent
        | Grater
        | GraterEqual
        | Less
        | LessEqual
    ) right = expression                                                       # LogicLike
    | <assoc = right> left = expression op = (Power | Surd) right = expression # PowerLike
    | left = expression op = (
        Divide
        | Times
        | Multiply
        | Kronecker
        | TensorProduct
    ) right = expression                                                          # MultiplyLike
    | left = expression op = (Plus | Minus) right = expression                    # PlusLike
    | left = expression op = (Concat | LeftShift | RightShift) right = expression # ListLike
    | id = function_apply op = lazy_assign expr = assignable                      # LazyAssign
    | <assoc = right> id = assignLHS op = (
        Assign
        | PlusTo
        | MinusFrom
        | LetAssign
        | FinalAssign
    ) expr = assignable   # OperatorAssign
    | data = tupleLiteral # Tuple
    | data = listLiteral  # List
    | data = dictLiteral  # Dict
    | atom = STRING       # String
    | atom = NUMBER       # Number
    | atom = symbol       # SymbolExpression
    | LS expression RS    # PriorityExpression;
assignable: (expression | ( LL statement+? RL));
assignLHS
    : Identifier                                     # ValueAssign
    | LS (assignPass (Comma assignPass)*)? Comma? RS # TupleAssign
    | Identifier LM Integer RM                       # ListAssign
    | Identifier LS Identifier RS                    # FunctionAssign;
assignPass: Tilde | symbol;
lazy_assign: DelayedAssign;
assign_mods: Let | Final;
module_statement
    : Using module = symbol controlModule? eos?         # ModuleInclude
    | Using module = symbol As alias = Identifier eos?  # ModuleAlias
    | Using source = symbol With name = Identifier eos? # ModuleSymbol
    | Using module = symbol LL (
        expression (Comma expression)* eos?
    )+? RL eos? # ModuleResolve;
controlModule: Times | Power;
macroStatement: Macro expression eos;
templateStatement: Template expression eos;
interfaceStatement: Interface expression eos;
classStatement: Class expression eos;
if_statement
    : If condition (Else expr_block)? eos?        # SingleIf
    | If condition elseif (Else expr_block)? eos? # NestedIf;
condition: LS? expression expr_block RS? # IfCondition;
elseif: (Else If condition)*;
catchProduction: Catch LS? symbol RS? ( LL statement+? RL);
finalProduction: Final ( LL statement+? RL);
tupleLiteral: LS (single (Comma single)*)? Comma? RS;
single: (STRING | NUMBER | BOOL);
dictLiteral: LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue: key = keys Colon value = element # KeyValue;
keys: (NUMBER | STRING | symbol);
listLiteral: LM (element (Comma? element)*)? Comma? RM;
element: (expression | dictLiteral | listLiteral);
signedInteger: (Plus | Minus)? Integer;
LineComment: Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment: Comment .*? Comment -> channel(HIDDEN);
WhiteSpace: [\t\r\n \u000C]+ -> skip;
NewLine: ('\r'? '\n' | '\r')+ -> skip;