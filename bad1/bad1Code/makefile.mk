#==============================================================================
# bad1/bad1Code/makefile by Alex Chadwick
#
# Generates bad1Code.bin, an injected code which enables the ctgp-r
#==============================================================================
.PHONY: bad1Code

bad1Code: $(BUILD)/bad1code.o

$(BUILD)/bad1code.o: $(BAD1)/bad1Code/main.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

