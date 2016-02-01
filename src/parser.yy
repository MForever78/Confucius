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

%{
#define YYDEBUG 1
%}

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

%token <std::string> SIMPLE_IDENTIFIER "simple_identifier" STRING "string"
%token <std::string> NUMBER "number"
/* FIXME: should not use std::string */
%token <std::string>
OCTAL_NUMBER        "octal_number"
BINARY_NUMBER       "binary_number"
HEX_NUMBER          "hex_number"
REAL_NUMBER         "real_number"
DECIMAL_NUMBER_OTHERS "decimal_number_others"
UNSIGNED_NUMBER     "unsigned_number"

%type <std::string> number decimal_number


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
    ids "simple_identifier" { DBMSG("scan id: " << $2);}|{};

strings:
    strings "string" { DBMSG("scan string: \"" << $2 << "\"");}|{};

numbers:
    numbers number { DBMSG("scan number: " << $2);}|{};

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

/* Formal Syntax Definition from IEEE Std 1364-2001 */
/* These grammars are located in Annex A */

/* A.1 Source text */

/* A.1.1 Library source text */
/* TODO */

/* A.1.2 Configuration source text */
/* TODO */

/* A.1.3 Module and primitive source text */
source_text:
    /* "seq_" prefix is alias for BNF syntax "{}" (means repeat) */
    seq_description;

seq_description:
    seq_description description
|   %empty;

description:
    module_declaration
/*|   udp_declaration*/
;

module_declaration:
    /* "opt_" prefix is alias for BNF syntax "[]" (means optional) */
    module_keyword module_identifier opt_module_parameter_port_list
    opt_list_of_ports ';' seq_module_item "endmodule"
|   module_keyword module_identifier opt_module_parameter_port_list
    opt_list_of_port_declarations ';' seq_non_port_module_item "endmodule"
;

/* opt_ and seq_ are developer-defined prefx */
opt_module_parameter_port_list: module_parameter_port_list | %empty;
opt_list_of_ports: list_of_ports | %empty;
opt_list_of_port_declarations: list_of_port_declarations | %empty;
seq_module_item: seq_module_item module_item | %empty;
seq_non_port_module_item:
    seq_non_port_module_item non_port_module_item | %empty;

module_keyword:
    "module"
|   "macromodule";

/* A.1.4 Module parameters and ports */
module_parameter_port_list:
    "#" "(" seq_parameter_declaration ")";

seq_parameter_declaration:
    seq_parameter_declaration "," parameter_declaration
|   parameter_declaration;

list_of_ports:
    "(" seq_port ")";

seq_port:
    seq_port"," port
|   port;

list_of_port_declarations:
    "(" seq_port_declaration")";

seq_port_declaration:
    seq_port_declaration"," port_declaration
|   port_declaration
|   %empty;

port:
    %empty
|   port_expression
|   "." port_identifier "(" ")"
|   "." port_identifier "(" port_expression ")"
;

port_expression:
    port_reference
|   "{" seq_port_reference"}";  /* FIXME: vim syntax highlight fails */

seq_port_reference:
    seq_port_reference"," port_reference
|   port_reference;

port_reference:
    port_identifier
|   port_identifier "[" constant_expression "]"
|   port_identifier "[" range_expression "]"
;

port_declaration:
    inout_declaration
|   input_declaration
|   output_declaration
;

/* A.1.5 Module items */
module_item:
    module_or_generate_item
|   port_declaration SEMICOLON
|   generated_instantiation
|   local_parameter_declaration
|   specify_block
|   specparam_declaration
;

module_or_generate_item:
    module_or_generate_item_declaration
|   parameter_override
|   continuous_assign
|   gate_instantiation
|   udp_instantiation
|   module_instantiation
|   initial_construct
|   always_construct
;

module_or_generate_item_declaration:
    net_declaration
|   reg_declaration
|   integer_declaration
|   real_declaration
|   time_declaration
|   realtime_declaration
|   event_declaration
|   genvar_declaration
|   task_declaration
|   function_declaration
;

non_port_module_items:
    non_port_module_items non_port_module_item
|   %empty;

non_port_module_item:
    generated_instantiation
|   local_parameter_declaration
|   module_or_generate_item
|   parameter_declaration
|   specify_block
|   specparam_declaration
;

parameter_override:
    generated_instantiation
|   local_parameter_declaration
|   module_or_generate_item
|   parameter_declaration
|   specify_block
|   specparam_declaration
;

parameter_override:
    "defparam" list_of_param_assignments;

/* A.2 Declarations */

/* A.2.1 Declaration types */
local_parameter_declaration:
    "localparam"                list_of_param_assignments SEMICOLON
|   "localparam" "signed"       list_of_param_assignments SEMICOLON
|   "localparam"          range list_of_param_assignments SEMICOLON
|   "localparam" "signed" range list_of_param_assignments SEMICOLON
|   "localparam" "integer" list_of_param_assignments SEMICOLON
|   "localparam" "real" list_of_param_assignments SEMICOLON
|   "localparam" "realtime" list_of_param_assignments SEMICOLON
|   "localparam" "time" list_of_param_assignments SEMICOLON
;

parameter_declaration:
    "parameter"                list_of_param_assignments SEMICOLON
|   "parameter" "signed"       list_of_param_assignments SEMICOLON
|   "parameter"          range list_of_param_assignments SEMICOLON
|   "parameter" "signed" range list_of_param_assignments SEMICOLON
|   "parameter" "integer" list_of_param_assignments SEMICOLON
|   "parameter" "real" list_of_param_assignments SEMICOLON
|   "parameter" "realtime" list_of_param_assignments SEMICOLON
|   "parameter" "time" list_of_param_assignments SEMICOLON
;

specparam_declaration:
    "specparam"       list_of_specparam_assignments
|   "specparam" range list_of_specparam_assignments
;

/* A.2.1.2 Port declarations */
inout_declaration:
    "inout"                         list_of_port_identifiers
|   "inout" net_type                list_of_port_identifiers
|   "inout"          "signed"       list_of_port_identifiers
|   "inout" net_type "signed"       list_of_port_identifiers
|   "inout"                   range list_of_port_identifiers
|   "inout" net_type          range list_of_port_identifiers
|   "inout"          "signed" range list_of_port_identifiers
|   "inout" net_type "signed" range list_of_port_identifiers
;

input_declaration:
    "input"                         list_of_port_identifiers
|   "input" net_type                list_of_port_identifiers
|   "input"          "signed"       list_of_port_identifiers
|   "input" net_type "signed"       list_of_port_identifiers
|   "input"                   range list_of_port_identifiers
|   "input" net_type          range list_of_port_identifiers
|   "input"          "signed" range list_of_port_identifiers
|   "input" net_type "signed" range list_of_port_identifiers
;

output_declaration:
    "output"                         list_of_port_identifiers
|   "output" net_type                list_of_port_identifiers
|   "output"          "signed"       list_of_port_identifiers
|   "output" net_type "signed"       list_of_port_identifiers
|   "output"                   range list_of_port_identifiers
|   "output" net_type          range list_of_port_identifiers
|   "output"          "signed" range list_of_port_identifiers
|   "output" net_type "signed" range list_of_port_identifiers
/*|   "output"                      list_of_port_identifiers*/
|   "output" "reg"                list_of_port_identifiers
|   "output"       "signed"       list_of_port_identifiers
|   "output" "reg" "signed"       list_of_port_identifiers
|   "output"                range list_of_port_identifiers
|   "output" "reg"          range list_of_port_identifiers
|   "output"       "signed" range list_of_port_identifiers
|   "output" "reg" "signed" range list_of_port_identifiers
|   "output" "reg"                list_of_variable_port_identifiers
|   "output" "reg" "signed"       list_of_variable_port_identifiers
|   "output" "reg"          range list_of_variable_port_identifiers
|   "output" "reg" "signed" range list_of_variable_port_identifiers
|   "output" output_variable_type list_of_variable_port_identifiers
;

/* A.2.1.3 Type declarations */
event_declaration:
    "event" list_of_event_identifiers
;

genvar_declaration:
    "genvar" list_of_genvar_identifiers
;

integer_declaration:
    "integer" list_of_variable_identifiers
;

net_declaration:
    net_type                 list_of_net_identifiers SEMICOLON
|   net_type "signed"        list_of_net_identifiers SEMICOLON
|   net_type          delay3 list_of_net_identifiers SEMICOLON
|   net_type "signed" delay3 list_of_net_identifiers SEMICOLON
|   net_type                                 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength                 list_of_net_decl_assignments SEMICOLON
|   net_type                 "signed"        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "signed"        list_of_net_decl_assignments SEMICOLON
|   net_type                          delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength          delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                 "signed" delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "signed" delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                     range        list_of_net_identifiers SEMICOLON
|   net_type "vectored"          range        list_of_net_identifiers SEMICOLON
|   net_type "scalared"          range        list_of_net_identifiers SEMICOLON
|   net_type            "signed" range        list_of_net_identifiers SEMICOLON
|   net_type "vectored" "signed" range        list_of_net_identifiers SEMICOLON
|   net_type "scalared" "signed" range        list_of_net_identifiers SEMICOLON
|   net_type                     range delay3 list_of_net_identifiers SEMICOLON
|   net_type "vectored"          range delay3 list_of_net_identifiers SEMICOLON
|   net_type "scalared"          range delay3 list_of_net_identifiers SEMICOLON
|   net_type            "signed" range delay3 list_of_net_identifiers SEMICOLON
|   net_type "vectored" "signed" range delay3 list_of_net_identifiers SEMICOLON
|   net_type "scalared" "signed" range delay3 list_of_net_identifiers SEMICOLON
|   net_type                                     range        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength                     range        list_of_net_decl_assignments SEMICOLON
|   net_type                 "vectored"          range        list_of_net_decl_assignments SEMICOLON
|   net_type                 "scalared"          range        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "vectored"          range        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "scalared"          range        list_of_net_decl_assignments SEMICOLON
|   net_type                            "signed" range        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength            "signed" range        list_of_net_decl_assignments SEMICOLON
|   net_type                 "vectored" "signed" range        list_of_net_decl_assignments SEMICOLON
|   net_type                 "scalared" "signed" range        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "vectored" "signed" range        list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "scalared" "signed" range        list_of_net_decl_assignments SEMICOLON
|   net_type                                     range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength                     range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                 "vectored"          range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                 "scalared"          range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "vectored"          range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "scalared"          range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                            "signed" range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength            "signed" range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                 "vectored" "signed" range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type                 "scalared" "signed" range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "vectored" "signed" range delay3 list_of_net_decl_assignments SEMICOLON
|   net_type driver_strength "scalared" "signed" range delay3 list_of_net_decl_assignments SEMICOLON
/* grammars start with "trireg" are not implemented
|   "trireg" [ charge_strength ] [ "signed" ] [ delay3 ] list_of_net_identifiers ;
|   "trireg" [ driver_strength ] [ "signed" ] [ delay3 ] list_of_net_decl_assignments ;
|   "trireg" [ charge_strength ] [ "vectored" | "scalared" ] [ "signed" ] range [ delay3 ] list_of_net_identifiers ;
|   "trireg" [ driver_strength ] [ "vectored" | "scalared" ] [ "signed" ] range [ delay3 ] list_of_net_decl_assignments ;
*/
;

real_declaration:
    "real" list_of_real_identifiers SEMICOLON
;

realtime_declaration:
    "realtime" list_of_real_identifiers SEMICOLON
;

reg_declaration:
    "reg"                list_of_variable_identifiers SEMICOLON
    "reg" "signed"       list_of_variable_identifiers SEMICOLON
    "reg"          range list_of_variable_identifiers SEMICOLON
    "reg" "signed" range list_of_variable_identifiers SEMICOLON
;

time_declaration:
    "time" list_of_variable_identifiers SEMICOLON
;

/* A.2.2 Declaration data types */
net_type:
    "supply0"
|   "supply1"
|   "tri"
|   "triand"
|   "trior"
|   "tri0"
|   "tri1"
|   "wire"
|   "wand"
|   "wor"
;

output_variable_type:
    "integer"
|   "time"
;

real_type:
    real_identifier
|   real_identifier "=" constant_expression
|   real_identifier seq_dimension
;

variable_type:
    variable_identifier
|   variable_identifier "=" constant_expression
|   variable_identifier seq_dimension
;

seq_dimension:
    seq_dimension dimension
|   dimension
;

/* A.2.2.2 Strengths */
/* TODO */
driver_strength: %empty;
charge_strength: %empty;

/* A.2.2.3 Delays */
delay3:
    "#" delay_value
|   "#" "(" delay_value ")"
|   "#" "(" delay_value "," delay_value ")"
|   "#" "(" delay_value "," delay_value "," delay_value ")"
;

delay2:
    "#" delay_value
|   "#" "(" delay_value ")"
|   "#" "(" delay_value "," delay_value ")"
;

delay_value:
    "unsigned_number"
|   parameter_identifier
|   specparam_identifier
|   mintypmax_expression
;

/* A.2.3 Declaration lists */
list_of_event_identifiers:
    list_of_event_identifiers "," event_identifier seq_dimension
|   event_identifier seq_dimension
;

list_of_genvar_identifiers:
    list_of_genvar_identifiers "," genvar_identifier
|   genvar_identifier
;

list_of_net_decl_assignments:
    list_of_net_decl_assignments "," net_decl_assignment
|   net_decl_assignment
;

list_of_net_identifiers:
    list_of_net_identifiers "," net_identifier seq_dimension
|   net_identifier seq_dimension
;

list_of_param_assignments:
    list_of_param_assignments "," param_assignment
|   param_assignment
;

list_of_port_identifiers:
    list_of_port_identifiers "," port_identifier
|   port_identifier
;

list_of_real_identifiers:
    list_of_real_identifiers "," real_type
|   real_type
;

list_of_specparam_assignments:
    list_of_specparam_assignments "," specparam_assignment
|   specparam_assignment
;

list_of_variable_identifiers:
    list_of_variable_identifiers "," variable_type
|   variable_type
;

list_of_variable_port_identifiers:
    list_of_variable_port_identifiers "," port_identifier "=" constant_expression
|   list_of_variable_port_identifiers "," port_identifier
|   port_identifier "=" constant_expression
|   port_identifier
;

/* A.2.4 Declaration assignment */
net_decl_assignment:
    net_identifier "=" expression
;

param_assignment:
    parameter_identifier "=" constant_expression
;

specparam_assignment:
    specparam_identifier "=" constant_mintypmax_expression
|   pulse_control_specparam
;

pulse_control_specparam: %empty; /* TODO: not implemented */

error_limit_value: limit_value;
reject_limit_value: limit_value;
limit_value: constant_mintypmax_expression;

/* A.2.5 Declaration ranges */
dimension:
    "[" dimension_constant_expression ":" dimension_constant_expression "]"
;

range:
    "[" msb_constant_expression ":" lsb_constant_expression "]"
;

/* A.2.6 Function declarations */
function_declaration:
    "function" "automatic" "signed" range_or_type function_identifier SEMICOLON function_item_declaration_sequence function_statement "endfunction"
|   "function" "automatic" "signed" range_or_type function_identifier "(" function_port_list ")" SEMICOLON block_item_declaration_sequence
    function_statement "endfunction"
;

automatic_optional: "automatic" | %empty ;
signed_optional: "signed" | %empty;
range_or_type_optional: range_or_type | %empty;
function_item_declaration_sequence:
    function_item_declaration_sequence function_item_declaration
|   function_item_declaration
;
block_item_declaration_sequence:
    block_item_declaration_sequence block_item_declaration
|   block_item_declaration_sequence
;

function_item_declaration:
    block_item_declaration
|   tf_input_declaration SEMICOLON
;

function_port_list:
    seq_tf_input_declaration
;

seq_tf_input_declaration:
    tf_input_declaration "," tf_input_declaration
|   tf_input_declaration
;

range_or_type:
    range | "integer" | "real" | "realtime" | "time";

/* A.2.7 Task declarations */
task_declaration: %empty;

tf_input_declaration:
    "input" opt_reg opt_signed opt_range list_of_port_identifiers
|   "input" opt_task_port_type list_of_port_identifiers
;

opt_reg: "reg" | %empty;
opt_signed: "signed" | %empty;
opt_task_port_type: task_port_type | %empty;

task_port_type: "time" | "real" | "realtime" | "integer"


/* A.2.8 Block item declarations */
block_item_declaration:
    block_reg_declaration
|   event_declaration
|   integer_declaration
|   local_parameter_declaration
|   parameter_declaration
|   real_declaration
|   realtime_declaration
|   time_declaration
;

block_reg_declaration:
    "reg"          opt_range list_of_block_variable_identifiers SEMICOLON
|   "reg" "signed" opt_range list_of_block_variable_identifiers SEMICOLON
;
opt_range: range | %empty;

list_of_block_variable_identifiers: seq_block_variabl_type;

seq_block_variabl_type:
    seq_block_variabl_type "," block_variable_type
|   block_variable_type
;

block_variable_type:
    variable_identifier
|   variable_identifier seq_dimension
;

/* A.3 Primitive instances */
/* A.3.1 Primitive instantiation and instances */
gate_instantiation: %empty; /* FIXME */

/* A.4 Module and generated instantiation */
/* A.4.1 Module instantiation */
module_instantiation:
    module_identifier opt_parameter_value_assignment seq_module_instance
    SEMICOLON
;

opt_parameter_value_assignment: parameter_value_assignment | %empty;
seq_module_instance:
    seq_module_instance "," module_instance
|   module_instance
;

parameter_value_assignment: "#" "(" list_of_parameter_assignments ")";

list_of_parameter_assignments:
    seq_ordered_parameter_assignment
|   seq_named_parameter_assignment
;

seq_ordered_parameter_assignment:
    seq_ordered_parameter_assignment "," ordered_parameter_assignment
|   ordered_parameter_assignment
;

seq_named_parameter_assignment:
    seq_named_parameter_assignment "," named_parameter_assignment
|   named_parameter_assignment
;

ordered_parameter_assignment: expression;
named_parameter_assignment:
    "." parameter_identifier "(" expression ")"
|   "." parameter_identifier "(" ")"
;

module_instance:
    name_of_instance "(" list_of_port_connections ")"
|   name_of_instance "(" ")"
;

name_of_instance:
    module_instance_identifier
|   module_instance_identifier range
;

list_of_port_connections:
    seq_ordered_port_connection
|   seq_named_port_connection
;

seq_ordered_port_connection:
    seq_ordered_port_connection "," ordered_port_connection
|   ordered_port_connection
;

seq_named_port_connection:
    seq_named_port_connection "," named_port_connection
|   named_port_connection
;

ordered_port_connection: expression | %empty;
named_port_connection:
    "." port_identifier "(" expression ")"
|   "." port_identifier "(" ")"
;

/* A.4.2 Generated instantiation */
generated_instantiation:
    "generate" opt_generate_item "endgenerate";

opt_generate_item: generate_item | "%empty";

generate_item_or_null:
    generate_item | SEMICOLON;

generate_item:
    generate_conditional_statement
|   generate_case_statement
|   generate_loop_statement
|   generate_block
|   module_or_generate_item
;

generate_conditional_statement:
    "if" "(" constant_expression ")" generate_item_or_null
    opt_else_generate_item_or_null;

opt_else_generate_item_or_null: "else" generate_item_or_null;

generate_case_statement:
    "case" "(" constant_expression ")" seq_genvar_case_item "endcase";

seq_genvar_case_item:
    seq_genvar_case_item genvar_case_item
|   genvar_case_item
;

genvar_case_item:
    seq_constant_expression ":" generate_item_or_null
|   "default" ":" generate_item_or_null
|   "default" generate_item_or_null
;

seq_constant_expression:
    seq_constant_expression "," constant_expression
|   constant_expression
;

generate_loop_statement:
    "for" "(" genvar_assignment SEMICOLON constant_expression SEMICOLON
    genvar_assignment ")" "begin" ":" generate_block_identifier
    seq_generate_item "end"
;

seq_generate_item:
    seq_generate_item generate_item
|   %empty
;

genvar_assignment:
    genvar_identifier "=" constant_expression
;

generate_block:
    "begin" opt_generate_block_identifier seq_generate_item "end"
;

opt_generate_block_identifier: ":" generate_block_identifier | %empty;

/* A.5.4 UDP instantiation */
udp_instantiation: %empty; /* FIXME */

/* A.6 Behavioral statments */
/* A.6.1 continuous assignment statements */
continuous_assign:
    "assign"                        list_of_net_assignments SEMICOLON
|   "assign" driver_strength        list_of_net_assignments SEMICOLON
|   "assign"                 delay3 list_of_net_assignments SEMICOLON
|   "assign" driver_strength delay3 list_of_net_assignments SEMICOLON
;

list_of_net_assignments: seq_net_assignment;

seq_net_assignment:
    seq_net_assignment "," net_assignment
|   net_assignment
;

net_assignment:
    net_lvalue "=" expression
;

/* A.6.2 Procedural blocks and assignments */
initial_construct: "initial" statement;
always_construct: "always" statement;
blocking_assignment:
    variable_lvalue "=" expression
|   variable_lvalue "=" delay_or_event_control expression
;

nonblocking_assignment:
    variable_lvalue "<="  expression
|   variable_lvalue "<=" delay_or_event_control expression
;

procedural_continuous_assignments:
    "assign" variable_assignment
|   "deassign" variable_lvalue
|   "force" variable_assignment
|   "force" net_assignment
|   "release" variable_lvalue
|   "release" net_lvalue
;

function_blocking_assignment: variable_lvalue "=" expression;
function_statement_or_null: function_statement | %empty;

/* A.6.3 Parallel and sequential blocks */
function_seq_block:
    "begin" seq_function_statement "end"
|   "begin" ":" block_identifier seq_block_item_declaration
    seq_function_statement "end"
;


seq_block_item_declaration:
    seq_block_item_declaration block_item_declaration
|   %empty
;

seq_function_statement:
    seq_function_statement function_statement
|   %empty
;

seq_statement:
    seq_statement statement
|   %empty
;

variable_assignment:
    variable_lvalue "=" expression
;

par_block:
    "fork" seq_function_statement "join"
|   "fork" ":" block_identifier seq_block_item_declaration seq_statement
    "join"
;

seq_block:
    "begin" seq_function_statement "end"
|   "begin" ":" block_identifier seq_block_item_declaration seq_statement
    "end"
;

/* A.6.4 Statements */
statement:
    blocking_assignment SEMICOLON
|   case_statement
|   conditional_statement
|   disable_statement
|   event_trigger
|   loop_statement
|   nonblocking_assignment SEMICOLON
|   par_block
|   procedural_continuous_assignments SEMICOLON
|   procedural_timing_control_statement
|   seq_block
|   system_task_enable
|   task_enable
|   wait_statement
;

statement_or_null: statement | %empty;

function_statement:
    function_blocking_assignment SEMICOLON
|   function_case_statement
|   function_conditional_statement
|   function_loop_statement
|   function_seq_block
|   disable_statement
|   system_task_enable
;

/* A.6.5 Timing control statmenets */
delay_control:
    "#" delay_value
|   "#" "(" mintypmax_expression ")"
;

delay_or_event_control:
    delay_control
|   event_control
|   "repeat" "(" expression ")" event_control
;

disable_statement:
    "disable" hierarchical_task_identifier SEMICOLON
|   "disable" hierarchical_block_identifier SEMICOLON
;

event_control:
    "@" event_identifier
|   "@" "(" event_expression ")"
|   "@" "*" /* TODO: seperate by space or not? */
|   "@" "(" "*" ")"
;

event_trigger:
    "->" hierarchical_event_identifier /* FIXME: add -> token */
;

event_expression:
    expression
|   hierarchical_identifier
|   "posedge" expression
|   "negedge" expression
|   event_expression "or" event_expression
|   event_expression "," event_expression
;

procedural_timing_control_statement:
    delay_or_event_control statement_or_null
;

wait_statement:
    "wait" "(" expression ")" statement_or_null
;

/* A.6.6 conditional statements */
conditional_statement:
    "if" "(" expression ")" statement_or_null opt_else_statement_or_null
|   if_else_if_statement
;

opt_else_statement_or_null: "else" statement_or_null;

if_else_if_statement:
    "if" "(" expression ")" statement_or_null
    seq_else_if_expression_statement_or_null opt_else_statement_or_null
;

seq_else_if_expression_statement_or_null:
    seq_else_if_expression_statement_or_null
    "else" "if" "(" expression ")" statement_or_null
|   %empty
;

function_conditional_statement:
    "if" "(" expression ")" function_statement_or_null
    opt_else_function_statement_or_null
|   function_if_else_if_statement
;

opt_else_function_statement_or_null:
    "else" function_statement_or_null
|   %empty
;


function_if_else_if_statement:
    "if" "(" expression ")" function_statement_or_null
    seq_else_if_expression_function_statement_or_null
    opt_else_function_statement_or_null
;

seq_else_if_expression_function_statement_or_null:
    seq_else_if_expression_function_statement_or_null
    "else" "if" "(" expression ")" function_statement_or_null
|   %empty
;

/* A.6.7 Case statements */
case_statement:
    "case" "(" expression ")" seq_case_item "endcase"
|   "casez" "(" expression ")" seq_case_item "endcase"
|   "casex" "(" expression ")" seq_case_item "endcase"
;

seq_case_item: seq_case_item case_item | case_item;

case_item:
    seq_expression_comma ":" statement_or_null
|   "default"     statement_or_null
|   "default" ":" statement_or_null
;

seq_expression_comma:
    seq_expression_comma "," expression
|   expression
;

function_case_statement:
    "case" "(" expression ")" seq_function_case_item "endcase"
|   "casez" "(" expression ")" seq_function_case_item "endcase"
|   "casex" "(" expression ")" seq_function_case_item "endcase"
;

seq_function_case_item:
    seq_function_case_item function_case_item
|   function_case_item;

function_case_item:
    seq_expression_comma ":" function_statement_or_null
|   "default"     function_statement_or_null
|   "default" ":" function_statement_or_null
;

/* A.6.8  Looping statements */
function_loop_statement:
    "forever" function_statement
|   "repeat" "(" expression ")" function_statement
|   "while" "(" expression ")" function_statement
|   "for" "(" variable_assignment SEMICOLON expression SEMICOLON
    variable_assignment ")" function_statement
;

loop_statement:
    "forever" statement
|   "repeat" "(" expression ")" statement
|   "while" "(" expression ")" statement
|   "for" "(" variable_assignment SEMICOLON expression SEMICOLON
    variable_assignment ")" statement
;


/* A.6.9 Task enable statements */
system_task_enable:
    system_task_identifier SEMICOLON
|   system_task_identifier "(" seq_expression_comma ")" SEMICOLON
;

task_enable:
    hierarchical_task_identifier SEMICOLON
|   hierarchical_task_identifier "(" seq_expression_comma ")" SEMICOLON
;

/* A.7 Specify section */
/* A.7.1 Specify block declaration */
specify_block:
    "specify" seq_specify_item "endspecify"
;

seq_specify_item: specify_item | %empty;

specify_item:
    specparam_declaration
|   pulsestyle_declaration
|   showcancelled_declaration
|   path_declaration
|   system_timing_check
;

pulsestyle_declaration:
    "pulsestyle_onevent" list_of_path_outputs SEMICOLON
|   "pulsestyle_onedetect" list_of_path_outputs SEMICOLON
;

showcancelled_declaration:
    "showcancelld" list_of_path_outputs SEMICOLON
|   "noshowcancelled" list_of_path_outputs SEMICOLON
;

/* A.7.2 Specify path declarations */

path_declaration:
    simple_path_declaration SEMICOLON
|   edge_sensitive_path_declaration SEMICOLON
|   state_dependent_path_declaration SEMICOLON
;

simple_path_declaration:
    parallel_path_description "=" path_delay_value
|   full_path_description "=" path_delay_value
;

parallel_path_description:
    "(" specify_input_terminal_descriptor opt_polarity_operator "=>"
    specify_output_terminal_descriptor ")"
;

opt_polarity_operator: polarity_operator | %empty;

full_path_description:
    "(" list_of_path_inputs opt_polarity_operator "*" ">"
    list_of_path_outputs ")" /* FIXME: "*>" or "*" ">" */
;

list_of_path_inputs:
    seq_specify_input_terminal_descriptor_comma
;

seq_specify_input_terminal_descriptor_comma:
    seq_specify_input_terminal_descriptor_comma
    "," specify_input_terminal_descriptor
|   specify_input_terminal_descriptor
;

list_of_path_outputs:
    seq_specify_output_terminal_descriptor_comma
;

seq_specify_output_terminal_descriptor_comma:
    seq_specify_output_terminal_descriptor_comma
    "," specify_output_terminal_descriptor
|   specify_output_terminal_descriptor
;

/* A.7.3 Spcify block terminals */
specify_input_terminal_descriptor:
    input_identifier
|   input_identifier "[" constant_expression "]"
|   input_identifier "[" range_expression "]"
;

specify_output_terminal_descriptor:
    output_identifier
|   output_identifier "[" constant_expression "]"
|   output_identifier "[" range_expression "]"
;

input_identifier: input_port_identifier | inout_port_identifier;
output_identifier: output_port_identifier | inout_port_identifier;

/* A.7.4 Specify path delays */

path_delay_value:
    list_of_path_delay_expressions
|   "(" list_of_path_delay_expressions ")"
;

list_of_path_delay_expressions: %empty;

edge_sensitive_path_declaration: %empty;
state_dependent_path_declaration: %empty;

polarity_operator: "+" | "-";

/* A.7.5 System timing checks */
/* A.7.5.1 System timing check commands */
system_timing_check: %empty;

/* A.8 Expressions */
/* A.8.1 Concatenations */
concatenation: CURLY_BRACKET_L seq_expression_comma CURLY_BRACKET_R;
constant_concatenation:
    CURLY_BRACKET_L seq_constant_expression CURLY_BRACKET_R
;
constant_multiple_concatenation:
    CURLY_BRACKET_L constant_expression constant_concatenation
    CURLY_BRACKET_R
;

module_path_concatenation:
    CURLY_BRACKET_L seq_module_path_expression_comma CURLY_BRACKET_R
;

seq_module_path_expression_comma:
    seq_module_path_expression_comma "," module_path_expression
|   module_path_expression
;

module_path_multiple_concatenation:
    CURLY_BRACKET_L constant_expression module_path_concatenation
    CURLY_BRACKET_R
;

multiple_concatenation:
    CURLY_BRACKET_L constant_expression concatenation CURLY_BRACKET_R
;

net_concatenation:
    CURLY_BRACKET_L seq_net_concatenation_value CURLY_BRACKET_R
;

seq_net_concatenation_value:
    seq_net_concatenation_value "," net_concatenation_value
|   net_concatenation_value
;

net_concatenation_value:
    hierarchical_net_identifier
|   hierarchical_net_identifier seq_expression_bracket
|   hierarchical_net_identifier seq_expression_bracket "[" range_expression
    "]"
|   hierarchical_net_identifier "[" range_expression "]"
|   net_concatenation
;

variable_concatenation:
    CURLY_BRACKET_L seq_variable_concatenation_value_comma CURLY_BRACKET_R
;
seq_variable_concatenation_value_comma:
    seq_variable_concatenation_value_comma "," variable_concatenation_value
|   variable_concatenation_value
;

variable_concatenation_value:
    hierarchical_variable_identifier
|   hierarchical_variable_identifier seq_expression_bracket
|   hierarchical_variable_identifier seq_expression_bracket "["
    range_expression "]"
|   hierarchical_variable_identifier "[" range_expression "]"
|   variable_concatenation
;

/* A.8.2 Function calls */
constant_function_call:
    function_identifier "(" seq_constant_expression ")"
;
function_call:
    hierarchical_function_identifier "(" seq_expression_comma ")"
;
genvar_function_identifier:
    genvar_function_identifier "(" seq_constant_expression ")"
;
system_function_call:
    system_function_identifier
|   system_function_identifier "(" seq_expression_comma ")"
;
/* A.8.3 Expression */
base_expression: expression;

conditional_expression:
    expression1 "?" expression2 ":" expression3
;

constant_base_expression:
    constant_expression
;

constant_expression:
    constant_primary
|   unary_operator constant_primary
|   constant_expression binary_operator constant_expression
|   constant_expression "?" constant_expression ":" constant_expression
|   "string"
;

constant_mintypmax_expression:
    constant_expression
|   constant_expression ":" constant_expression ":" constant_expression
;

constant_range_expression:
    constant_expression
|   msb_constant_expression ":" lsb_constant_expression
|   constant_base_expression "+" ":" width_constant_expression
|   constant_base_expression "-" ":" width_constant_expression
;

dimension_constant_expression: constant_expression;

expression1: expression;
expression2: expression;
expression3: expression;

expression:
    primary
|   unary_operator primary
|   expression binary_operator expression
|   conditional_expression
|   "string"
;

lsb_constant_expression: constant_expression;
mintypmax_expression:
    expression
|   expression ":" expression ":" expression
;

module_path_conditional_expression:
    module_path_expression "?" module_path_expression ":"
    module_path_expression
;

module_path_expression:
    module_path_primary
|   unary_module_path_operator module_path_primary
|   module_path_expression binary_module_path_operator
    module_path_expression
|   module_path_conditional_expression
;

module_path_mintypmax_expression:
    module_path_expression
|   module_path_expression ":" module_path_expression ":"
    module_path_expression
;

msb_constant_expression: constant_expression;

range_expression:
    expression
|   msb_constant_expression ":" lsb_constant_expression
|   base_expression "+" ":" width_constant_expression
|   base_expression "-" ":" width_constant_expression
;

width_constant_expression:
    constant_expression
;

/* A.8.4 Primaries */
constant_primary:
    constant_concatenation
|   constant_function_call
|   "(" constant_mintypmax_expression ")"
|   constant_multiple_concatenation
|   genvar_identifier
|   "number"
|   parameter_identifier
|   specparam_identifier
;

module_path_primary:
    number
|   identifier
|   module_path_concatenation
|   module_path_multiple_concatenation
|   function_call
|   system_function_call
|   constant_function_call
|   "(" module_path_mintypmax_expression ")"
;

primary:
    "number"
|   hierarchical_identifier
|   hierarchical_identifier seq_expression_bracket
|   hierarchical_identifier seq_expression_bracket "[" range_expression "]"
|   hierarchical_identifier "[" range_expression "]"
|   concatenation
|   multiple_concatenation
|   function_call
|   system_function_call
|   constant_function_call
|   "(" mintypmax_expression ")"
;

seq_expression_bracket:
    seq_expression_bracket "[" expression "]"
|   "[" expression "]"
;

/* A.8.5 Expression left-side values */
net_lvalue:
    hierarchical_net_identifier
|   hierarchical_net_identifier seq_constant_expression_bracket
|   hierarchical_net_identifier seq_constant_expression_bracket "["
    constant_range_expression "]"
|   hierarchical_net_identifier "[" constant_range_expression "]"
|   net_concatenation
;

seq_constant_expression_bracket:
    seq_constant_expression_bracket "[" constant_expression "]"
|   "[" constant_expression "]"
;

variable_lvalue:
    hierarchical_variable_identifier
|   hierarchical_variable_identifier seq_expression_bracket
|   hierarchical_variable_identifier seq_expression_bracket "["
    range_expression "]"
|   hierarchical_variable_identifier "[" range_expression "]"
|   variable_concatenation
;

seq_expression_bracket:
    seq_expression_bracket "[" expression "]"
|   "[" expression "]"
;

/* A.8.6 Operators */

unary_operator:
    "+" | "-" | "!" | "~" | "~&" | "|" | "~|" | "^" | "~^" | "^~";

binary_operator:
    "+" | "-" | "*" | "/" | "%" | "==" | "!=" | "===" | "!==" | "&&" |
    "||" | "**" | "<" | "<=" | ">" | ">=" | "&" | "|" | "^" | "^~" | "~^" |
    ">>" | "<<" | ">>>" | "<<<";

unary_module_path_operator:
    "!" | "~" | "&" | "~&" | "|" | "~|" | "^" | "^~" | "~^";

binary_module_path_operator:
    "==" | "!=" | "&&" | "||" | "&" | "^" | "^~" | "~^";

/* A.8.7 Numbers */

number:
    decimal_number      { $$ = $1; }
|   "octal_number"      { $$ = $1; }
|   "binary_number"     { $$ = $1; }
|   "hex_number"        { $$ = $1; }
|   "real_number"       { $$ = $1; }
;

decimal_number:
    "unsigned_number"   { $$ = $1; }
|   "decimal_number_others" { $$ = $1; }
;

/* A.9.3 Identifiers */

arrayed_identifier:
    simple_arrayed_identifier
|   escaped_arrayed_identifier
;

block_identifier:       identifier;
cell_identifier:        identifier;
config_identifier:      identifier;
escaped_arrayed_identifier: escaped_identifier opt_range;
escaped_hierarchical_identifier:
    escaped_hierarchical_branch seq_simple_or_escaped_hierarchical_branch
;
seq_simple_or_escaped_hierarchical_branch:
    seq_simple_or_escaped_hierarchical_branch "." simple_hierarchical_branch
|   seq_simple_or_escaped_hierarchical_branch "."
    escaped_hierarchical_branch
|   %empty
;

escaped_identifier: %empty;

event_identifier:       identifier;
function_identifier:    identifier;
gate_instance_identifier: arrayed_identifier;
generate_block_identifier: identifier;
genvar_function_identifier: identifier;
genvar_identifier:      identifier;
hierarchical_block_identifier:      hierarchical_identifier;
hierarchical_event_identifier:      hierarchical_identifier;
hierarchical_function_identifier:   hierarchical_identifier;
hierarchical_net_identifier:        hierarchical_identifier;
hierarchical_variable_identifier:   hierarchical_identifier;
hierarchical_task_identifier:       hierarchical_identifier;
hierarchical_identifier:
    simple_hierarchical_identifier
|   escaped_hierarchical_identifier
;

identifier:
    "simple_identifier"
/*|   "escaped_identifier"*/ /* TODO */
;
simple_hierarchical_identifier: %empty;

inout_port_identifier:  identifier;
input_port_identifier:  identifier;
instance_identifier:    identifier;
library_identifier:     identifier;
memory_identifier:      identifier;
module_identifier:      identifier;
module_instance_identifier:    arrayed_identifier;
net_identifier:         identifier;
output_port_identifier: identifier;
parameter_identifier:   identifier;
port_identifier:        identifier;
real_identifier:        identifier;
simple_arrayed_identifier: "simple_identifier" opt_range
specparam_identifier:   identifier;
system_function_identifier: %empty; /* FIXME */
system_task_identifier: %empty; /* FIXME */
task_identifier:        identifier;
terminal_identifier:    identifier;
text_marco_identifier:  "simple_identifier";
topmodule_identifier:   identifier;
udp_identifier:         identifier;
udp_instance_identifier:    arrayed_identifier;
variable_identifier:    identifier;

/* A.9.4 Identifier branches */
simple_hierarchical_branch: %empty; /* FIXME */
escaped_hierarchical_branch: %empty; /* FIXME */

%%

void yy::Parser::error(const location_type& l, const std::string &m) {
    driver.error(l, m);
}

