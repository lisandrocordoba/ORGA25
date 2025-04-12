CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = casteo

all: $(TARGET)

$(TARGET): casteo.o
	$(CC) $(CFLAGS) $^ -o $@

casteo.o: casteo.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean