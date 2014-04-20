/*=============================================================================
* bad0/bad0.ld by Alex Chadwick
*
* Linker script to generate boot.bin, a code to be inserted into the 
* main.dol to load ctgpr_code.tex0
*============================================================================*/

MEMORY {
	/* The gap in main.dol left for the .bss section. They zero this at the
     * start of the game, so it's safe to put stuff here temporarily. */
	BSS : ORIGIN = 0x802A4080, LENGTH = 0xE50FC
}

SECTIONS {
	.text 0x802A5000 : {
		*(.text)
	} > BSS
	.data 0x802A8000 : {
		*(.data)
	} > BSS
	/DISCARD/ : {
		*(*)
	}
}

ENTRY(_start)