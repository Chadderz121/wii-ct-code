#==============================================================================
# bad1/makefile by Alex Chadwick
# 'szstools1' rule by Dirk Clemens (Wiimm)
#
# Generates ctgpr_code.tex0, an injected code which enables the ctgp-r
#==============================================================================
.PHONY: bad1 

include $(BAD1)/bad1Code/makefile.mk
include $(BAD1)/bad1Data/makefile.mk

bad1: bad1Code bad1Data $(TARGETDIR)/ctgpr_code.tex0 szstools1 

$(TARGETDIR)/ctgpr_code.tex0: $(BUILD)/ctgpr_code.o
	$(LOG)
	$Q$(OC) -O binary $< $@

.PHONY: szstools1
szstools1: $(BUILD)/ctgpr_code.o $(BUILD)/bad1.bin
	$(LOG)
	$Qcp $(BUILD)/{mod1,mod2,ovr1}.bin $(SZSTOOLSDIR)/
	$Qhead -c1824 $(BUILD)/bad1.bin >$(SZSTOOLSDIR)/bad1code.bin
	$Qchmod a-x $(SZSTOOLSDIR)/*.bin

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
