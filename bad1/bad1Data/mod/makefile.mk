WD := $(dir $(lastword $(MAKEFILE_LIST)))

# NOTE: speedo.mod must come first as the frist two entries of MOD2 must be its
#       entries.
SRC_MOD := \
	$(WD)speedo.mod \
	$(WD)blue_drag.mod \
	$(WD)bmg.mod \
	$(WD)ctww.mod \
	$(WD)demo.mod \
	$(WD)filter.mod \
	$(WD)menu.mod \
	$(WD)mod2.mod \
	$(WD)random.mod \
	$(WD)track_redirect.mod \

$(BUILD)/mod%.bin: $(BUILD)/mod%.elf
	$(LOG)
	$Q$(OC) -O binary $< $@ && chmod a-x $@

$(BUILD)/mod%.elf: $(BUILD)/mod%.elf.ld $(BUILD)/mod%.data.o $(BUILD)/mod.text.elf
	$(LOG)
	$Q$(LD) -T $<  $(BUILD)/mod$*.data.o $(BUILD)/mod.text.elf -o $@ \
		&& chmod a-x $@

$(BUILD)/mod%.elf.ld: $(SRC_MOD) $(BUILD_ALL)/mod.elf.ld.inc $(BUILD)/mod%.inc $(game).ld
	$(LOG)
	$Qecho "SECTIONS { .data : { *(.data); }" > $@
	$Qcat $(BUILD_ALL)/mod.elf.ld.inc $(BUILD)/mod$*.inc $(SRC_MOD) \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD1)/bad1Data/mod - >> $@
	$Qecho "mod_end = .; /DISCARD/ : { *(*); } }" >> $@
	$Qcat $(game).ld >> $@

$(BUILD_ALL)/mod.elf.ld.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) . = ALIGN(4); .rodata.id : { id ## _start = .; *(.text.id); id ## _size = ABSOLUTE(. - id ## _start); }" > $@

$(BUILD)/mod%.data.o: $(BUILD)/mod%.data.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

$(BUILD)/mod%.data.s: $(BUILD)/mod%.data.i
	$(LOG)
	$Qcat $< \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD1)/bad1Data/mod - \
	| sed "s/;/\n/g" > $@

$(BUILD)/mod%.data.i: $(SRC_MOD) $(BUILD_ALL)/mod.data.o.inc $(BUILD)/mod%.inc
	$(LOG)
	$Qcat $(BUILD_ALL)/mod.data.o.inc $(BUILD)/mod$*.inc > $@
	$Qecho ".section .data; .ascii \"MOD$*\"; .int mod_end; .int 0; .int ( table_end - table_start ) / 16; .int 0; .int 0; .int 0; .int 0; table_start:" >> $@
	$Qcat $(SRC_MOD) >> $@
	$Qecho "table_end:" >> $@

$(BUILD_ALL)/mod.data.o.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) .int addr; .int id ## _start; .int id ## _size; .int 0" > $@

$(BUILD)/mod.text.elf: $(BUILD)/mod.text.elf.ld $(BUILD)/mod1.text.o $(BUILD)/mod2.text.o
	$(LOG)
	$Q$(LD) -T $<  $(BUILD)/mod1.text.o $(BUILD)/mod2.text.o -o $@ \
		&& chmod a-x $@

$(BUILD)/mod.text.elf.ld: $(SRC_MOD) $(BUILD_ALL)/mod.text.elf.ld.inc $(BUILD)/mod_all.inc $(game).ld
	$(LOG)
	$Qecho "SECTIONS {" > $@
	$Qcat $(BUILD_ALL)/mod.text.elf.ld.inc $(BUILD)/mod_all.inc $(SRC_MOD) \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD1)/bad1Data/mod - >> $@
	$Qecho "}" >> $@
	$Qcat $(game).ld >> $@

$(BUILD_ALL)/mod.text.elf.ld.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) .text.id addr : { *(.text.id); }" > $@

$(BUILD)/mod%.text.o: $(BUILD)/mod%.text.s
	$(LOG)
	$Q$(AS) $(SFLAGS) $< -o $@

$(BUILD)/mod%.text.s: $(BUILD)/mod%.text.i
	$(LOG)
	$Qcat $< \
	| $(CC) -E -P $(addprefix -D,$(SETTINGS)) -I$(BAD1)/bad1Data/mod - \
	| sed "s/;/\n/g" > $@

$(BUILD)/mod%.text.i: $(SRC_MOD) $(BUILD_ALL)/mod.text.o.inc $(BUILD)/mod%.inc
	$(LOG)
	$Qcat $(BUILD_ALL)/mod.text.o.inc $(BUILD)/mod$*.inc > $@
	$Qcat $(SRC_MOD) >> $@

$(BUILD_ALL)/mod.text.o.inc:
	$(LOG)
	$Qecho "#define MOD(id, addr, ...) .section .text.id; __VA_ARGS__" > $@

$(BUILD)/mod_all.inc:
	$(LOG)
	$Qecho "#define MOD_DOL(id, addr, ...) MOD(id, addr, ## __VA_ARGS__)" > $@
	$Qecho "#define MOD_REL(id, addr, ...) MOD(id, addr, ## __VA_ARGS__)" >> $@

$(BUILD)/mod1.inc:
	$(LOG)
	$Qecho "#define MOD_DOL(id, addr, ...) MOD(id, addr, ## __VA_ARGS__)" > $@
	$Qecho "#define MOD_REL(id, addr, ...) " >> $@

$(BUILD)/mod2.inc:
	$(LOG)
	$Qecho "#define MOD_DOL(id, addr, ...) " > $@
	$Qecho "#define MOD_REL(id, addr, ...) MOD(id, addr, ## __VA_ARGS__)" >> $@
