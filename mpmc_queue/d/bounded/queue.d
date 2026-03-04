module queue;

import core.atomic : atomicOp, atomicLoad, atomicStore, atomicFetchAdd;
import core.thread : Thread;
import core.sync.mutex : Mutex;
import core.sync.condition : Condition;
import core.runtime;
import std.stdio : writeln;

extern (C)
{
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
// Bounded circular buffer queue
// --------------------------------------------------

// In D, module globals behave like C++ static globals.
// Because multiple threads access them → must be shared.

shared long[] buffer;
shared size_t capacity;
shared size_t head;
shared size_t tail;
shared size_t size;

__gshared Mutex mtx;
__gshared Condition notEmpty;
__gshared Condition notFull;

shared bool consumersRunning = false;
shared long totalConsumed = 0;

__gshared Thread[] consumerThreads; // only main thread touches this

// --------------------------------------------------
// Initialization
// --------------------------------------------------

extern (C) void queue_init(int cap)
{
    if (mtx is null)
        mtx = new Mutex();

    notEmpty = new Condition(mtx);
    notFull = new Condition(mtx);

    synchronized (mtx)
    {
        capacity = cap;
        buffer = new long[cap];

        head = 0;
        tail = 0;
        size = 0;

        atomicStore(totalConsumed, 0);
        atomicStore(consumersRunning, false);
    }
}

// --------------------------------------------------
// Enqueue (blocking if full)
// --------------------------------------------------

extern (C) bool queue_enqueue(long value)
{
    mtx.lock();
    scope (exit)
        mtx.unlock();

    while (size == capacity)
    {
        notFull.wait();
    }

    buffer[tail] = value;
    tail = (tail + 1) % capacity;
    atomicOp!"+="(size, 1);

    notEmpty.notify();
    return true;
}

// --------------------------------------------------
// Consumer loop
// --------------------------------------------------

void consumerLoop()
{
    while (atomicLoad(consumersRunning))
    {
        mtx.lock();

        while (size == 0 && atomicLoad(consumersRunning))
        {
            notEmpty.wait();
        }

        if (size == 0 && !atomicLoad(consumersRunning))
        {
            mtx.unlock();
            break;
        }

        long val = buffer[head];
        head = (head + 1) % capacity;
        atomicOp!"-="(size, 1);

        atomicFetchAdd(totalConsumed, 1);

        notFull.notify();
        mtx.unlock();

        cast(void) val; // prevent optimization
    }
}

// --------------------------------------------------
// Start consumers
// --------------------------------------------------

extern (C) void queue_start_consumers(int threads)
{
    atomicStore(consumersRunning, true);

    consumerThreads.length = threads;

    foreach (i; 0 .. threads)
    {
        auto t = new Thread(&consumerLoop);
        consumerThreads ~= t;
        t.start();
    }
}

// --------------------------------------------------
// Stop consumers
// --------------------------------------------------

extern (C) void queue_stop()
{
    atomicStore(consumersRunning, false);

    // Wake all waiting threads
    notEmpty.notifyAll();
    notFull.notifyAll();

    foreach (t; consumerThreads)
    {
        if (t !is null)
            t.join();
    }

    consumerThreads.length = 0;
}

// --------------------------------------------------
// Total consumed
// --------------------------------------------------

extern (C) long queue_total_consumed()
{
    return atomicLoad(totalConsumed);
}
