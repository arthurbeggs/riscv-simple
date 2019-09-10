# Constants
BIN_DIR = bin
SRC_DIR = src
OBJ_DIR = obj

CC              = gcc
CC_FLAGS        = -Wextra -Wall -ggdb3 -fpic -lm
RM              = rm -rf --preserve-root

MAIN_NAME       = bmp2oac
OBJ_FILES       = $(foreach file, $(shell ls $(SRC_DIR)), $(OBJ_DIR)/$(file:.c=.o))

PROJECT_NAME    = bmp2oac
MAIN_PROG       = $(BIN_DIR)/$(PROJECT_NAME)

# Recipes
all : $(MAIN_PROG)

$(MAIN_PROG): $(OBJ_FILES) | $(BIN_DIR)
	$(CC) $(CC_FLAGS) -o $@ $^

$(OBJ_DIR) $(BIN_DIR):
	mkdir -v $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR) $(DEP_DIR)
	$(CC) $(CC_FLAGS) -c $< -o $@

.PHONY: clean

clean :
	@echo Cleanning up the project
	$(RM) $(OBJ_DIR) $(BIN_DIR)

