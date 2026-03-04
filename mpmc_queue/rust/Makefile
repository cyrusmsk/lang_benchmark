# rust/Makefile
RUSTC = rustc
CFLAGS = -O3 -std=c11 -pthread
BASE_DIR = ../base_interface
BUILD_DIR = build

.PHONY: baseline mutex bounded clean

ifeq ($(shell uname),Darwin)
  DYNEXT = .dylib
else
  DYNEXT = .so
endif

baseline:
	@mkdir -p $(BUILD_DIR)
	# Build Rust shared library
	$(RUSTC) --crate-type cdylib -C opt-level=3 baseline/queue.rs -o $(BUILD_DIR)/libbaseline$(DYNEXT)
	# Compile producer.c
	clang $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with Rust shared library
	clang $(CFLAGS) $(BUILD_DIR)/producer.o -L$(BUILD_DIR) -lbaseline -o benchmark
	@rm -f $(BUILD_DIR)/*.o

mutex:
	@mkdir -p $(BUILD_DIR)
	# Build Rust shared library
	$(RUSTC) --crate-type cdylib -C opt-level=3 mutex/queue.rs -o $(BUILD_DIR)/libmutex$(DYNEXT)
	# Compile producer.c
	clang $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with Rust shared library
	clang $(CFLAGS) $(BUILD_DIR)/producer.o -L$(BUILD_DIR) -lmutex -o benchmark
	@rm -f $(BUILD_DIR)/producer.o

bounded:
	@mkdir -p $(BUILD_DIR)
	# Build Rust shared library
	$(RUSTC) --crate-type cdylib -C opt-level=3 bounded/queue.rs -o $(BUILD_DIR)/libbounded$(DYNEXT)
	# Compile producer.c
	clang $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with Rust shared library
	clang $(CFLAGS) $(BUILD_DIR)/producer.o -L$(BUILD_DIR) -lbounded -o benchmark
	@rm -f $(BUILD_DIR)/producer.o

clean:
	rm -rf $(BUILD_DIR)
