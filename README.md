# ARM Cortex-M Makefile Template

Makefile template for Cortex-M projects using the [GCC ARM Embedded][1]
toolchain. The template contains pre-configured examples for a few particular
MCUs but it can be easily used with other vendors' SDKs as well.

## Dependencies

To successfully compile and debug the project, you need:

- Linux desktop (OS X should work as well)
- [GCC ARM Embedded][1] toolchain
- [OpenOCD][2] debugger
- [Eclipse CDT Stand-alone Debugger][3]
- MCU vendor's HAL (start-up code, register definitions, ...)

### Toolchain and OpenOCD installation on Ubuntu

Both the toolchain and OpenOCD can be installed from Ubuntu packages:

	sudo apt-get install gcc-arm-embedded openocd

It is also possible to download a specific version of the toolchain directly
from the [website][1]. In this case, it might be necessary to obtain 32-bit
`libc` and `libncurses` (required by `gdb`):

	sudo apt-get install libc6:i386 libncurses5:i386

## Configuration

The configuration is quite straightforward. Use the following `Makefile`
variables:

- `INC`: include path
- `SRC_ASM`: startup code (assembler, MCU specific)
- `SRC_C`: CMSIS initialization code
- `SRC_LD`: linker script (MCU specific)
- `DEF`: Library-specific macros (`#define`)
- `OPENOCD`: OpenOCD command (with script selection) to set up debug session.
  You can use one of the [built-in scripts][4] or create your own.

### Configuration for a different target

This template can be easily used with different MCU family, see a
target-specific Makefile as an exmple. It's only necessary to obtain
startup code and linker script (which is typically part of a SDK package
provided by the MCU vencor) and configure the `ARCHFLAGS` variable to match its
CPU architecture:

- Cortex-M0: `-mcpu=cortex-m0` (the default option)
- Cortex-M0+: `-mcpu=cortex-m0plus`
- Cortex-M3: `-mcpu=cortex-m3`
- Cortex-M4 (Soft FP): `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp`
- Cortex-M4 (Hard FP): `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard`

## Usage

To compile the project, simply run `make` in its `src directory`, e.g.:

	cd src/stm32-cube
	make

To use a specific toolchain (other than the default `arm-none-eabi`), simply
set the `CROSS_COMPILE` variable:

	make CROSS_COMPILE=/usr/local/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-

The process will create `.elf` and `.hex` binaries in the `build` directory
together with other files useful for debugging:

- `.disasm`: Disassembly output
- `.sym`: Name list (useful to check memory layout)
- `.map`: Linker map (useful to check linked object files, discarded sections,
  etc.)

### Flashing and debugging

To flash the program using OpenOCD, run `make flash`. To reset the CPU, run
`make reset`.

To debug the project, run `make gdb` (which starts OpenOCD's GDB server)
followed by `make debug` in a different terminal (which starts the Eclipse
debugger). The GDB is configured to stop at a breakpoint placed at the beginning
of `main()`.

The Eclipse debugger has to be available as `cdtdebug`. If it isn't, simply
change the `CDTDEBUG` variable.

## License

CM-Makefile is free software: you can redistribute it and/or modify it under the
terms of the GNU Lesser General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

See `COPYING` and `COPYING.LESSER` for details.

[1]: https://launchpad.net/gcc-arm-embedded
[2]: http://openocd.org/
[3]: https://wiki.eclipse.org/CDT/StandaloneDebugger
[4]: https://github.com/ntfreak/openocd/tree/master/tcl/board
