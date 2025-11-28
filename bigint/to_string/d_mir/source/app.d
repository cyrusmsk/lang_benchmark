import core.time : Duration;
enum N = 10_000;

Duration test_mir() {
    import mir.stdio;
    import mir.bignum.integer;
    import std.datetime.stopwatch;

    auto start = StopWatch(AutoStart.yes);

    auto a = BigInt!64(0);
    auto b = BigInt!64(1);
    auto sum = BigInt!64(0);

    foreach (n; 2 .. N) {
        sum += a;
        sum += b;
        dout << n << "\t" << sum << "\n";
        a = b;
        b = sum;
    }

    start.stop();
    return start.peek();
}
void main() {
    import std.stdio : writeln;

    writeln(i"Total time = $(test_mir())");
}
