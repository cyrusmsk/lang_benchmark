import std;

alias nullableUlong = Nullable!ulong;

static immutable ulong A = 1_103_515_245L;
static immutable ulong C = 12_345L;
static immutable ulong M = cast(ulong) 1 << 31;

class LRU(KT, VT)
{
    private int _size;
    private VT[KT] _dict;
    private KT[] _order;

    this(int size)
    {
        _size = size;
        _order = new KT[size];
    }

    protected VT get(KT key)
    {
        auto val = key in _dict;
        VT a;
        a.nullify();
        if (val == null)
            return a;
        auto index = _order.countUntil(key);          
        _order = _order.remove(index);
        _order ~= key;
        return _dict[key];
    }

    protected void put(KT key, VT value)
    {
        auto val = key in _dict;
        if (val == null)
        {
            if (_order.length == _size)
            {
                _dict.remove(_order.front());
                _order.popFront();
                
            }
        }
        else
        {
            auto index = _order.countUntil(key);
            _order = _order.remove(index);
        }
        _order ~= key;
        _dict[key] = value;
    }
}

class LCG(VT)
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
    long n;
    if (argv.length == 0)
        n = 100;
    else
        n = to!long(argv[1]);
    int hit, missed;

    alias CPP11LCG = LinearCongruentialEngine!(ulong, A, C, M);
    auto rnd0 = CPP11LCG(0);
    auto rnd1 = CPP11LCG(1);
    auto lru = new LRU!(ulong, nullableUlong)(10);

    foreach (i; 0 .. n)
    {
        auto n0 = rnd0.front % 100;
        rnd0.popFront();
        lru.put(n0, to!nullableUlong(n0));
        auto n1 = rnd1.front % 100;
        rnd1.popFront();
        if (lru.get(n1).isNull)
            missed++;
        else
            hit++;
    }
    writeln(hit);
    writeln(missed);
}
