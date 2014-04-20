_methodLoadBad1Code:
	#method start
	stwu r1,-16(r1)
	mflr r0
	stw r0,20(r1)
	
	#load tag
	lwz r4,0(r3)

	#load 0xbad1code
	lis r5,0xbad1
	ori r5,r5,0xc0de

	#check correct
	cmpw r4,r5
	beq- _methodLoadBad1CodeTagCorrect
	li r3,0
	b _methodLoadBad1CodeReturn

_methodLoadBad1CodeTagCorrect:
	
	#load version number
	lwz r4,8(r3)

	#check correct
	cmpwi r4,0
	beq- _methodLoadBad1CodeReturn
	li r3,0

_methodLoadBad1CodeReturn:
	#method end
	lwz r0,20(r1)
	mtlr r0
	addi r1,r1,16
	blr
