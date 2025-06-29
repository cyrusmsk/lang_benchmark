import std;
import core.thread : Thread;

Tuple!(ulong, ulong) f(immutable(ubyte)[] arr, ulong order)
{
    ubyte[] res;
    auto app = appender(&res);
    Thread.sleep(dur!"msecs"(10 * (order)));
    foreach (k; 0 .. 10_000)
    {
        long m = arr.length / 2;
        while (m > 0)
        {
            app ~= arr[m .. $];
            app ~= arr[0 .. m];
            m /= 2;
        }
    }
    res.sort!"a < b";
    return tuple(order, res.length);
}

void main()
{
    static immutable(ubyte)[][10] data = [
        cast(immutable(ubyte)[]) "wqerqwerqwerqwerqwerqwerqwerqwer",
        cast(immutable(ubyte)[]) "wqerqwerqwerqwerqwerqwerqwer",
        cast(immutable(ubyte)[]) "wqerqwerqwerqwerqwerqwer",
        cast(immutable(ubyte)[]) "wqerqwerqerqwerqwer",
        cast(immutable(ubyte)[]) "wqerqwerqwerqwer",
        cast(immutable(ubyte)[]) "wqerqwerrqwer",
        cast(immutable(ubyte)[]) "wqerqwerer",
        cast(immutable(ubyte)[]) "wqerqwer",
        cast(immutable(ubyte)[]) "wqeer",
        cast(immutable(ubyte)[]) "wqr"
    ];

    alias myTask = Task!(run, Tuple!(ulong, ulong) function(immutable(ubyte)[], ulong), immutable(
            ubyte)[], ulong)*;
    myTask[] calls;
    foreach (i; 0 .. data.length)
    {
        auto t = task(&f, data[i], i);
        t.executeInNewThread();
        calls ~= t;
    }

    foreach (i; iota(9, -1, -1))
    {
        writeln(calls[i].yieldForce());
    }
}
