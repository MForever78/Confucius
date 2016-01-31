set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

find_package(BISON)
find_package(FLEX)

flex_target(VerilogScanner scanner.ll ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp)
bison_target(VerilogParser parser.yy ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp COMPILE_FLAGS "-v")
add_flex_bison_dependency(VerilogScanner VerilogParser)

set(CMAKE_CXX_NOWARNING "-Wno-deprecated-register")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g ${CMAKE_CXX_NOWARNING}")

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_executable(Confucius
    main.cpp
    driver.cpp
    ${BISON_VerilogParser_OUTPUTS}
    ${FLEX_VerilogScanner_OUTPUTS}
)

target_link_libraries(Confucius ${FLEX_LIBRARIES} ${BISON_LIBRARIES})
