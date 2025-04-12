CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = malloc

all: $(TARGET)

$(TARGET): malloc.o
	$(CC) $(CFLAGS) $^ -o $@

malloc.o: malloc.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean