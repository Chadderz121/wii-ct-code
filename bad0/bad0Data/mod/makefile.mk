WD := $(dir $(lastword $(MAKEFILE_LIST)))

SRC_MOD0 := \
	$(WD)mod0.mod

$(BUILD)/mod0.bin: $(BUILD)/m0d.elf
	$(LOG)
	$Q$(OC) -O binary $< $@

$(BUILD)/m0d.elf: $(BUILD)/m0d.elf.ld $(BUILD)/m0d.data.o $(BUILD)/m0d.text.elf
	$(LOG)
	$Q$(LD) -T $<  $(BUILD)/m0d.data.o $(BUILD)/m0d.text.elf -o $@

$(BUILD)/m0d.elf.ld: $(SRC_MOD0) $(BUILD_ALL)/m0d.elf.ld.inc $(BUILD)/m0d.inc $(game).ld
	$(LOG)
	$Qecho "SECTIONS { .data : { *(.data); }" > $@
	$Qcat $(BUILD_ALL)/m0d.elf.ld.inc $(BUILD)/m0d.inc $(SRC_MOD0) \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD0)/bad0Data/mod - >> $@
	$Qecho "mod_end = .; /DISCARD/ : { *(*); } }" >> $@
	$Qcat $(game).ld >> $@

$(BUILD_ALL)/m0d.elf.ld.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) . = ALIGN(4); .rodata.id : { id ## _start = .; *(.text.id); id ## _size = ABSOLUTE(. - id ## _start); }" > $@

$(BUILD)/m0d.data.o: $(BUILD)/m0d.data.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

$(BUILD)/m0d.data.s: $(BUILD)/m0d.data.i
	$(LOG)
	$Qcat $< \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD0)/bad0Data/mod - \
	| sed "s/;/\n/g" > $@

$(BUILD)/m0d.data.i: $(SRC_MOD0) $(BUILD_ALL)/m0d.data.o.inc $(BUILD)/m0d.inc
	$(LOG)
	$Qcat $(BUILD_ALL)/m0d.data.o.inc $(BUILD)/m0d.inc > $@
	$Qecho ".section .data; .ascii \"MOD0\"; .int mod_end; .int 0; .int ( table_end - table_start ) / 16; .int 0; .int 0; .int 0; .int 0; table_start:" >> $@
	$Qcat $(SRC_MOD0) >> $@
	$Qecho "table_end:" >> $@

$(BUILD_ALL)/m0d.data.o.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) .int addr; .int id ## _start; .int id ## _size; .int 0" > $@

$(BUILD)/m0d.text.elf: $(BUILD)/m0d.text.elf.ld $(BUILD)/m0d.text.o
	$(LOG)
	$Q$(LD) -T $<  $(BUILD)/m0d.text.o -o $@

$(BUILD)/m0d.text.elf.ld: $(SRC_MOD0) $(BUILD_ALL)/m0d.text.elf.ld.inc $(BUILD)/m0d_all.inc $(game).ld
	$(LOG)
	$Qecho "SECTIONS {" > $@
	$Qcat $(BUILD_ALL)/m0d.text.elf.ld.inc $(BUILD)/m0d_all.inc $(SRC_MOD0) \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD0)/bad0Data/mod - >> $@
	$Qecho "}" >> $@
	$Qcat $(game).ld >> $@

$(BUILD_ALL)/m0d.text.elf.ld.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) .text.id addr : { *(.text.id); }" > $@

$(BUILD)/m0d.text.o: $(BUILD)/m0d.text.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

$(BUILD)/m0d.text.s: $(BUILD)/m0d.text.i
	$(LOG)
	$Qcat $< \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD0)/bad0Data/mod - \
	| sed "s/;/\n/g" > $@

$(BUILD)/m0d.text.i: $(SRC_MOD0) $(BUILD_ALL)/m0d.text.o.inc $(BUILD)/m0d.inc
	$(LOG)
	$Qcat $(BUILD_ALL)/m0d.text.o.inc $(BUILD)/m0d.inc > $@
	$Qcat $(SRC_MOD0) >> $@

$(BUILD_ALL)/m0d.text.o.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) .section .text.id; __VA_ARGS__" > $@
	
$(BUILD)/m0d_all.inc:
	$(LOG)
	$Qecho "#define MOD_DOL(id, addr, ...) MOD(id, addr, ## __VA_ARGS__)" > $@

$(BUILD)/m0d.inc:
	$(LOG)
	$Qecho "#define MOD_DOL(id, addr, ...) MOD(id, addr, ## __VA_ARGS__)" > $@
