_methodRunCrs1:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #store bad1Data address
    mr r31,r3

    #call findDataSection
    lis r4,0x4352       #CR
    ori r4,r4,0x5331    #S1
    li r5,0

    bl _methodFindDataSection
    bl _methodCheckCanProceed

    #store crs1 adddress
    mr r30,r3

    #store key addresses
    addi r27,r30,0x14
    lis r4,raceTrackNameTable@ha
    addi r4,r4,raceTrackNameTable@l
    bl _methodRunCrs1StoreLocationStub

    #load course count
    lwz r4,12(r30)
    mtctr r4

    #set up loop location
    addi r19,r30,64

    #process each course
    _methodRunCrs1CourseLoopStart:
        bl _methodRunCrs1ProcessCourseStub
        addi r19,r19,256
        bdnz- _methodRunCrs1CourseLoopStart

    #store key addresses
    addi r27,r30,0x24
    lis r4,battleTrackNameTable@ha
    addi r4,r4,battleTrackNameTable@l
    bl _methodRunCrs1StoreLocationStub
    
    #load battle course count
    lwz r4,16(r30)
    mtctr r4

    #process each battle course
    _methodRunCrs1BattleCourseLoopStart:
        bl _methodRunCrs1ProcessCourseStub
        addi r19,r19,256
        bdnz- _methodRunCrs1BattleCourseLoopStart

    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr

_methodRunCrs1StoreLocationStub:
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
    subi r21,r21,1

    li r4,4
    mr r5,r26
    lwz r3,8(r27)
    mtctr r29
    bctrl
    mr r22,r3
    stw r22,8(r28)
    subi r22,r22,4

    li r4,4
    mr r5,r26
    lwz r3,12(r27)
    mtctr r29
    bctrl
    mr r23,r3
    stw r23,12(r28)
    subi r23,r23,4

    mtlr r25
    blr

_methodRunCrs1ProcessCourseStub:
    #store cup name address
    addi r4,r21,1
    stwu r4,4(r20)

    #store course name
    addi r4,r19,127
_methodRunCrs1ProcessCourseStubStringCopyLoopStart:
    lbzu r5,1(r4)
    stbu r5,1(r21)
    cmpwi r5,0
    bne- _methodRunCrs1ProcessCourseStubStringCopyLoopStart

    #store course music
    lwz r4,192(r19)
    stwu r4,4(r22)

    #store course slot
    lwz r4,196(r19)
    stwu r4,4(r23)
    blr
