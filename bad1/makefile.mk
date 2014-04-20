#==============================================================================
# bad1/makefile by Alex Chadwick
#
# Generates ctgpr_code.tex0, an injected code which enables the ctgp-r
#==============================================================================
.PHONY: bad1

include $(BAD1)/bad1code/makefile.mk
include $(BAD1)/bad1data/makefile.mk

bad1: bad1code bad1data $(TARGETDIR)/ctgpr_code.tex0

$(TARGETDIR)/ctgpr_code.tex0: $(BUILD)/ctgpr_code.o
	$(LOG)
	$Q$(OC) -O binary $< $@
	
$(BUILD)/ctgpr_code.o: $(BAD1)/tex0.s $(BUILD)/bad1.bin
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

$(BUILD)/bad1.bin: $(BUILD)/bad1.elf
	$(LOG)
	$Q$(OC) -O binary $< $@	

$(BUILD)/bad1.elf: $(BUILD)/bad1code.o $(BUILD)/bad1data.o $(BUILD)/bad1.ld
	$(LOG)
	$Q$(LD) -L $(BAD1) -T $(BUILD)/bad1.ld $(BUILD)/bad1code.o $(BUILD)/bad1data.o -o $@

$(BUILD)/bad1.ld: $(BAD1)/bad1.ld $(game).ld
	$(LOG)
	$Qcat $^ > $@