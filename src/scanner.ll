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
dec_number  {uns_number}|{size}?{dec_base}{uns_number}|{size}?{dec_base}{x_digit}[_]*|{size}?{dec_base}{z_digit}[_]* /* TODO: could we wrap this line under the flex grammar? */


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
{id}        {
                DBVAR(std::string(yytext));
                return yy::Parser::make_IDENTIFIER(yytext, loc);
            }

<<EOF>>     {
                return yy::Parser::make_END(loc);
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

