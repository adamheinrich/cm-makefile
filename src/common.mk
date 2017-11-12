# Set to @ if you want to suppress command echo
CMD_ECHO ?= @

# Project name
BIN ?= template

# Important directories
BUILD_DIR ?= ./build

# Include directories
INC += -I.
INC_LD += .

# ASM and C (e.g. startup) source files and linker script outside src directory
SRC_ASM ?=
SRC_C ?=
SRC_LD ?=

# Defines required by included libraries
DEF ?=

# Debugger configuration
CDTDEBUG ?= cdtdebug

# Compiler and linker flags
ARCHFLAGS ?= -mcpu=cortex-m0
ARCHFLAGS += -mthumb -mabi=aapcs
DBGFLAGS ?= -ggdb
OPTFLAGS ?= -O3 -flto
WARNFLAGS ?= -Wall -Wextra -Wundef -Wshadow -Wimplicit-function-declaration \
             -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
             -Wconversion -Wdouble-promotion -Wfloat-conversion -pedantic

# This should be only enabled during development:
#WARNFLAGS += -Werror

ASFLAGS = $(ARCHFLAGS)

# CC: Place functions and data into separate sections to allow dead code removal
# by the linker (-f*-sections)
CFLAGS = $(ARCHFLAGS) $(OPTFLAGS) $(DBGFLAGS) $(WARNFLAGS) -std=gnu99 \
         -ffunction-sections -fdata-sections

# LD: Remove unused sections, link with newlib-nano implementation, generate map
LDFLAGS = $(ARCHFLAGS) $(OPTFLAGS) $(DBGFLAGS) -Wl,-Map=$(BUILD_DIR)/$(BIN).map\
          -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

# Generate object list from source files and add their dirs to search path
SRC_ASM += $(wildcard *.s)
SRC_ASM += $(wildcard *.S)
FILENAMES_ASM = $(notdir $(SRC_ASM))
OBJFILENAMES_ASM = $(FILENAMES_ASM:.s=.o)
OBJS_ASM = $(addprefix $(BUILD_DIR)/, $(OBJFILENAMES_ASM:.S=.o))
vpath %.s $(dir $(SRC_ASM))
vpath %.S $(dir $(SRC_ASM))

SRC_C += $(wildcard *.c)
FILENAMES_C = $(notdir $(SRC_C))
OBJS_C = $(addprefix $(BUILD_DIR)/, $(FILENAMES_C:.c=.o))
vpath %.c $(dir $(SRC_C))

# Tools selection
CROSS_COMPILE ?= arm-none-eabi-

CC := $(CROSS_COMPILE)gcc
AS := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)gcc
NM := $(CROSS_COMPILE)nm
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump
SIZE := $(CROSS_COMPILE)size
GDB := $(CROSS_COMPILE)gdb

all: $(BUILD_DIR) $(BUILD_DIR)/$(BIN).hex  $(BUILD_DIR)/$(BIN).bin
	@echo ""
	$(CMD_ECHO) @$(SIZE) $(BUILD_DIR)/$(BIN).elf

$(BUILD_DIR):
	$(CMD_ECHO) mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(BIN).hex: $(BUILD_DIR)/$(BIN).elf
	@echo "Generating HEX binary: $(notdir $@)"
	$(CMD_ECHO) $(OBJCOPY) -O ihex $< $@

$(BUILD_DIR)/$(BIN).bin: $(BUILD_DIR)/$(BIN).elf
	@echo "Generating BIN binary: $(notdir $@)"
	$(CMD_ECHO) $(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/%.o: %.s
	@echo "Compiling ASM file: $(notdir $<)"
	$(CMD_ECHO) $(AS) $(ASFLAGS) $(DEF) $(INC) -c -o $@ $<

$(BUILD_DIR)/%.o: %.S
	@echo "Compiling ASM file: $(notdir $<)"
	$(CMD_ECHO) $(AS) $(ASFLAGS) $(DEF) $(INC) -c -o $@ $<

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling C file: $(notdir $<)"
	$(CMD_ECHO) $(CC) $(CFLAGS) $(DEF) $(INC) -c -o $@ $<

$(BUILD_DIR)/$(BIN).elf: $(OBJS_ASM) $(OBJS_C)
	@echo "Linking ELF binary: $(notdir $@)"
	$(CMD_ECHO) $(LD) $(LDFLAGS) $(INC) -T$(SRC_LD) -o $@ $^

	@echo "Generating name list: $(BIN).sym"
	$(CMD_ECHO) $(NM) -n $@ > $(BUILD_DIR)/$(BIN).sym

	@echo "Generating disassembly: $(BIN).disasm"
	$(CMD_ECHO) $(OBJDUMP) -S $@ > $(BUILD_DIR)/$(BIN).disasm

clean:
	rm -f $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.hex $(BUILD_DIR)/*.bin
	rm -f $(BUILD_DIR)/*.map $(BUILD_DIR)/*.sym $(BUILD_DIR)/*.disasm
	rm -f $(BUILD_DIR)/*.ini $(BUILD_DIR)/*.o
