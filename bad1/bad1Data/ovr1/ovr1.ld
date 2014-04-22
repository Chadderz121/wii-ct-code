/*=============================================================================
* ovr1.ld by Alex Chadwick
*
* Linker script to generate ovr1.bin, code injected to make the speedometer on 
* Mario Kart
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