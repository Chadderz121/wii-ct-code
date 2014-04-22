_methodRunMod0:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #store bad0Data address
    mr r31,r3

    #call findDataSection
    lis r4,0x4d4f       #MO
    ori r4,r4,0x4430    #D0
    li r5,0

    bl _methodFindDataSection
    bl _methodCheckCanProceed

    #store mod0 adddress
    mr r30,r3

    #load mod count
    lwz r4,12(r30)
    mtctr r4

    #set up loop location
    addi r29,r30,16

_methodRunMod0ModLoopStart:
    #load mod information
    lwzu r3,16(r29)     #address
    lwz r4,4(r29)       #offset
    lwz r5,8(r29)       #length

    #make absoulte
    add r4,r4,r30

    #call memcpy
    lis r12,memcpy@h
    ori r12,r12,memcpy@l
    mtlr r12
    blrl

    #loop
    bdnz- _methodRunMod0ModLoopStart

    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr
