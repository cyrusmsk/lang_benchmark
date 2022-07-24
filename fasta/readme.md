Compilation comands:

crystal build release cr1.cr

zig build-zig -O ReleaseFast zig1.zig

ldc2 -O3 -release -mcpu=native -flto=full -defaultlib=phobos2-ldc-lto,druntime-ldc-lto -m64 -betterC -static d3.d


Versions:
- d1: based on zig version
- d2: with OuterBuf for stdout
- d3: betterC version
