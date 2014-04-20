_methodLoadBad0Code:
	#method start
	stwu r1,-16(r1)
	mflr r0
	stw r0,20(r1)
	
	#load tag
	lwz r4,0(r3)

	#load 0xbad0code
	lis r5,0xbad0
	ori r5,r5,0xc0de

	#check correct
	cmpw r4,r5
	beq- _methodLoadBad0CodeTagCorrect
	li r3,0
	b _methodLoadBad0CodeReturn

_methodLoadBad0CodeTagCorrect:
	
	#load version number
	lwz r4,8(r3)

	#check correct
	cmpwi r4,0
	beq- _methodLoadBad0CodeVersionCorrect
	li r3,0
	b _methodLoadBad0CodeReturn
	
_methodLoadBad0CodeVersionCorrect:
	
	#load address
	lwz r4,16(r3)

	#check correct
	cmpw r4,r3
	beq- _methodLoadBad0CodeReturn
	li r3,0

_methodLoadBad0CodeReturn:
	#method end
	lwz r0,20(r1)
	mtlr r0
	addi r1,r1,16
	blr
