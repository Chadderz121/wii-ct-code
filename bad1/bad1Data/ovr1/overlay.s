# =============================================================================
#  Overlay.s
#   by Chadderz
#   Version 0.3 (2012-09-21)
# =============================================================================
#  Writes arbitrary images to the screen in wii games
#  Changelog
#	v0.3 (2012-09-21): Updated to fix 480p
#   v0.2 (2012-03-20): Added drawNumber
#   v0.1 (2012-03-18): Initial
# =============================================================================
#  Usage: Branch at 0x8016eab0 (the stwu command of the gx_draw method) 
#   replacing with an absolute branch to the start of the code, and then 
#   modifying gx_draw+4 to be the line after said stwu.
# 
#  Calls methodDraw for desired rendering desired rendering.
# =============================================================================
#  Tweakables

# Set this to the offset of the stwu command replaced
.set replacedStackSize,16

# =============================================================================
#  main()
#   main method to run for everutjomg
# =============================================================================

# Save all regs, just to be sure!
.set stackSize,128
.set regDumps,3

.globl _start
_start:
stwu r1,-stackSize(r1)
stmw regDumps,8(r1)
mflr r31
stw r31,stackSize+4(r1)

# Compute the screen info
.set screenWidth,31
.set screenHeight,30
.set screenAddress,29
.set viPtr,28

# Pointer to the VI data
lis viPtr,0xCC00
ori viPtr,viPtr,0x2000

# Address of the frame buffer
lwz screenAddress,0x1c(viPtr)
andis. r31,screenAddress,0x1000
beq- 0f
slwi screenAddress,screenAddress,5
0:
addis screenAddress,screenAddress,0x8000


# Height of screen
lbz screenWidth,0x0(viPtr)
slwi screenWidth,screenWidth,5
lbz screenHeight,0x1(viPtr)
srwi screenHeight,screenHeight,3
or screenHeight,screenHeight,screenWidth
andi. screenHeight,screenHeight,0x7fe

# Width of the screen
lbz screenWidth,0x49(viPtr)
slwi screenWidth,screenWidth,3

cmpw screenWidth, screenHeight
bgel methodDraw

slwi screenWidth,screenWidth,1
srwi screenHeight,screenHeight,1

# Do the render
bl methodDraw

# Stack cleanup 
lwz r31,stackSize+4(r1)
mtlr r31
lis r31,(gx_draw+4)@ha
addi r31,r31,(gx_draw+4)@l
mtctr r31
lmw regDumps,8(r1)
addi r1,r1,stackSize

stwu r1,-replacedStackSize(r1)
bctr

# =============================================================================
#  Function library
#   Use the functions below to achieve drawing!
# =============================================================================
#  PixelCopy(r3=pixelSrc, r4=pixelDest)
#   Copies two BGRA (that order) pixels to a yuyv pixel pair.
# =============================================================================
.set pixelSrc,27
.set pixelDest,28
.set pixelAOffset,0
.set pixelROffset,24
.set pixelGOffset,16
.set pixelBOffset,8

methodPixelCopy:
stwu r1,-128(r1)
stmw r3,8(r1)
mr pixelSrc,r3
mflr r3
stw r3,132(r1)
mr pixelDest,r4

# Read in two pixels
.set pixel1,26
.set pixel2,25
.set yuyv,24
.set y1,23
.set y2,22
.set u,21
.set v,20

lwz pixel1,0(pixelSrc)
lwz pixel2,4(pixelSrc)

andi. r3,pixel1,0xff
bne- 0f
andi. r3,pixel2,0xff
bne- 0f
b methodPixelCopyEnd
0:

lwz yuyv,0(pixelDest)
rlwinm y1,yuyv,8,24,31
rlwinm y2,yuyv,24,24,31
rlwinm u,yuyv,16,24,31
rlwinm v,yuyv,0,24,31

subi y1,y1,16
subi y2,y2,16
subi u,u,128
subi v,v,128

andi. r3,pixel1,0xff
cmpwi r3,0xff
beq- methodPixelCopyPixel1NoAlpha

# Perform alpha blend!
# Compute screen rgb
.set pixelR,19
.set pixelG,18
.set pixelB,17
.set reg1000,16

li reg1000,1000
mulli pixelR,v,1596
mulli r3,y1,1164
add pixelR,pixelR,r3
divw pixelR,pixelR,reg1000
cmpwi pixelR,255
blt- 0f
li pixelR,255
0:
cmpwi pixelR,0
bge- 0f
li pixelR,0
0:

mulli pixelG,v,-813
mulli pixelB,u,-392
mulli r3,y1,1164
add pixelG,pixelG,pixelB
add pixelG,pixelG,r3
divw pixelG,pixelG,reg1000
cmpwi pixelG,255
blt- 0f
li pixelG,255
0:
cmpwi pixelG,0
bge- 0f
li pixelG,0
0:

mulli pixelB,u,2017
mulli r3,y1,1164
add pixelB,pixelB,r3
divw pixelB,pixelB,reg1000
cmpwi pixelB,255
blt- 0f
li pixelB,255
0:
cmpwi pixelB,0
bge- 0f
li pixelB,0
0:

# Deduce blend factor
.set reg255,16
li reg255,255
rlwinm r3,pixel1,pixelAOffset,24,31
sub r4,reg255,r3
mullw pixelR,pixelR,r4
mullw pixelG,pixelG,r4
mullw pixelB,pixelB,r4
rlwinm r4,pixel1, pixelROffset,24,31
mullw r4,r3,r4
add pixelR,pixelR,r4
rlwinm r4,pixel1, pixelGOffset,24,31
mullw r4,r3,r4
add pixelG,pixelG,r4
rlwinm r4,pixel1, pixelBOffset,24,31
mullw r4,r3,r4
add pixelB,pixelB,r4
divw pixelR,pixelR,reg255
divw pixelG,pixelG,reg255
divw pixelB,pixelB,reg255

slwi pixelB,pixelB,24
slwi pixelG,pixelG,16
slwi pixelR,pixelR,8
or pixel1,pixelR,pixelG
or pixel1,pixel1,pixelB

methodPixelCopyPixel1NoAlpha:

andi. r3,pixel2,0xff
cmpwi r3,0xff
beq- methodPixelCopyPixel2NoAlpha

# Perform alpha blend!
# Compute screen rgb
.set pixelR,19
.set pixelG,18
.set pixelB,17
.set reg1000,16

li reg1000,1000
mulli pixelR,v,1596
mulli r3,y2,1164
add pixelR,pixelR,r3
divw pixelR,pixelR,reg1000
cmpwi pixelR,255
blt- 0f
li pixelR,255
0:
cmpwi pixelR,0
bge- 0f
li pixelR,0
0:

mulli pixelG,v,-813
mulli pixelB,u,-392
mulli r3,y2,1164
add pixelG,pixelG,pixelB
add pixelG,pixelG,r3
divw pixelG,pixelG,reg1000
cmpwi pixelG,255
blt- 0f
li pixelG,255
0:
cmpwi pixelG,0
bge- 0f
li pixelG,0
0:

mulli pixelB,u,2017
mulli r3,y2,1164
add pixelB,pixelB,r3
divw pixelB,pixelB,reg1000
cmpwi pixelB,255
blt- 0f
li pixelB,255
0:
cmpwi pixelB,0
bge- 0f
li pixelB,0
0:

# Deduce blend factor
.set reg255,16
li reg255,255
rlwinm r3,pixel2,pixelAOffset,24,31
sub r4,reg255,r3
mullw pixelR,pixelR,r4
mullw pixelG,pixelG,r4
mullw pixelB,pixelB,r4
rlwinm r4,pixel2,pixelROffset,24,31
mullw r4,r3,r4
add pixelR,pixelR,r4
rlwinm r4,pixel2,pixelGOffset,24,31
mullw r4,r3,r4
add pixelG,pixelG,r4
rlwinm r4,pixel2,pixelBOffset,24,31
mullw r4,r3,r4
add pixelB,pixelB,r4
divw pixelR,pixelR,reg255
divw pixelG,pixelG,reg255
divw pixelB,pixelB,reg255

slwi pixelB,pixelB,24
slwi pixelG,pixelG,16
slwi pixelR,pixelR,8
or pixel2,pixelR,pixelG
or pixel2,pixel2,pixelB

methodPixelCopyPixel2NoAlpha:

# Copy to screen!
.set u1,15
.set u2,14
.set vc1,11
.set vc2,12

rlwinm pixelR,pixel1,pixelROffset,24,31
rlwinm pixelG,pixel1,pixelGOffset,24,31
rlwinm pixelB,pixel1,pixelBOffset,24,31
li reg1000,1000

mulli y1,pixelR,128
mulli r3,pixelG,521
add y1,y1,r3
mulli r3,pixelB,210
add y1,y1,r3
divw y1,y1,reg1000
addi y1,y1,16
cmpwi y1,255
ble- 0f
li y1,255
0:
cmpwi y1,0
bge- 0f
li y1,0
0:

mulli u1,pixelR,-148
mulli r3,pixelG,-291
add u1,u1,r3
mulli r3,pixelB,439
add u1,u1,r3
divw u1,u1,reg1000
addi u1,u1,128
cmpwi u1,255
ble- 0f
li u1,255
0:
cmpwi u1,0
bge- 0f
li u1,0
0:

mulli vc1,pixelR,439
mulli r3,pixelG,-368
add vc1,vc1,r3
mulli r3,pixelB,-71
add vc1,vc1,r3
divw vc1,vc1,reg1000
addi vc1,vc1,128
cmpwi vc1,255
ble- 0f
li vc1,255
0:
cmpwi vc1,0
bge- 0f
li vc1,0
0:

rlwinm pixelR,pixel2,pixelROffset,24,31
rlwinm pixelG,pixel2,pixelGOffset,24,31
rlwinm pixelB,pixel2,pixelBOffset,24,31

mulli y2,pixelR,128
mulli r3,pixelG,521
add y2,y2,r3
mulli r3,pixelB,210
add y2,y2,r3
divw y2,y2,reg1000
addi y2,y2,16
cmpwi y2,255
ble- 0f
li y2,255
0:
cmpwi y2,0
bge- 0f
li y2,0
0:


mulli u2,pixelR,-148
mulli r3,pixelG,-291
add u2,u2,r3
mulli r3,pixelB,439
add u2,u2,r3
divw u2,u2,reg1000
addi u2,u2,128
cmpwi u2,255
ble- 0f
li u2,255
0:
cmpwi u2,0
bge- 0f
li u2,0
0:

mulli vc2,pixelR,439
mulli r3,pixelG,-368
add vc2,vc2,r3
mulli r3,pixelB,-71
add vc2,vc2,r3
divw vc2,vc2,reg1000
addi vc2,vc2,128
cmpwi vc2,255
ble- 0f
li vc2,255
0:
cmpwi vc2,0
bge- 0f
li vc2,0
0:

add u,u1,u2
srawi u,u,1
add v,vc1,vc2
srawi v,v,1

slwi y1,y1,24
slwi u,u,16
slwi y2,y2,8
or y1,y1,u
or y2,y2,v
or yuyv,y1,y2

stw yuyv,0(pixelDest)

methodPixelCopyEnd:

# Stack cleanup
lwz r3,132(r1)
mtlr r3
lmw r3,8(r1)
addi r1,r1,128
blr

# =============================================================================
#  DrawImage(r3=x, r4=y, r5=imageWidth, r6=imageHeight, r7=imagePtr, 
#       screenWidth, screenHeight, screenAddress)
#   Draws an image to the screen.
#   Assmumption: imageWidth and imageHeight are multiples of 2
# =============================================================================
.set x,24
.set y,25
.set imageWidth,26
.set imageHeight,27
.set imagePtr,28

methodDrawImage:
# Stack frame
stwu r1,-128(r1)
stmw r3,8(r1)
mr x,r3
mflr r3
stw r3,132(r1)
mr y,r4
mr imageWidth,r5
mr imageHeight,r6
mr imagePtr,r7

# Pixel copy loop
.set tempX,20
.set tempY,21
.set loopX,22
.set loopY,23


xor loopY,loopY,loopY
methodDrawImageLoopY:
    cmpw loopY,imageHeight
    bge- methodDrawImageLoopYBreak
      
    add tempY,loopY,y
    cmpwi tempY,0
    blt- methodDrawImageLoopYContinue
    cmpw tempY,screenHeight
    bge- methodDrawImageLoopYBreak

   xor loopX,loopX,loopX
   methodDrawImageLoopX:
      cmpw loopX,imageWidth
      bge- methodDrawImageLoopXBreak

      add tempX,loopX,x
      cmpwi tempX,0
      blt- methodDrawImageLoopXContinue
      cmpw tempX,screenWidth
      bge- methodDrawImageLoopXBreak

      mullw r3,loopY,imageWidth
      add r3,r3,loopX
      slwi r3,r3,2
      add r3,r3,imagePtr
      
      mullw r4,tempY,screenWidth
      add r4,r4,tempX
      slwi r4,r4,1
      add r4,r4,screenAddress
      
      bl methodPixelCopy
      
	  methodDrawImageLoopXContinue:
      
      mullw r4,tempY,screenWidth
      add r4,r4,tempX
      slwi r4,r4,1
      add r4,r4,screenAddress

	  andi. r3,r4,0x1f
	  cmpwi r3,0x1c
	  blt- 0f
	  li r3,0
	  dcbst r3,r4
	  0:

      addi loopX,loopX,2
      b methodDrawImageLoopX

   methodDrawImageLoopXBreak:	 
      
   mullw r4,tempY,screenWidth
   add r4,r4,tempX
   slwi r4,r4,1
   add r4,r4,screenAddress
   li r3,0
   dcbst r3,r4
	   
   methodDrawImageLoopYContinue:
   addi loopY,loopY,1
   b methodDrawImageLoopY

methodDrawImageLoopYBreak:


# Stack cleanup
lwz r3,132(r1)
mtlr r3
lmw r3,8(r1)
addi r1,r1,128
blr


# =============================================================================
#  DrawNumber(r3=num, r4=right, r5=top, screenWidth, screenHeight, 
#       screenAddress)
#   Renders a number in the built-in font
# =============================================================================
.set num,28
.set right,27
.set top,26
.set textPtr,25
.set reg10,24
.set charWidth,18
.set charHeight,24

methodDrawNumber:
# Stack frame
stwu r1,-128(r1)
stmw r3,8(r1)
mr num,r3
mflr r3
stw r3,132(r1)
mr right,r4
mr top,r5
bl 0f
.incbin "build/numberfont.bin"
0:
mflr textPtr

cmpwi num,10
blt- 0f
li reg10,10
divwu r3,num,reg10
mullw reg10,r3,reg10
sub num,num,reg10
subi r4,right,charWidth
bl methodDrawNumber

0:
mulli num,num,charWidth*charHeight*4
add r7,textPtr,num
li r5, charWidth
li r6, charHeight
subi r3,right,charWidth
mr r4,top

bl methodDrawImage

# Stack cleanup
lwz r3,132(r1)
mtlr r3
lmw r3,8(r1)
addi r1,r1,128
blr
