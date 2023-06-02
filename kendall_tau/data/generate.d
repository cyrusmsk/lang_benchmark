import std;
import std.file: write;

uint[] generate_ts(uint len, uint seed, uint maxValue)
{
    uint[] res = new uint[len];
    BigInt next = seed;
    foreach(ref el; res)
    {
        next = next * 1_103_515_245;
        el = cast(uint)((next/65_536) % (maxValue));
    }
    return res;
}

void main()
{
    //auto lhs = generate_ts(50_000, 5, 100);
    //auto rhs = generate_ts(50_000, 1, 100);
    File file = File("data.csv", "w");
    int[] a = [ 0, 1, 1, 2, 3, 5, 8 ];
    file.writefln("%(%s,%)",a);
}
