CP = cp

ifeq ($(OS),Windows_NT)
    uname_S := Windows

	CC_ROOT = "/c/Program Files/SDCC"
	CC = $(CC_ROOT)/bin/sdcc
	LN = cp
	PYTHON = python
else
    uname_S := $(shell uname -s)
	
	CC_ROOT = /usr
	CC = $(CC_ROOT)/bin/sdcc
	LN = ln -sf
	PYTHON = python3
endif

switch-sdccrm:
	$(LN) .make/Makefile-sdccrm Makefile || $(CP) .make/Makefile-sdccrm Makefile
  
switch-sdcc-gas::
	$(LN) .make/Makefile-sdcc-gas Makefile || $(CP) .make/Makefile-sdcc-gas Makefile
