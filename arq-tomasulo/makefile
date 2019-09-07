APPS = ./apps
BIN = ./bin
COMPILER = ./compiler
INCLUDE = ./include
OBJ = ./obj
SRC = ./src
TESTS = ./tests

FLAGS = -O3 -Wall -std=gnu99

all: bison flex libed app
	./bin/simulator -h
libed: \
	$(OBJ)/memory.o \
	$(OBJ)/cache.o \
	$(OBJ)/so.o \
	$(OBJ)/fila.o \
	$(OBJ)/processor.o \
	$(OBJ)/converters.o \
	$(OBJ)/system_bus.o \
	$(OBJ)/utils.o
	gcc -c $(SRC)/functional_units.s -o $(OBJ)/functional_units.o
	gcc -c $(COMPILER)/compiler.c -I $(INCLUDE) -o $(OBJ)/compiler.o

$(OBJ)/%.o: $(SRC)/%.c $(INCLUDE)/%.h
	gcc -c $< -I $(INCLUDE) -o $@

app:
	gcc $(COMPILER)/grammar.tab.c $(COMPILER)/lex.yy.c $(APPS)/simulator.c $(OBJ)/*.o -I $(INCLUDE) $(FLAGS) -o $(BIN)/simulator -lfl -lm

bison:
	bison -d $(COMPILER)/grammar.y
	mv grammar.tab.h $(COMPILER)
	mv grammar.tab.c $(COMPILER)

flex:
	flex $(COMPILER)/lex.l
	mv lex.yy.c $(COMPILER)

run:
	$(BIN)/simulator $(TESTS)/fatorial.asm

clean:
	rm $(OBJ)/*.o
	rm $(BIN)/*
	rm mmap_memory.bin
	rm $(COMPILER)/labels.out
	rm $(COMPILER)/out.o
	rm $(COMPILER)/grammar.tab.c
	rm $(COMPILER)/grammar.tab.h
	rm $(COMPILER)/lex.yy.c
