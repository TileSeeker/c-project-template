

# Project Settings
debug = 1
PROJECT_NAME = test_1
NAME = $(PROJECT_NAME).out

SRC_DIR = ./src
INCLUDE_DIR = ./include
BUILD_DIR = ./build
BIN_DIR = ./bin
LIB_DIR = ./lib
DOCS_DIR = ./docs

# Object files
OBJS := $(patsubst %.c,%.o, $(wildcard $(SRC_DIR)/*.c) $(wildcard $(LIB_DIR)/**/*.c))

# Compile Settings
CC := gcc
CFLAGS := -Wall -Wstrict-prototypes -Wmissing-prototypes -Wshadow -Wconversion -std=c99 -I$(INCLUDE_DIR)
#LFAGS := 

ifeq ($(debug), 1)
	DEBUG_CFLAGS := -g
	CFLAGS := $(CFLAGS) $(DEBUG_CFLAGS)
endif


# Run Executable
run: $(NAME)
	@echo "Running $(NAME)"
	@$(BIN_DIR)/$(NAME)

# Build executable
#$(CC) $(CFLAGS) $(LDFLAGS) -o $(BIN_DIR)/$@ $(patsubst %, build/%, $(OBJS))
$(NAME): dir $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BIN_DIR)/$@ $(patsubst %, ./build/%, $(OBJS))

# Build object files and third-party libraries
$(OBJS): dir
	@echo "Building object files"
	@mkdir -p $(BUILD_DIR)/$(@D)
	@$(CC) $(CFLAGS) -o $(BUILD_DIR)/$@ -c $*.c

# Run valgrind memory checker on executable
check: $(NAME)
	#@sudo valgrind -s --leak-check=full --show-leak-kinds=all $(BIN_DIR)/$< --help
	#@sudo valgrind -s --leak-check=full --show-leak-kinds=all $(BIN_DIR)/$< --version
	@sudo valgrind -s --leak-check=full --show-leak-kinds=all $(BIN_DIR)/$< -v

dir:
	@echo "Creating directories"
	@mkdir -p $(BUILD_DIR) $(BIN_DIR) $(DOCS_DIR)

clean:
	@echo "Cleaning up"
	@rm -rf $(BUILD_DIR) $(BIN_DIR) $(DOCS_DIR)

docs: Doxyfile $(OBJS)
	@echo "Generating documentation"
	@doxygen Doxyfile

open_docs: docs
	@echo "Opening documentation"
	@brave $(DOCS_DIR)/html/index.html

.PHONY: lint format check setup dir clean bear
