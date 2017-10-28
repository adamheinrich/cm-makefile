# OpenOCD target configuration
OPENOCD ?= openocd -f board/st_nucleo_f0.cfg

flash: $(BUILD_DIR)/$(BIN).hex
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 100; \
	flash write_image erase $^; \
	reset run; \
	shutdown"

reset:
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 100; \
	reset run; \
	shutdown"

gdb: $(BUILD_DIR)/$(BIN).hex
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 100; \
	flash write_image erase $^; \
	reset halt"

debug: $(BUILD_DIR)/$(BIN).elf
	@echo "Starting cdtdebug with $(GDB)..."
	$(CMD_ECHO) echo "org.eclipse.cdt.dsf.gdb/defaultGdbCommand=$(GDB)" \
	    > $(BUILD_DIR)/cdtdebug.ini
	$(CMD_ECHO) $(CDTDEBUG) -pluginCustomization $(BUILD_DIR)/cdtdebug.ini \
	    -r localhost:3333 -e $(realpath $^) &
