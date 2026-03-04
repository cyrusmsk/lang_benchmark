// queue.h

#pragma once
#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void queue_init(int capacity);
bool queue_enqueue(int64_t value);
void queue_start_consumers(int threads);
void queue_stop();
int64_t queue_total_consumed();
void queue_runtime_init();
void queue_runtime_shutdown();

#ifdef __cplusplus
}
#endif
