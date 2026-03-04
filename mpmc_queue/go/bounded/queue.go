package main

/*
#include <stdint.h>
#include <stdbool.h>
*/
import "C"

import (
	"sync"
	"sync/atomic"
)

// -------------------------------
// Bounded circular buffer queue
// -------------------------------
var (
	buffer           []int64
	capacity         int
	head             int // dequeue index
	tail             int // enqueue index
	size             int
	mtx              sync.Mutex
	notEmpty         = sync.NewCond(&mtx)
	notFull          = sync.NewCond(&mtx)
	consumersRunning int32
	consumerWG       sync.WaitGroup
	totalConsumed    int64
)

// -------------------------------
// Consumer loop
// -------------------------------
func consumerLoop() {
	defer consumerWG.Done()

	for atomic.LoadInt32(&consumersRunning) != 0 {
		var val int64
		mtx.Lock()
		for size == 0 && atomic.LoadInt32(&consumersRunning) != 0 {
			notEmpty.Wait()
		}
		if size == 0 && atomic.LoadInt32(&consumersRunning) == 0 {
			mtx.Unlock()
			break
		}

		val = buffer[head]
		head = (head + 1) % capacity
		size--

		atomic.AddInt64(&totalConsumed, 1)
		notFull.Signal()
		mtx.Unlock()

		_ = val // prevent compiler from optimizing away
	}
}

// -------------------------------
// Exported C functions
// -------------------------------

//export queue_runtime_init
func queue_runtime_init() {}

//export queue_runtime_shutdown
func queue_runtime_shutdown() {}

//export queue_init
func queue_init(cap C.int) {
	mtx.Lock()
	capacity = int(cap)
	buffer = make([]int64, capacity)
	head, tail, size = 0, 0, 0
	mtx.Unlock()

	atomic.StoreInt64(&totalConsumed, 0)
	atomic.StoreInt32(&consumersRunning, 0)
}

//export queue_enqueue
func queue_enqueue(value C.int64_t) C.bool {
	mtx.Lock()
	for size == capacity {
		notFull.Wait()
	}

	buffer[tail] = int64(value)
	tail = (tail + 1) % capacity
	size++

	notEmpty.Signal()
	mtx.Unlock()
	return true
}

//export queue_start_consumers
func queue_start_consumers(threads C.int) {
	atomic.StoreInt32(&consumersRunning, 1)
	consumerWG.Add(int(threads))

	for i := 0; i < int(threads); i++ {
		go consumerLoop()
	}
}

//export queue_stop
func queue_stop() {
	atomic.StoreInt32(&consumersRunning, 0)
	mtx.Lock()
	notEmpty.Broadcast()
	notFull.Broadcast()
	mtx.Unlock()

	consumerWG.Wait()
}

//export queue_total_consumed
func queue_total_consumed() C.int64_t {
	return C.int64_t(atomic.LoadInt64(&totalConsumed))
}

func main() {} // required for c-shared
