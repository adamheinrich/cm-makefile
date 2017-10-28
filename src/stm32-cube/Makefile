# Project name
BIN = stm32-cube

# Include paths (STM32CubeF0 library)
CUBE_DIR = lib/STM32Cube_FW_F0_V1.4.0
CUBE_DEVICE_DIR = $(CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32F0xx

INC = -I$(CUBE_DIR)/Drivers/CMSIS/Include \
      -I$(CUBE_DEVICE_DIR)/Include

# ASM and C (e.g. startup) source files and linker script outside src directory
SRC_ASM = $(CUBE_DEVICE_DIR)/Source/Templates/gcc/startup_stm32f030x8.s
SRC_C = $(CUBE_DEVICE_DIR)/Source/Templates/system_stm32f0xx.c
SRC_LD = $(CUBE_DIR)/Projects/STM32F030R8-Nucleo/Templates/TrueSTUDIO/STM32F030R8-Nucleo/STM32F030R8_FLASH.ld

# Defines required by included libraries
DEF = -DSTM32F030x8

include ../common.mk
include ../openocd.mk
