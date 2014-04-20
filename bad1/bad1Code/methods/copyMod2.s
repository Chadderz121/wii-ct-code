_methodCopyMod2:
	#method start
	stwu r1,-256(r1)
	stmw r0,8(r1)
	mflr r0
	stw r0,260(r1)
	
	#store bad1Data address
	mr r31,r3

	#call findDataSection
	lis r4,0x4d4f		#MO
	ori r4,r4,0x4432	#D2
	li r5,0

	bl _methodFindDataSection
	bl _methodCheckCanProceed

	#store mod2 adddress
	mr r30,r3

	#get memory
	lis r29,malloc@ha
	addi r29,r29,malloc@l
	lis r5,defaultHeap@ha
	addi r5,r5,defaultHeap@l
	li r4,4
	lwz r3,4(r30)
	mtctr r29
	bctrl

	#save location
	lis r4,mod2@ha
	stw r3,mod2@l(r4)
		
	#load length
	lwz r5,4(r30)
	mr r4,r30
	lis r12,memcpy@ha
	addi r12,r12,memcpy@l
	mtlr r12
	blrl

	#method end
	lwz r0,260(r1)
	mtlr r0
	lwz r0,8(r1)
	lmw r2,16(r1)
	addi r1,r1,256
	blr
