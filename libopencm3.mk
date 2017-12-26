##
##  This file is part of CM-Makefile.
##
##  Copyright (C) 2015 Adam Heinrich <adam@adamh.cz>
##
##  CM-Makefile is free software: you can redistribute it and/or modify
##  it under the terms of the GNU Lesser General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  CM-Makefile is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU Lesser General Public License for more details.
##
##  You should have received a copy of the GNU Lesser General Public License
##  along with CM-Makefile.  If not, see <http://www.gnu.org/licenses/>.
##

OPENCM3_DIR ?= ./libopencm3
OPENCM3_LIB ?= libopencm3_stm32f0.a

OPENCM3_FLAGS  = V=$(V)
OPENCM3_FLAGS += PREFIX=$(subst --,,$(CROSS_COMPILE)-)
OPENCM3_FLAGS += FP_FLAGS="$(FPFLAGS)"
OPENCM3_FLAGS += DEBUG_FLAGS="$(DBGFLAGS)"

HELP_TEXT += \n\
  libopencm3 - Build the libopencm3 library\n\
  libopencm3_clean - Remove files built in the libopencm3 folder

$(OPENCM3_DIR)/Makefile:
	$(error Error: libopencm3 is not available. Run \
		`git submodule update --init` to initialize submodules.)

$(OPENCM3_DIR)/lib/$(OPENCM3_LIB): $(OPENCM3_DIR)/Makefile
	$(CMD_ECHO) $(MAKE) -C $(OPENCM3_DIR) $(OPENCM3_FLAGS)

.PHONY: libopencm3
libopencm3: $(OPENCM3_DIR)/lib/$(OPENCM3_LIB)

.PHONY: libopencm3_clean
libopencm3_clean:
	$(CMD_ECHO) $(MAKE) -C $(OPENCM3_DIR) clean