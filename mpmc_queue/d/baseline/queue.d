module queue;

import core.atomic;
import core.thread : Thread;
import core.atomic : atomicLoad, atomicStore, atomicFetchAdd;
import std.stdio : writeln, stdout;
import core.runtime;

extern (C)
{
    // --------------------------------------------------
    // API functions for FFI
    // --------------------------------------------------
    void queue_init(int capacity);
    bool queue_enqueue(long value);
    void queue_start_consumers(int threads);
    void queue_stop();
    long queue_total_consumed();
}

extern (C) void queue_runtime_init()
{
    Runtime.initialize();
}

extern (C) void queue_runtime_shutdown()
{
    Runtime.terminate();
}

// --------------------------------------------------
// Baseline Atomic Counter Implementation
// --------------------------------------------------

align(64)
struct PaddedAtomic
{
    long value;
}

shared PaddedAtomic globalCounter;
shared bool consumersRunning = false;
Thread[] consumerThreads;

// --------------------------------------------------

extern (C) void queue_init(int capacity)
{
    atomicStore(globalCounter.value, 0);
}

extern (C) bool queue_enqueue(long value)
{
    atomicFetchAdd(globalCounter.value, 1);
    return true;
}

// --------------------------------------------------
// Consumers (do nothing meaningful in baseline)
// --------------------------------------------------

void consumerLoop()
{
    while (atomicLoad(consumersRunning))
    {
        Thread.yield();
    }
}

extern (C) void queue_start_consumers(int threads)
{
    atomicStore(consumersRunning, true);

    consumerThreads = [];

    try
    {
        foreach (i; 0 .. threads)
        {
            auto t = new Thread(&consumerLoop);
            consumerThreads ~= t;
            t.start();
        }
    }
    catch (Throwable t)
    {
        writeln("ERROR: ", t.msg);
    }
}

extern (C) void queue_stop()
{
    atomicStore(consumersRunning, false);

    foreach (t; consumerThreads)
    {
        if (t !is null)
        {
            t.join();
        }
    }

    consumerThreads.length = 0;
}

extern (C) long queue_total_consumed()
{
    return atomicLoad(globalCounter.value);
}
