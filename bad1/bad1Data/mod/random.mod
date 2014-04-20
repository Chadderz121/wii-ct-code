/* random.mod
 *  by Chadderz
 *
 * Manipulates the menu such that pressing start or timing out online randomly
 * selects from the six cups available.
 */


MOD_DOL(
    mod1_9,
    0x80003864,
    /* Finds the address of a panel passed in r3 returned in r3.
     * Returns 0 if panel is not on screen (or cannot be found for any
     * reason).
     *
     * EABI compliant.
     */
    _get_panel_ptr:
        mr r6,r3;
        /* set r4 to the address of the menu structure */
        lis r4,menuData@ha;
        lwz r4,menuData@l(r4);
        lwz r4,0(r4);

        /* set r3 to the n'th menu's address */
    0:	lwz r3,0x378(r4);
        cmpwi r3,0;
        beq 1f;

        /* r5 contains the menu id */
        lwz r5,4(r3);
        cmpw r5,r6;
        beqlr;

        cmpwi r5,0x4e;  /* Ignore the Vote/Random prompt */
        beq 1f;
        cmpwi r5,0x6e;  /* Ignore the cup select */
        beq 1f;
        cmpwi r5,0x6f;  /* Ignore the course select */
        beq 1f;
        cmpwi r5,0x91;  /* Ignore the VR select */
        beq 1f;
        li r3,0;
        blr;

    1:	subi r4,r4,4;
        b 0b;

    /* Called every frame when randomOverride is 1 to orchestrate the
     * randomisation.
     *
     * EABI compliant.
     */
    _ctgpr_random_main:
        stwu r1,-16(r1);
        mflr r0;
        stw r0,20(r1);
        stmw r30,8(r1);

        lis r31,random_enable@ha;
        lbz r3,random_enable@l(r31);
        cmpwi r3,0;
        beq 0f;

        /* Vote/Random screen */
        li r3,0x4e;
        bl _get_panel_ptr;
        cmpwi r3,0;
        beq 8f;

        /* check screen is displayed. */	
        lwz r4,0x8(r3);
        cmpwi r4,4;
        bne 8f;

        /* spam 'A' button on random override */
        lbz r3,random_action@l(r31);
        cmpwi r3,0;
        bgt 1f;

        li r3,2;
        stb r3,random_action@l(r31);
        li r3,1;
        stb r3,random_button@l(r31);
        b 9f;

    1:	subi r3,r3,1;
        stb r3,random_action@l(r31);
        li r4,0;
        stb r4,random_button@l(r31);
        b 9f;

        /* Cup select screen */
    8:	li r3,0x6e;
        bl _get_panel_ptr;
        cmpwi r3,0;
        beq 8f;

        lbz r3,random_action@l(r31);
        cmpwi r3,0;
        bgt 1f;

        /* handle panel appropriately */
        bl _ctgpr_random_panel_6e;

        li r3,2;
        stb r3,random_action@l(r31);
        b 9f;

    1:	subi r3,r3,1;
        stb r3,random_action@l(r31);
        li r4,0;
        stb r4,random_button@l(r31);
        b 9f;

        /* Course select screen */
    8:	li r3,0x6f;
        bl _get_panel_ptr;
        cmpwi r3,0;
        beq 8f;

        mr r30,r3;
        lbz r3,random_action@l(r31);
        cmpwi r3,0;
        bgt 1f;

        /* handle menu appropriately */
        bl _ctgpr_random_panel_6f;

        li r3,2;
        stb r3,random_action@l(r31);
        b 9f;

    1:	subi r3,r3,1;
        stb r3,random_action@l(r31);
        li r4,0;
        stb r4,random_button@l(r31);
        stw r4,0x4c0(r30);
        b 9f;

        /* VR screen */
    8:	li r3,0x91;
        bl _get_panel_ptr;
        cmpwi r3,0;
        beq 8f;

        /* spam 'A' on random override */
        lbz r3,random_action@l(r31);
        cmpwi r3,0;
        bgt 1f;

        li r3,2;
        stb r3,random_action@l(r31);
        li r3,1;
        stb r3,random_button@l(r31);
        b 9f;

    1:	subi r3,r3,1;
        stb r3,random_action@l(r31);
        li r4,0;
        stb r4,random_button@l(r31);
        b 9f;

        /* Not a randomised screen, disable randomiser. */
    8:	li r4,0;
        stb r4,random_enable@l(r31);
        stb r4,random_button@l(r31);

    9:	lmw r30,8(r1);
        lwz r0,20(r1);
        mtlr r0;
        addi r1,r1,16;
        blr;

    /* Disables all cup buttons and the back button on panel 6E, then
     * randomly selects one.
     *
     * EABI Compliant.
     */
    _ctgpr_random_panel_6e:
        stwu r1,-32(r1);
        mflr r0;
        stmw r29,8(r1);
        stw r0,36(r1);

        li r3,0x6e;
        bl _get_panel_ptr;
        cmpwi r3,0;
        lis r30,random_enable@ha;
        bne 1f;

        /* disable the random and exit if the panel isn't on screen. */
        li r4,0;
        stb r4,random_enable@l(r30);
        stb r4,random_button@l(r30);
        b 0f;

        /* Press A on finish */
    1:	lbz r3,random_timeout@l(r30);
        cmpwi r3,1;
        bgt 2f;
        cmpwi r3,0;
        bne 1f;

        /* initialise timeout if it hasn't been. (50) */
        li r3,50;
        stb r3,random_timeout@l(r30);
        b 2f;

    1:	subi r3,r3,1;
        stb r3,random_timeout@l(r30);
        li r4,1;
        stb r4,random_button@l(r30);
        b 0f;

    2:	subi r3,r3,1;
        stb r3,random_timeout@l(r30);
        li r4,0;
        stb r4,random_button@l(r30);

    1:	li r3,0x6e;
        bl _get_panel_ptr;
        mr r31,r3;

        /* Make all buttons unselectable */
        li r4,0;
        stw r4,0x238(r31);
        stw r4,0xa1c + 0*0x254(r31);
        stw r4,0xa1c + 1*0x254(r31);
        stw r4,0xa1c + 2*0x254(r31);
        stw r4,0xa1c + 3*0x254(r31);
        stw r4,0xa1c + 4*0x254(r31);
        stw r4,0xa1c + 5*0x254(r31);
        stw r4,0xa1c + 6*0x254(r31);
        stw r4,0xa1c + 7*0x254(r31);

        /* alternate direction */
        lwz r3,0x4c0(r31);
        cmpwi r3,5;
        beq-    1f;
        li      r3,10;
    1:	xori    r3,r3,15;
        b       _direction_patch;
    _direction_patch_ret:

        /* Make one random button selectable, different from the last
         * one. */
        lbz r29,random_last_cup@l(r30);

    1:	li r3,6;
        bl _ctgpr_rng;
        cmpw r3,r29;
        beq 1b;
        mr r29,r3;
        stb r29,random_last_cup@l(r30);

        /* Pick a cup */
        lis r3,cupCount@ha;
        lwz r3,cupCount@l(r3);
        bl _ctgpr_rng;
        lwz r4,cupStart@l(r30);
        add r3,r3,r4;

        /* set the button's cup. */
        lwz r5,0x1754(r31);
        lwz r5,0x98(r5);
        lwz r5,0x28(r5);
        lwz r5,0x40(r5);
        lwz r5,0(r5);
        addis r5,r5,1;
        mulli r29,r29,0x254;
        add r31,r31,r29;
        stw r3,0xa78(r31);

        lwz r4,cupStart@l(r30);
        sub r4,r3,r4;
        srwi r4,r4,1;
        stw r4,pageNumber@l(r30);

        addi r4,r31,0x838;
        bl _ctgpr_set_cup_image;
        li r3,1;
        stw r3,0xa1c(r31);

    0:	lmw r29,8(r1);
        lwz r0,36(r1);
        mtlr r0;
        addi r1,r1,32;
        blr;


    /* Disables the back button on panel 6F, then randomly moves the cursor
     * down to select a track.
     *
     * EABI Compliant.
     */
    _ctgpr_random_panel_6f:
        stwu r1,-32(r1);
        mflr r0;
        stmw r29,8(r1);
        stw r0,36(r1);

        li r3,0x6f;
        bl _get_panel_ptr;
        cmpwi r3,0;
        lis r30,random_enable@ha;
        bne 1f;

        /* disable random and exit if panel not on screen. */
        li r4,0;
        stb r4,random_enable@l(r30);
        stb r4,random_button@l(r30);
        b 0f;

        /* Press A on finish */
    1:	lbz r3,random_timeout@l(r30);
        cmpwi r3,1;
        bgt 2f;
        cmpwi r3,0;
        bne 1f;

        /* initialise timeout if it hasn't been. (16-48) */
        li r3,32;
        bl _ctgpr_rng;
        addi r3,r3,16;
        stb r3,random_timeout@l(r30);
        b 2f;

    1:	subi r3,r3,1;
        stb r3,random_timeout@l(r30);
        li r4,1;
        stb r4,random_button@l(r30);
        b 0f;

    2:	subi r3,r3,1;
        stb r3,random_timeout@l(r30);
        li r4,0;
        stb r4,random_button@l(r30);

    1:	li r3,0x6f;
        bl _get_panel_ptr;
        mr r31,r3;

        /* Make back button unselectable */
        li r4,0;
        stw r4,0x238(r31);

        /* Alternate direction (left, down) */
        lwz r3,0x4c0(r31);
        cmpwi r3,0;
        bne 1f;
        li r3,4;
    
    1:	xori r3,r3,0x6;
        stw r3,0x4c0(r31);

    0:	lmw r29,8(r1);
        lwz r0,36(r1);
        mtlr r0;
        addi r1,r1,32;
        blr;

    /* Installs the start button behavior to the menus, checks the time
     * limit.
     *
     * EABI Compliant.
     */
    .globl _ctgpr_install_menu;
    _ctgpr_install_menu:
        stwu r1,-16(r1);
        mflr r0;
        stw r0,20(r1);

        /* Install on start button in course select menu */
        li r3,0x6e;
        bl _get_panel_ptr;

        cmpwi r3,0;
        beq 0f;

        lis r4,startBehaviour@ha;
        b _install_patch;
    _install_patch_ret:

        stw r4,0x210(r3);
        stw r4,0x9F4+0*0x254(r3);
        stw r4,0x9F4+1*0x254(r3);
        stw r4,0x9F4+2*0x254(r3);
        stw r4,0x9F4+3*0x254(r3);
        stw r4,0x9F4+4*0x254(r3);
        stw r4,0x9F4+5*0x254(r3);
        stw r4,0x9F4+6*0x254(r3);
        stw r4,0x9F4+7*0x254(r3);

        /* Run when timer expires (or about to anyway) */
    0:	li r3,0x90;
        bl _get_panel_ptr;

        cmpwi r3,0;
        beq 0f;

        lis r5,random_enable@ha;
        lbz r6,random_enable@l(r5);
        cmpwi r6,0;

        bne 1f;

        addi r3,r3,120;
        bl displayTimer;

        li r3,0x90;
        bl _get_panel_ptr;
        lis r5,timelimit@ha;
        b 2f;

    1:	li r6,6;
        stw r6,8(r3);

        /* check time limit. */
    2:	lwz r4,0x6c(r3);
        lwz r6,timelimit@l(r5);
        cmpw r4,r6;
        bgt 0f;

        /* too close to expiring, set to 100.05 and trigger random */
        lwz r4,timeset@l(r5);
        stw r4,0x6c(r3);
        li r3,1;
        stb r3,random_enable@l(r5);

    0:	lwz r0,20(r1);
        mtlr r0;
        addi r1,r1,16;
        blr;

    /* Starts the CTGP-R randomiser.
     *
     * EABI Complaint.
     */
    _ctgpr_trigger_random:
        lis r3,random_enable@ha;
        li r4,1;
        stb r4,random_enable@l(r3);
        blr;

    startBehaviour:
        .int startBehaviour;
        .int 0;
        .int _ctgpr_trigger_random;
    timelimit:
        .float 0.035;
    timeset:
        .float 100.05;

    /* onButton(in out r6 button pushed)
     * Called every time A or B (or equivalent) are pressed on a menu.
     * When the override variable is set, we supply the details.
     * Replaces 0x805F1998 on PAL.
     * Also, alter branch at 0x805F199C to go for 0x805F19D0
     *
     * EABI compliant.
     */
    .globl onButton;
    onButton:
        stwu r1,-128(r1);
        stw r0,8(r1);
        stmw r3,12(r1);
        mflr r0;
        stw r0,132(r1);

        bl _ctgpr_install_menu;

        lis r31,random_enable@ha;
        lbz r30,random_enable@l(r31);
        cmpwi r30,0;

        beq 0f;

        bl _ctgpr_random_main;

        lbz r6,random_button@l(r31);
        stw r6,24(r1);

    0:	lwz r0,132(r1);
        mtlr r0;
        lwz r0,8(r1);
        lmw r3,12(r1);
        addi r1,r1,128;
        cmpwi r6,0;
        blr;

    /* onButtonUnhandled(out r0 was handled)
     * Called every time a button event isn't handled. If in random mode,
     * we treat all inputs as handled to stop user input.
     * Replaces 0x805F19D0 on PAL.
     *
     * EABI compliant.
     */
    .globl onButtonUnhandled;
    onButtonUnhandled:
        lis r3,random_enable@ha;
        lbz r0,random_enable@l(r3);
        blr;

    /* onIsActive(in r16 isActive)
     * Called every time the controller is polled. We stop this behaviour
     * in override mode. The correct behaviour is cmpwi r16,0
     * Replaces 0x805F1904 on PAL. 
     *
     * Leaf procedure: trashes r17, r16
     */
    .globl onIsActive;
    onIsActive:
        lis r17,random_enable@ha;
        lbz r17,random_enable@l(r17);
        cmpwi r17,0;
        beq 0f;
        li r16,0;
    0:	cmpwi r16,0;
        blr;

    /* onScroll(in r4 scroll)
     * Called every time the controller is scrolled. We stop this behaviour
     * in random mode. The correct behaviour is stw r4,52(r31)
     * Replaces 0x805EF940 on PAL. 
     *
     * EABI compliant.
     */
    .globl onScroll;
    onScroll:
        mr r0,r4;
        lis r4,random_enable@ha;
        lbz r4,random_enable@l(r4);
        cmpwi r4,0;
        bnelr;
        stw r0,52(r31);
        blr;

    /* onScrollTime(in r7 time)
     * Called every time scroll is held on the controller. We stop this
     * updating override mode. The correct behaviour is stw r7,4(r10)
     * Replaces 0x805EF104 on PAL. 
     *
     * EABI complaint.
     */
    .globl onScrollTime;
    onScrollTime:
        stwu r1,-16(r1);
        stw r4,8(r1);
        lis r4,random_enable@ha;
        lbz r4,random_enable@l(r4);
        cmpwi r4,0;
        bne 0f;

        stw r7,4(r10);

    0:	lwz r4,8(r1);
        addi r1,r1,16;
        b onScrollTimeReturn;

    /* Generates a random number between 0 inclusive and r3 exclusive
     *
     * EABI compliant.
     */
    .globl _ctgpr_rng;
    _ctgpr_rng:
        lis r4,random_seed@ha;
        lbz r5,random_has_seed@l(r4);

        cmpwi r5,0;
        beq 0f;
        lwz r5,random_seed@l(r4);
        b 1f;

        /* Seed the RNG by reading some numbers in */
    0:	lis r6,0x809c;
    0:		lwzu r7,4(r6);
            add r7,r7,r6;
            xor r5,r5,r7;
            rlwinm r5,r5,3,0,31;
            andis. r7,r6,1;
            beq 0b;
        li r7,1;
        stb r7,random_has_seed@l(r4);

    1:	/* QCRNG params: a=0x3f00, b=1, c=31073 */
        mulli r6,r5,0x3f00;
        mullw r6,r6,r5;
        add r6,r6,r5;
        addi r6,r6,31073;

        stw r6,random_seed@l(r4);
        rlwinm r6,r6,16,16,31;
        divwu r5,r6,r3;
        mullw r5,r5,r3;
        subf r3,r5,r6;
        blr;
)

/* ========== hot fixes =========== */
MOD_DOL(
    mod1_9b,
    0x80003ea4,
    
    /* fix bug where user could maintain control if pressing left/right
     * simultaneously with start. */
    _direction_patch:
        stw     r3,1216(r31);
        li      r3,-1;
        stw     r3,1180(r31);
        stw     r3,1184(r31);
        stw     r3,1188(r31);
        stw     r3,1192(r31);
        b       _direction_patch_ret;

    _install_patch:
        lwz     r5,1156(r3);
        lwz     r5,204(r5);
        stw     r5,3600(r4);
        addi    r4,r4,15596;
        b       _install_patch_ret;
)

/* Starts the randomiser on timeout */
MOD_REL(
    mod_random_enable,
    mod_random_enable_addr,
        lis r3,random_enable@ha;
        li  r0,1;
        stb r0,random_enable@l(r3);
)
MOD_REL(
    mod_timeout,
    mod_timeout_addr,
        b mod_timeout_addr + 0x9c;
)
MOD_REL(
    mod_timeout2,
    mod_timeout2_addr,
        b mod_timeout2_addr + 0xc4;
)
MOD_REL(
    mod_timeout3,
    mod_timeout3_addr,
        blr;
)