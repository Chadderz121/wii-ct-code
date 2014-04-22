.include "bad1/bad1Code/methods/checkCanProceed.s"
.include "bad1/bad1Code/methods/loadBad1Code.s"
.include "bad1/bad1Code/methods/loadBad1Data.s"
.include "bad1/bad1Code/methods/runBad1Data.s"

.globl _start
_entryPoint:
_start:
_methodMain:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #get the current location
    bl _methodMainLocationGet
_methodMainLocationGet:
    mflr r12
    subi r3,r12,_methodMainLocationGet - _bad1start

    #call loadBad1Code
    bl _methodLoadBad1Code
    bl _methodCheckCanProceedMain

    #store bad1Code location
    mr r31,r3

    #call loadBad1Data
    bl _methodLoadBad1Data
    bl _methodCheckCanProceedMain

    #store bad1Data location
    mr r30,r3

    #call runBad1Data
    bl _methodRunBad1Data
    bl _methodCheckCanProceedMain

    #set image to success
    lwz r3,276(r1)
    lwz r4,0x18(r31)
    add r3,r3,r4
    stw r3,276(r1)

    #return 1
    li r3,1

    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr
