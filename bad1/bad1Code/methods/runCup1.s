_methodRunCup1:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #store bad1Data address
    mr r31,r3

    #call findDataSection
    lis r4,0x4355       #CU
    ori r4,r4,0x5031    #P1
    li r5,0

    bl _methodFindDataSection
    bl _methodCheckCanProceed

    #store cup1 adddress
    mr r30,r3

    #store key addresses
    addi r27,r30,0x14
    lis r4,raceCupTable@ha
    addi r4,r4,raceCupTable@l
    bl _methodRunCup1StoreLocationStub

    #load cup count
    lwz r4,12(r30)
    stw r4,-8(r28)
    mtctr r4

    #set up loop location
    addi r19,r30,64

    #process each cup
    _methodRunCup1CupLoopStart:
        bl _methodRunCup1ProcessCupStub
        addi r19,r19,256
        bdnz- _methodRunCup1CupLoopStart

    #store key addresses
    addi r27,r30,0x20
    lis r4,battleCupTable@ha
    addi r4,r4,battleCupTable@l
    bl _methodRunCup1StoreLocationStub

    #load battle cup count
    lwz r4,16(r30)
    mtctr r4

    #process each battle cup
    _methodRunCup1BattleCupLoopStart:
        bl _methodRunCup1ProcessBattleCupStub
        addi r19,r19,256
        bdnz- _methodRunCup1BattleCupLoopStart

    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr

_methodRunCup1StoreLocationStub:
    mflr r25
    lis r29,malloc@ha
    addi r29,r29,malloc@l
    lis r26,defaultHeap@ha
    addi r26,r26,defaultHeap@l
    mr r28,r4

    li r4,4
    mr r5,r26
    lwz r3,0(r27)
    mtctr r29
    bctrl
    mr r20,r3
    stw r20,0(r28)
    subi r20,r20,4

    li r4,4
    mr r5,r26
    lwz r3,4(r27)
    mtctr r29
    bctrl
    mr r21,r3
    stw r21,4(r28)
    subi r21,r21,4

    li r4,4
    mr r5,r26
    lwz r3,8(r27)
    mtctr r29
    bctrl
    mr r22,r3
    stw r22,8(r28)
    subi r22,r22,2

    mtlr r25
    blr

_methodRunCup1ProcessCupStub:
    #store cup name address
    addi r4,r22,2
    stwu r4,4(r21)

    #store cup name
    subi r4,r19,2
_methodRunCup1ProcessCupStubStringCopyLoopStart:
    lhzu r5,2(r4)
    sthu r5,2(r22)
    cmpwi r5,0
    bne- _methodRunCup1ProcessCupStubStringCopyLoopStart

    #store cup courses
    lwz r4,128(r19)
    stwu r4,4(r20)
    lwz r4,132(r19)
    stwu r4,4(r20)
    lwz r4,136(r19)
    stwu r4,4(r20)
    lwz r4,140(r19)
    stwu r4,4(r20)
    blr

_methodRunCup1ProcessBattleCupStub:
    #store cup name address
    addi r4,r22,2
    stwu r4,4(r21)

    #store cup name
    subi r4,r19,2
_methodRunCup1ProcessBattleCupStubStringCopyLoopStart:
    lhzu r5,2(r4)
    sthu r5,2(r22)
    cmpwi r5,0
    bne- _methodRunCup1ProcessBattleCupStubStringCopyLoopStart

    #store cup courses
    lwz r4,128(r19)
    stwu r4,4(r20)
    lwz r4,132(r19)
    stwu r4,4(r20)
    lwz r4,136(r19)
    stwu r4,4(r20)
    lwz r4,140(r19)
    stwu r4,4(r20)
    lwz r4,144(r19)
    stwu r4,4(r20)
    blr
