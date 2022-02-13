import std;

static immutable ulong A = 1_103_515_245L;
static immutable ulong C = 12_345L;
static immutable ulong M = cast(ulong) 1 << 31;

final class LCG(VT)
{
    private VT _seed;

    this(VT seed)
    {
        _seed = seed;
    }

    protected VT next()
    {
        _lcg();
        return _seed;
    }

    protected void _lcg()
    {
        _seed = (A * _seed + C) % M;
    }
}

void main(string[] argv)
{
    int n = to!int(argv[1]);

    auto rnd0 = new LCG!uint(0);
    auto rnd1 = new LCG!uint(1);

    uint n0,n1;

    foreach (i; 0 .. n)
    {
        n0 = rnd0.next % 1000;
        n1 = rnd1.next % 1000;
    }
    writeln(n0 + n1);
}
