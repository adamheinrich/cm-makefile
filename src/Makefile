# Set to @ if you want to suppress command echo
CMD_ECHO = @

# Project name
BIN = hello

# Important directories
BUILD_DIR = ../build
TOOLCHAIN_DIR = /usr/local/gcc-arm-none-eabi-4_9-2015q1/bin

# Include paths (STM32CubeF0 library)
CUBE_DIR = ../lib/STM32Cube_FW_F0_V1.4.0
CUBE_DEVICE_DIR = $(CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32F0xx

INC = -I. \
      -I$(CUBE_DIR)/Drivers/CMSIS/Include \
      -I$(CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32F0xx/Include

# ASM and C (e.g. startup) source files and linker script
SRC_ASM = $(CUBE_DEVICE_DIR)/Source/Templates/gcc/startup_stm32f030x8.s
SRC_C = $(CUBE_DEVICE_DIR)/Source/Templates/system_stm32f0xx.c
SRC_LD = $(CUBE_DIR)/Projects/STM32F030R8-Nucleo/Templates/TrueSTUDIO/STM32F030R8-Nucleo/STM32F030R8_FLASH.ld

# Defines required by included libraries
DEF = -DSTM32F030x8

# Debug interface configuration
OPENOCD = openocd
OPENOCD_SCRIPT = board/st_nucleo_f0.cfg

# Compiler and linker flags
ARCHFLAGS = -mcpu=cortex-m0 -mthumb -mabi=aapcs
DBGFLAGS = -ggdb
ASFLAGS = $(ARCHFLAGS)

# CC: Place functions and data into separate sections to allow dead code removal
# by the linker (-f*-sections). Enable link time optimization (-flto)
CFLAGS = $(ARCHFLAGS) -std=gnu99 -Wall -Wno-format -Werror \
         -ffunction-sections -fdata-sections \
         -Os -flto $(DBGFLAGS)

# LD: Remove unused sections, link with newlib-nano implementation, generate map
LDFLAGS = $(ARCHFLAGS) -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs
LDFLAGS += -Wl,-Map=$(BUILD_DIR)/$(BIN).map $(DBGFLAGS)

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
CC = $(TOOLCHAIN_DIR)/arm-none-eabi-gcc
AS = $(TOOLCHAIN_DIR)/arm-none-eabi-gcc
LD = $(TOOLCHAIN_DIR)/arm-none-eabi-gcc
NM = $(TOOLCHAIN_DIR)/arm-none-eabi-nm
OBJCOPY = $(TOOLCHAIN_DIR)/arm-none-eabi-objcopy
OBJDUMP = $(TOOLCHAIN_DIR)/arm-none-eabi-objdump
SIZE = $(TOOLCHAIN_DIR)/arm-none-eabi-size
GDB = $(TOOLCHAIN_DIR)/arm-none-eabi-gdb

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
	$(OPENOCD) -f $(OPENOCD_SCRIPT) -c \
	"init; \
	reset halt; \
	sleep 500; \
	flash write_image erase $(BUILD_DIR)/$(BIN).hex; \
	reset run; \
	shutdown"

gdb: $(BUILD_DIR)/$(BIN).hex
	$(OPENOCD) -f $(OPENOCD_SCRIPT) -c \
	"init; \
	reset halt"

debug: $(BUILD_DIR)/$(BIN).hex
	@echo "target remote localhost:3333\n\
	monitor reset halt\n\
	load\n\
	break main\n\
	continue\n" > $(BUILD_DIR)/$(BIN).gdbinit

	$(GDB) -x $(BUILD_DIR)/$(BIN).gdbinit -tui $(BUILD_DIR)/$(BIN).elf

clean:
	rm -f $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.hex $(BUILD_DIR)/*.map
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/*.sym $(BUILD_DIR)/*.disasm
	rm -f $(BUILD_DIR)/*.gdbinit
