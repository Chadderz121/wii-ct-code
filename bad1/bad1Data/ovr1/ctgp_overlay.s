# =============================================================================
#  ctgp_overlay.s
#   by Chadderz
#   Version 0.2 (2012-09-21)
# =============================================================================
#  Constructs a speedometer on mario kart wii
#  Changelog
#   v0.2 (2012-09-21): Updated to work with karts
#   v0.1 (2012-03-20): Initial
# =============================================================================
_overlayStart:
# Header
.ascii "OVR1"
.int _overlayEnd-_overlayStart
.int 0
.int copy-_start

# =============================================================================
#  draw(screenWidth, screenHeight, screenAddress)
#   Alter this method to achieve drawing
# =============================================================================


.include "overlay.s"

methodDraw:
# Stack frame
stwu r1,-16(r1)
mflr r3
stw r3,20(r1)

lis r3,SpeedCounter@ha
lwz r4,SpeedCounter@l(r3)
cmpwi r4,0
ble 1f
cmpwi r4,3
li r4,0
stw r4,0xde8(r3)
bgt 1f

# Drawing here!
bl 0f
.incbin "build/kmph.bin"
0:
mflr r7
subi r3,screenWidth,88
subi r4,screenHeight,48
li r5, 40
li r6, 15
bl methodDrawImage

lis r3,SpeedValue@ha
lwz r3,SpeedValue@l(r3)
subi r4,screenWidth,48
subi r5,screenHeight,72
bl methodDrawNumber

1:

# Stack cleanup
lwz r3,20(r1)
mtlr r3
addi r1,r1,16
blr

# =============================================================================
#  speedo copy
#  bl from 0x807eefac (to +52e0)
# =============================================================================
copy:
lis r15,playerBase@ha
lwz r15,playerBase@l(r15)
lwz r15,32(r15)
mulli r19,r0,4
add r15,r15,r19
lwz r15,0(r15)
lwz r15,16(r15)
lwz r15,16(r15)
lwz r3,playerDataUNK@l(r31)
lis r19,SpeedCounter@ha
lwz r15,36(r15)
stw r15,SpeedFloat@l(r19)
lfs f0,SpeedFloat@l(r19)
fabs f0,f0
li r15,SpeedValue@l
fctiw f0,f0
stfiwx f0,r15,r19
lwz r15,SpeedCounter@l(r19)
cmpwi r15,3
blt 0f
li r15,4
b 1f
0:
li r15,3
1:
stw r15,SpeedCounter@l(r19)
blr

_overlayEnd:
