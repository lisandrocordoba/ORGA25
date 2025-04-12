CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = pointers

all: $(TARGET)

$(TARGET): pointers.o
	$(CC) $(CFLAGS) $^ -o $@

pointers.o: pointers.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean