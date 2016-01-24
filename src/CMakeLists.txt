set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

find_package(BISON)
find_package(FLEX)

flex_target(VerilogScanner scanner.ll ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp)
bison_target(VerilogParser parser.yy ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
add_flex_bison_dependency(VerilogScanner VerilogParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_executable(Unamed
    main.cpp
    driver.cpp
    ${BISON_VerilogParser_OUTPUTS}
    ${FLEX_VerilogScanner_OUTPUTS}
)

target_link_libraries(Unamed ${FLEX_LIBRARIES} ${BISON_LIBRARIES})
