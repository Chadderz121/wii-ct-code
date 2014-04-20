_methodLoadBad1Data:
	#method start
	stwu r1,-16(r1)
	mflr r0
	stw r0,20(r1)
	
	#load offset
	lwz r4,20(r3)

	#load address
	add r3,r3,r4
	
	#load tag
	lwz r4,0(r3)

	#load 0xbad1Da7a
	lis r5,0xbad1
	ori r5,r5,0xda7a

	#check correct
	cmpw r4,r5
	beq- _methodLoadBad1DataTagCorrect
	li r3,0
	b _methodLoadBad1DataReturn

_methodLoadBad1DataTagCorrect:
	
	#load version number
	lwz r4,8(r3)

	#check correct
	cmpwi r4,0
	beq- _methodLoadBad1DataReturn
	li r3,0	

_methodLoadBad1DataReturn:
	#method end
	lwz r0,20(r1)
	mtlr r0
	addi r1,r1,16
	blr
