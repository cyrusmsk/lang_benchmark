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
                a = a.remove(i);
                a ~= tmp;
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
                a = a.remove(i);
                a ~= tuple(key, value);
                return;
            }
        }
        if (a.length < _size)
        {
            a ~= tuple(key, value);
            return;
        }
        // FIXME: use ring buffer and this copy loop won't be necessary
        a.popFront();
        a ~= tuple(key, value);
    }
}

struct LCG(VT)
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

    auto rnd0 = new LCG!ulong(0);
    auto rnd1 = new LCG!ulong(1);
    auto lru = LRU!(ulong, ulong)(k);
    l = 10*k;

    ulong n0, n1;
    foreach (i; 0 .. n)
    {
        n0 = rnd0.next % l;
        
        lru.put(n0, n0);

        n1 = rnd1.next % l;

        if (!lru.get(n1)[0])
            missed++;
        else
            hit++;
    }

    printf("%d\n", hit);
    printf("%d\n", missed);

}
