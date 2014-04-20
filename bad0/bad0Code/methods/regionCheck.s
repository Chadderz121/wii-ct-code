_methodRegionCheck:
	#method start
	stwu r1,-16(r1)
	mflr r0
	stw r0,20(r1)
	
	#load address
	lis r3,0x8000

	#load region letter
	lbz r3,3(r3)

	#comare to Region
	cmpwi r3,game@l

	#set r3 to 0 if not
	beq- _methodRegionCheckReturn
	li r3,0

_methodRegionCheckReturn:
	#method end
	lwz r0,20(r1)
	mtlr r0
	addi r1,r1,16
	blr
