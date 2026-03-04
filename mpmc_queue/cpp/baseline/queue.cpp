#include <atomic>
#include <cstdint>
#include <thread>
#include <vector>

extern "C" {
#include "../../base_interface/queue.h"
}

void queue_runtime_init() {}
void queue_runtime_shutdown() {}

// --------------------------------------------------
// Baseline Atomic Counter Implementation
// --------------------------------------------------

// Avoid false sharing by aligning to cache line
struct alignas(64) PaddedAtomic {
    std::atomic<int64_t> value;
};

static PaddedAtomic global_counter;
static std::atomic<bool> consumers_running{false};
static std::vector<std::thread> consumer_threads;

// --------------------------------------------------

void queue_init(int capacity) {
    (void)capacity; // unused in baseline
    global_counter.value.store(0, std::memory_order_relaxed);
}

bool queue_enqueue(int64_t value) {
    (void)value; // unused
    global_counter.value.fetch_add(1, std::memory_order_relaxed);
    return true;
}

// --------------------------------------------------
// Consumers (do nothing meaningful in baseline)
// --------------------------------------------------

static void consumer_loop() {
    while (consumers_running.load(std::memory_order_relaxed)) {
        // spin — baseline doesn't consume anything
        std::this_thread::yield();
    }
}

void queue_start_consumers(int threads) {
    consumers_running.store(true, std::memory_order_relaxed);

    consumer_threads.reserve(threads);
    for (int i = 0; i < threads; ++i) {
        consumer_threads.emplace_back(consumer_loop);
    }
}

void queue_stop() {
    consumers_running.store(false, std::memory_order_relaxed);

    for (auto& t : consumer_threads) {
        if (t.joinable()) {
            t.join();
        }
    }
    consumer_threads.clear();
}

int64_t queue_total_consumed() {
    return global_counter.value.load(std::memory_order_relaxed);
}
