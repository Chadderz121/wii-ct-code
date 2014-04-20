#==============================================================================
# bad0/bad0code/makefile by Alex Chadwick
#
# Generates bad0code.bin, a code to be inserted into the main.dol to load 
# ctgpr_code.tex0
#==============================================================================
.PHONY: bad0code

bad0code: $(BUILD)/bad0code.o

$(BUILD)/bad0code.o: $(BAD0)/bad0code/main.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@
