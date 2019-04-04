grammar Nyar;
program: statement+;
// $antlr-format useTab false ;reflowComments false;
// $antlr-format alignColons hanging;
statement
    : expression ';'                 # cal_stat
    | SYMBOL '=' expression ';'      # assign
    | 'print' '(' expression ')' ';' # print;

expression
    : <assco = right>expression POW expression     # pow_Like
    | expression op = (MUL | DIV | MOD) expression # mul_Like
    | expression op = (ADD | SUB) expression       # add_Like
    | sign = (ADD | SUB)? Number                   # number
    | SYMBOL                                       # symbol
    | '(' expression ')'                           # parens;

// $antlr-format alignColons trailing;
Number : INTEGER | FLOAT;

MUL : '*';
DIV : '/';
ADD : '+';
SUB : '-';
POW : '^';
MOD : '%';

SYMBOL : [a-zA-Z]+ [0-9a-zA-Z]*;

ZERO          : '0';
INTEGER       : [1-9][0-9]* | ZERO;
FLOAT         : INTEGER '.' [0-9]+;
COMMENT_LINE  : '//' .*? '\r'? '\n' -> skip;
COMMENT_BLOCK : '/*' .*? '*/' -> skip;
WS            : [\t\r\n] -> skip;