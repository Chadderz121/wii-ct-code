.include "bad0/bad0Code/methods/checkCanProceed.s"
.include "bad0/bad0Code/methods/regionCheck.s"
.include "bad0/bad0Code/methods/loadBad0Code.s"
.include "bad0/bad0Code/methods/loadBad0Data.s"
.include "bad0/bad0Code/methods/runBad0Data.s"

_methodMain:
    #method start
    stwu r1,-256(r1)
    stmw r0,8(r1)
    mflr r0
    stw r0,260(r1)

    #call regionCheck
    bl _methodRegionCheck
    bl _methodCheckCanProceed

    #get the current location
    bl _methodMainLocationGet
_methodMainLocationGet:
    mflr r12
    subi r3,r12,_methodMainLocationGet - _start

    #call loadBad0Code
    bl _methodLoadBad0Code
    bl _methodCheckCanProceed

    #store bad0Code location
    mr r31,r3

    #call loadBad0Data
    bl _methodLoadBad0Data
    nop #bl _methodCheckCanProceed

    #store bad0Data location
    mr r30,r3

    #call runBad0Data
    bl _methodRunBad0Data
    bl _methodCheckCanProceed

    #return 1
    li r3,1

    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
    blr
