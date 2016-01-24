%{ /* -*- C++ -*- */
#include <string>
#include "driver.hpp"
#include "parser.hpp"

#undef yywrap
#define yywrap() 1

static yy::location loc;
%}

%option noyywrap nounput batch debug noinput

id [a-zA-z][a-zA-Z_0-9]*
int [0-9]+
blank [ \t]

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
loc.step();
%}

{blank}+    loc.step();
[\n]+       loc.lines(yyleng); loc.step();

"-"         return yy::Parser::make_MINUS(loc);
"+"         return yy::Parser::make_PLUS(loc);
":="        return yy::Parser::make_ASSIGN(loc);

{int}       {
                long n = strtol(yytext, NULL, 10);
                return yy::Parser::make_NUMBER(n, loc);
            }

{id}        return yy::Parser::make_IDENTIFIER(yytext, loc);
.           driver.error(loc, "invalid character");
<<EOF>>     return yy::Parser::make_END(loc);
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

