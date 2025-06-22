import std.stdio;
import std.conv;

void main(string[] args)
{
    long n = args.length > 1 ? args[1].to!long: 10;
    long sum_prime;
    long[] prime;
    long check_f;
    long current = 2;
    while(n > 0) {
        foreach(p; prime)
            if (current % p != 0) {
                check_f++;
            }
        if (check_f == prime.length) {
            sum_prime += current;
            prime ~= current;
            n--;
        }
        check_f = 0;
        current++;
    }
    writeln(sum_prime);
}
