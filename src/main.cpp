#include <iostream>
#include "driver.hpp"

int main(int argc, const char **argv) {
    int ret = 0;
    Driver driver;
    // enable debugging
    //driver.trace_parsing = true;
    //driver.trace_scanning = true;
    driver.parse(argv[1]);
    return ret;
}
