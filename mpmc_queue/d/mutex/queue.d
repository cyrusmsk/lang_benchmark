module queue;

import core.atomic;
import core.thread : Thread;
import core.sync.mutex : Mutex;
import core.atomic : atomicLoad, atomicStore, atomicFetchAdd;
import std.container : DList;
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
// Global lock MPMC queue
// --------------------------------------------------

__gshared DList!long g_queue;
__gshared Mutex g_mutex;

shared bool consumersRunning = false;
shared long totalConsumed = 0;
__gshared Thread[] consumerThreads;

// --------------------------------------------------

extern (C) void queue_init(int capacity)
{
    if (g_mutex is null)
        g_mutex = new Mutex();

    synchronized (g_mutex)
    {
        g_queue = DList!long(0);
        g_queue.removeBack();
    }
}

// Enqueue with global lock
extern (C) bool queue_enqueue(long value)
{
    synchronized (g_mutex)
    {
        g_queue.insertBack(value);
    }
    return true;
}

// --------------------------------------------------
// Consumers
// --------------------------------------------------

void consumerLoop()
{
    while (atomicLoad(consumersRunning))
    {
        long val = 0;
        bool gotValue = false;

        synchronized (g_mutex)
        {
            if (!(g_queue[]).empty)
            {
                val = g_queue.front;
                g_queue.removeFront();
                gotValue = true;
            }

            if (!gotValue)
            {
                Thread.yield();
                continue;
            }

            atomicFetchAdd(totalConsumed, 1);
            cast(void) val;
        }

    }
}

extern (C) void queue_start_consumers(int threads)
{
    atomicStore(consumersRunning, true);

    consumerThreads.length = threads;

    foreach (i; 0 .. threads)
    {
        auto t = new Thread(&consumerLoop);
        consumerThreads[i] = t;
        t.start();
    }
}

extern (C) void queue_stop()
{
    atomicStore(consumersRunning, false);

    foreach (t; consumerThreads)
    {
        if (t !is null)
            t.join();
    }

    consumerThreads.length = 0;
}

extern (C) long queue_total_consumed()
{
    return atomicLoad(totalConsumed);
}
