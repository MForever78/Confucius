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
ws          [ \t\n] /* TODO: watch out white spaces in string literals */

/* comments */
/* TODO: no rules in Rule Section for comments now */
sc          "//" /* single-line comment */
bcstart     "/*" /* block comment */
bcend       "*/"

/* operators */
/* TODO: maybe no need to define operators here, however in Rule Section */

/* numbers */
/* TODO: not consider the situation that white space is embedded in number */
z_digit     [zZ?]
x_digit     [xX]

hex_digit   {x_digit}|{z_digit}|[0-9a-fA-F]
oct_digit   {x_digit}|{z_digit}|[0-7]
bin_digit   {x_digit}|{z_digit||[0-1]
dec_digit   [0-9]
dec_digit_pos   [1-9] /* positive digit */

hex_base    "'"[sS]?[hH]
oct_base    "'"[sS]?[oO]
bin_base    "'"[sS]?[bB]
dec_base    "'"[sS]?[dD]

hex_value   {hex_digit}(_|{hex_digit})+
oct_value   {oct_digit}(_|{oct_digit})+
bin_value   {bin_digit}(_|{bin_digit})+
dec_value   {dec_digit}(_|{dec_digit})+

uns_number  {dec_digit}(_|dec_digit)+       /* unsigned number */
pos_number  {dec_digit_pos}(_|dec_digit)+   /* non-zero unsigned */

size        {pos_number}
sign        [+-]

hex_number  {size}?{hex_base}{hex_value}
oct_number  {size}?{oct_base}{oct_value}
bin_number  {size}?{bin_base}{bin_value}
dec_number  {uns_number} /*
    */| {size}?{dec_base}{uns_number}|
            {size}?{dec_base}{x_digit}[_]*|\
            {size}?{dec_base}{z_digit}[_]* /* TODO: could we wrap this line under the flex grammar? */


exp_digit   [eE]
real_number {uns_number}"."{uns_number}|{uns_number}("."{uns_number})?{exp_digit}{sign}?{uns_number} /* TODO: same with last todo, about wrapping */

number      {dec_number}|{oct_number}|{bin_number}|{hex_number}|{real_number}

/* strings */
/* TODO: can not simply use definition */

/* identifiers */
/* TODO: maximum length of identifiers is 1024 characters */
id          [a-z_A-Z][a-z_$A-Z0-9]*

/* keyword */
/* TODO: insert the keyword list */

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
loc.step();
%}

ws+         loc.step();
[\n]+       loc.lines(yyleng); loc.step();

                         /* keywords list */
"always"                 return make_ALWAYS(yytext, loc);
"and"                    return make_AND(yytext, loc);
"assign"                 return make_ASSIGN(yytext, loc);
"automatic"              return make_AUTOMATIC(yytext, loc);
"begin"                  return make_BEGIN(yytext, loc);
"buf"                    return make_BUF(yytext, loc);
"bufif0"                 return make_BUFIF0(yytext, loc);
"bufif1"                 return make_BUFIF1(yytext, loc);
"case"                   return make_CASE(yytext, loc);
"casex"                  return make_CASEX(yytext, loc);
"casez"                  return make_CASEZ(yytext, loc);
"cell"                   return make_CELL(yytext, loc);
"cmos"                   return make_CMOS(yytext, loc);
"config"                 return make_CONFIG(yytext, loc);
"deassign"               return make_DEASSIGN(yytext, loc);
"default"                return make_DEFAULT(yytext, loc);
"defparam"               return make_DEFPARAM(yytext, loc);
"design"                 return make_DESIGN(yytext, loc);
"disable"                return make_DISABLE(yytext, loc);
"edge"                   return make_EDGE(yytext, loc);
"else"                   return make_ELSE(yytext, loc);
"end"                    return make_END(yytext, loc);
"endcase"                return make_ENDCASE(yytext, loc);
"endconfig"              return make_ENDCONFIG(yytext, loc);
"endfunction"            return make_ENDFUNCTION(yytext, loc);
"endgenerate"            return make_ENDGENERATE(yytext, loc);
"endmodule"              return make_ENDMODULE(yytext, loc);
"endprimitive"           return make_ENDPRIMITIVE(yytext, loc);
"endspecify"             return make_ENDSPECIFY(yytext, loc);
"endtable"               return make_ENDTABLE(yytext, loc);
"endtask"                return make_ENDTASK(yytext, loc);
"event"                  return make_EVENT(yytext, loc);
"for"                    return make_FOR(yytext, loc);
"force"                  return make_FORCE(yytext, loc);
"forever"                return make_FOREVER(yytext, loc);
"fork"                   return make_FORK(yytext, loc);
"function"               return make_FUNCTION(yytext, loc);
"generate"               return make_GENERATE(yytext, loc);
"genvar"                 return make_GENVAR(yytext, loc);
"highz0"                 return make_HIGHZ0(yytext, loc);
"highz1"                 return make_HIGHZ1(yytext, loc);
"if"                     return make_IF(yytext, loc);
"ifnone"                 return make_IFNONE(yytext, loc);
"incdir"                 return make_INCDIR(yytext, loc);
"include"                return make_INCLUDE(yytext, loc);
"initial"                return make_INITIAL(yytext, loc);
"inout"                  return make_INOUT(yytext, loc);
"input"                  return make_INPUT(yytext, loc);
"instance"               return make_INSTANCE(yytext, loc);
"integer"                return make_INTEGER(yytext, loc);
"join"                   return make_JOIN(yytext, loc);
"large"                  return make_LARGE(yytext, loc);
"liblist"                return make_LIBLIST(yytext, loc);
"library"                return make_LIBRARY(yytext, loc);
"localparam"             return make_LOCALPARAM(yytext, loc);
"macromodule"            return make_MACROMODULE(yytext, loc);
"medium"                 return make_MEDIUM(yytext, loc);
"module"                 return make_MODULE(yytext, loc);
"nand"                   return make_NAND(yytext, loc);
"negedge"                return make_NEGEDGE(yytext, loc);
"nmos"                   return make_NMOS(yytext, loc);
"nor"                    return make_NOR(yytext, loc);
"noshowcancelled"        return make_NOSHOWCANCELLED(yytext, loc);
"not"                    return make_NOT(yytext, loc);
"notif0"                 return make_NOTIF0(yytext, loc);
"notif1"                 return make_NOTIF1(yytext, loc);
"or"                     return make_OR(yytext, loc);
"output"                 return make_OUTPUT(yytext, loc);
"parameter"              return make_PARAMETER(yytext, loc);
"pmos"                   return make_PMOS(yytext, loc);
"posedge"                return make_POSEDGE(yytext, loc);
"primitive"              return make_PRIMITIVE(yytext, loc);
"pull0"                  return make_PULL0(yytext, loc);
"pull1"                  return make_PULL1(yytext, loc);
"pulldown"               return make_PULLDOWN(yytext, loc);
"pullup"                 return make_PULLUP(yytext, loc);
"pulsestyle_onevent"     return make_PULSESTYLE_ONEVENT(yytext, loc);
"pulsestyle_ondetect"    return make_PULSESTYLE_ONDETECT(yytext, loc);
"rcmos"                  return make_RCMOS(yytext, loc);
"real"                   return make_REAL(yytext, loc);
"realtime"               return make_REALTIME(yytext, loc);
"reg"                    return make_REG(yytext, loc);
"release"                return make_RELEASE(yytext, loc);
"repeat"                 return make_REPEAT(yytext, loc);
"rnmos"                  return make_RNMOS(yytext, loc);
"rpmos"                  return make_RPMOS(yytext, loc);
"rtran"                  return make_RTRAN(yytext, loc);
"rtranif0"               return make_RTRANIF0(yytext, loc);
"rtranif1"               return make_RTRANIF1(yytext, loc);
"scalared"               return make_SCALARED(yytext, loc);
"showcancelled"          return make_SHOWCANCELLED(yytext, loc);
"signed"                 return make_SIGNED(yytext, loc);
"small"                  return make_SMALL(yytext, loc);
"specify"                return make_SPECIFY(yytext, loc);
"specparam"              return make_SPECPARAM(yytext, loc);
"strong0"                return make_STRONG0(yytext, loc);
"strong1"                return make_STRONG1(yytext, loc);
"supply0"                return make_SUPPLY0(yytext, loc);
"supply1"                return make_SUPPLY1(yytext, loc);
"table"                  return make_TABLE(yytext, loc);
"task"                   return make_TASK(yytext, loc);
"time"                   return make_TIME(yytext, loc);
"tran"                   return make_TRAN(yytext, loc);
"tranif0"                return make_TRANIF0(yytext, loc);
"tranif1"                return make_TRANIF1(yytext, loc);
"tri"                    return make_TRI(yytext, loc);
"tri0"                   return make_TRI0(yytext, loc);
"tri1"                   return make_TRI1(yytext, loc);
"triand"                 return make_TRIAND(yytext, loc);
"trior"                  return make_TRIOR(yytext, loc);
"trireg"                 return make_TRIREG(yytext, loc);
"unsigned"               return make_UNSIGNED(yytext, loc);
"use"                    return make_USE(yytext, loc);
"vectored"               return make_VECTORED(yytext, loc);
"wait"                   return make_WAIT(yytext, loc);
"wand"                   return make_WAND(yytext, loc);
"weak0"                  return make_WEAK0(yytext, loc);
"weak1"                  return make_WEAK1(yytext, loc);
"while"                  return make_WHILE(yytext, loc);
"wire"                   return make_WIRE(yytext, loc);
"wor"                    return make_WOR(yytext, loc);
"xnor"                   return make_XNOR(yytext, loc);
"xor"                    return make_XOR(yytext, loc);
                    
{id}        {
                DBVAR(std::string(yytext));
                return yy::Parser::make_IDENTIFIER(yytext, loc);
            }

<<EOF>>     {
                return yy::Parser::make_EOF(loc);
            }
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

