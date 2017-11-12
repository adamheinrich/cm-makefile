# Segger J-Link onboard debug interface configuration
JLINK_EXE = JLinkExe
JLINK_GDB = JLinkGDBServer
JLINK_TARGET = NRF51

.PHONY: flash
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

.PHONY: reset
reset:
	@echo "device $(JLINK_TARGET)\n\
	speed 1000\n\
	sleep 100\n\
	g\n\
	q\n" | $(JLINK_EXE)

.PHONY: gdb
gdb: $(BUILD_DIR)/$(PROJ).hex
	@echo "Starting GDB server"
	$(CMD_ECHO) $(JLINK_GDB) -if SWD -speed 1000 -device $(JLINK_TARGET)

.PHONY: debug
debug: $(BUILD_DIR)/$(BIN).elf
	@echo "Starting cdtdebug with $(GDB)..."
	$(CMD_ECHO) echo "org.eclipse.cdt.dsf.gdb/defaultGdbCommand=$(GDB)" \
	    > $(BUILD_DIR)/cdtdebug.ini
	$(CMD_ECHO) $(CDTDEBUG) -pluginCustomization $(BUILD_DIR)/cdtdebug.ini \
	    -r localhost:2331 -e $(realpath $^) &
