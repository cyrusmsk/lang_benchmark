# go/Makefile
GO = go
CC = clang
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
	# Build Go shared library
	$(GO) build -buildmode=c-shared -o $(BUILD_DIR)/libbaseline$(DYNEXT) baseline/queue.go
	# Compile producer.c
	$(CC) $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with Go shared library
	$(CC) $(CFLAGS) $(BUILD_DIR)/producer.o $(BUILD_DIR)/libbaseline$(DYNEXT) -o benchmark
	cp $(BUILD_DIR)/libbaseline$(DYNEXT) .
	@rm -f $(BUILD_DIR)/*.o

mutex:
	@mkdir -p $(BUILD_DIR)
	# Build Go shared library
	$(GO) build -buildmode=c-shared -o $(BUILD_DIR)/libmutex$(DYNEXT) mutex/queue.go
	# Compile producer.c
	$(CC) $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with Go shared library
	$(CC) $(CFLAGS) $(BUILD_DIR)/producer.o $(BUILD_DIR)/libmutex$(DYNEXT) -o benchmark
	cp $(BUILD_DIR)/libmutex$(DYNEXT) .
	@rm -f $(BUILD_DIR)/*.o

bounded:
	@mkdir -p $(BUILD_DIR)
	# Build Go shared library
	$(GO) build -buildmode=c-shared -o $(BUILD_DIR)/libbounded$(DYNEXT) bounded/queue.go
	# Compile producer.c
	$(CC) $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	# Link with Go shared library
	$(CC) $(CFLAGS) $(BUILD_DIR)/producer.o $(BUILD_DIR)/libbounded$(DYNEXT) -o benchmark
	cp $(BUILD_DIR)/libbounded$(DYNEXT) .
	@rm -f $(BUILD_DIR)/*.o

clean:
	@rm -rf $(BUILD_DIR) ./lib*
