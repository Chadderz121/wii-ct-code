_methodLoadBad0Data:
    #method start
    stwu r1,-16(r1)
    mflr r0
    stw r0,20(r1)

    #load address
    lwz r3,20(r3)

    #load tag
    lwz r4,0(r3)

    #load 0xBad0Da7a
    lis r5,0xbad0
    ori r5,r5,0xda7a

    #check correct
    cmpw r4,r5
    beq- _methodLoadBad0DataTagCorrect
    li r3,0
    b _methodLoadBad0DataReturn

_methodLoadBad0DataTagCorrect:

    #load version number
    lwz r4,8(r3)

    #check correct
    cmpwi r4,0
    beq- _methodLoadBad0DataReturn
    li r3,0 

_methodLoadBad0DataReturn:
    #method end
    lwz r0,20(r1)
    mtlr r0
    addi r1,r1,16
    blr
