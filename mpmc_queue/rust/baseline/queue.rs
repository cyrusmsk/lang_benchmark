use std::sync::atomic::{AtomicI32, AtomicI64, Ordering};
use std::sync::{Mutex, OnceLock};
use std::thread;

// --------------------------------------------------
// Global state
// --------------------------------------------------
static GLOBAL_COUNTER: AtomicI64 = AtomicI64::new(0);
static CONSUMERS_RUNNING: AtomicI32 = AtomicI32::new(0);

// Safe static for consumer threads
static CONSUMER_THREADS: OnceLock<Mutex<Vec<thread::JoinHandle<()>>>> = OnceLock::new();

// --------------------------------------------------
// Consumer loop
// --------------------------------------------------
fn consumer_loop() {
    while CONSUMERS_RUNNING.load(Ordering::Relaxed) != 0 {
        thread::yield_now();
    }
}

// --------------------------------------------------
// C API exports
// --------------------------------------------------
#[no_mangle]
pub extern "C" fn queue_runtime_init() {}

#[no_mangle]
pub extern "C" fn queue_runtime_shutdown() {}

#[no_mangle]
pub extern "C" fn queue_init(_capacity: i32) {
    GLOBAL_COUNTER.store(0, Ordering::Relaxed);
}

#[no_mangle]
pub extern "C" fn queue_enqueue(_value: i64) -> bool {
    GLOBAL_COUNTER.fetch_add(1, Ordering::Relaxed);
    true
}

#[no_mangle]
pub extern "C" fn queue_start_consumers(threads: i32) {
    CONSUMERS_RUNNING.store(1, Ordering::Relaxed);
    let handles_mutex = CONSUMER_THREADS.get_or_init(|| Mutex::new(Vec::new()));
    let mut handles = handles_mutex.lock().unwrap();
    handles.clear();

    for _ in 0..threads {
        let handle = thread::spawn(|| consumer_loop());
        handles.push(handle);
    }
}

#[no_mangle]
pub extern "C" fn queue_stop() {
    CONSUMERS_RUNNING.store(0, Ordering::Relaxed);
    if let Some(handles_mutex) = CONSUMER_THREADS.get() {
        let mut handles = handles_mutex.lock().unwrap();
        for handle in handles.drain(..) {
            let _ = handle.join();
        }
    }
}

#[no_mangle]
pub extern "C" fn queue_total_consumed() -> i64 {
    GLOBAL_COUNTER.load(Ordering::Relaxed)
}
