import std.stdio: writefln;
import std.datetime.stopwatch: StopWatch, AutoStart;

int isPrime(int n) {
    foreach(i; 2..n/2 + 1)
        if (!(n % i))
            return 0;
    return 1;
}

void main() {
    auto sw = StopWatch(AutoStart.no);
    sw.start();
    int limit = 250001;
    int numPrimes = 0;
    foreach(i; 2..limit)
        numPrimes += isPrime(i);
    sw.stop();
    writefln("\n%d primes found <%d in %f sec using D\n", numPrimes, limit, cast(float) sw.peek.total!"msecs" / 1000.);
}
