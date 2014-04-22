_methodRunOvr1:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #store bad1Data address
    mr r31,r3

    #call findDataSection
    lis r4,0x4F56       #OV
    ori r4,r4,0x5231    #R1
    li r5,0

    bl _methodFindDataSection
    bl _methodCheckCanProceed

    #store ovr1 adddress
    mr r30,r3

    #malloc a region to store ovr1
    lis r29,malloc@ha
    addi r29,r29,malloc@l
    lis r5,defaultHeap@ha
    addi r5,r5,defaultHeap@l
    li  r4,4
    lwz r3,4(r30)
    mtctr r29
    bctrl 
    mr r20,r3
    
    #Copy the actual data
    mr r3,r20           #address
    addi r4,r30,16      #offset
    lwz r5,4(r30)       #length

    #call memcpy
    lis r12,memcpy@ha
    addi r12,r12,memcpy@l
    mtlr r12
    blrl

    #mod mod2!
    mr r3,r31
    lis r4,0x4D4F       #MO
    ori r4,r4,0x4432    #D2
    li r5,0

    bl _methodFindDataSection
    bl _methodCheckCanProceed

    #store mod2 address
    mr r29,r3

    #address of branches
    lwz r3,0x24(r29)
    add r3,r3,r29

    #offset to data
    subis r4,r20,0x8000
    lwz r5,0(r3)
    lwz r6,8(r30)
    add r6,r6,r4
    add r5,r5,r6
    stw r5,0(r3)

    lwz r5,4(r3)
    lwz r6,12(r30)
    add r6,r6,r4
    add r5,r5,r6
    stw r5,4(r3)

    li r3,1
    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr
