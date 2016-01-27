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
OR                  "or"
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

%token <std::string> IDENTIFIER "identifier"

%printer {yyoutput << $$; } <*>;

%%

%start unit;

unit:  
    ids {};

ids:
    ids "identifier" {}|{};

%%

void yy::Parser::error(const location_type& l, const std::string &m) {
    driver.error(l, m);
}

