#==============================================================================
# bad1/bad1code/makefile by Alex Chadwick
#
# Generates bad1code.bin, an injected code which enables the ctgp-r
#==============================================================================
.PHONY: bad1code

bad1code: $(BUILD)/bad1code.o

$(BUILD)/bad1code.o: $(BAD1)/bad1code/main.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

