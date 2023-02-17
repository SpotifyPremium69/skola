######################################################
#         Makefile pro sdccrm
######################################################
# makefile for STM8S_StdPeriph_Lib and SDCC compiler
#
# Customized by MightyPork 1/2017
#
# usage:
#   1. if SDCC not in PATH set path -> CC_ROOT
#   2. set correct STM8 device -> DEVICE
#   3. set project paths -> PRJ_ROOT, PRJ_SRC_DIR, PRJ_INC_DIR
#   4. set SPL root path -> SPL_ROOT
#   5. include required SPL modules -> SPL_SOURCE
#
#######

# STM8 device (default is STM8 discovery board)
DEVICE=STM8S103
DEVICE_FLASH=stm8s103f3

STLINK=stlinkv2
STLINK=stlink

F_CPU=16000000

MKDIR = mkdir
CP = cp

ifeq ($(findstring 2019, $(shell openocd --version 2>&1)), 2019)
    interface = interface/stlink.cfg
else
    interface = interface/stlink-dap.cfg
endif
ifeq ($(findstring 003, $(DEVICE)), 003)
	target = target/stm8s003.cfg
else ifeq ($(findstring 103, $(DEVICE)), 103)
	target = target/stm8s103.cfg
else ifeq ($(findstring 105, $(DEVICE)), 105)
	target = target/stm8s105.cfg
else
	target = target/stm8s.cfg
endif
OPENOCD = openocd -f .make/stm8s-flash.cfg -f $(interface) -f $(target)


ifeq ($(OS),Windows_NT)
    uname_S := Windows

	CC_ROOT = "/c/Program Files/SDCC"
	CC = $(CC_ROOT)/bin/sdcc
	LN = cp
	PYTHON = python
	STVP = "/c/Program Files (x86)/STMicroelectronics/st_toolset/stvp/STVP_CmdLine.exe"

else
    uname_S := $(shell uname -s)
	
	CC_ROOT = /usr
	CC = $(CC_ROOT)/bin/sdcc
	LN = ln -sf
	PYTHON = python3
endif

# trap handling requires SDCC >=v3.4.3
SKIP_TRAPS = 1

# set compiler path & parameters 
CFLAGS  = -mstm8 -lstm8 --opt-code-size 
CFLAGS  = -mstm8 -lstm8 --opt-code-size --std-sdcc99 --nogcse --all-callee-saves --stack-auto --fverbose-asm --float-reent --no-peep
CFLAGS += -I inc
CFLAGS += -D F_CPU=$(F_CPU)

# required for some examples for STM8S EVAL board
#CFLAGS += -DUSE_STM8_128_EVAL

# set output folder and target name
OUTPUT_DIR = ./build-$(DEVICE)
TARGET     = $(OUTPUT_DIR)/out

# set project folder and files (all *.c)
PRJ_ROOT    = .
PRJ_SRC_DIR = $(PRJ_ROOT)/src
PRJ_INC_DIR = $(PRJ_ROOT)/inc
# all project sources included by default
PRJ_SOURCE  = $(notdir $(wildcard $(PRJ_SRC_DIR)/*.c))
PRJ_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(PRJ_SOURCE:.c=.rel))
PRJ_INCS  = $(wildcard $(PRJ_INC_DIR)/*.h)
PRJ_ASSMS := $(addprefix $(OUTPUT_DIR)/, $(PRJ_SOURCE:.c=.asm))
PRJ_ASSRM := $(addprefix $(OUTPUT_DIR)/, $(PRJ_SOURCE:.c=.asmrm))

# set SPL paths
#SPL_SRC_DIR = /usr/local/lib/stm8/src/
#SPL_INC_DIR = /usr/local/lib/stm8/inc/
#SPL_SRC_DIR = ../SPL/src/
#SPL_INC_DIR = ../SPL/inc/
SPL_SRC_DIR = ../SPL-$(DEVICE)/src/
SPL_INC_DIR = ../SPL-$(DEVICE)/inc/
# add all library sources used here singly ... or all .c files in SPL src dir
SPL_SOURCE  = stm8s_gpio.c stm8s_clk.c stm8s_tim4.c stm8s_itc.c 
SPL_SOURCE += stm8s_uart1.c
#SPL_SOURCE += stm8s_adc2.c
#SPL_SOURCE += stm8s_tim1.c
#SPL_SOURCE += stm8s_tim2.c
#SPL_SOURCE += stm8s_tim3.c
#SPL_SOURCE  = $(notdir $(wildcard $(SPL_SRC_DIR)/*.c))
SPL_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(SPL_SOURCE:.c=.rel))
SPL_ASSMS := $(addprefix $(OUTPUT_DIR)/, $(SPL_SOURCE:.c=.asm))
SPL_ASSRM := $(addprefix $(OUTPUT_DIR)/, $(SPL_SOURCE:.c=.asmrm))

# collect all include folders
INCLUDE = -I$(PRJ_INC_DIR) -I$(SPL_INC_DIR) 

# collect all source directories
VPATH=$(PRJ_SRC_DIR):$(SPL_SRC_DIR)


ihx:: $(TARGET).ihx

$(TARGET).ihx: $(PRJ_ASSMS) $(SPL_ASSMS)
	.make/asm2obj $^	
	$(CC) $(CFLAGS) -o $(TARGET).ihx $(PRJ_OBJECTS) $(SPL_OBJECTS)
	$(LN) $@ ./out.ihx
	@echo 
	@echo MemSize:
	@$(PYTHON) .make/sizecal.py ./out.ihx
	@echo 


$(OUTPUT_DIR)/%.asm: %.c Makefile $(PRJ_INCS) | $(OUTPUT_DIR)
	$(CC) $(CFLAGS) -D$(DEVICE) $(INCLUDE) -DSKIP_TRAPS=$(SKIP_TRAPS) -c $< -o $@

$(OUTPUT_DIR):
	$(MKDIR) -p $(OUTPUT_DIR)

clean::
	rm -f ./out.ihx
	rm -f ./out.elf
	rm -Rf $(OUTPUT_DIR)

flash: $(TARGET).ihx
	$(STVP) -BoardName=ST-LINK -Device=STM8S103F3 -Port=USB -ProgMode=SWIM -no_loop -no_log -FileProg=$(TARGET).ihx
	#$(OPENOCD) -c "init" -c "program_device $(TARGET).ihx 0"

flash2: $(TARGET).ihx
	stm8flash -c $(STLINK) -p $(DEVICE_FLASH) -s flash -w $(TARGET).ihx

rebuild::
	make clean
	make ihx

reflash::
	make clean
	make flash

openocd::
	$(OPENOCD) -c "init" -c "reset halt"
debug: $(TARGET).elf
	stm8-gdb --tui $^


switch-sdcc-gas::
	$(LN) .make/Makefile-sdcc-gas Makefile || $(CP) .make/Makefile-sdcc-gas Makefile

spl::
	bash .make/spl.sh

.PHONY: clean
