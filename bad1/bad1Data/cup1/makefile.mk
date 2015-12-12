#==============================================================================
# bad1/bad1Data/cup1/makefile by Alex Chadwick
#
# Generates cup1.bin, the cup table
#==============================================================================

$(BUILD)/cup1.bin: $(BAD1)/bad1Data/cup1/cup1.bin
	$(LOG)
	$Qcp $< $@
