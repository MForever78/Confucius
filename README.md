# Confucius

A verilog obfuscator

# Build

```
mkdir build # if not exists
cd build
cmake ..
make
```
# Debug

## 1. Set `YYDEBUG` macro

`#define YYDEBUG 1` in prologue of `parser.yy`

## 2. Set `trace_` member of driver

```c++
parser.trace_scanning = true;
parser.trace_parsing = true;
```

