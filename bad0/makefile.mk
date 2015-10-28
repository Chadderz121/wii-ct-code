#==============================================================================
# bad0/makefile by Alex Chadwick
# 'SZSTOOLSDIR' extention by Dirk Clemens (Wiimm)
#
# Generates boot.bin, a code to be inserted into the main.dol to load 
# ctgpr_code.tex0
#==============================================================================
.PHONY: bad0

include $(BAD0)/bad0Code/makefile.mk
include $(BAD0)/bad0Data/makefile.mk

bad0: bad0Code bad0Data $(TARGETDIR)/boot_code.bin $(TARGETDIR)/boot_data.bin \
	$(SZSTOOLSDIR)/boot_code.bin $(SZSTOOLSDIR)/boot_data.bin

$(TARGETDIR)/boot_code.bin: $(BUILD)/bad0.elf
	$(LOG)
	$Q$(OC) -O binary -j .text $< $@

$(TARGETDIR)/boot_data.bin: $(BUILD)/bad0.elf
	$(LOG)
	$Q$(OC) -O binary -j .data $< $@

$(SZSTOOLSDIR)/boot_code.bin: $(TARGETDIR)/boot_code.bin
	$(LOG)
	$Qcp $(TARGETDIR)/boot_code.bin $(SZSTOOLSDIR)/

$(SZSTOOLSDIR)/boot_data.bin: $(TARGETDIR)/boot_data.bin
	$(LOG)
	$Qcp $(TARGETDIR)/boot_data.bin $(SZSTOOLSDIR)/

$(BUILD)/bad0.elf: $(BUILD)/bad0code.o $(BUILD)/bad0data.o $(BUILD)/bad0.ld
	$(LOG)
	$Q$(LD) -L $(BAD0) -T $(BUILD)/bad0.ld $(BUILD)/bad0code.o $(BUILD)/bad0data.o -o $@

$(BUILD)/bad0.ld: $(BAD0)/bad0.ld $(game).ld
	$(LOG)
	$Qcat $^ > $@
