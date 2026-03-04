# d/Makefile
LDC = ldc2
CFLAGS = -O3 -std=c11 -pthread
DFLAGS = -O0 -release

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
	# Build D shared library
	$(LDC) $(DFLAGS) -relocation-model=pic -shared baseline/queue.d -of$(BUILD_DIR)/libbaseline$(DYNEXT)
	# Compile producer.c
	clang $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with D shared library
	clang $(CFLAGS) $(BUILD_DIR)/producer.o -L$(BUILD_DIR) -lbaseline -o benchmark
	@rm -f $(BUILD_DIR)/*.o

mutex:
	@mkdir -p $(BUILD_DIR)
	# Build D shared library
	$(LDC) $(DFLAGS) -relocation-model=pic -shared mutex/queue.d -of$(BUILD_DIR)/libmutex$(DYNEXT)
	# Compile producer.c
	clang $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with D shared library
	clang $(CFLAGS) $(BUILD_DIR)/producer.o -L$(BUILD_DIR) -lmutex -o benchmark
	@rm -f $(BUILD_DIR)/*.o

bounded:
	@mkdir -p $(BUILD_DIR)
	# Build D shared library
	$(LDC) $(DFLAGS) -relocation-model=pic -shared bounded/queue.d -of$(BUILD_DIR)/libbounded$(DYNEXT)
	# Compile producer.c
	clang $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with D shared library
	clang $(CFLAGS) $(BUILD_DIR)/producer.o -L$(BUILD_DIR) -lbounded -o benchmark
	@rm -f $(BUILD_DIR)/*.o

clean:
	rm -rf $(BUILD_DIR)
