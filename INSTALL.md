# CM-Makefile: How to install required tools

This document describes how to install tools required by CM-Makefile.

## Ubuntu

### GCC ARM Embedded Toolchain

The toolchain can be installed from Ubuntu repository:

	sudo apt-get install gcc-arm-embedded openocd

It is also possible to download a specific version of the toolchain directly
from the [website][1]. In this case, it might be necessary to obtain 32-bit
`libc` and `libncurses` (required by `gdb`):

	sudo apt-get install libc6:i386 libncurses5:i386

To use a specific toolchain version, set the `CROSS_COMPILE` variable
accordingly, e.g.:

	make CROSS_COMPILE=/usr/local/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-

### OpenOCD

OpenOCD can be installed from Ubuntu repository:

	sudo apt-get install openocd

[1]: https://launchpad.net/gcc-arm-embedded
