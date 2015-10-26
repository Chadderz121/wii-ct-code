#==============================================================================
# bad1/bad1Data/ovr1/makefile by Alex Chadwick
#
# Generates ovr1.bin, code injected to make the speedometer on Mario Kart
#==============================================================================

$(BUILD_ALL)/numberfont.bin: $(BAD1)/bad1Data/ovr1/numberfont.dds
	$(LOG)
	$Qtail --bytes=17280 $< > $@

$(BUILD_ALL)/kmph.bin: $(BAD1)/bad1Data/ovr1/kmph.dds
	$(LOG)
	$Qtail --bytes=2400 $< > $@

$(BUILD)/ovr1.bin: $(BUILD)/ovr1.elf
	$(LOG)
	$Q$(OC) -O binary $< $@

$(BUILD)/ovr1.elf: $(BUILD)/ovr1.o $(BUILD)/ovr1.ld
	$(LOG)
	$Q$(LD) -L $(BAD1)/bad1Data/ovr1 -T $(BUILD)/ovr1.ld $< -o $@

$(BUILD)/ovr1.o: $(BAD1)/bad1Data/ovr1/ctgp_overlay.s $(BUILD_ALL)/numberfont.bin $(BUILD_ALL)/kmph.bin
	$(LOG)
	$Q$(AS) $(SFLAGS) -I $(BAD1)/bad1Data/ovr1/ $< -o $@

$(BUILD)/ovr1.ld: $(BAD1)/bad1Data/ovr1/ovr1.ld $(game).ld
	$(LOG)
	$Qcat $^ > $@