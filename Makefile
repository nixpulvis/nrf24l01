LIBRARY = nrf24l01
VERSION = 0.0.4
PREFIX = /usr/local/Cellar/$(LIBRARY)/$(VERSION)

AVRM = /usr/local/Cellar/avrm/0.0.4
DEPENDENCIES = $(PREFIX) $(AVRM)

include $(AVRM)/Makefile
