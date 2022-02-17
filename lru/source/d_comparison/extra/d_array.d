import std;

immutable ulong A = 1_103_515_245L;
immutable ulong C = 12_345L;
immutable ulong M = cast(ulong) 1 << 31;

struct LRU(KT, VT)
{
    private int _size;
    private Tuple!(KT, VT)[] a;

    this(int size)
    {
        _size = size;
    }

    protected Tuple!(bool, VT) get(KT key)
    {
        foreach (i; 0 .. a.length)
        {
            if (a[i][0] == key)
            {
                auto tmp = a[i];
                foreach (j; i + 1 .. a.length)
                    a[j - 1] = a[j];
                a.back = tmp;
                return tuple(true, a.back[1]);
            }
        }
        return tuple(false, cast(VT) 0);
    }

    protected void put(KT key, VT value)
    {
        foreach (i; 0 .. a.length)
        {
            if (a[i][0] == key)
            {
                foreach (j; i + 1 .. a.length)
                    a[j - 1] = a[j];
                a.back = tuple(key, value);
                return;
            }
        }
        if (a.length < _size)
        {
            a ~= tuple(key, value);
            return;
        }
        // FIXME: use ring buffer and this copy loop won't be necessary
        foreach (j; 1 .. a.length)
            a[j - 1] = a[j];
        a.back = tuple(key, value);
    }
}

void main(string[] argv)
{

    int n, k, l;
    if (argv.length == 1)
    {
        n = 1000;
        k = 10;
    }
    else
    {
        n = to!int(argv[1]);
        k = to!int(argv[2]);
    }
    int hit, missed;

    alias CPP11LCG = LinearCongruentialEngine!(ulong, A, C, M);
    auto rnd0 = CPP11LCG(0);
    auto rnd1 = CPP11LCG(1);
    auto lru = LRU!(ulong, ulong)(k);

    l = 10 * k;
    foreach (i; 0 .. n)
    {
        auto n0 = rnd0.front % l;
        rnd0.popFront();

        lru.put(n0, n0);

        auto n1 = rnd1.front % l;
        rnd1.popFront();

        if (!lru.get(n1)[0])
            missed++;
        else
            hit++;
    }

    printf("%d\n", hit);
    printf("%d\n", missed);

}
