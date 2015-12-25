# STM32 Template

Makefile template for STM32 Cortex-M projects using the GCC ARM Embedded
toolchain.

The template is configured for STM32F030R8 Nucleo board but it can be easily
modified to support any other development kit by ST.

## Dependencies

To successfully compile and debug the project, you need:

- Some nice *nix operating system (tested on OS X)
- [GCC ARM Embedded][1] toolchain (4.9 2015q1)
- [OpenOCD][2] (0.9.0)
- [STM32CubeF0][3] library by ST (1.4.0)

Version numbers correspond to my current setup.

The STM32CubeF0 library has to be placed in directory
``lib/STM32Cube_FW_F0_Vx.x.x``. Only CMSIS compliant headers, startup code and
linker script are used. Any higher level components provided by the Cube library
(such as HAL) are ignored.

## Configuration

The configuration is quite straightforward. Check following variables in the
Makefile:

- ``TOOLCHAIN_DIR`` - location of the GCC ARM Embedded toolchain
- ``CUBE_DIR`` - location of the STM32CubeF0
- ``SRC_ASM`` - startup code (assembler, MCU specific)
- ``SRC_C`` - CMSIS initialization code
- ``SRC_LD`` - linker script (MCU specific)
- ``DEF`` - #define for specific MCU selection
- ``OPENOCD_SCRIPT`` - OpenOCD script to set up debug session. You can create
  your own or use one of [built-in scripts][4].

## Configuration for a different target

This template can be easily used with different family than STM32F0. It's only
necessary to download proper version of the [STM32Cube][5] library
(F1, F2, ...) and configure the ``-mcpu`` option in ``ARCHFLAGS`` to match MCU
architecture:

- Cortex-M0: ``-mcpu=cortex-m0``
- Cortex-M0+: ``-mcpu=cortex-m0plus``
- Cortex-M3: ``-mcpu=cortex-m3``
- Cortex-M4 (Soft FP): ``-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp``
- Cortex-M4 (Hard FP): ``-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard``

## Usage

To compile the project, simply ``cd`` to the *src* directory and run ``make``.

The process will create *.elf* and *.hex* binaries in *build* directory together
with other files useful for debugging:

- *.disasm*: Disassembly output
- *.sym*: Name list (useful to check memory layout)
- *.map*: Linker map (useful to check linked object files, discarded sections,
  etc.)

To debug the project, run ``make gdb`` (which starts OpenOCD with GDB server)
followed by ``make debug`` in a different terminal (which starts GDB client with
TUI interface). The GDB is configured to stop at a breakpoint placed at the
beginning of main().

[1]: https://launchpad.net/gcc-arm-embedded
[2]: http://openocd.org/
[3]: http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897/PF260612
[4]: https://github.com/ntfreak/openocd/tree/master/tcl/board
[5]: http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897
