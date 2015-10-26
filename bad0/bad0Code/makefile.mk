#==============================================================================
# bad0/bad0Code/makefile by Alex Chadwick
#
# Generates bad0Code.bin, a code to be inserted into the main.dol to load 
# ctgpr_code.tex0
#==============================================================================
.PHONY: bad0Code

bad0Code: $(BUILD)/bad0code.o

$(BUILD)/bad0code.o: $(BAD0)/bad0Code/main.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@
