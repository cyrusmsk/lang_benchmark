# Multi producers multi consumers queue
Test for multi-threading and atomic syncrhonization language abilities.
Most of the code was vibe-coded. Still need to check that the implementations are correct and the same.

## Types of approachs
Then implement:
 - Baseline atomic counter
 - Global lock
 - Condition-variable

## Rules
Every language should implement interface from file `queue.h`.

And output:
```bash
threads=8
duration=10
operations=12345678
ops_per_sec=1234567.8
```

## Build
To run any test you need to enter the language folder and run one of the command:
```bash
make baseline
make mutex
make bounded
```

## Platform
Current code requires `make` and based on `Makefile` - so only POSIX.

## License
MIT
