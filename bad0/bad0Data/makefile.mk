#==============================================================================
# bad0/bad0data/makefile by Alex Chadwick
#
# Generates bad0data.bin, data to be inserted into the main.dol to load 
# ctgpr_code.tex0
#==============================================================================
.PHONY: bad0data

bad0data: $(BUILD)/bad0data.o

$(BUILD)/bad0data.o: $(BAD0)/bad0data/bad0data.s $(BUILD)/mod0.bin
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@
		
include $(BAD0)/bad0data/mod/makefile.mk
