#==============================================================================
# makefile by Alex Chadwick
# 'SZSTOOLSDIR' extention by Dirk Clemens (Wiimm)
#
# makefile script for the CTGP-R Mario Kart Wii modification software.
#==============================================================================

#==============================================================================
# Settings
#==============================================================================

ONLINE_REGION	?= 255
ENABLE_CTWW	?= 1
ENABLE_FILTER	?= 1
ENABLE_BSHELL	?= 1
ENABLE_SOM	?= 1
ENABLE_CTS	?= 1

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
region	?= *
BAD0	?= bad0
BAD1	?= bad1
TARGETS	?= bad0 bad1
GAMES	?= rmce rmcj rmck rmcp

SFLAGS	+= -mregnames

ifeq ("$(region)","E")
	game		:= rmce
	ALL		:= $(BUILD) $(TARGETS)
else ifeq ("$(region)","J")
	game		:= rmcj
	ALL		:= $(BUILD) $(TARGETS)
else ifeq ("$(region)","K")
	game		:= rmck
	ALL		:= $(BUILD) $(TARGETS)
else ifeq ("$(region)","P")
	game		:= rmcp
	ALL		:= $(BUILD) $(TARGETS)
else ifeq ("$(region)","*")
	game		:= dummy
	#ALL		:= $(GAMES)
	ALL		:= rmce rmcj rmcp
else
	$(error 'region' is not 'E', 'J', 'K', 'P' or '*')
endif

TARGETDIR	?= bin/$(game)
SZSTOOLSDIR	?= szs-tools/$(game)
BUILD		?= build/$(game)
BUILD_ALL	?= build
SFLAGS		+= --defsym region=$(region) -I $(BUILD)

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
.PHONY: help all clean allregions rmcp rmce rmck rmcj

help:
	$Qecho "CT-CODE build system."
	$Qecho " by Chadderz & Wiimm"
	$Qecho ""
	$Qecho "make all      : Make all files for all regions (rmce,rmcj,rmcp)."
	$Qecho "make rmc[ejp] : Make just the files for RMC[EJP]."
	$Qecho "make rmck     : Make the files for RMCK (not included in all)."
	$Qecho "make clean    : Remove all generated files."
	$Qecho ""
	$Qecho "All outputs go into the bin/ and szs-tools/ directories."
	$Qecho "Temprorary files go into the build/ directory."

all: $(ALL)

rmce: bin/rmce build/rmce szs-tools/rmce
	$(LOG)
	$Q-make --no-print-directory region=E all

rmcj: bin/rmcj build/rmcj szs-tools/rmcj
	$(LOG)
	$Q-make --no-print-directory region=J all

rmck: bin/rmck build/rmck szs-tools/rmck
	$(LOG)
	$Q-make --no-print-directory region=K all

rmcp: bin/rmcp build/rmcp szs-tools/rmcp
	$(LOG)
	$Q-make --no-print-directory region=P all

#--- create directories

$(GAMES:%=bin/%) : bin
	$(LOG)
	$Q- test -d $@ || mkdir $@

$(GAMES:%=build/%) : build
	$(LOG)
	$Q- test -d $@ || mkdir $@

$(GAMES:%=szs-tools/%) : szs-tools
	$(LOG)
	$Q- test -d $@ || mkdir $@

bin build szs-tools:
	$(LOG)
	$Q-test -d $@ || mkdir $@

#--- clean

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
