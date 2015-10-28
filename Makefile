#==============================================================================
# makefile by Alex Chadwick
# 'SZSTOOLSDIR' extention by Dirk Clemens (Wiimm)
#
# makefile script for the CTGP-R Mario Kart Wii modification software.
#==============================================================================

#==============================================================================
# Settings
#==============================================================================

ONLINE_REGION ?= 255
ENABLE_CTWW ?= 1
ENABLE_FILTER ?= 1
ENABLE_BSHELL ?= 1
ENABLE_SOM ?= 1
ENABLE_CTS ?= 1

#==============================================================================
# Programs
#==============================================================================
ifneq ($(strip $(DEVKITPPC)),)
PATH := $(DEVKITPPC)/bin:$(PORTLIBS)/bin:$(PATH)
endif

PREFIX ?= powerpc-eabi-
AS = $(PREFIX)as
CC = $(PREFIX)gcc
LD = $(PREFIX)ld
OD = $(PREFIX)objdump
OC = $(PREFIX)objcopy

Q ?= @
LOG ?= @echo $@

.SECONDARY:

#==============================================================================
# Output configuration
#==============================================================================
region ?= *
BAD0 ?= bad0
BAD1 ?= bad1
TARGETS ?= bad0 bad1

SFLAGS += -mregnames

ifeq ("$(region)","E")
	game = rmce
	TARGETDIR ?= bin/$(game)
	SZSTOOLSDIR ?= szs-tools/$(game)
	BUILD ?= build/$(game)
	BUILD_ALL ?= build
	SFLAGS += --defsym region=U -I $(BUILD)
	ALL = $(BUILD) $(TARGETS)
else ifeq ("$(region)","J")
	game = rmcj
	TARGETDIR ?= bin/$(game)
	SZSTOOLSDIR ?= szs-tools/$(game)
	BUILD ?= build/$(game)
	BUILD_ALL ?= build
	SFLAGS += --defsym region=J -I $(BUILD)
	ALL = $(BUILD) $(TARGETS)
else ifeq ("$(region)","P")
	game = rmcp
	TARGETDIR ?= bin/$(game)
	SZSTOOLSDIR ?= szs-tools/$(game)
	BUILD ?= build/$(game)
	BUILD_ALL ?= build
	SFLAGS += --defsym region=P -I $(BUILD)
	ALL = $(BUILD) $(TARGETS)
else ifeq ("$(region)","*")
	ALL = rmce rmcj rmcp
	# define some dummies to avoid warnings
	TARGETDIR ?= bin/dummy
	SZSTOOLSDIR ?= szs-tools/dummy
else
	$(error 'region' is not 'E', 'J', 'P' or '*')
endif

SETTINGS := GAME=$(game) REGION=$(region) ONLINE_REGION=$(ONLINE_REGION) \
            ENABLE_CTWW=$(ENABLE_CTWW) \
            ENABLE_FILTER=$(ENABLE_FILTER) ENABLE_BSHELL=$(ENABLE_BSHELL) \
            ENABLE_SOM=$(ENABLE_SOM) ENABLE_CTS=$(ENABLE_CTS)
SFLAGS += $(addprefix --defsym ,$(SETTINGS))

#==============================================================================
#==============================================================================
# Rules
#==============================================================================
#==============================================================================
# Overall
#==============================================================================
.PHONY: help all clean allregions rmcp rmce rmcj

help:
	$Qecho "CT-CODE build system."
	$Qecho " by Chadderz"
	$Qecho ""
	$Qecho "make all   - make all files for all regions."
	$Qecho "make rmcp  - make just the files for RMCP (or similar for other regions)."
	$Qecho "make clean - remove all generated files."
	$Qecho ""
	$Qecho "all outputs go into the bin/rmcp/ directory (or similar for other regions)."
	$Qecho "temprorary files go into the build/ directory."

all: $(ALL)

rmce: bin/rmce build/rmce szs-tools/rmce
	$(LOG)
	$Q-make --no-print-directory region=E all
rmcj: bin/rmcj build/rmcj szs-tools/rmcj
	$(LOG)
	$Q-make --no-print-directory region=J all
rmcp: bin/rmcp build/rmcp szs-tools/rmcp
	$(LOG)
	$Q-make --no-print-directory region=P all

bin/rmce bin/rmcj bin/rmcp:
	$(LOG)
	$Q-mkdir -p $@

build/rmce build/rmcj build/rmcp:
	$(LOG)
	$Q-mkdir -p $@

szs-tools/rmce szs-tools/rmcj szs-tools/rmcp:
	$(LOG)
	$Q-mkdir -p $@

clean: 
	$(LOG)
	$Q-rm -rf build bin szs-tools

#==============================================================================
# bad0
#==============================================================================

include $(BAD0)/makefile.mk

#==============================================================================
# bad1
#==============================================================================

include $(BAD1)/makefile.mk
