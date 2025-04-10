CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = operadores

all: $(TARGET)

$(TARGET): operadores.o
	$(CC) $(CFLAGS) $^ -o $@

operadores.o: operadores.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean