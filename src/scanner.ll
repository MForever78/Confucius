%{ /* -*- C++ -*- */
#include <string>
#include <iostream>
#include "driver.hpp"
#include "parser.hpp"
#include "debugoutput.hpp"

#undef yywrap
#define yywrap() 1

static yy::location loc;
%}

%option noyywrap nounput batch debug noinput

/* 
   Definitions Section 
*/

/* white space */
ws          [ \t]

/* comments */
/* sc = single-line comment, bc = block comment */
sc          "//"
bcstart     "/*"
bcend       "*/"
%x COMMENT

/* operators - see in Rules Section */

/* numbers */
z_digit     [zZ?]
x_digit     [xX]

hex_digit   {x_digit}|{z_digit}|[0-9a-fA-F]
oct_digit   {x_digit}|{z_digit}|[0-7]
bin_digit   {x_digit}|{z_digit}|[0-1]
dec_digit   [0-9]
dec_digit_pos   [1-9]

hex_base    "'"[sS]?[hH]
oct_base    "'"[sS]?[oO]
bin_base    "'"[sS]?[bB]
dec_base    "'"[sS]?[dD]

hex_value   {hex_digit}(_|{hex_digit})*
oct_value   {oct_digit}(_|{oct_digit})*
bin_value   {bin_digit}(_|{bin_digit})*
dec_value   {dec_digit}(_|{dec_digit})*

/* unsigned number and non-zero unsigned number */
uns_number  {dec_digit}(_|{dec_digit})*
pos_number  {dec_digit_pos}{dec_digit}*
/*  TODO: the original rule in the std 2001 may be wrong, which is
pos_number  {dec_digit_pos}(_|{dec_digit})* 

There shall not be any '_' in pos_number, which would be used in size constant
*/

sign        [+-]
size        {sign}?{pos_number}
/* TODO: the original rule in the std 2001 may be wrong, which is
size        {pos_number}
*/ 
dec_number_others   {size}?{dec_base}{ws}*{uns_number}|{size}?{dec_base}{ws}*{x_digit}[_]*|{size}?{dec_base}{ws}*{z_digit}[_]*
/* TODO: could we wrap this line under the flex grammar? */

hex_number  {size}?{hex_base}{ws}*{hex_value}
oct_number  {size}?{oct_base}{ws}*{oct_value}
bin_number  {size}?{bin_base}{ws}*{bin_value}
/*dec_number  {uns_number}|{dec_number_others}*/


exp_digit   [eE]
real_number {uns_number}"."{uns_number}|{uns_number}("."{uns_number})?{exp_digit}{sign}?{uns_number}
/* TODO: same with last todo, about wrapping */

/*number {dec_number}|{oct_number}|{bin_number}|{hex_number}|{real_number}*/

/* strings */
/* TODO: can not simply use definition */
%{
std::string str_literal;
%}
quote       "\""
%x STRING

/* identifiers */
/* TODO: maximum length of identifiers is 1024 characters */
simple_id          [a-z_A-Z][a-z_$A-Z0-9]*

/* keyword */
/* TODO: insert the keyword list */

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
loc.step();
%}

<INITIAL>{bcstart}      {
                            BEGIN(COMMENT);
                            DBMSG("enter block comment");
                        }

<COMMENT>{
    {bcend}             {
                            BEGIN(INITIAL);
                            loc.step();
                            DBMSG("leave block comment");
                        }
    [^*\n]+             /* do nothing */
    "*"                 /* do nothing */
    \n                  loc.lines(yyleng);
}

{sc}[^\n]*              {
                            loc.step();
                            DBMSG("matche single-line comment");
                        }

{ws}+          loc.step();
[\n]+                   loc.lines(yyleng); loc.step();

    /* string literal */
<INITIAL>{quote}        BEGIN(STRING); str_literal = "";
<STRING>{
    {quote}             {
                            BEGIN(INITIAL); loc.step();
                            return yy::Parser::make_STRING(str_literal, loc);
                        }
    "\\"[nt\\\x22]      str_literal += yytext; /* escaped \n \t \\ \" */
    "\\"[0-7]{1,3}      str_literal += yytext; /* escaped \o \oo \ooo */
    [^\n\\\x22]*        str_literal += yytext; /* not one of \n, \\, \" */
    [\n]                /* FIXME: report an error of unterminated string */
}

    /* keywords list */
"always"                return yy::Parser::make_ALWAYS(loc);
"and"                   return yy::Parser::make_AND(loc);
"assign"                return yy::Parser::make_ASSIGN(loc);
"automatic"             return yy::Parser::make_AUTOMATIC(loc);
"begin"                 return yy::Parser::make_BEGIN(loc);
"buf"                   return yy::Parser::make_BUF(loc);
"bufif0"                return yy::Parser::make_BUFIF0(loc);
"bufif1"                return yy::Parser::make_BUFIF1(loc);
"case"                  return yy::Parser::make_CASE(loc);
"casex"                 return yy::Parser::make_CASEX(loc);
"casez"                 return yy::Parser::make_CASEZ(loc);
"cell"                  return yy::Parser::make_CELL(loc);
"cmos"                  return yy::Parser::make_CMOS(loc);
"config"                return yy::Parser::make_CONFIG(loc);
"deassign"              return yy::Parser::make_DEASSIGN(loc);
"default"               return yy::Parser::make_DEFAULT(loc);
"defparam"              return yy::Parser::make_DEFPARAM(loc);
"design"                return yy::Parser::make_DESIGN(loc);
"disable"               return yy::Parser::make_DISABLE(loc);
"edge"                  return yy::Parser::make_EDGE(loc);
"else"                  return yy::Parser::make_ELSE(loc);
"end"                   return yy::Parser::make_END(loc);
"endcase"               return yy::Parser::make_ENDCASE(loc);
"endconfig"             return yy::Parser::make_ENDCONFIG(loc);
"endfunction"           return yy::Parser::make_ENDFUNCTION(loc);
"endgenerate"           return yy::Parser::make_ENDGENERATE(loc);
"endmodule"             return yy::Parser::make_ENDMODULE(loc);
"endprimitive"          return yy::Parser::make_ENDPRIMITIVE(loc);
"endspecify"            return yy::Parser::make_ENDSPECIFY(loc);
"endtable"              return yy::Parser::make_ENDTABLE(loc);
"endtask"               return yy::Parser::make_ENDTASK(loc);
"event"                 return yy::Parser::make_EVENT(loc);
"for"                   return yy::Parser::make_FOR(loc);
"force"                 return yy::Parser::make_FORCE(loc);
"forever"               return yy::Parser::make_FOREVER(loc);
"fork"                  return yy::Parser::make_FORK(loc);
"function"              return yy::Parser::make_FUNCTION(loc);
"generate"              return yy::Parser::make_GENERATE(loc);
"genvar"                return yy::Parser::make_GENVAR(loc);
"highz0"                return yy::Parser::make_HIGHZ0(loc);
"highz1"                return yy::Parser::make_HIGHZ1(loc);
"if"                    return yy::Parser::make_IF(loc);
"ifnone"                return yy::Parser::make_IFNONE(loc);
"incdir"                return yy::Parser::make_INCDIR(loc);
"include"               return yy::Parser::make_INCLUDE(loc);
"initial"               return yy::Parser::make_INITIAL(loc);
"inout"                 return yy::Parser::make_INOUT(loc);
"input"                 return yy::Parser::make_INPUT(loc);
"instance"              return yy::Parser::make_INSTANCE(loc);
"integer"               return yy::Parser::make_INTEGER(loc);
"join"                  return yy::Parser::make_JOIN(loc);
"large"                 return yy::Parser::make_LARGE(loc);
"liblist"               return yy::Parser::make_LIBLIST(loc);
"library"               return yy::Parser::make_LIBRARY(loc);
"localparam"            return yy::Parser::make_LOCALPARAM(loc);
"macromodule"           return yy::Parser::make_MACROMODULE(loc);
"medium"                return yy::Parser::make_MEDIUM(loc);
"module"                return yy::Parser::make_MODULE(loc);
"nand"                  return yy::Parser::make_NAND(loc);
"negedge"               return yy::Parser::make_NEGEDGE(loc);
"nmos"                  return yy::Parser::make_NMOS(loc);
"nor"                   return yy::Parser::make_NOR(loc);
"noshowcancelled"       return yy::Parser::make_NOSHOWCANCELLED(loc);
"not"                   return yy::Parser::make_NOT(loc);
"notif0"                return yy::Parser::make_NOTIF0(loc);
"notif1"                return yy::Parser::make_NOTIF1(loc);
"or"                    return yy::Parser::make_OR(loc);
"output"                return yy::Parser::make_OUTPUT(loc);
"parameter"             return yy::Parser::make_PARAMETER(loc);
"pmos"                  return yy::Parser::make_PMOS(loc);
"posedge"               return yy::Parser::make_POSEDGE(loc);
"primitive"             return yy::Parser::make_PRIMITIVE(loc);
"pull0"                 return yy::Parser::make_PULL0(loc);
"pull1"                 return yy::Parser::make_PULL1(loc);
"pulldown"              return yy::Parser::make_PULLDOWN(loc);
"pullup"                return yy::Parser::make_PULLUP(loc);
"pulsestyle_onevent"    return yy::Parser::make_PULSESTYLE_ONEVENT(loc);
"pulsestyle_ondetect"   return yy::Parser::make_PULSESTYLE_ONDETECT(loc);
"rcmos"                 return yy::Parser::make_RCMOS(loc);
"real"                  return yy::Parser::make_REAL(loc);
"realtime"              return yy::Parser::make_REALTIME(loc);
"reg"                   return yy::Parser::make_REG(loc);
"release"               return yy::Parser::make_RELEASE(loc);
"repeat"                return yy::Parser::make_REPEAT(loc);
"rnmos"                 return yy::Parser::make_RNMOS(loc);
"rpmos"                 return yy::Parser::make_RPMOS(loc);
"rtran"                 return yy::Parser::make_RTRAN(loc);
"rtranif0"              return yy::Parser::make_RTRANIF0(loc);
"rtranif1"              return yy::Parser::make_RTRANIF1(loc);
"scalared"              return yy::Parser::make_SCALARED(loc);
"showcancelled"         return yy::Parser::make_SHOWCANCELLED(loc);
"signed"                return yy::Parser::make_SIGNED(loc);
"small"                 return yy::Parser::make_SMALL(loc);
"specify"               return yy::Parser::make_SPECIFY(loc);
"specparam"             return yy::Parser::make_SPECPARAM(loc);
"strong0"               return yy::Parser::make_STRONG0(loc);
"strong1"               return yy::Parser::make_STRONG1(loc);
"supply0"               return yy::Parser::make_SUPPLY0(loc);
"supply1"               return yy::Parser::make_SUPPLY1(loc);
"table"                 return yy::Parser::make_TABLE(loc);
"task"                  return yy::Parser::make_TASK(loc);
"time"                  return yy::Parser::make_TIME(loc);
"tran"                  return yy::Parser::make_TRAN(loc);
"tranif0"               return yy::Parser::make_TRANIF0(loc);
"tranif1"               return yy::Parser::make_TRANIF1(loc);
"tri"                   return yy::Parser::make_TRI(loc);
"tri0"                  return yy::Parser::make_TRI0(loc);
"tri1"                  return yy::Parser::make_TRI1(loc);
"triand"                return yy::Parser::make_TRIAND(loc);
"trior"                 return yy::Parser::make_TRIOR(loc);
"trireg"                return yy::Parser::make_TRIREG(loc);
"unsigned"              return yy::Parser::make_UNSIGNED(loc);
"use"                   return yy::Parser::make_USE(loc);
"vectored"              return yy::Parser::make_VECTORED(loc);
"wait"                  return yy::Parser::make_WAIT(loc);
"wand"                  return yy::Parser::make_WAND(loc);
"weak0"                 return yy::Parser::make_WEAK0(loc);
"weak1"                 return yy::Parser::make_WEAK1(loc);
"while"                 return yy::Parser::make_WHILE(loc);
"wire"                  return yy::Parser::make_WIRE(loc);
"wor"                   return yy::Parser::make_WOR(loc);
"xnor"                  return yy::Parser::make_XNOR(loc);
"xor"                   return yy::Parser::make_XOR(loc);

    /* operator token list */
">>>"                   return yy::Parser::make_ARITHMETIC_R_SHIFT(loc);
"<<<"                   return yy::Parser::make_ARITHMETIC_L_SHIFT(loc);
"==="                   return yy::Parser::make_CASE_EQUAL(loc);
"!=="                   return yy::Parser::make_CASE_INEQUAL(loc);
">>"                    return yy::Parser::make_LOGIC_R_SHIFT(loc);
"<<"                    return yy::Parser::make_LOGIC_L_SHIFT(loc);
"&&"                    return yy::Parser::make_LOGIC_AND(loc);
"||"                    return yy::Parser::make_LOGIC_OR(loc);
"=="                    return yy::Parser::make_LOGIC_EQUAL(loc);
"!="                    return yy::Parser::make_LOGIC_INEQUAL(loc);
"**"                    return yy::Parser::make_POWER(loc);
"?"                     return yy::Parser::make_QUESTION_MARK(loc);
"~|"                    return yy::Parser::make_REDUCTION_NOR(loc);
"~^"                    return yy::Parser::make_TILDE_HAT(loc);
"~&"                    return yy::Parser::make_REDUCTION_NAND(loc);
"^~"                    return yy::Parser::make_HAT_TILDE(loc);
">="                    return yy::Parser::make_GREATER_EQUAL(loc);
"<="                    return yy::Parser::make_LESS_EQUAL(loc);
":"                     return yy::Parser::make_COLON(loc);
";"                     return yy::Parser::make_SEMICOLON(loc);
">"                     return yy::Parser::make_GREATER(loc);
"<"                     return yy::Parser::make_LESS(loc);
"^"                     return yy::Parser::make_HAT(loc);
"|"                     return yy::Parser::make_BITWISE_OR(loc);
"&"                     return yy::Parser::make_BITWISE_AND(loc);
"{"                     return yy::Parser::make_CURLY_BRACKET_L(loc);
"}"                     return yy::Parser::make_CURLY_BRACKET_R(loc);
"["                     return yy::Parser::make_SQUARE_BRACKET_L(loc);
"]"                     return yy::Parser::make_SQUARE_BRACKET_R(loc);
"~"                     return yy::Parser::make_BITWISE_NEG(loc);
"+"                     return yy::Parser::make_PLUS(loc);
"-"                     return yy::Parser::make_MINUS(loc);
"*"                     return yy::Parser::make_MUL(loc);
"/"                     return yy::Parser::make_DIV(loc);
"%"                     return yy::Parser::make_MOD(loc);
"!"                     return yy::Parser::make_LOGIC_NEG(loc);
"@"                     return yy::Parser::make_AT(loc);
"#"                     return yy::Parser::make_HASH(loc);
"."                     return yy::Parser::make_DOT(loc);

    /* compiler directives */
"`celldefine"           return yy::Parser::make__CELLDEFINE(loc);
"`default_nettype"      return yy::Parser::make__DEFAULT_NETTYPE(loc);
"`define"               return yy::Parser::make__DEFINE(loc);
"`else"                 return yy::Parser::make__ELSE(loc);
"`elsif"                return yy::Parser::make__ELSIF(loc);
"`endcelldefine"        return yy::Parser::make__ENDCELLDEFINE(loc);
"`endif"                return yy::Parser::make__ENDIF(loc);
"`ifdef"                return yy::Parser::make__IFDEF(loc);
"`ifndef"               return yy::Parser::make__IFNDEF(loc);
"`include"              return yy::Parser::make__INCLUDE(loc);
"`line"                 return yy::Parser::make__LINE(loc);
"`nounconnected_drive"  return yy::Parser::make__NOUNCONNECTED_DRIVE(loc);
"`resetall"             return yy::Parser::make__RESETALL(loc);
"`timescale"            return yy::Parser::make__TIMESCALE(loc);
"`unconnected_drive"    return yy::Parser::make__UNCONNECTED_DRIVE(loc);
"`undef"                return yy::Parser::make__UNDEF(loc);

{simple_id}         return yy::Parser::make_SIMPLE_IDENTIFIER(yytext, loc);

{bin_number}        return yy::Parser::make_BINARY_NUMBER(yytext, loc);
{oct_number}        return yy::Parser::make_OCTAL_NUMBER(yytext, loc);
{hex_number}        return yy::Parser::make_HEX_NUMBER(yytext, loc);
{real_number}       return yy::Parser::make_REAL_NUMBER(yytext, loc);
{uns_number}        return yy::Parser::make_UNSIGNED_NUMBER(yytext, loc);
{dec_number_others} return yy::Parser::make_DECIMAL_NUMBER_OTHERS(yytext,loc);
    /* FIXME: number should return an new symbol type of number*/

.                       DBMSG("scan invalid character: " << yytext);
<<EOF>>                 return yy::Parser::make_EOF(loc);
%%

void Driver::scan_begin() {
    yy_flex_debug = trace_scanning;
    if (file.empty() || file == "-")
        yyin = stdin;
    else {
        yyin = fopen(file.c_str(), "r");
    }
}

void Driver::scan_end() {
    fclose(yyin);
}

