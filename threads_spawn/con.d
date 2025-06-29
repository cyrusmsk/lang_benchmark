import std;
import core.thread : Thread;

alias Data = Tuple!(immutable(ubyte)[], int);
alias T = Tuple!(int, ulong);

static void proc(Tid ownerTid)
{
    receive((Data t) {
        ubyte[] res;
        auto app = appender(&res);
        Thread.sleep(dur!"msecs"(10 * (t[1])));
        foreach (k; 0 .. 10_000)
        {
            long m = t[0].length / 2;
            while (m > 0)
            {
                app ~= t[0][m .. $];
                app ~= t[0][0 .. m];
                m /= 2;
            }
        }
        res.sort!"a < b";
        send(ownerTid, tuple(t[1], res.length));
    });
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

    Tid[] calls;
    foreach (i; 0 .. 10)
    {
        auto t = spawn(&proc, thisTid);
        calls ~= t;
        send(t, tuple(data[i], i));
    }
    foreach (i; 0 .. 10)
    {
        writeln(receiveOnly!(T));
    }
}
