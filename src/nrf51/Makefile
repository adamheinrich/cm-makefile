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

include ../common.mk
include jlink.mk

# Disable GCC warnings which are triggered by the nRF5 SDK
WARNFLAGS += -Wno-pedantic -Wno-undef -Wno-sign-conversion -Wno-unused-parameter
