use std::sync::{
    atomic::{AtomicBool, AtomicI64, Ordering},
    Mutex,
};
use std::thread;

// --------------------------------------------------
// Global state
// --------------------------------------------------
static GLOBAL_QUEUE: Mutex<Vec<i64>> = Mutex::new(Vec::new());
static CONSUMER_THREADS: Mutex<Vec<thread::JoinHandle<()>>> = Mutex::new(Vec::new());
static CONSUMERS_RUNNING: AtomicBool = AtomicBool::new(false);
static TOTAL_CONSUMED: AtomicI64 = AtomicI64::new(0);

// --------------------------------------------------
// Consumer loop
// --------------------------------------------------
fn consumer_loop() {
    while CONSUMERS_RUNNING.load(Ordering::Relaxed) {
        let mut val_opt: Option<i64> = None;

        {
            let mut queue: std::sync::MutexGuard<Vec<i64>> = GLOBAL_QUEUE.lock().unwrap();
            if !queue.is_empty() {
                val_opt = Some(queue.remove(0));
            }
        }

        match val_opt {
            Some(val) => {
                TOTAL_CONSUMED.fetch_add(1, Ordering::Relaxed);
                let _ = val; // trivial work
            }
            None => {
                thread::yield_now();
            }
        }
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
    TOTAL_CONSUMED.store(0, Ordering::Relaxed);
    let mut queue: std::sync::MutexGuard<Vec<i64>> = GLOBAL_QUEUE.lock().unwrap();
    queue.clear();
}

#[no_mangle]
pub extern "C" fn queue_enqueue(value: i64) -> bool {
    let mut queue: std::sync::MutexGuard<Vec<i64>> = GLOBAL_QUEUE.lock().unwrap();
    queue.push(value);
    true
}

#[no_mangle]
pub extern "C" fn queue_start_consumers(threads: i32) {
    CONSUMERS_RUNNING.store(true, Ordering::Relaxed);

    let mut handles: std::sync::MutexGuard<Vec<thread::JoinHandle<()>>> =
        CONSUMER_THREADS.lock().unwrap();
    handles.clear();

    for _ in 0..threads {
        let handle = thread::spawn(|| consumer_loop());
        handles.push(handle);
    }
}

#[no_mangle]
pub extern "C" fn queue_stop() {
    CONSUMERS_RUNNING.store(false, Ordering::Relaxed);

    let mut handles: std::sync::MutexGuard<Vec<thread::JoinHandle<()>>> =
        CONSUMER_THREADS.lock().unwrap();
    for handle in handles.drain(..) {
        let _ = handle.join();
    }
}

#[no_mangle]
pub extern "C" fn queue_total_consumed() -> i64 {
    TOTAL_CONSUMED.load(Ordering::Relaxed)
}
