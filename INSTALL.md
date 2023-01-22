# CM-Makefile: How to install required tools

This document describes how to install tools required by CM-Makefile.

## Ubuntu 22.04

### GNU Make

If Make is not already present, install the `build-essential` package which
also contains GCC and other tools:

	sudo apt-get install build-essential

### Arm GNU Toolchain

The Arm GNU Toolchain can be downloaded directly from the [Arm website][1].
Simply unpack the archive and put it to a convenient location:

	tar xf arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz
	sudo mv arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi /opt

Then add the toolchain to `PATH`:

	echo "export PATH="/opt/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi/bin:$PATH"" >> ~/.bashrc
	source ~/.bashrc

Alternatively (or to use a specific toolchain version), set the `CROSS_COMPILE`
variable when running `make`:

	make CROSS_COMPILE=/usr/local/gcc-arm-none-eabi-8-2018-q4-major/bin/arm-none-eabi-

### GDB (as part of the Arm GNU Toolchain)

GDB is distributed as part of the Arm GNU Toolchain and is available as
`arm-none-eabi-gdb` after the toolchain installation.

To run this particular version on Ubuntu 22.04, it is necessary to install
the libncursesw5 library and Python 3.8 (available in a PPA):

	sudo apt-get install libncursesw5
	sudo add-apt-repository -y ppa:deadsnakes/ppa
	sudo apt-get install python3.8

### GDB (built separately)

A better strategy is to build GDB from sources and install it alongside the Arm
GNU Toolchain version. This way it is configured to use the default system
version of Python version which makes running plugins easier.

First install the ncurses library:

	sudo apt-get install libncursesw5-dev

Then, build and install GDB to a convenient location (e.g. `/opt/arm-none-eabi-gdb`):

	wget https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz
	tar xf gdb-12.1.tar.xz
	mkdir gdb-12.1-build
	cd gdb-12.1-build
	../gdb-12.1/configure --with-python=$(which python3) --target=arm-none-eabi --enable-interwork --enable-multilib --prefix=/opt/arm-none-eabi-gdb
	make -j$(nproc)
	sudo make install

Finally, append it to PATH which overrides `arm-none-eabi-gdb` from the Arm GNU
Toolchain:

	echo "export PATH="/opt/arm-none-eabi-gdb/bin:$PATH"" >> ~/.bashrc
	source ~/.bashrc

### OpenOCD

OpenOCD can be installed from Ubuntu repository:

	sudo apt-get install openocd

However, as the release cycle is rather slow, it might be more useful to compile
it from sources (especially when working with newer MCUs):

	git clone --recursive https://git.code.sf.net/p/openocd/code openocd
	cd openocd
	./bootstrap
	./configure
	make -j$(nproc)
	sudo make install

[1]: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
