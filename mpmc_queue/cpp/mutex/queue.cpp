#include <queue>
#include <mutex>
#include <thread>
#include <vector>
#include <atomic>
#include <cstdint>
#include "../../base_interface/queue.h"

extern "C" {

void queue_runtime_init() {}
void queue_runtime_shutdown() {}

// --------------------------------------------------
// Global lock MPMC queue
// --------------------------------------------------

static std::queue<int64_t> g_queue;
static std::mutex g_mutex;

static std::atomic<bool> consumers_running{false};
static std::atomic<int64_t> total_consumed{0};

static std::vector<std::thread> consumer_threads;

void queue_init(int capacity) {
    (void)capacity;

    std::lock_guard<std::mutex> lock(g_mutex);
    std::queue<int64_t> empty;
    std::swap(g_queue, empty);

    total_consumed.store(0, std::memory_order_relaxed);
}

// Enqueue with global lock
bool queue_enqueue(int64_t value) {
    std::lock_guard<std::mutex> lock(g_mutex);
    g_queue.push(value);
    return true;
}

// --------------------------------------------------
// Consumers
// --------------------------------------------------

static void consumer_loop() {
    while (consumers_running.load(std::memory_order_relaxed)) {

        int64_t val = 0;
        bool got_value = false;

        {
            std::lock_guard<std::mutex> lock(g_mutex);
            if (!g_queue.empty()) {
                val = g_queue.front();
                g_queue.pop();
                got_value = true;
            }
        }

        if (!got_value) {
            std::this_thread::yield();
            continue;
        }

        // Count processed item
        total_consumed.fetch_add(1, std::memory_order_relaxed);

        (void)val; // prevent optimization
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
        if (t.joinable()) t.join();
    }

    consumer_threads.clear();
}

int64_t queue_total_consumed() {
    return total_consumed.load(std::memory_order_relaxed);
}

}
