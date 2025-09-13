CC = gcc
ASM = nasm
CFLAGS = -m32 -Wall -Wextra -std=c99 -no-pie
ASMFLAGS = -f elf32
LDFLAGS = -m32 -no-pie

BASIC_DIR = basic
EXTRA_DIR = extra
TEST_DIR = test
UNITY_DIR = $(TEST_DIR)/unity

MAIN_OBJS = sparseset.o
BASIC_OBJS = $(BASIC_DIR)/contains.o $(BASIC_DIR)/insert.o $(BASIC_DIR)/remove.o $(BASIC_DIR)/search.o 
EXTRA_OBJS = $(EXTRA_DIR)/union.o $(EXTRA_DIR)/intersection.o $(EXTRA_DIR)/issubset.o $(EXTRA_DIR)/setdifference.o

ASM_OBJS = $(MAIN_OBJS) $(BASIC_OBJS) $(EXTRA_OBJS)

TEST_OBJ = $(TEST_DIR)/test.o
UNITY_OBJ = $(UNITY_DIR)/src/unity.o

all: program test

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

$(BASIC_DIR)/%.o: $(BASIC_DIR)/%.asm
	$(ASM) $(ASMFLAGS) $< -o $@

$(EXTRA_DIR)/%.o: $(EXTRA_DIR)/%.asm
	$(ASM) $(ASMFLAGS) $< -o $@

$(UNITY_OBJ): $(UNITY_DIR)/src/unity.c
	$(CC) $(CFLAGS) -I$(UNITY_DIR)/src -c $< -o $@

$(TEST_DIR)/%.o: $(TEST_DIR)/%.c
	$(CC) $(CFLAGS) -I$(UNITY_DIR)/src -c $< -o $@

program: main.o $(ASM_OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

unit_test: $(ASM_OBJS) $(TEST_OBJ) $(UNITY_OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm -f *.o $(BASIC_DIR)/*.o $(EXTRA_DIR)/*.o $(TEST_DIR)/*.o $(UNITY_DIR)/src/*.o program unit_test

run: program
	./program

test-run: unit_test
	./unit_test

.PHONY: all clean run test-run
