@safe:
import std;
import std.outbuffer: OutBuffer;

static immutable LN_TAU = log(PI * 2);

void main(string[] args)
{
    OutBuffer buf = new OutBuffer();
    scope(exit) write(buf.toString());
    auto n = args.length > 1 ? args[1].to!int() : 27;
    immutable int k = binary_search(n);
    BigInt q, p;
    AliasSeq!(p, q) = sum_terms(0, k - 1);

    p += q;
    string a = "1";
    foreach(_; 0 .. n)
        a ~= "0";
    auto answer = p * BigInt(a) / q;

    auto s = format("%s", answer);
    auto i = 0;
    for (; i + 10 <= n; i += 10)
    {
        auto end = i + 10;
        buf.writefln("%s\t:%d", s[i .. end], end);
    }
    auto rem_len = n - i;
    if (rem_len > 0)
    {
        auto padding = "";
        for (auto j = 0; j < 10 - rem_len; j++)
            padding ~= " ";
        buf.writefln("%s%s\t:%d", s[i .. n], padding, n);
    }
}

static ONE = BigInt(1);

Tuple!(BigInt, BigInt) sum_terms(int a, int b)
{
    if (b == a + 1)
    {
        return tuple(ONE, BigInt(b));
    }
    auto mid = (a + b) / 2;
    BigInt p_left, q_left, p_right, q_right;
    AliasSeq!(p_left, q_left) = sum_terms(a, mid);
    AliasSeq!(p_right, q_right)= sum_terms(mid, b);
    return tuple(p_left*q_right + p_right, q_left * q_right);
}

int binary_search(int n)
{
    auto a = 0;
    auto b = 1;
    while (!test_k(n, b))
    {
        a = b;
        b <<= 1;
    }
    int m;
    while (b - a > 1)
    {
        m = (a + b) / 2;
        if (test_k(n, m))
            b = m;
        else
            a = m;
    }
    return b;
}

bool test_k(int n, int k)
{
    if (k < 0)
        return false;
    auto ln_k_factorial = k * (log(k) - 1) + 0.5 * LN_TAU;
    auto log_10_k_factorial = ln_k_factorial / LN10;
    return log_10_k_factorial >= n + 50;
}