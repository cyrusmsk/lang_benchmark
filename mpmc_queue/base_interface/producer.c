#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "queue.h"

typedef struct {
    int id;
    atomic_int* running;
} producer_arg_t;

typedef struct {
    pthread_mutex_t mutex;
    pthread_cond_t cond;
    int count;
    int trip_count;
} barrier_t;

void barrier_init(barrier_t* b, int threads) {
    pthread_mutex_init(&b->mutex, NULL);
    pthread_cond_init(&b->cond, NULL);
    b->count = 0;
    b->trip_count = threads;
}

void barrier_wait(barrier_t* b) {
    pthread_mutex_lock(&b->mutex);

    b->count++;
    if (b->count >= b->trip_count) {
        b->count = 0;
        pthread_cond_broadcast(&b->cond);
    } else {
        pthread_cond_wait(&b->cond, &b->mutex);
    }

    pthread_mutex_unlock(&b->mutex);
}

static barrier_t start_barrier;

void* producer_thread(void* arg) {
    producer_arg_t* parg = (producer_arg_t*)arg;

    int64_t value = parg->id;

    // wait for all producers to start together
    barrier_wait(&start_barrier);

    while (atomic_load(parg->running)) {
        queue_enqueue(value++);
    }

    return NULL;
}

double now_seconds() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec * 1e-9;
}

int main(int argc, char** argv) {
    int threads = 2;
    int duration = 5;
    int capacity = 1024;

    if (argc > 1) threads = atoi(argv[1]);
    if (argc > 2) duration = atoi(argv[2]);
    queue_runtime_init();
    queue_init(capacity);

    // start consumers
    queue_start_consumers(threads);

    pthread_t* tids = malloc(sizeof(pthread_t) * threads);
    producer_arg_t* args = malloc(sizeof(producer_arg_t) * threads);

    atomic_int running = 1;

    barrier_init(&start_barrier, threads + 1);

    for (int i = 0; i < threads; i++) {
        args[i].id = i;
        args[i].running = &running;
        pthread_create(&tids[i], NULL, producer_thread, &args[i]);
    }

    // start all producers at the same time
    barrier_wait(&start_barrier);
    double start = now_seconds();

    sleep(duration);

    // stop producers
    atomic_store(&running, 0);

    for (int i = 0; i < threads; i++) {
        pthread_join(tids[i], NULL);
    }

    double elapsed = now_seconds() - start;
    int64_t total_consumed = queue_total_consumed();

    printf("threads=%d\n", threads);
    printf("duration=%.2f\n", elapsed);
    printf("total_consumed=%lld\n", total_consumed);
    printf("throughput=%.2f ops/sec\n", total_consumed / elapsed);

    // stop consumers and cleanup queue
    queue_stop();

    free(tids);
    free(args);

    queue_runtime_shutdown();
    return 0;
}
