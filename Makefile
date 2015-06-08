# Microcontroller options.
DF_CPU ?= 16000000UL
MMCU   ?= atmega328p

# Port to flash to.
PORT ?= /dev/$(shell ls /dev/ | grep "tty\.usb" | sed -n 1p)

# UART baud rate.
# 115200 - Arduino Uno
# 57600  - Arduino Mini Pro
BAUD ?= 115200

# The location for our library archives and headers.
PREFIX ?= /usr/local/avr

################################

# Probably shouldn't touch these.

# Source files, defaults to all.
SRC = $(wildcard lib/*.c)

# The `gcc` executable.
CC = avr-gcc
C_FLAGS = -Wall -Werror -pedantic -Os -std=c99

# C flags for compiling with this library.
C_AVR_INCLUDES = -I$(PREFIX)/include
C_AVR_LIBS = -L$(PREFIX)/lib -lavr

# The `as` executable.
AS = avr-as

# The `obj-copy` executable.
OBJ_COPY = avr-objcopy
OBJ_COPY_FLAGS = -O ihex -R .eeprom

# The `avrdude` executable.
AVRDUDE = avrdude
AVRDUDE_FLAGS = -F -V -c arduino -p ATMEGA328P

# The `avr-size` executable.
AVRSIZE = avr-size
AVRSIZE_FLAGS = -C

################################

# The default task is to build all projects.
default: all

################################

# Pseudo rules.

# These rules are not file based.
.PHONY: flash serial size clean

# Mark the hex file as intermediate.
.INTERMEDIATE: $(TARGET).hex $(TARGET).bin

################################

# Utility rules (not file based).

# TODO: Build the archive.
all: $(PROJECTS:.c=.bin)

# TODO: Compile the tests against the installed lib.
test: $(TESTS:.c=.hex)
	@echo "foo"

# Given a hex file using `avrdude` this target flashes the AVR with the
# new program contained in the hex file.
flash: $(TARGET).hex
	$(AVRDUDE) $(AVRDUDE_FLAGS) -P $(PORT) -b $(BAUD) -U flash:w:$<

# Open up a screen session for communication with the AVR
# through it's on-board UART.
serial:
	screen $(PORT) $(BAUD)

# Show information about target's size.
size: $(TARGET).bin
	$(AVRSIZE) $(AVRSIZE_FLAGS) --mcu=$(MMCU) $<

# Remove non-source files.
clean:
	rm -rf $(wildcard **/*.o) $(wildcard **/*.bin) $(wildcard **/*.hex) $(wildcard test/**/*.hex)

################################

# File rules.

# .bin <- .o
%.bin: %.o $(SRC:.c=.o)
	$(CC) $(C_FLAGS) -mmcu=$(MMCU) $? -o $@ $(C_AVR_LIBS)

# .o <- .c
%.o: %.c
	$(CC) $(C_FLAGS) $(C_AVR_INCLUDES) -DF_CPU=$(DF_CPU) -mmcu=$(MMCU) -c $< -o $@

# .hex <- .bin
%.hex: %.bin
	$(OBJ_COPY) $(OBJ_COPY_FLAGS) $< $@
