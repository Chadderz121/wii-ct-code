#==============================================================================
# bad1/bad1data/makefile by Alex Chadwick
#
# Generates bad1data.bin, injected data which enables the ctgp-r
#==============================================================================
.PHONY: bad1data

bad1data: $(BUILD)/bad1data.o

$(BUILD)/bad1data.o: $(BAD1)/bad1data/bad1data.s $(BUILD)/cup1.bin $(BUILD)/crs1.bin $(BUILD)/mod1.bin $(BUILD)/mod2.bin $(if $(filter $(ENABLE_SOM),1), $(BUILD)/ovr1.bin, )
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

include $(BAD1)/bad1data/crs1/makefile.mk
include $(BAD1)/bad1data/cup1/makefile.mk
include $(BAD1)/bad1data/mod/makefile.mk
include $(BAD1)/bad1data/ovr1/makefile.mk
