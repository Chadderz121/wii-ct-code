_methodCheckCanProceed:     
    #checks if r3 is 0. If so, it returns.
    #check r3
    cmpwi r3,0

    #branch if necessary
    bne- _methodCheckCanProceedReturn

    #method end
    lwz r0,260(r1)
    mtlr r0
    lwz r0,8(r1)
    lmw r2,16(r1)
    addi r1,r1,256
_methodCheckCanProceedReturn:
    blr
