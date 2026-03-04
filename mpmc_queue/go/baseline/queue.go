package main

/*
#include <stdbool.h>
#include <stdint.h>
*/
import "C"

import (
	"runtime"
	"sync"
	"sync/atomic"
)

// --------------------------------------------------
// Baseline Atomic Counter Implementation
// --------------------------------------------------

// global atomic counter
var globalCounter int64

// spin-yield consumers
var consumersRunning int32
var consumerWG sync.WaitGroup

// --------------------------------------------------
// Consumer loop
// --------------------------------------------------
func consumerLoop() {
	defer consumerWG.Done()

	for atomic.LoadInt32(&consumersRunning) != 0 {
		runtime.Gosched() // yield CPU, spin
	}
}

// --------------------------------------------------
// C API (exported)
// --------------------------------------------------

//export queue_runtime_init
func queue_runtime_init() {}

//export queue_runtime_shutdown
func queue_runtime_shutdown() {}

//export queue_init
func queue_init(capacity C.int) {
	_ = capacity // baseline ignores capacity
	atomic.StoreInt64(&globalCounter, 0)
}

//export queue_enqueue
func queue_enqueue(value C.int64_t) C.bool {
	_ = value // unused in baseline
	atomic.AddInt64(&globalCounter, 1)
	return true
}

//export queue_start_consumers
func queue_start_consumers(threads C.int) {
	atomic.StoreInt32(&consumersRunning, 1)
	consumerWG = sync.WaitGroup{}
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
	return C.int64_t(atomic.LoadInt64(&globalCounter))
}

// --------------------------------------------------
func main() {}
