.section .data
.globl _bad0data
_bad0data:

#Write Header
.int 0xBad0Da7a					#tag
.int _bad0DataEnd - _bad0data	#length
.int 0							#version
.int 1							#section count
.int _bad0data					#bad0data address
.int 0							#padding
.int 0							#padding
.int 0							#padding

#Write contents
.int _mod0Start-_bad0data
.ascii "MOD0"


.p2align 5
_mod0Start:
.incbin "mod0.bin"
.p2align 4

_bad0DataEnd:
