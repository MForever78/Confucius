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

%token
END 0 "end of file"
MINUS "-"
PLUS  "+"
ASSIGN ":="
;

%token <std::string> IDENTIFIER "identifer"
%token <int> NUMBER "number"
%type <int> exp

%printer {yyoutput << $$; } <*>;

%%

%start unit;

unit: assignments exp   {driver.result = $2;};

assignments:
    %empty              {}
|   assignments assignment {};

assignment:
    "identifer" ":=" exp { driver.variables[$1] = $3; };

%left "+" "-";
exp:
    exp "+" exp { $$ = $1 + $3; }
|   exp "-" exp { $$ = $1 - $3; }
|   "identifer" { $$ = driver.variables[$1];}
|   "number"    { std::swap ($$, $1); };
%%

void yy::Parser::error(const location_type& l, const std::string &m) {
    driver.error(l, m);
}

