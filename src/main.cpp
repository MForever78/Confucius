#include <iostream>
#include "driver.hpp"

int main(int argc, const char **argv) {
    int ret = 0;
    Driver driver;
    driver.parse(argv[1]);
    std::cout << driver.result << std::endl;
    return ret;
}
