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

_methodCheckCanProceedMain:		
	#checks if r3 is 0. If so, it returns.
	#check r3
	cmpwi r3,0
	
	#branch if necessary
	bne- _methodCheckCanProceedMainReturn

	#set image to fail
	lwz r3,276(r1)
	lwz r4,0x1c(r31)
	add r3,r3,r4
	stw r3,276(r1)
	
	#method end
	lwz r0,260(r1)
	mtlr r0
	lwz r0,8(r1)
	lmw r2,16(r1)
	addi r1,r1,256
_methodCheckCanProceedMainReturn:
	blr
