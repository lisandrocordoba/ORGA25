CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = mascaras

all: $(TARGET)

$(TARGET): mascaras.o
	$(CC) $(CFLAGS) $^ -o $@

mascaras.o: mascaras.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean