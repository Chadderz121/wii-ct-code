#==============================================================================
# bad0/makefile by Alex Chadwick
#
# Generates boot.bin, a code to be inserted into the main.dol to load 
# ctgpr_code.tex0
#==============================================================================
.PHONY: bad0

include $(BAD0)/bad0code/makefile.mk
include $(BAD0)/bad0data/makefile.mk

bad0: bad0code bad0data $(TARGETDIR)/boot_code.bin $(TARGETDIR)/boot_data.bin

$(TARGETDIR)/boot_code.bin: $(BUILD)/bad0.elf
	$(LOG)
	$Q$(OC) -O binary -j .text $< $@
$(TARGETDIR)/boot_data.bin: $(BUILD)/bad0.elf
	$(LOG)
	$Q$(OC) -O binary -j .data $< $@

$(BUILD)/bad0.elf: $(BUILD)/bad0code.o $(BUILD)/bad0data.o $(BUILD)/bad0.ld
	$(LOG)
	$Q$(LD) -L $(BAD0) -T $(BUILD)/bad0.ld $(BUILD)/bad0code.o $(BUILD)/bad0data.o -o $@

$(BUILD)/bad0.ld: $(BAD0)/bad0.ld $(game).ld
	$(LOG)
	$Qcat $^ > $@
	