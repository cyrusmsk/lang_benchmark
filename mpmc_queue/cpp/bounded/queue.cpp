#include <vector>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <cstdint>
#include <atomic>
#include "../../base_interface/queue.h"

extern "C" {

void queue_runtime_init() {}
void queue_runtime_shutdown() {}

// --------------------------------------------------
// Bounded circular buffer queue
// --------------------------------------------------
static std::vector<int64_t> buffer;
static size_t capacity = 0;
static size_t head = 0;   // dequeue index
static size_t tail = 0;   // enqueue index
static size_t size = 0;

static std::mutex mtx;
static std::condition_variable not_empty;
static std::condition_variable not_full;

static std::atomic<bool> consumers_running{false};
static std::vector<std::thread> consumer_threads;
static std::atomic<int64_t> total_consumed{0};

// --------------------------------------------------
// Initialization
// --------------------------------------------------
void queue_init(int cap) {
    std::lock_guard<std::mutex> lock(mtx);
    capacity = cap;
    buffer.assign(cap, 0);
    head = tail = size = 0;
    total_consumed.store(0);
    consumers_running.store(false);
}

// --------------------------------------------------
// Enqueue (blocking if full)
// --------------------------------------------------
bool queue_enqueue(int64_t value) {
    std::unique_lock<std::mutex> lock(mtx);
    not_full.wait(lock, [] { return size < capacity; });

    buffer[tail] = value;
    tail = (tail + 1) % capacity;
    size++;

    not_empty.notify_one();
    return true;
}

// --------------------------------------------------
// Consumer loop
// --------------------------------------------------
static void consumer_loop() {
    while (consumers_running.load()) {
        std::unique_lock<std::mutex> lock(mtx);
        not_empty.wait(lock, [] { return size > 0 || !consumers_running.load(); });

        if (size == 0 && !consumers_running.load()) break;

        // Consume one item
        int64_t val = buffer[head];
        head = (head + 1) % capacity;
        size--;

        total_consumed.fetch_add(1);

        not_full.notify_one();

        lock.unlock();
        (void)val; // avoid optimizing away
    }
}

// --------------------------------------------------
// Start consumers
// --------------------------------------------------
void queue_start_consumers(int threads) {
    consumers_running.store(true);
    consumer_threads.clear();
    consumer_threads.reserve(threads);

    for (int i = 0; i < threads; ++i) {
        consumer_threads.emplace_back([] { consumer_loop(); });
    }
}

// --------------------------------------------------
// Stop consumers
// --------------------------------------------------
void queue_stop() {
    consumers_running.store(false);
    not_empty.notify_all();
    not_full.notify_all();

    for (auto& t : consumer_threads) {
        if (t.joinable()) t.join();
    }
    consumer_threads.clear();
}

// --------------------------------------------------
// Total consumed
// --------------------------------------------------
int64_t queue_total_consumed() {
    return total_consumed.load();
}

} // extern "C"
