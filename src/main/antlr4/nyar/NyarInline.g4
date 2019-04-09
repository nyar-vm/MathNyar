grammar NyarInline;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
import NyarKeywords, NyarOperators;
program: statement* EOF;
statement
    : (eos)                                                      # EmptyStatement
    | ( LL statement+? RL)                                       # BlockStatement
    | (expression (Comma expression)* eos?)                      # ExpressionStatement
    | (op = Assign_mods id = assignTuple expr = assignable eos?) # AssignStatement
    | (If condition elseif (Else expr_block)? eos?)              # IfStatement
    | (
        Try ( LL statement+? RL) finalProduction
        | Try (LL statement+? RL) (
            catchProduction finalProduction?
        )
    ) # TryStatement
    | (
        Using module = vaildModule
        | Using module = vaildModule As alias = SYMBOL
        | Using source = vaildModule With name = SYMBOL
        | Using module = vaildModule LL (
            expression (Comma expression)* eos?
        )+? RL
    ) # ModuleStatement;
expr_block: ( LL statement+? RL) | expression;
eos: Semicolon;
expression
    : op = (Plus | Minus | Not) right = expression                       # PrefixExpression
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
    | <assoc = right> id = assignTuple op = (
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
    | atom = SYMBOL       # Symbol
    | LS expression RS    # PriorityExpression;
assignable: (expression | ( LL statement+? RL));
assignTuple
    : (SYMBOL | LS (assignPass (Comma assignPass)*)? Comma? RS);
assignPass: Tilde | SYMBOL;
lazy_assign: DelayedAssign;
Assign_mods: Let | Final;
vaildModule: SYMBOL (Dot SYMBOL)*?;
controlModule: Times | Power;
macroStatement: Macro expression eos;
templateStatement: Template expression eos;
interfaceStatement: Interface expression eos;
classStatement: Class expression eos;
condition: LS? expression expr_block RS?;
elseif: (Else If condition)*;
catchProduction: Catch LS? SYMBOL RS? ( LL statement+? RL);
finalProduction: Final ( LL statement+? RL);
tupleLiteral: LS (single (Comma single)*)? Comma? RS;
single: (STRING | NUMBER | BOOL);
dictLiteral: LL (keyvalue (Comma keyvalue)*)? Comma? RL;
keyvalue: (NUMBER | STRING | SYMBOL) Colon element;
listLiteral: LM (element (Comma? element)*)? Comma? RM;
element: (expression | dictLiteral | listLiteral);
signedInteger: (Plus | Minus)? Integer;
LineComment: Shebang ~[\r\n]* -> channel(HIDDEN);
PartComment: Comment .*? Comment -> channel(HIDDEN);
WhiteSpace: [\t\r\n \u000C]+ -> skip;
NewLine: ('\r'? '\n' | '\r')+ -> skip;