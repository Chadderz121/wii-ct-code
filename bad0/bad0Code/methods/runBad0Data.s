.include "bad0/bad0Code/methods/findDataSection.s"
.include "bad0/bad0Code/methods/runMod0.s"

_methodRunBad0Data:
	#method start
	stwu r1,-256(r1)
	stmw r0,8(r1)
	mflr r0
	stw r0,260(r1)
	
	#store bad0Data address
	mr r31,r3

	#call run mod0
	bl _methodRunMod0
	bl _methodCheckCanProceed

	#method end
	lwz r0,260(r1)
	mtlr r0
	lwz r0,8(r1)
	lmw r2,16(r1)
	addi r1,r1,256
	blr
