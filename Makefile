TARGET   := msd.sh
OUT      := msd
INST_DIR := $(PREFIX)/bin

.PHONY: install uninstall sync help

install: $(TARGET)
	@mkdir -p $(INST_DIR)
	chmod +x $(TARGET)
	cp $(TARGET) $(INST_DIR)/$(OUT)

uninstall:
	rm -f $(INST_DIR)/$(OUT)

sync:
	cp $(INST_DIR)/$(OUT) $(TARGET)

help:
	@echo "Available commands: install, uninstall, sync, help"
	@echo "  PREFIX=$(PREFIX)"
