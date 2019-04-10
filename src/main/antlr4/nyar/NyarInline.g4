grammar NyarInline;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
import NyarKeywords, NyarOperators;
program: statement* EOF;
statement
    : (( Semicolon))                                 # EmptyStatement
    | ( LL statement+? RL)                           # BlockStatement
    | (expression (Comma expression)* ( Semicolon)?) # ExpressionStatement
    | (
        op = assign_mods id = assignLHS expr = assignable (
            Semicolon
        )?
    ) # AssignStatement
    | (
        If condition elseif (
            Else (( LL statement+? RL) | expression)
        )? (Semicolon)?
    ) # IfStatement
    | (
        Try ( LL statement+? RL) finalProduction
        | Try (LL statement+? RL) (
            catchProduction finalProduction?
        )
    )                  # TryStatement
    | module_statement # ModuleStatement;
function_params: expression (Comma expression)*;
expression
    : (left = Identifier op = TypeAnnotation right = expression)         # TypeStatement
    | (( Identifier (Dot Identifier)*) LS function_params? RS)           # FunctionApply
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
    | id = (
        (Identifier (Dot Identifier)*) LS function_params? RS
    ) op = lazy_assign expr = assignable # LazyAssign
    | <assoc = right> id = assignLHS op = (
        Assign
        | PlusTo
        | MinusFrom
        | LetAssign
        | FinalAssign
    ) expr = assignable                     # OperatorAssign
    | data = tupleLiteral                   # Tuple
    | data = listLiteral                    # List
    | data = dictLiteral                    # Dict
    | atom = STRING                         # String
    | atom = NUMBER                         # Number
    | atom = (Identifier (Dot Identifier)*) # SymbolExpression
    | LS expression RS                      # PriorityExpression;
assignable: (expression | ( LL statement+? RL));
assignLHS
    : Identifier                                     # ValueAssign
    | LS (assignPass (Comma assignPass)*)? Comma? RS # TupleAssign
    | Identifier LM Integer RM                       # ListAssign
    | Identifier LS Identifier RS                    # FunctionAssign;
assignPass: Tilde | ( Identifier (Dot Identifier)*);
lazy_assign: DelayedAssign;
assign_mods: Let | Final;
module_statement
    : Using module = (Identifier (Dot Identifier)*) controlModule? (
        Semicolon
    )? # ModuleInclude
    | Using module = (Identifier (Dot Identifier)*) As alias = Identifier (
        Semicolon
    )? # ModuleAlias
    | Using source = (Identifier (Dot Identifier)*) With name = Identifier (
        Semicolon
    )? # ModuleSymbol
    | Using module = (Identifier (Dot Identifier)*) LL (
        expression (Comma expression)* (Semicolon)?
    )+? RL (Semicolon)? # ModuleResolve;
controlModule: Times | Power;
macroStatement: Macro expression ( Semicolon);
templateStatement: Template expression ( Semicolon);
interfaceStatement: Interface expression ( Semicolon);
classStatement: Class expression ( Semicolon);
condition
    : LS? expression (( LL statement+? RL) | expression) RS?;
elseif: (Else If condition)*;
catchProduction
    : Catch LS? (Identifier (Dot Identifier)*) RS? (
        LL statement+? RL
    );
finalProduction: Final ( LL statement+? RL);
tupleLiteral: LS (single (Comma single)*)? Comma? RS;
single: (STRING | NUMBER | BOOL);
dictLiteral: LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue: key = keys Colon value = element # KeyValue;
keys: (NUMBER | STRING | ( Identifier (Dot Identifier)*));
listLiteral: LM (element (Comma? element)*)? Comma? RM;
element: (expression | dictLiteral | listLiteral);
signedInteger: (Plus | Minus)? Integer;
LineComment: Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment: Comment .*? Comment -> channel(HIDDEN);
WhiteSpace: [\t\r\n \u000C]+ -> skip;
NewLine: ('\r'? '\n' | '\r')+ -> skip;