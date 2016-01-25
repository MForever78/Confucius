#ifndef __DEBUG_OUTPUT_HPP__
#define __DEBUG_OUTPUT_HPP__
#ifdef NDEBUG
#define DEBUG_TEST_COND 0
#else
#define DEBUG_TEST_COND 1
#endif

/* get only filename */
#include <cstring>
#define __FILENAME__ \
    (std::strrchr(__FILE__, '/') ? std::strrchr(__FILE__, '/') + 1 : __FILE__)

/* show more precise infomartion */
#ifdef DB_POSITION
#define __DB_POS__ \
    "[" << __FILENAME__ << ":" << __LINE__ << "] " <<
#else
#define __DB_POS__ "" <<
#endif

/* define printng macros */
#include <iostream>
#define DBVAR(var) \
    do { \
        if (DEBUG_TEST_COND) \
        std::cout << "[DEBUG] " << __DB_POS__ \
        #var << "\t"  << (var) << \
        std::endl; \
    } while (0)

#define DBMSG(msg) \
    do { \
        if (DEBUG_TEST_COND) \
        std::cout << "[DEBUG] " << __DB_POS__ \
        msg << \
        std::endl;\
    } while (0)

#define LOG(msg) \
    do { \
        if (DEBUG_TEST_COND) \
        std::cout << "[LOG] " << __DB_POS__ \
        msg << \
        std::endl; \
    } while (0)

#endif //__DEBUG_OUTPUT_HPP__
