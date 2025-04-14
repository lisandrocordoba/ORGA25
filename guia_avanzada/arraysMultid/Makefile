CC = gcc
CFLAGS = -g -Wall -Wextra -pedantic -MMD -MP
TARGET = bin

all: $(TARGET)

SRCS = main.c
OBJS = $(SRCS:.c=.o)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

-include £(OBJS:.o=.d)

clean:
	rm *.o $(TARGET)

.PHONY: all clean