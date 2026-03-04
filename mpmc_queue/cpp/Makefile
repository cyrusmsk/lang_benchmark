CC = clang
CXX = clang++

CFLAGS = -O3 -std=c11 -pthread
CXXFLAGS = -O3 -std=c++20 -pthread

BASE_DIR = ../base_interface
BUILD_DIR = build

.PHONY: baseline mutex bounded clean

baseline:
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	$(CXX) $(CXXFLAGS) -c baseline/queue.cpp -o $(BUILD_DIR)/queue.o
	$(CXX) $(BUILD_DIR)/producer.o $(BUILD_DIR)/queue.o -pthread -o benchmark
	@rm -f $(BUILD_DIR)/*.o

mutex:
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	$(CXX) $(CXXFLAGS) -c mutex/queue.cpp -o $(BUILD_DIR)/queue.o
	$(CXX) $(BUILD_DIR)/producer.o $(BUILD_DIR)/queue.o -pthread -o benchmark
	@rm -f $(BUILD_DIR)/*.o

bounded:
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $(BASE_DIR)/producer.c -o $(BUILD_DIR)/producer.o
	$(CXX) $(CXXFLAGS) -c bounded/queue.cpp -o $(BUILD_DIR)/queue.o
	$(CXX) $(BUILD_DIR)/producer.o $(BUILD_DIR)/queue.o -pthread -o benchmark
	@rm -f $(BUILD_DIR)/*.o

clean:
	rm -rf $(BUILD_DIR)
