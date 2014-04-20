/* menu.mod
 *  by Chadderz
 *
 * Manipulates the menu such that the last two cups are 'arrows' which can be
 * use to scroll the menu left and right, changing the functionality of all
 * other displayed buttons.
 */

/* Provides the methods:
 *  _ctgpr_wrap_page
 *  _ctgpr_menu_refresh
 *  ctgpr_menu_scroll
 *  _ctgpr_load_raceCupTable_r28_r0
 *  _ctgpr_set_cup_image
 *  _ctgpr_install_scroll
 *  _ctgpr_menu_scroll_0_r31
 *  _ctgpr_scroll_toscreen
 *  _ctgpr_scroll_toscreen_patch_back
 */
MOD_DOL(
    mod1_1,
    0x800031c8,
    .globl _ctgpr_wrap_page;
    _ctgpr_wrap_page:
        lis     r28,cupStart@ha;
        lwz     r26,9172(r3);
        lwz     r27,cupStart@l(r28);
        subf    r26,r27,r26;
        lwz     r27,pageNumber@l(r28);
        rlwinm  r27,r27,1,0,30;

    0:		subf    r26,r27,r26;
            lwz     r27,cupCount@l(r28);
            subf    r26,r27,r26;
            cmpwi   r26,6;
            bge-    0b;

        b       0f;
    .globl _ctgpr_menu_refresh;
    _ctgpr_menu_refresh:
        addi    r3,r31,916;
        b       _ctgpr_menu_scroll_0;
    _ctgpr_menu_scroll_fwd:
        li      r4,1;
        b       _ctgpr_menu_scroll;
    _ctgpr_menu_scroll_bck:
        li      r4,-1;
        b       _ctgpr_menu_scroll;
    _ctgpr_menu_scroll_0:
        li      r4,0;
    _ctgpr_menu_scroll:
        lwz     r3,4(r3);
        li      r8,0;
    .globl ctgpr_menu_scroll;
    ctgpr_menu_scroll:
        stwu    r1,-256(r1);
        stmw    r0,8(r1);
        mflr    r0;
        stw     r0,260(r1);

        /* Load in the important variables. */
        lis     r30,pageNumber@ha;
        lwz     r31,pageNumber@l(r30);
        lwz     r29,cupCount@l(r30);

        /* Change the page number as needed. */
        add     r31,r31,r4;
        stw     r31,pageNumber@l(r30);

        /* Load the address of the button array. */
        lwz     r28,100(r3);
        lwz     r28,0(r28);

        /* Load the address of the texture data. */
        lwz     r27,24(r28);
        lwz     r27,292(r27);
        lwz     r27,152(r27);
        lwz     r27,40(r27);
        lwz     r27,64(r27);
        lwz     r27,0(r27);

        /* Set the left arrow image. */
        li      r3,0;
        lwz     r4,24(r28);
        mr      r5,r27;
        bl      _ctgpr_set_cup_image;

        /* Set the right arrow image. */
        li      r3,1;
        lwz     r4,28(r28);
        mr      r5,r27;
        bl      _ctgpr_set_cup_image;

        /* Deduce the active cup ID. */
        mulli   r31,r31,2;

        /* Loop through 6 displayed buttons. */
        li      r3,6;
        mtctr   r3;

    2:		lwz     r4,0(r28);
    1:		cmpw    r31,r29;
            blt-    1f;
            subf    r31,r29,r31;
            b       1b;
    1:		cmpwi   r31,0;
            bge-    1f;
            add     r31,r31,r29;
            b       1b;
    1:		lwz     r3,cupStart@l(r30);
            cmpwi   r8,0;
            add     r3,r3,r31;
            addis   r5,r27,1;
            beql-   1f;
            bl      _ctgpr_set_cup_image;
            addi    r31,r31,1;
            addi    r28,r28,4;
            bdnz-   2b;

        lwz     r0,260(r1);
        mtlr    r0;
        lwz     r0,8(r1);
        lmw     r2,16(r1);
        addi    r1,r1,256;
        blr;

    0:		cmpwi   r26,0;
            bgelr;
            add     r26,r26,r27;
            b       0b;

        .int 0;

    /* Loads the address of the race cup table into r0 trashing r28.
     *
     * Leaf procedure.
     */
    .globl _ctgpr_load_raceCupTable_r28_r0;
    _ctgpr_load_raceCupTable_r28_r0:
        lis     r28,raceCupTable@ha;
        lwz     r0,raceCupTable@l(r28);
        blr;

    /* Sets the button addressed by r4's image data pointer into the middle
     * of the image data addressed by r5 + r3 * 0x8000. Therefore, since
     * the cup icons are in a tall image each being 0x8000 long, this
     * method selects the icon for the cup ID in r3.
     *
     * EABI Compliant
     */
    .globl _ctgpr_set_cup_image;
    _ctgpr_set_cup_image:
        stwu    r1,-16(r1);
        mflr    r0;
        stw     r0,20(r1);
        mfctr   r0;
        stw     r0,8(r1);

        /* multiply r3 by 0x8000 */
        rlwinm  r3,r3,15,0,16;
        /* offset into image data */
        add     r5,r5,r3;

        /* loop over the three button images (normal, highlight, shadow)
         * changing the resolution to 128x128. */
        li      r3,3;
        mtctr   r3;
        lwz     r3,292(r4);
        addi    r3,r3,152;
        lis     r4,128;
        ori     r4,r4,128;

    0:		lwz     r6,0(r3);
            lwz     r6,40(r6);
            lwz     r6,64(r6);
            stw     r4,8(r6);
            stw     r5,0(r6);
            addi    r3,r3,12;
            bdnz-   0b;

        lwz     r0,20(r1);
        mtlr    r0;
        lwz     r0,8(r1);
        mtctr   r0;
        addi    r1,r1,16;
        /* lol, oops, this symbol wasn't supposed to overlap the blr!
         * should be .int 0, .int 0 then the methods. */
    _ctgpr_scroll_vtable:
        blr;

        .int 0;
        .int _ctgpr_menu_scroll_fwd;
        .int _ctgpr_menu_scroll_bck;
    /* mod1_4 0x80003380 */
    .globl _ctgpr_install_scroll;
    _ctgpr_install_scroll:
        lis     r4,_ctgpr_scroll_vtable@h;
        ori     r4,r4,_ctgpr_scroll_vtable@l;
        stw     r4,6820(r3);
        addi    r4,r4,4;
        stw     r4,6224(r3);
        b       _ctgpr_scoll_patch;
    1:	stw     r3,576(r4);
        li      r6,1;
        stw     r6,484(r4);
        blr;

    .globl _ctgpr_menu_scroll_0_r31;
    _ctgpr_menu_scroll_0_r31:
        addi    r3,r31,372;
        li      r4,0;
        li      r8,1;
        b       ctgpr_menu_scroll;

    /* 33b8 */
    .globl _ctgpr_scroll_toscreen;
    _ctgpr_scroll_toscreen:
        lis     r5,cupStart@ha;
        b       _ctgpr_scroll_toscreen_patch;

    .globl _ctgpr_scroll_toscreen_patch_back;
    _ctgpr_scroll_toscreen_patch_back:
        lwz     r4,cupStart@l(r5);
        subf    r31,r4,r31;
        rlwinm  r31,r31,31,1,31;
        lwz     r4,pageNumber@l(r5);
        li      r26,0;

    0:		cmpw    r4,r31;
            beq-    0f;
            addi    r31,r31,-1;
            addi    r26,r26,1;
            cmpwi   r26,3;
            bne-    0b;

        addi    r31,r31,1;
        stw     r31,3576(r5);
    0:	lis     r5,-32629;
        blr;
)
MOD_DOL(
    mod1_2c,
    0x800041d0,
    .globl _ctgpr_scoll_patch;
    _ctgpr_scoll_patch:
        addi    r4,r3,6820;
        stw     r4,6736(r3);
        addi    r4,r3,6224;
        stw     r4,6136(r3);
        blr;
        .int 0x0;
)

/* Installs the scrolling arrow behaviours to the buttons */
MOD_REL(
    mod_install_scroll,
    mod_install_scroll_addr,
        b _ctgpr_install_scroll;
)
MOD_REL(
    mod_menu_refresh,
    mod_menu_refresh_addr,
        b _ctgpr_menu_refresh;
)

MOD_REL(
    mod_onButton,
    mod_onIsActive_addr + 0x94,
        bl onButton;
        beq- mod_onIsActive_addr + 0xcc;
)
MOD_REL(
    mod_onButtonUnhandled,
    mod_onIsActive_addr + 0xcc,
        bl onButtonUnhandled;
)
MOD_REL(
    mod_onScroll,
    mod_onScroll_addr,
        bl onScroll;
)
MOD_REL(
    mod_onScrollTime,
    mod_onScrollTime_addr,
        b onScrollTime;

    .globl onScrollTimeReturn;
    onScrollTimeReturn:
)
MOD_REL(
    mod_onIsActive,
    mod_onIsActive_addr,
        bl onIsActive;
)
MOD_REL(
    mod_ctgpr_scroll_toscreen,
    mod_ctgpr_scroll_toscreen_addr,
        bl _ctgpr_scroll_toscreen;
)
MOD_REL(
    mod_ctgpr_menu_scroll_0_r31,
    mod_ctgpr_menu_scroll_0_r31_addr,
        b _ctgpr_menu_scroll_0_r31;
)
MOD_REL(
    mod_ctgpr_wrap_page,
    mod_ctgpr_wrap_page_addr,
        bl _ctgpr_wrap_page;
)
/* Number of cup buttons */
MOD_REL(
    mod_cup_buttons,
    mod_cup_buttons_addr,
        cmpwi r28,6;
)

/* Makes all custom cups award the special trophy to prevent crashes. */
MOD_REL(
    mod_trophy_brres,
    mod_trophy_brres_addr,
        bgt mod_trophy_brres_addr+0xb8;
)

/* Forgotten what these do. */
MOD_REL(
    mod2_16,
    mod2_16_addr,
        nop;
)
MOD_REL(
    mod2_19,
    mod2_19_addr,
        nop;
)
MOD_REL(
    mod2_22,
    mod2_22_addr,
        li r0,0;
)
MOD_REL(
    mod2_128,
    mod2_128_addr,
        nop;
)
MOD_REL(
    mod2_129,
    mod2_129_addr,
        nop;
)