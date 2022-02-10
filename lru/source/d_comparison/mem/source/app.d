import std;
import memutils.hashmap: mem_HashMap = HashMap;
import memutils.allocators;

immutable ulong A = 1_103_515_245L;
immutable ulong C = 12_345L;
immutable ulong M = cast(ulong) 1 << 31;

struct OrderedHash(K, V)
{
	void opIndexAssign(V in_value, K key)
	{
		if (m_data.length > 0)
		{
			auto ptr = key in m_data;
			if (ptr == null)
			{
				(m_last in m_data).next = key;
				m_data[key] = Payload(in_value, m_last);
				m_last = key;
			}
			else
			{
				ptr.valueP = in_value;
			}
		}
		else
		{
			m_data[key] = Payload(in_value, key, key);
			m_first = m_last = key;
		}
	}

	V opIndex(const K key)
	{
		return m_data[key].valueP;
	}

	V* opBinaryRight(string op : "in")(K key)
	{
		// auto ptr = m_data.fetch(key);
		// if (!ptr.ok)
		// 	return null;
		// return ptr.value.valueP;
		auto ptr = key in m_data;
        if (ptr == null)
            return null;
        return &ptr.valueP;
	}

	void remove(K key)
	{
		// auto ptr = m_data.fetch(key);
		auto ptr = key in m_data;
		if (ptr != null)
		{
			if (m_data.length > 1)
			{
				if (key == m_first)
					m_first = ptr.next;
				else if (key == m_last)
					m_last = ptr.prev;
				else
				{
					(ptr.prev in m_data).next = ptr.next;
					// m_data.fetch(ptr.value.prev).value.next = ptr.value.next;
					(ptr.next in m_data).prev = ptr.prev;
					// m_data.fetch(ptr.value.next).value.prev = ptr.value.prev;
				}
			}
			m_data.remove(key);
		}
	}

	auto first_key()
	{
		assert(m_data.length > 0);
		return m_first;
	}

	auto length()
	{
		return m_data.length;
	}

	int opApply(scope int delegate(K, V) dg)
	{
		int result = 0;

		if (m_data.length > 0)
		{
			K k = m_first;
			while (true)
			{
				result = dg(k, m_data[k].valueP);
				if (result || k == m_last)
					break;
				k = m_data[k].next;
			}
		}
		return result;
	}

private:
	struct Payload
	{
		V valueP;
		K prev, next;
	}

	mem_HashMap!(K, Payload) m_data;

	K m_first, m_last;
}

struct LRU(KT, VT)
{
	private int _size;
	private OrderedHash!(VT, KT) _dict;

	this(int size)
	{
		_size = size;
	}

	protected Tuple!(bool, VT) get(KT key)
	{
		auto val = key in _dict;
		if (val == null)
			return tuple(false, cast(VT) 0);
		_dict.remove(key);
		_dict[key] = *val;
		return tuple(true, _dict[key]);
	}

	protected void put(KT key, VT value)
	{
		auto ptr = key in _dict;
		if (ptr == null)
		{
			if (_dict.length == _size)
				_dict.remove(_dict.first_key());
		}
		else
			_dict.remove(key);
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
	int n;
	if (argv.length == 0)
		n = 100;
	else
		n = to!int(argv[1]);
	int hit, missed;

	auto rnd0 = new LCG!ulong(0);
	auto rnd1 = new LCG!ulong(1);
	auto lru = new LRU!(ulong, ulong)(10);

	ulong n0, n1;
	foreach (i; 0 .. n)
	{
		n0 = rnd0.next % 100;
		lru.put(n0, n0);
		n1 = rnd1.next % 100;
		if (!lru.get(n1)[0])
			missed++;
		else
			hit++;
	}
	printf("%d\n", hit);
	printf("%d\n", missed);
}
