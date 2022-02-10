import std;
 
import std.datetime.stopwatch;
 
alias nullableUlong = Nullable!ulong;
 
static immutable ulong A = 1_103_515_245L;
static immutable ulong C = 12_345L;
static immutable ulong M = cast(ulong) 1 << 31;
 
import std.container.dlist;
 
struct LRU(KT, VT)
{
    private size_t _size;
    private VT[KT] _dict;
 
    private DList!KT _order = DList!KT();
    private size_t _orderSize;
 
    this(size_t size)
    {
        _size = size;
    }
 
    void destroy()
    {
        _order.clear;
    }
 
    protected VT get(KT key)
    {
        auto val = key in _dict;
        VT a;
        a.nullify();
        if (val == null)
            return a;
        bool isRemove = _order.linearRemoveElement(key);
        enforce(isRemove, "Removing error from list");
        _order.insertBack(key);
        return _dict[key];
    }
 
    protected void put(KT key, VT value)
    {
        auto val = key in _dict;
        if (val == null)
        {
            if (_orderSize == _size)
            {
                _dict.remove(_order.front);
                _order.removeFront;
                _orderSize--;
            }
        }
        else
        {
            bool isRemove = _order.linearRemoveElement(key);
            if (isRemove)
            {
                _orderSize--;
            }
        }
 
        _order.insertBack(key);
        _orderSize++;
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
    if (argv.length == 1)
        n = 100;
    else
        n = to!long(argv[1]);
    int hit, missed;
 
    alias CPP11LCG = LinearCongruentialEngine!(ulong, A, C, M);
    auto rnd0 = CPP11LCG(0);
    auto rnd1 = CPP11LCG(1);
    auto lru = LRU!(ulong, nullableUlong)(10);
    scope (exit)
    {
        lru.destroy;
    }
 
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