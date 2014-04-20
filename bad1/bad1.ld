/*=============================================================================
* bad1.ld by Alex Chadwick
*
* Linker script to generate ctgpr_code.tex0,  an injected code which enables 
* the ctgp-r
*============================================================================*/

SECTIONS {
	.data : {
		*(.init)
		*(.text)
		*(.data)
	}
	/DISCARD/ : {
		*(*)
	}
}

ENTRY(_start)