# STM32 Template

Makefile template for STM32-based Cortex-M projects using the GCC ARM Embedded
toolchain. Although the template is configured for the STM32F030R8 Nucleo board,
it can be easily modified for any other development kit by ST.

## Dependencies

To successfully compile and debug the project, you need:

- Linux desktop (OS X should work as well)
- [GCC ARM Embedded][1] toolchain (4.9 2015q1)
- [OpenOCD][2] (0.9.0)
- [STM32CubeF0][3] library by ST (1.4.0)
- [Eclipse CDT Stand-alone Debugger][4] (9.2.0)

Version numbers correspond to my current setup. Newer versions will probably
work as well.

The STM32CubeF0 library has to be placed in directory
`lib/STM32Cube_FW_F0_Vx.x.x`. Only CMSIS compliant headers, startup code and
linker script are used. Any higher level components provided by the Cube library
(such as HAL) are ignored.

### Toolchain and OpenOCD installation on Ubuntu

Both the toolchain and OpenOCD can be installed from Ubuntu packages:

	sudo apt-get install gcc-arm-embedded openocd

It is also possible to download a specific version of the toolchain directly
from the [website][1]. In this case, it might be necessary to obtain 32-bit
`libc` and `libncurses` (required by `gdb`):

	sudo apt-get install libc6:i386 libncurses5:i386

## Configuration

The configuration is quite straightforward. Check the following variables in
`Makefile`:

- `CUBE_DIR`: location of the STM32CubeF0
- `SRC_ASM`: startup code (assembler, MCU specific)
- `SRC_C`: CMSIS initialization code
- `SRC_LD`: linker script (MCU specific)
- `DEF`: Library-specific macros (`#define`) -- MCU selection in this case
- `OPENOCD`: OpenOCD command (with script selection) to set up debug session.
  You can use one of the [built-in scripts][5] or create your own.

### Configuration for a different target

This template can be easily used with different family than STM32F0. It's only
necessary to download proper version of the [STM32Cube][6] library and configure
the `-mcpu` option in `ARCHFLAGS` to match its CPU architecture:

- Cortex-M0: `-mcpu=cortex-m0`
- Cortex-M0+: `-mcpu=cortex-m0plus`
- Cortex-M3: `-mcpu=cortex-m3`
- Cortex-M4 (Soft FP): `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp`
- Cortex-M4 (Hard FP): `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard`

## Usage

To compile the project, simply `cd` to the `src` directory and run `make`.
To use a specific toolchain (other than the default `arm-none-eabi`), simply
set the `TOOLCHAIN` variable:

	make TOOLCHAIN=/usr/local/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-

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

[1]: https://launchpad.net/gcc-arm-embedded
[2]: http://openocd.org/
[3]: http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897/PF260612
[4]: https://wiki.eclipse.org/CDT/StandaloneDebugger
[5]: https://github.com/ntfreak/openocd/tree/master/tcl/board
[6]: http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897
