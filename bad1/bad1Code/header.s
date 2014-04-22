#Write Header
.int 0xBAD1C0DE                         #tag
.int _bad1CodeEnd - _bad1start          #length
.int 0                                  #version
.int _entryPoint - _bad1start   + 0x40  #entry point
.int _bad1start + 0x40                  #address
.int _bad1Data - _bad1start             #bad1Data offset
.int 0x3c2070 - 0x502af0                #success image offset
.int 0x140b70 - 0x502af0                #fail image offset
