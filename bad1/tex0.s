.section .data
.org 0
.globl _start
_start:
.include "bad1/tex0/imageHeader.s"

.incbin "bad1.bin"

.p2align 5

.space 0x87640-0x21d80 - (. - _start)
_bad1End:
.incbin "bad1/tex0/imageData.bin"
_fileEnd:
