#==============================================================================
# bad1/bad1data/crs1/makefile by Alex Chadwick
#
# Generates crs1.bin, the course table
#==============================================================================

$(BUILD)/crs1.bin: $(BAD1)/bad1data/crs1/crs1.bin
	$(LOG)
	$Qcp $< $@
