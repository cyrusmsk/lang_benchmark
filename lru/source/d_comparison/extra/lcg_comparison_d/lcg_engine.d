import std;

static immutable ulong A = 1_103_515_245L;
static immutable ulong C = 12_345L;
static immutable ulong M = cast(ulong) 1 << 31;


void main(string[] argv)
{

    int n = to!int(argv[1]);

    alias CPP11LCG = LinearCongruentialEngine!(uint, A, C, M);
    auto rnd0 = CPP11LCG(0);
    auto rnd1 = CPP11LCG(1);
    
    uint n0, n1;

    foreach (i; 0 .. n)
    {
        n0 = rnd0.front % 1000;
        rnd0.popFront();

        n1 = rnd1.front % 1000;
        rnd1.popFront();
    }
    writeln(n0 + n1);
}
