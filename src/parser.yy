%skeleton "lalr1.cc"
%require "3.0.4"

/*A setting same with bison's "-d" option*/
%defines

%define parser_class_name {Parser}

/*These three lines are needed by the feature variant*/
%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires
{
#include <string>
#include "debugoutput.hpp"
class Driver;
}

%param { Driver& driver }

/*enable location tracking*/
%locations
%initial-action {
    @$.begin.filename = @$.end.filename = &driver.file;
}

%define parse.trace
%define parse.error verbose

%code {
#include "driver.hpp"
}

%define api.token.prefix {TOK_}

%token  EOF     0   "end of file"

/* keywords list */
%token
ALWAYS              "always"
AND                 "and"
ASSIGN              "assign"
AUTOMATIC           "automatic"
BEGIN               "begin"
BUF                 "buf"
BUFIF0              "bufif0"
BUFIF1              "bufif1"
CASE                "case"
CASEX               "casex"
CASEZ               "casez"
CELL                "cell"
CMOS                "cmos"
CONFIG              "config"
DEASSIGN            "deassign"
DEFAULT             "default"
DEFPARAM            "defparam"
DESIGN              "design"
DISABLE             "disable"
EDGE                "edge"
ELSE                "else"
END                 "end"
ENDCASE             "endcase"
ENDCONFIG           "endconfig"
ENDFUNCTION         "endfunction"
ENDGENERATE         "endgenerate"
ENDMODULE           "endmodule"
ENDPRIMITIVE        "endprimitive"
ENDSPECIFY          "endspecify"
ENDTABLE            "endtable"
ENDTASK             "endtask"
EVENT               "event"
FOR                 "for"
FORCE               "force"
FOREVER             "forever"
FORK                "fork"
FUNCTION            "function"
GENERATE            "generate"
GENVAR              "genvar"
HIGHZ0              "highz0"
HIGHZ1              "highz1"
IF                  "if"
IFNONE              "ifnone"
INCDIR              "incdir"
INCLUDE             "include"
INITIAL             "initial"
INOUT               "inout"
INPUT               "input"
INSTANCE            "instance"
INTEGER             "integer"
JOIN                "join"
LARGE               "large"
LIBLIST             "liblist"
LIBRARY             "library"
LOCALPARAM          "localparam"
MACROMODULE         "macromodule"
MEDIUM              "medium"
MODULE              "module"
NAND                "nand"
NEGEDGE             "negedge"
NMOS                "nmos"
NOR                 "nor"
NOSHOWCANCELLED     "noshowcancelled"
NOT                 "not"
NOTIF0              "notif0"
NOTIF1              "notif1"
OR                  "or"            /* FIXME: conflict with operator "or" */
OUTPUT              "output"
PARAMETER           "parameter"
PMOS                "pmos"
POSEDGE             "posedge"
PRIMITIVE           "primitive"
PULL0               "pull0"
PULL1               "pull1"
PULLDOWN            "pulldown"
PULLUP              "pullup"
PULSESTYLE_ONEVENT  "pulsestyle_onevent"
PULSESTYLE_ONDETECT "pulsestyle_ondetect"
RCMOS               "rcmos"
REAL                "real"
REALTIME            "realtime"
REG                 "reg"
RELEASE             "release"
REPEAT              "repeat"
RNMOS               "rnmos"
RPMOS               "rpmos"
RTRAN               "rtran"
RTRANIF0            "rtranif0"
RTRANIF1            "rtranif1"
SCALARED            "scalared"
SHOWCANCELLED       "showcancelled"
SIGNED              "signed"
SMALL               "small"
SPECIFY             "specify"
SPECPARAM           "specparam"
STRONG0             "strong0"
STRONG1             "strong1"
SUPPLY0             "supply0"
SUPPLY1             "supply1"
TABLE               "table"
TASK                "task"
TIME                "time"
TRAN                "tran"
TRANIF0             "tranif0"
TRANIF1             "tranif1"
TRI                 "tri"
TRI0                "tri0"
TRI1                "tri1"
TRIAND              "triand"
TRIOR               "trior"
TRIREG              "trireg"
UNSIGNED            "unsigned"
USE                 "use"
VECTORED            "vectored"
WAIT                "wait"
WAND                "wand"
WEAK0               "weak0"
WEAK1               "weak1"
WHILE               "while"
WIRE                "wire"
WOR                 "wor"
XNOR                "xnor"
XOR                 "xor"
;

/* operators token list - sorted by length */
%token
ARITHMETIC_R_SHIFT  ">>>"
ARITHMETIC_L_SHIFT  "<<<"
CASE_EQUAL          "==="
CASE_INEQUAL        "!=="
LOGIC_R_SHIFT       ">>"
LOGIC_L_SHIFT       "<<"
LOGIC_AND           "&&"
LOGIC_OR            "||"
LOGIC_EQUAL         "=="
LOGIC_INEQUAL       "!="
POWER               "**"
QUESTION_MARK       "?"
REDUCTION_NOR       "~|"
TILDE_HAT           "~^"
REDUCTION_NAND      "~&"
HAT_TILDE           "^~"
GREATER_EQUAL       ">="
LESS_EQUAL          "<="
COLON               ":"
SEMICOLON           ";"
GREATER             ">"
LESS                "<"
HAT                 "^"
BITWISE_OR          "|"
BITWISE_AND         "&"
CURLY_BRACKET_L     "{"
CURLY_BRACKET_R     "}"
SQUARE_BRACKET_L    "["
SQUARE_BRACKET_R    "]"
BITWISE_NEG         "~"
PLUS                "+"
MINUS               "-"
MUL                 "*"
DIV                 "/"
MOD                 "%"
LOGIC_NEG           "!"
AT                  "@"
HASH                "#"
DOT                 "."
;

/* compier directives list */
%token
_CELLDEFINE          "`celldefine"
_DEFAULT_NETTYPE     "`default_nettype"
_DEFINE              "`define"
_ELSE                "`else"
_ELSIF               "`elsif"
_ENDCELLDEFINE       "`endcelldefine"
_ENDIF               "`endif"
_IFDEF               "`ifdef"
_IFNDEF              "`ifndef"
_INCLUDE             "`include"
_LINE                "`line"
_NOUNCONNECTED_DRIVE "`nounconnected_drive"
_RESETALL            "`resetall"
_TIMESCALE           "`timescale"
_UNCONNECTED_DRIVE   "`unconnected_drive"
_UNDEF               "`undef"
;

%token <std::string> IDENTIFIER "identifier" STRING "string"
%token <std::string> NUMBER "number" /* FIXME: should not use std::string */


%printer {yyoutput << $$; } <*>;

%%

%start unit;

unit:
    scanner_gnnng_test {}; /* TODO: comment this line when finish */

/* FIXME: this test contains an RR conflict now, should be fixed later */
scanner_gnnng_test:
    ids {}
|   strings {}
|   numbers {}
|   keywords {}
|   operators {}
|   compiler_directives {};

ids:
    ids "identifier" { DBMSG("scan id: " << $2);}|{};

strings:
    strings "string" { DBMSG("scan string: \"" << $2 << "\"");}|{};

numbers:
    numbers "number" { DBMSG("scan number: " << $2);}|{};

keywords:
    keywords keyword { DBMSG("scan keyword: N/A");} | {};

keyword:
    "always" | "and" | "assign" | "automatic" | "begin" | "buf" | "bufif0"
| "bufif1" | "case" | "casex" | "casez" | "cell" | "cmos" | "config"
| "deassign" | "default" | "defparam" | "design" | "disable" | "edge" | "else"
| "end" | "endcase" | "endconfig" | "endfunction" | "endgenerate"
| "endmodule" | "endprimitive" | "endspecify" | "endtable" | "endtask"
| "event" | "for" | "force" | "forever" | "fork" | "function" | "generate"
| "genvar" | "highz0" | "highz1" | "if" | "ifnone" | "incdir" | "include"
| "initial" | "inout" | "input" | "instance" | "integer" | "join" | "large"
| "liblist" | "library" | "localparam" | "macromodule" | "medium" | "module"
| "nand" | "negedge" | "nmos" | "nor" | "noshowcancelled" | "not" | "notif0"
| "notif1" | "or" | "output" | "parameter" | "pmos" | "posedge" | "primitive"
| "pull0" | "pull1" | "pulldown" | "pullup" | "pulsestyle_onevent"
| "pulsestyle_ondetect" | "rcmos" | "real" | "realtime" | "reg" | "release"
| "repeat" | "rnmos" | "rpmos" | "rtran" | "rtranif0" | "rtranif1"
| "scalared" | "showcancelled" | "signed" | "small" | "specify" | "specparam"
| "strong0" | "strong1" | "supply0" | "supply1" | "table" | "task" | "time"
| "tran" | "tranif0" | "tranif1" | "tri" | "tri0" | "tri1" | "triand"
| "trior" | "trireg" | "unsigned" | "use" | "vectored" | "wait" | "wand"
| "weak0" | "weak1" | "while" | "wire" | "wor" | "xnor" | "xor";

operators:
    operators operator { DBMSG("scan operator: N/A");} | {};

operator:
    ARITHMETIC_R_SHIFT | ARITHMETIC_L_SHIFT | CASE_EQUAL | CASE_INEQUAL
| LOGIC_R_SHIFT | LOGIC_L_SHIFT | LOGIC_AND | LOGIC_OR | LOGIC_EQUAL
| LOGIC_INEQUAL | POWER | QUESTION_MARK | REDUCTION_NOR | TILDE_HAT
| REDUCTION_NAND | HAT_TILDE | GREATER_EQUAL | LESS_EQUAL | COLON | SEMICOLON
| GREATER | LESS | HAT | BITWISE_OR | BITWISE_AND | CURLY_BRACKET_L
| CURLY_BRACKET_R | SQUARE_BRACKET_L | SQUARE_BRACKET_R | BITWISE_NEG | PLUS
| MINUS | MUL | DIV | MOD | LOGIC_NEG | AT;

compiler_directives:
    compiler_directives compiler_directive { DBMSG("compiler_directive");} |;
compiler_directive:
    _CELLDEFINE | _DEFAULT_NETTYPE | _DEFINE | _ELSE | _ELSIF
| _ENDCELLDEFINE | _ENDIF | _IFDEF | _IFNDEF | _INCLUDE | _LINE
| _NOUNCONNECTED_DRIVE | _RESETALL | _TIMESCALE | _UNCONNECTED_DRIVE
| _UNDEF;

%%

void yy::Parser::error(const location_type& l, const std::string &m) {
    driver.error(l, m);
}

