using System.Threading;
Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture;

var start = System.DateTimeOffset.Now.Ticks;
int limit = 250001;
int numPrimes = 0;

static int IsPrime(int n)
{
    for (int i = 2; i < n/2 + 1; i++)
        if ((n % i) == 0)
            return 0;
    return 1;
}

for (int i = 2; i < limit; i++)
{
    numPrimes += IsPrime(i);
}

long timeElapsed = System.DateTimeOffset.Now.Ticks - start;
System.Console.WriteLine("\n{0} primes found <{1} in {2} sec using C#\n", numPrimes, limit, (timeElapsed/10_000_000d));
