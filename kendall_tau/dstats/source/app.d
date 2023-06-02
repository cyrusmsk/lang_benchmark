import std;
import dstats;
import std.datetime.stopwatch: AutoStart, StopWatch;


void main()
{
    auto sw2 = StopWatch(AutoStart.no);
    sw2.start();
    auto n = lhs.length;
    auto ind = new size_t[n];
    makeIndex(lhs, ind);
    auto lhsSorted = assumeSorted(indexed(lhs, ind));

    auto rhsRearranged = indexed(rhs, ind);
    writeln(kendallCorTest(lhsSorted, rhsRearranged));
    sw2.stop();
    writeln("Correlation computation takes=",sw2.peek.total!"msecs"," milliseconds");
}
