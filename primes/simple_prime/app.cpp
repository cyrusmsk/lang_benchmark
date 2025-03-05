#include <iostream>
#include <vector>
#include <chrono>

using namespace std;
using namespace std::chrono;

void SieveOfEratosthenes(int n)
{
    vector<bool> prime(n + 1, true);

    for (int p = 2; p * p <= n; p++)
    {
        if (prime[p] == true)
        {
            for (int i = p * p; i <= n; i += p)
            {
                prime[i] = false;
            }
        }
    }
}

int main()
{
    int n = 1000000000;
    auto start = high_resolution_clock::now();
    SieveOfEratosthenes(n);
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<milliseconds>(stop - start);
    cout << "Time taken by SieveOfEratosthenes: "
         << duration.count() << " milliseconds" << endl;

    return 0;
}
