#params
#r3: bad0Data addres
#r4: section tag
#r5: version number
#returns
#r3: section address or 0

_methodFindDataSection:
    #method start
    stwu r1,-16(r1)
    mflr r0
    stw r0,20(r1)

    #load section count
    lwz r6,12(r3)
    mtctr r6

    #initialise loop
    addi r6,r3,0x1c

_methodFindDataSectionSectionLoopStart:
    #find tag
    lwzu r7,8(r6)
    cmpw r7,r4
    beq- _methodFindDataSectionSectionLoopEndSuccess
    bdnz- _methodFindDataSectionSectionLoopStart

    #tag not found; error
    b _methodFindDataSectionError

_methodFindDataSectionSectionLoopEndSuccess:
    #goto section; check tag
    lwz r6,-4(r6)
    add r6,r6,r3
    lwz r7,0(r6) 
    cmpw r7,r4
    bne- _methodFindDataSectionError

    #check version
    lwz r7,8(r6) 
    cmpw r7,r5
    bne- _methodFindDataSectionError

    #load success value
    mr r3,r6
    b _methodFindDataSectionReturn

_methodFindDataSectionError:
    li r3,0
_methodFindDataSectionReturn:
    #method end
    lwz r0,20(r1)
    mtlr r0
    addi r1,r1,16
    blr
