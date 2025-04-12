CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = tamañoTipos

all: $(TARGET)

$(TARGET): tamañoTipos.o
	$(CC) $(CFLAGS) $^ -o $@

tamañoTipos.o: tamañoTipos.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean