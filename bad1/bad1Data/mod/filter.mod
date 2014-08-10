/* filter.mod
 *  by Chadderz
 *
 * Causes the cup selection to be filtered when playing online.
 */

#if ENABLE_CTS == 1

MOD_DOL(
    mod1_8,
    0x80003554,
        /* join friend -> logging on, need to determine if WW or region */
    0:  cmpwi   r30,91;
        bne-    0f;
        b       1f;

    .globl _ctgpr_scroll_toscreen_patch;
    _ctgpr_scroll_toscreen_patch:
        lwz     r26,saved_cup@l(r5);
        lwz     r4,raceCupTable@l(r5);
        lmw     r30,cupCount@l(r5);
        subf.   r26,r31,r26;
        ble-    2f;
        cmpw    r26,r30;
        bgt-    2f;
        add     r31,r31,r26;
        nop;
    2:  stw     r31,9172(r3);
        b       _ctgpr_scroll_toscreen_patch_back;

    /* method to detect appropriate cup filter.
     * called directly by patch in the game when character select screen
     * shows. Tail calls the method the game intended to call.
     *
     * EABI compliant.
     */
     .globl _ctgpr_detect_wifi_cup_filter;
     _ctgpr_detect_wifi_cup_filter:
        stwu    r1,-32(r1);
        stmw    r26,8(r1);
        mflr    r0;
        stw     r0,36(r1);

        /* load current menu ID */
        lis     r31,menuData@ha;
        lwz     r31,menuData@l(r31);
        lwz     r31,0(r31);
        addi    r31,r31,24;
        lwz     r30,-24(r31);

        /* WiFi race menu -> probably Bean's character changer, leave
         * filter alone (could be either region or WW) */
        cmpwi   r30,88;
        beq-    2f;

        /* WiFi main -> logging on, need to determine if WW or region */
        cmpwi   r30,85;
        bne-    0b;

        /* check we're on character select. */
    1:  lwz     r30,848(r31);
        lwz     r29,4(r30);
        cmpwi   r29,143;
        bne-    0f;

        /* check if WW */
        lwz     r29,7412(r30);
        andi.   r29,r29,1;
        beq-    1f;

#if ENABLE_FILTER == 1
        bl      _ctgpr_filter_custom_only;
#else
        bl      _ctgpr_filter_all;
#endif
        b       2f;
    1:  bl      _ctgpr_filter_nintendo_only;
        b       2f;

    0:  bl      _ctgpr_filter_all;

    2:  lwz     r0,36(r1);
        mtlr    r0;
        lmw     r26,8(r1);
        addi    r1,r1,32;
        b       detect_wifi_cup_filter_return;

    /* methods for setting cup filtering.
     * _ctgpr_filter_nintendo_only: filter to cups 0-7
     * _ctgpr_filter_all: filter to cups 0-end
     * _ctgpr_filter_custom_only: filter to cups 8-end
     *
     * NOTE: leaf procedures; they trash r28-r30.
     */
    _ctgpr_filter_nintendo_only:
        lis     r30,totalCupCount@ha;
        li      r29,0;
        li      r28,8;
        b       0f;
    _ctgpr_filter_all:
        lis     r30,totalCupCount@ha;
        li      r29,0;
        lwz     r28,totalCupCount@l(r30);
        b       0f;
    _ctgpr_filter_custom_only:
        lis     r30,totalCupCount@ha;
        li      r29,8;
        lwz     r28,totalCupCount@l(r30);
        subf    r28,r29,r28;
    0:
        stw     r29,cupStart@l(r30);
        stw     r28,cupCount@l(r30);
        blr;
)

MOD_REL(
    mod_detect_wifi_cup_filter,
    mod_detect_wifi_cup_filter_addr,
        .int _ctgpr_detect_wifi_cup_filter;
)
MOD_REL(
    mod_default_cup_count,
    cupCount,
        .int 0x8;
)

#endif
