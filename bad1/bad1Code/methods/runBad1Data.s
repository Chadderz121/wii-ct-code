.include "bad1/bad1Code/methods/findDataSection.s"
.include "bad1/bad1Code/methods/runCup1.s"
.include "bad1/bad1Code/methods/runCrs1.s"
.include "bad1/bad1Code/methods/runMod1.s"
.include "bad1/bad1Code/methods/runOvr1.s"
.include "bad1/bad1Code/methods/copyMod2.s"

_methodRunBad1Data:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #store bad1Data address
    mr r31,r3

    lis r3,0x8000
    lwz r3,0xcfc(r3)
    cmpwi r3,0
    bne 0f

.if ENABLE_SOM == 1
    #call run ovr1
    mr r3,r31
    bl _methodRunOvr1
    bl _methodCheckCanProceed
.endif

    #call run cup1
    mr r3,r31
    bl _methodRunCup1
    bl _methodCheckCanProceed

    #call run crs1
    mr r3,r31
    bl _methodRunCrs1
    bl _methodCheckCanProceed

    #call copy mod2
    mr r3,r31
    bl _methodCopyMod2
    bl _methodCheckCanProceed

    #call run mod1
    mr r3,r31
    bl _methodRunMod1
    bl _methodCheckCanProceed

0:
    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr
