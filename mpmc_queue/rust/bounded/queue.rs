use std::sync::atomic::{AtomicBool, AtomicI64, Ordering};
use std::sync::{Arc, Condvar, Mutex};
use std::thread;

// ---------------------------
// Queue structure
// ---------------------------
struct BoundedQueue {
    buffer: Vec<i64>,
    capacity: usize,
    head: usize,
    tail: usize,
    size: usize,
}

impl BoundedQueue {
    fn new(cap: usize) -> Self {
        Self {
            buffer: vec![0; cap],
            capacity: cap,
            head: 0,
            tail: 0,
            size: 0,
        }
    }
}

// ---------------------------
// Shared queue state
// ---------------------------
struct QueueState {
    queue: Mutex<BoundedQueue>,
    not_empty: Condvar,
    not_full: Condvar,
    consumers_running: AtomicBool,
    total_consumed: AtomicI64,
}

impl QueueState {
    fn new(cap: usize) -> Self {
        Self {
            queue: Mutex::new(BoundedQueue::new(cap)),
            not_empty: Condvar::new(),
            not_full: Condvar::new(),
            consumers_running: AtomicBool::new(false),
            total_consumed: AtomicI64::new(0),
        }
    }
}

// ---------------------------
// Global singleton
// ---------------------------
static mut GLOBAL_QUEUE: Option<Arc<QueueState>> = None;

// ---------------------------
// Consumer loop
// ---------------------------
fn consumer_loop(queue_state: Arc<QueueState>) {
    loop {
        let mut guard = queue_state.queue.lock().unwrap();

        while guard.size == 0 && queue_state.consumers_running.load(Ordering::Relaxed) {
            guard = queue_state.not_empty.wait(guard).unwrap();
        }

        if guard.size == 0 && !queue_state.consumers_running.load(Ordering::Relaxed) {
            break;
        }

        // Consume one item
        let val = guard.buffer[guard.head];
        guard.head = (guard.head + 1) % guard.capacity;
        guard.size -= 1;
        queue_state.total_consumed.fetch_add(1, Ordering::Relaxed);

        queue_state.not_full.notify_one();
        drop(guard);

        // Prevent optimizing away
        let _ = val;
    }
}

// ---------------------------
// C ABI
// ---------------------------
#[no_mangle]
pub extern "C" fn queue_runtime_init() {}
#[no_mangle]
pub extern "C" fn queue_runtime_shutdown() {}

#[no_mangle]
pub extern "C" fn queue_init(capacity: i32) {
    let q = Arc::new(QueueState::new(capacity as usize));
    unsafe {
        GLOBAL_QUEUE = Some(q);
    }
}

#[no_mangle]
pub extern "C" fn queue_enqueue(value: i64) -> bool {
    unsafe {
        if let Some(ref q) = GLOBAL_QUEUE {
            let mut guard = q.queue.lock().unwrap();

            // wait until there's space
            while guard.size >= guard.capacity {
                guard = q.not_full.wait(guard).unwrap();
            }

            // store value after exiting wait (borrow checker happy)
            let tail = guard.tail;
            guard.buffer[tail] = value;
            guard.tail = (tail + 1) % guard.capacity;
            guard.size += 1;

            q.not_empty.notify_one();
            true
        } else {
            false
        }
    }
}

#[no_mangle]
pub extern "C" fn queue_start_consumers(threads: i32) {
    unsafe {
        if let Some(ref q) = GLOBAL_QUEUE {
            q.consumers_running.store(true, Ordering::Relaxed);

            let mut handles = Vec::new();
            for _ in 0..threads {
                let q_clone = Arc::clone(q);
                handles.push(thread::spawn(move || consumer_loop(q_clone)));
            }

            CONSUMER_THREADS = Some(handles);
        }
    }
}

static mut CONSUMER_THREADS: Option<Vec<thread::JoinHandle<()>>> = None;

#[no_mangle]
pub extern "C" fn queue_stop() {
    unsafe {
        if let Some(ref q) = GLOBAL_QUEUE {
            q.consumers_running.store(false, Ordering::Relaxed);
            q.not_empty.notify_all();
            q.not_full.notify_all();
        }

        if let Some(handles) = CONSUMER_THREADS.take() {
            for h in handles {
                let _ = h.join();
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn queue_total_consumed() -> i64 {
    unsafe {
        if let Some(ref q) = GLOBAL_QUEUE {
            q.total_consumed.load(Ordering::Relaxed)
        } else {
            0
        }
    }
}
