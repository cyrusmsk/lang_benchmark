package main

/*
#include <stdint.h>
#include <stdbool.h>
*/
import "C"

import (
	"runtime"
	"sync"
	"sync/atomic"
)

// -------------------------------
// Global queue state
// -------------------------------
var (
	queue            []int64
	queueMutex       sync.Mutex
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
		gotValue := false

		queueMutex.Lock()
		if len(queue) > 0 {
			val = queue[0]
			queue = queue[1:]
			gotValue = true
		}
		queueMutex.Unlock()

		if !gotValue {
			runtime.Gosched()
			continue
		}

		atomic.AddInt64(&totalConsumed, 1)
		_ = val
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
func queue_init(capacity C.int) {
	queueMutex.Lock()
	queue = make([]int64, 0, int(capacity))
	queueMutex.Unlock()

	atomic.StoreInt64(&totalConsumed, 0)
	atomic.StoreInt32(&consumersRunning, 0)
}

//export queue_enqueue
func queue_enqueue(value C.int64_t) C.bool {
	queueMutex.Lock()
	queue = append(queue, int64(value))
	queueMutex.Unlock()
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
	consumerWG.Wait()
}

//export queue_total_consumed
func queue_total_consumed() C.int64_t {
	return C.int64_t(atomic.LoadInt64(&totalConsumed))
}

func main() {} // required for c-shared
