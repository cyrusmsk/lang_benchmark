import core.time : Duration;
enum N = 10_000;

Duration test_gmp() {
    import gmp.z : BigInt = MpZ;
    import std.algorithm.mutation : move;
    import std.datetime.stopwatch;
    import std.stdio : writeln;

    auto start = StopWatch(AutoStart.yes);
    BigInt a = 0.BigInt;
    BigInt b = 1.BigInt;
    BigInt sum = 0.BigInt;

    foreach(n; 2 .. N) {
        sum = a + b;
        writeln(i"$(n)\t$(sum.toString())");
        a = b.move();
        b = sum.move();
    }
    start.stop();
    return start.peek();
}

void main() {
    import std.stdio : writeln;

    writeln(i"Total time = $(test_gmp())");
}
