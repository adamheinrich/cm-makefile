# Project name
BIN = nrf51

# Include paths (nRF5 SDK)
SDK_DIR = lib/nRF5_SDK_12.3.0_d7731ad

INC = -I$(SDK_DIR)/components/toolchain/cmsis/include \
      -I$(SDK_DIR)/components/toolchain/gcc \
      -I$(SDK_DIR)/components/toolchain \
      -I$(SDK_DIR)/components/device \
      -I$(SDK_DIR)/components/drivers_nrf/common \
      -I$(SDK_DIR)/components/drivers_nrf/hal \
      -I$(SDK_DIR)/components/drivers_nrf/delay \
      -I$(SDK_DIR)/components/drivers_nrf/nrf_soc_nosd \
      -I$(SDK_DIR)/components/libraries/util

INC += -L$(SDK_DIR)/components/toolchain/gcc

# ASM and C (e.g. startup) source files and linker script outside src directory
SRC_ASM = $(SDK_DIR)/components/toolchain/gcc/gcc_startup_nrf51.S
SRC_C = $(SDK_DIR)/components/toolchain/system_nrf51.c
SRC_LD = nrf51.ld

# Defines required by included libraries
DEF = -DNRF51 \
      -DNRF51422

# Segger J-Link onboard debug interface configuration
JLINK_EXE = JLinkExe
JLINK_GDB = JLinkGDBServer
JLINK_TARGET = NRF51

include ../common.mk

flash: $(BUILD_DIR)/$(BIN).hex
	# NVMC - Nonvolatile Memory Controller (address 0x4001e)
	# Write enable erase (2) to CONFIG (offset 0x504) register
	# Write start chip erase (1) to ERASEALL (offset 0x50c) register
	@echo "device $(JLINK_TARGET)\n\
	speed 1000\n\
	w4 4001e504 2\n\
	w4 4001e50c 1\n\
	sleep 100\n\
	r\n\
	loadbin $^ 0x00\n\
	sleep 100\n\
	r\n\
	g\n\
	q\n" | $(JLINK_EXE)

reset:
	@echo "device $(JLINK_TARGET)\n\
	speed 1000\n\
	sleep 100\n\
	g\n\
	q\n" | $(JLINK_EXE)

gdb: $(BUILD_DIR)/$(PROJ).hex
	@echo "Starting GDB server"
	$(CMD_ECHO) $(JLINK_GDB) -if SWD -speed 1000 -device $(JLINK_TARGET)

debug: $(BUILD_DIR)/$(BIN).elf
	@echo "Starting cdtdebug with $(GDB)..."
	$(CMD_ECHO) echo "org.eclipse.cdt.dsf.gdb/defaultGdbCommand=$(GDB)" \
	    > $(BUILD_DIR)/cdtdebug.ini
	$(CMD_ECHO) $(CDTDEBUG) -pluginCustomization $(BUILD_DIR)/cdtdebug.ini \
	    -r localhost:2331 -e $(realpath $^) &
