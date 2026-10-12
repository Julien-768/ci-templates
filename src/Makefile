CC = arm-none-eabi-gcc
CFLAGS = -Wall -Wextra -std=c11

TARGET = main.o
SOURCES = main.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -c $(SOURCES) -o $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all clean
