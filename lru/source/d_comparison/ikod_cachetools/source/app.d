import std;
import cachetools;

immutable ulong A = 1_103_515_245L;
immutable ulong C = 12_345L;
immutable ulong M = cast(ulong) 1 << 31;

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
	uint n, k, l;
	if (argv.length == 1)
    {
		n = 10_000;
        k = 100;
    }
	else
    {
        k = to!uint(argv[1]);
		n = to!uint(argv[2]);
    }
	uint hit, missed;

	auto rnd0 = new LCG!uint(0);
	auto rnd1 = new LCG!uint(1);
	auto lru = new CacheLRU!(uint, uint);
    lru.size = k;

	l = 10*k;
	uint n0, n1;
	foreach (i; 0 .. n)
	{
		n0 = rnd0.next % l;
		lru.put(n0, n0);
		n1 = rnd1.next % l;
		if (lru.get(n1).isNull)
			missed++;
		else
			hit++;
	}
	printf("%d\n%d", hit, missed);
}
