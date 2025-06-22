import core.thread : Fiber;
import std;

void fiberedRange(R, T)(
    R range,
    int prime,
    ref T result)
{
    for(; !range.empty; range.popFront) {
        result = filter!(a => a % prime != 0)(range).inputRangeObject;
        Fiber.yield();
    }
}

void main(string[] args)
{
    auto k = args.length > 1 ? args[1].to!int() : 10;

    long sum_prime = 0;
    InputRange!int squareResult = recurrence!("a[n-1] + 1")(2).inputRangeObject;
    auto squareResult_in = squareResult;
    
    int cur = 2;

    foreach(i; 0..k)
    {
        if (i == 0)
            sum_prime += cur;
        else {
            auto squareFiber = new Fiber({
                fiberedRange(squareResult_in, cur, squareResult);
            });
            squareFiber.call();
            cur = squareResult.front;
            squareResult_in = squareResult;
            sum_prime += cur;
        }
    }   
    writeln(sum_prime);
}
