#ifndef DRIVER_HPP
#define DRIVER_HPP
#include <string>
#include <map>
#include "parser.hpp"

#define YY_DECL \
    yy::Parser::symbol_type yylex (Driver& driver)

YY_DECL;

class Driver {
public:
    Driver();
    virtual ~Driver();

    std::map<std::string, int> variables;
    
    int result;

    void scan_begin();
    void scan_end();

    bool trace_scanning;

    int parse(const std::string& f);

    std::string file;
    bool trace_parsing;

    void error(const yy::location& l, const std::string& m);
    void error(const std::string& m);
};

#endif 

