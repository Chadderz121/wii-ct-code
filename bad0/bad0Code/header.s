#Write Header
.int 0xBAD0C0DE			#tag
.int _end - _start		#length
.int 0					#version
.int _entryPoint		#entry point
.int _start				#address
.int _bad0data			#bad0Data address
.int 0					#pad
.int 0					#pad
