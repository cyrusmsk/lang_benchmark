import std;
import core.memory;

immutable ulong A = 1_103_515_245L;
immutable ulong C = 12_345L;
immutable ulong M = cast(ulong) 1 << 31;

struct OrderedHash(K, V)
{
    void opIndexAssign(V value, K key)
    {
        if (m_data.length > 0)
        {
            auto ptr = key in m_data;
            if (ptr == null)
            {
                (m_last in m_data).next = key;
                m_data[key] = Payload(value, m_last);
                m_last = key;
            }
            else
            {
                ptr.value = value;
            }
        }
        else
        {
            m_data[key] = Payload(value, key, key);
            m_first = m_last = key;
        }
    }

    ref V opIndex(const K key)
    {
        return m_data[key].value;
    }

    V* opBinaryRight(string op : "in")(K key)
    {
        auto ptr = key in m_data;
        if (ptr == null)
            return null;
        return &ptr.value;
    }

    void remove(K key)
    {
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
                    (ptr.next in m_data).prev = ptr.prev;
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
                result = dg(k, m_data[k].value);
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
        V value;
        K prev, next;
    }

    Payload[K] m_data;

    K m_first, m_last;
}

class LRU(KT, VT)
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
    int n, k;
    if (argv.length == 1)
    {
        k = 10;
        n = 100;
    }
    else
    {
        n = to!int(argv[1]);
        k = to!int(argv[2]);
    }
    int hit, missed;

    auto rnd0 = new LCG!ulong(0);
    auto rnd1 = new LCG!ulong(1);
    auto lru = new LRU!(ulong, ulong)(k);

    ulong n0, n1;
    GC.disable();
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
    printf("%d\n",hit);
    printf("%d\n",missed);
}