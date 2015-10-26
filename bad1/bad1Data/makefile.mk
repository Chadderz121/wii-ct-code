#==============================================================================
# bad1/bad1Data/makefile by Alex Chadwick
#
# Generates bad1Data.bin, injected data which enables the ctgp-r
#==============================================================================
.PHONY: bad1Data

bad1Data: $(BUILD)/bad1data.o

$(BUILD)/bad1data.o: $(BAD1)/bad1Data/bad1data.s \
        $(if $(filter $(ENABLE_CTS),1),$(BUILD)/cup1.bin $(BUILD)/crs1.bin, ) \
        $(BUILD)/mod1.bin $(BUILD)/mod2.bin \
        $(if $(filter $(ENABLE_SOM),1), $(BUILD)/ovr1.bin, )
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

include $(BAD1)/bad1Data/crs1/makefile.mk
include $(BAD1)/bad1Data/cup1/makefile.mk
include $(BAD1)/bad1Data/mod/makefile.mk
include $(BAD1)/bad1Data/ovr1/makefile.mk
