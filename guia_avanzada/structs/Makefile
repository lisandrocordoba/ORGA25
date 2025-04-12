CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = structs

all: $(TARGET)

$(TARGET): structs.o
	$(CC) $(CFLAGS) $^ -o $@

structs.o: structs.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean