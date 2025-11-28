import core.time : Duration;
enum N = 10_000;

Duration test_std() {
    import std.stdio : writeln;
    import std.bigint;
    import std.datetime.stopwatch;

    auto start = StopWatch(AutoStart.yes);

    auto a = BigInt(0);
    auto b = BigInt(1);
    auto sum = BigInt(0);

    foreach (n; 2 .. N) {
        sum = a + b;
        writeln(i"$(n)\t$(sum)");
        a = b;
        b = sum;
    }

    start.stop();
    return start.peek();
}

void main() {
    import std.stdio : writeln;

    writeln(i"Total time = $(test_std())");
}
