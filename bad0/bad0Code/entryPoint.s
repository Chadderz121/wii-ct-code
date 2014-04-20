_entryPoint:
	#call reset regs
	lis r3,initRegs@ha
	addi r3,r3,initRegs@l
	mtlr r3
	blrl					

	#call main
	bl _methodMain				

	#call main for mkwii
	lis r3,main@ha
	addi r3,r3,main@l
	mtlr r3
	blrl	
