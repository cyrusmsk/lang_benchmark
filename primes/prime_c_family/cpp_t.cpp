#include <stdio.h>
#include <time.h>

int isPrime(int n) {
    for (int i =2;i<=n/2;i++)
        if(!(n%i))
            return 0;
    return 1;
}

int main() {
    clock_t t = clock();
    int limit = 250001;
    int numPrimes = 0;
    for (int i = 2; i < limit; i++)
    {
        numPrimes += isPrime(i);
    }

    t = clock() - t;
    printf("\n%d primes found <\%d in %f sec using Cpp\n\n", numPrimes, limit, ((float)t)/CLOCKS_PER_SEC);
    return 0;
}
