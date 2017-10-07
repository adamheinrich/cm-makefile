# Set to @ if you want to suppress command echo
CMD_ECHO = @

# Project name
BIN = hello

# Important directories
BUILD_DIR = ../build
TOOLCHAIN ?= arm-none-eabi-

# Include paths (STM32CubeF0 library)
CUBE_DIR = ../lib/STM32Cube_FW_F0_V1.4.0
CUBE_DEVICE_DIR = $(CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32F0xx

INC = -I. \
      -I$(CUBE_DIR)/Drivers/CMSIS/Include \
      -I$(CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32F0xx/Include

# ASM and C (e.g. startup) source files and linker script outside src directory
SRC_ASM = $(CUBE_DEVICE_DIR)/Source/Templates/gcc/startup_stm32f030x8.s
SRC_C = $(CUBE_DEVICE_DIR)/Source/Templates/system_stm32f0xx.c
SRC_LD = $(CUBE_DIR)/Projects/STM32F030R8-Nucleo/Templates/TrueSTUDIO/STM32F030R8-Nucleo/STM32F030R8_FLASH.ld

# Defines required by included libraries
DEF = -DSTM32F030x8

# Debug interface configuration
OPENOCD = openocd -f board/st_nucleo_f0.cfg
CDTDEBUG = /Applications/cdt-stand-alone-debugger.app/Contents/MacOS/cdtdebug

# Compiler and linker flags
ARCHFLAGS = -mcpu=cortex-m0 -mthumb -mabi=aapcs
DBGFLAGS = -ggdb
OPTFLAGS = -O3 -flto

ASFLAGS = $(ARCHFLAGS)

# CC: Place functions and data into separate sections to allow dead code removal
# by the linker (-f*-sections)
CFLAGS = $(ARCHFLAGS) $(OPTFLAGS) $(DBGFLAGS) -std=gnu99 -Wall -Wno-format \
         -Werror -ffunction-sections -fdata-sections

# LD: Remove unused sections, link with newlib-nano implementation, generate map
LDFLAGS = $(ARCHFLAGS) $(OPTFLAGS) $(DBGFLAGS) -Wl,-Map=$(BUILD_DIR)/$(BIN).map\
          -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

# Generate object list from source files and add their dirs to search path
SRC_ASM += $(wildcard *.s) 
FILENAMES_ASM = $(notdir $(SRC_ASM))
OBJS_ASM = $(addprefix $(BUILD_DIR)/, $(FILENAMES_ASM:.s=.o))
vpath %.s $(dir $(SRC_ASM))

SRC_C += $(wildcard *.c) 
FILENAMES_C = $(notdir $(SRC_C))
OBJS_C = $(addprefix $(BUILD_DIR)/, $(FILENAMES_C:.c=.o))
vpath %.c $(dir $(SRC_C))

# Tools selection
CC = $(TOOLCHAIN)gcc
AS = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)gcc
NM = $(TOOLCHAIN)nm
OBJCOPY = $(TOOLCHAIN)objcopy
OBJDUMP = $(TOOLCHAIN)objdump
SIZE = $(TOOLCHAIN)size
GDB = $(TOOLCHAIN)gdb

all: $(BUILD_DIR) $(BUILD_DIR)/$(BIN).hex
	@echo ""
	$(CMD_ECHO) @$(SIZE) $(BUILD_DIR)/$(BIN).elf

$(BUILD_DIR):
	$(CMD_ECHO) mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(BIN).hex: $(BUILD_DIR)/$(BIN).elf
	@echo "Generating HEX binary: $(notdir $@)"
	$(CMD_ECHO) $(OBJCOPY) -O ihex $< $@

$(BUILD_DIR)/%.o: %.s
	@echo "Compiling ASM file: $(notdir $<)"
	$(CMD_ECHO) $(AS) $(ASFLAGS) $(DEF) $(INC) -c -o $@ $<

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling C file: $(notdir $<)"
	$(CMD_ECHO) $(CC) $(CFLAGS) $(DEF) $(INC) -c -o $@ $<

$(BUILD_DIR)/$(BIN).elf: $(OBJS_ASM) $(OBJS_C)
	@echo "Linking ELF binary: $(notdir $@)"
	$(CMD_ECHO) $(LD) $(LDFLAGS) -T$(SRC_LD) -o $@ $^
	
	@echo "Generating name list: $(BIN).sym"
	$(CMD_ECHO) $(NM) -n $@ > $(BUILD_DIR)/$(BIN).sym

	@echo "Generating disassembly: $(BIN).disasm"
	$(CMD_ECHO) $(OBJDUMP) -S $@ > $(BUILD_DIR)/$(BIN).disasm

flash: $(BUILD_DIR)/$(BIN).hex
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 500; \
	flash write_image erase $^; \
	reset run; \
	shutdown"

reset:
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 500; \
	reset run; \
	shutdown"

gdb: $(BUILD_DIR)/$(BIN).hex
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 500; \
	flash write_image erase $^; \
	reset halt"

debug: $(BUILD_DIR)/$(BIN).hex
	@echo "Starting cdtdebug..."
	$(CMD_ECHO) $(CDTDEBUG) -r localhost:3333 -e $(realpath $(BUILD_DIR)/$(BIN).elf) &
clean:
	rm -f $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.hex $(BUILD_DIR)/*.map
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/*.sym $(BUILD_DIR)/*.disasm
