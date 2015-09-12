/* track_redirect.mod
 *  by Chadderz
 *
 * The code which causes CT-CODE to be able to load more than 32 tracks.
 * Ideally, this code would be simple; extend the table of track names, songs,
 * etc. Unfortunately the game is hard coded to give certain effects to certain
 * courses (known as slots). Therefore we'd like to be able to patch these ID
 * checks too to give various custom courses the same behaviour as the original
 * tracks, but there are far too many. Therefore we essentially do the
 * opposite: the game genuinely believes it's going to one of the original 32
 * tracks, but we redirect the (handful) of methods that actually deal with the
 * file system, songs, etc, to load from the custom track we want to load.
 */
 
#if ENABLE_CTS == 1

/* these patches redirect the game's cup -> track table to raceCupTable. */
MOD_REL(
    mod_raceCupTable_1,
    mod_raceCupTable_1_addr,
        lis r5,raceCupTable@ha;
)
MOD_REL(
    mod_raceCupTable_2,
    mod_raceCupTable_1_addr + 0x10,
        lwz r5,raceCupTable@l(r5);
)
MOD_REL(
    mod_raceCupTable_3,
    mod_raceCupTable_3_addr,
        lis r31,raceCupTable@ha;
)
MOD_REL(
    mod_raceCupTable_4,
    mod_raceCupTable_3_addr + 0xc,
        lwz r31,raceCupTable@l(r31);
)
MOD_REL(
    mod_raceCupTable_5,
    mod_raceCupTable_5_addr,
        lis r4,raceCupTable@ha;
)
MOD_REL(
    mod_raceCupTable_6,
    mod_raceCupTable_5_addr + 0x8,
        lwz r4,raceCupTable@l(r4);
)
MOD_REL(
    mod_raceCupTable_7,
    mod_raceCupTable_7_addr,
        lis r4,raceCupTable@ha;
)
MOD_REL(
    mod_raceCupTable_8,
    mod_raceCupTable_7_addr + 0x8,
        lwz r4,raceCupTable@l(r4);
)
MOD_REL(
    mod_raceCupTable_9,
    mod_raceCupTable_9_addr,
        lis r4,raceCupTable@ha;
)
MOD_REL(
    mod_raceCupTable_10,
    mod_raceCupTable_9_addr + 0xc,
        lwz r4,raceCupTable@l(r4);
)
MOD_REL(
    mod_raceCupTable_11,
    mod_raceCupTable_11_addr,
        lis r5,raceCupTable@ha;
        lwz r5,raceCupTable@l(r5);
)
MOD_REL(
    mod_raceCupTable_12,
    mod_raceCupTable_12_addr,
        lis r5,raceCupTable@ha;
)
MOD_REL(
    mod_raceCupTable_13,
    mod_raceCupTable_12_addr + 0x10,
        lwz r5,raceCupTable@l(r5);
)
MOD_REL(
    mod2_23,
    mod2_23_addr,
        bl _ctgpr_load_raceCupTable_r28_r0;
)


/* these patches redirect the game's track file name table to
 * raceTrackNameTable.
 */
MOD_REL(
    mod_raceTrackNameTable_1,
    mod_raceTrackNameTable_1_addr,
        lis r4,raceTrackNameTable@ha;
)
MOD_REL(
    mod_raceTrackNameTable_2,
    mod_raceTrackNameTable_1_addr + 0x10,
        lwz r4,raceTrackNameTable@l(r4);
)
MOD_REL(
    mod_raceTrackNameTable_3,
    mod_raceTrackNameTable_4_addr + 0x10,
        lwz r4,raceTrackNameTable@l(r4);
)
MOD_REL(
    mod_raceTrackNameTable_4,
    mod_raceTrackNameTable_4_addr,
        lis r4,raceTrackNameTable@ha;
)
MOD_REL(
    mod_raceTrackNameTable_5,
    mod_raceTrackNameTable_5_addr,
        lis r4,raceTrackNameTable@ha;
)
MOD_REL(
    mod_raceTrackNameTable_6,
    mod_raceTrackNameTable_5_addr + 0x10,
        lwz r4,raceTrackNameTable@l(r4);
)

/* These mods redirect certain track IDs to the real track ID. */
MOD_REL(
    mod_currentCourse_1,
    mod_currentCourse_1_addr,
        lis r5,currentCourse@ha;
        lwz r0,currentCourse@l(r5);
)
MOD_REL(
    mod_currentCourse_2,
    mod_currentCourse_2_addr,
        lis r4,currentCourse@ha;
)
MOD_REL(
    mod_currentCourse_3,
    mod_currentCourse_2_addr + 0x10,
        lwz r4,currentCourse@l(r4);
)
MOD_REL(
    mod_currentCourse_4,
    mod_currentCourse_4_addr,
        lis r3,currentCourse@ha;
        lwz r27,currentCourse@l(r3);
)

/* These mods change to the real track id (as picked in the menu) to the slot
 * ID which the game will henceforth believe is being played. */
MOD_DOL(
    mod1_2b,
    0x80004194,
    /* Redirects a course ID to be loaded in r31 to the corresponding slot
     * ID, and stores the true ID in currentCourse. r3 points to the race
     * information structure, which is altered.
     *
     * Leaf procedure; trashes r31.
     */
     .globl _ctgpr_redirect_course;
     _ctgpr_redirect_course:
        stwu    r1,-16(r1);
        mflr    r0;
        stw     r0,20(r1);
        stw     r4,8(r1);

        lis     r4,currentCourse@ha;
        stw     r31,currentCourse@l(r4);
        lwz     r4,raceTrackSlotTable@l(r4);
        rlwinm  r31,r31,2,0,29;
        lwzx    r31,r4,r31;
        stw     r31,5976(r3);

        lwz     r4,8(r1);
        lwz     r0,20(r1);
        mtlr    r0;
        addi    r1,r1,16;
        blr;
)
MOD_DOL(
    mod1_6,
    0x80004250,
    /* EABI compliant wrapper of _ctgpr_redirect_course redirecting based
     * on r3. r4 points to the race information structure.
     *
     * EABI compliant.
     */
    .globl _ctgpr_redirect_course_eabi_r3_r4;
    _ctgpr_redirect_course_eabi_r3_r4:
        stwu    r1,-16(r1);
        mflr    r0;
        stw     r0,20(r1);
        stw     r31,8(r1);
        mr      r31,r3;
        mr      r3,r4;
        bl      _ctgpr_redirect_course;
        lwz     r31,8(r1);
        lwz     r0,20(r1);
        mtlr    r0;
        addi    r1,r1,16;
        blr;

    /* EABI compliant wrapper of _ctgpr_redirect_course redirecting based
     * on r3. r5 points to the race information structure.
     *
     * EABI compliant.
     */
    .globl _ctgpr_redirect_course_eabi_r3_r5;
    _ctgpr_redirect_course_eabi_r3_r5:
        stwu    r1,-16(r1);
        mflr    r0;
        stw     r0,20(r1);
        stw     r31,8(r1);
        mr      r31,r3;
        mr      r3,r5;
        bl      _ctgpr_redirect_course;
        lwz     r31,8(r1);
        lwz     r0,20(r1);
        mtlr    r0;
        addi    r1,r1,16;
        blr;

    /* EABI compliant wrapper of _ctgpr_redirect_course redirecting based
     * on r0. r3 points to the race information structure.
     *
     * EABI compliant.
     */
    .globl _ctgpr_redirect_course_eabi_r0;
    _ctgpr_redirect_course_eabi_r0:
        mr      r4,r0;
        /* fall through */

    /* EABI compliant wrapper of _ctgpr_redirect_course redirecting based
     * on r4. r3 points to the race information structure.
     *
     * EABI compliant.
     */
    .globl _ctgpr_redirect_course_eabi_r4;
    _ctgpr_redirect_course_eabi_r4:
        stwu    r1,-16(r1);
        mflr    r0;
        stw     r0,20(r1);
        stw     r31,8(r1);
        mr      r31,r4;
        bl      _ctgpr_redirect_course;
        lwz     r31,8(r1);
        lwz     r0,20(r1);
        mtlr    r0;
        addi    r1,r1,16;
        blr;

    .globl _ctgpr_get_currentCourse_r0_r4;
    _ctgpr_get_currentCourse_r0_r4:
        lwz     r0,currentCourse@l(r4);
        lwz     r4,raceData@l(r26);
        blr;

    .globl _ctgpr_get_currentCourse_r0_r5;
    _ctgpr_get_currentCourse_r0_r5:
        lwz     r0,currentCourse@l(r5);
        lwz     r5,raceData@l(r26);
        blr;
)
MOD_DOL(
    mod1_5,
    0x8000433c,
    /* Wrapper of _ctgpr_redirect_course redirecting based on r0. r3 points
     * to 0xc10 into the race information structure. */
    .globl _ctgpr_redirect_course_r0_off;
    _ctgpr_redirect_course_r0_off:
        mr      r4,r0;
        stwu    r1,-16(r1);
        mflr    r0;
        stw     r0,20(r1);

        addi    r3,r3,-0xc10;
        bl      _ctgpr_redirect_course_eabi_r4;
        addi    r3,r3,0xc10;

        lwz     r0,20(r1);
        mtlr    r0;
        addi    r1,r1,16;
        blr;

    /* Wrapper of _ctgpr_redirect_course redirecting based on r0. r3 points
     * to 0xc10 into the race information structure. Designed to be called
     * from leaf procedure of stack size 32, which hasn't saved LR.
     */
    .globl _ctgpr_redirect_course_r0_off_leaf32;
    _ctgpr_redirect_course_r0_off_leaf32:
        mflr    r4;
        stw     r4,36(r1);
        bl      _ctgpr_redirect_course_r0_off;
        lwz     r4,36(r1);
        mtlr    r4;
        b       _ctgpr_redirect_course_r0_off_leaf32_ret;

    .globl _battle_id_to_track_id;
    _battle_id_to_track_id:
        cmpwi   r3,-1;
        li      r4,255;
        beq-    0f;
        and     r3,r3,r4;
    0:  blr;

    .globl _ctgpr_func_4394;
    _ctgpr_func_4394:
        lis     r3,raceData2@ha;
        lwz     r3,raceData2@l(r3);
        lwz     r3,20(r3);
        lhz     r3,21(r3);
        cmpwi   r3,1320;
        blt-    0f;
        lwz     r3,28(r31);
        blr;
    0:  lwz     r3,68(r31);
        blr;
)
    
MOD_REL(
    mod_redirect_course_1,
    mod_redirect_course_1_addr,
        bl _ctgpr_redirect_course;
)
MOD_REL(
    mod_redirect_course_2,
    mod_redirect_course_2_addr,
        bl _ctgpr_redirect_course_eabi_r3_r4;
)
MOD_REL(
    mod_redirect_course_3,
    mod_redirect_course_3_addr,
        bl _ctgpr_redirect_course_eabi_r3_r5;
)
MOD_REL(
    mod_redirect_course_4,
    mod_redirect_course_4_addr,
        bl _ctgpr_redirect_course_eabi_r0;
)
MOD_REL(
    mod_redirect_course_5,
    mod_redirect_course_5_addr,
        b _ctgpr_redirect_course_r0_off_leaf32;
    .globl _ctgpr_redirect_course_r0_off_leaf32_ret;
    _ctgpr_redirect_course_r0_off_leaf32_ret:
)
MOD_REL(
    mod_redirect_course_6,
    mod_redirect_course_6_addr,
        bl _ctgpr_redirect_course_eabi_r0;
)
MOD_REL(
    mod_redirect_course_7,
    mod_redirect_course_7_addr,
        bl _ctgpr_redirect_course_eabi_r0;
)
MOD_REL(
    mod_redirect_course_8,
    mod_redirect_course_7_addr + 0x1c,
        bl _ctgpr_redirect_course_eabi_r0;
)
MOD_REL(
    mod_redirect_course_9,
    mod_redirect_course_9_addr,
        lis r4,currentCourse@ha;
        bl _ctgpr_get_currentCourse_r0_r4;
)
MOD_REL(
    mod_redirect_course_10,
    mod_redirect_course_10_addr,
        lis r5,currentCourse@ha;
        bl _ctgpr_get_currentCourse_r0_r5;
)


/* These mods add 0x4000 to the battle track IDs to distinguish them from race
 * track IDs.
 */
MOD_REL(
    mod_offset_battle_1,
    mod_offset_battle_3_addr + 0x8,
        addi r0,r3,0x4000;
)
MOD_REL(
    mod_offset_battle_2,
    mod_offset_battle_2_addr,
        cmplwi r3,254;
)
MOD_REL(
    mod_offset_battle_3,
    mod_offset_battle_3_addr,
        cmplwi r3,254;
)
MOD_REL(
    mod_offset_battle_4,
    mod_offset_battle_2_addr + 0x38,
        addi r26,r27,0x4000;
)
MOD_REL(
    mod_offset_battle_5,
    mod_offset_battle_6_addr + 0x140,
        b _battle_id_to_track_id;
)
MOD_REL(
    mod_offset_battle_6,
    mod_offset_battle_6_addr,
        b _battle_id_to_track_id;
)
MOD_REL(
    mod_offset_battle_7,
    mod_offset_battle_7_addr,
        .short 0x4000;
)
MOD_REL(
    mod_offset_battle_8,
    mod_offset_battle_8_addr,
        .short 0x4000;
)
MOD_REL(
    mod_offset_battle_9,
    mod_offset_battle_6_addr + 0x15c,
        b _battle_id_to_track_id;
)


/* These mods add proper CT-CODE logic to the "In Order" and "Random" VS settings.
 * Prior to a VS game, a pool of 32 course IDs is generated, which determines what
 * course is played next upon selecting "Next Course". Not only do we need to make
 * custom tracks poolable (rather than just their special slot IDs), we must also
 * redirect the "Next Course" handler to take advantage of CT-CODE.
 * 
 * For reference: "Random" picks the 1st course, pools 31 more in subsequent order,
 * then randomly permutes each pooled course with another. Consequently, on CT-CODE,
 * courses that are 32+ slots apart from each other are never pooled together.
 */
MOD_REL(
    mod_redirect_vs_1,
    mod_redirect_vs_1_addr,
        /* Reload current track ID into param r4. "In Order" passes us its slot instead. */
        lis r6, raceCupTable@ha;
        lwz r4, currentCourse@l(r6);
        stw r0, 52(r1);
        lwz r6, raceCupTable@l(r6);
)
MOD_REL(
    mod_redirect_vs_2,
    mod_redirect_vs_1_addr + 0x50,
        /* Break from 2 nested loops, rather than using a standard C break + r8 check. */
        b _ctgpr_redirect_vs_locate_course_done;
)
MOD_REL(
    mod_redirect_vs_3,
    mod_redirect_vs_1_addr + 0x68,
        lis r8, totalCupCount@ha;
        lwz r8, totalCupCount@l(r8);
        cmpw r9, r8;
)
MOD_REL(
    mod_redirect_vs_4,
    mod_redirect_vs_1_addr + 0x78,
    _ctgpr_redirect_vs_locate_course_done:
        /* We adjust cup wrapping depending on whether the first course belongs to a CT
         * cup or a Nintendo cup, thus restricting the entire pool to the same category.
         * This helps ensure that Random VS will only pick CTs; never a Nintendo course.
         * 
         * r9/r10: the lower/upper cup boundaries. r29: cup index of the 1st course pick.
         * r0: VS pool capacity. The game normally adjusts it to the number of courses
         *     unlocked (up to 32). But why check for cup unlocks when we have CT-CODE!
         */
        li     r9, 0;
        li     r10, 8;
        li     r0, 32;
        cmpwi  r29, 8;
        blt-   0f;

        /* CT wrapping. Just in case, if we have <32 CTs then reduce the pool to those. */
        lis    r10, totalCupCount@ha;
        lwz    r10, totalCupCount@l(r10);
        li     r9, 8;
        cmpwi  r10, 16;
        bge+   0f;
        subi   r0, r10, 8;
        slwi   r0, r0, 2;

    0:  stw    r0, 0xF8(r3);
        b      _ctgpr_redirect_vs_fill_track_pool;
)
MOD_REL(
    mod_redirect_vs_5,
    mod_redirect_vs_1_addr + 0x11C,
    _ctgpr_redirect_vs_fill_track_pool:
        lis r26, raceCupTable@ha;
)
MOD_REL(
    mod_redirect_vs_6,
    mod_redirect_vs_1_addr + 0x128,
        lwz r26, raceCupTable@l(r26);
)
MOD_REL(
    mod_redirect_vs_7,
    mod_redirect_vs_1_addr + 0x1F4,
        /* Moving from one cup to another during pool generation. Make sure to wrap. */
        sub r25, r10, r9;
        nop;
        addi r3, r29, 1;
        divw r0, r3, r10;
        mullw r0, r0, r25;
        sub r29, r3, r0;
)
MOD_REL(
    mod_redirect_vs_8,
    mod_redirect_vs_2_addr,
        /* Now for the finishing touch: fix our almighty "Next Course" button! */
        bl _ctgpr_redirect_course_eabi_r3_r4;
)

/* These mods ensure that the correct course is loaded upon starting a Random VS. */
MOD_REL(
    mod_redirect_vs_9,
    mod_redirect_vs_3_addr,
        lwz r7, 0x98(r4);
        lwz r3, raceData@l(r28);
)
MOD_REL(
    mod_redirect_vs_10,
    mod_redirect_vs_3_addr + 0x0C,
        lwz r31, 0x78(r7);
)
MOD_REL(
    mod_redirect_vs_11,
    mod_redirect_vs_3_addr + 0x14,
        bl _ctgpr_redirect_course;
        mr r3, r30;
)

MOD_REL(
    mod_redirect_vs_12,
    mod_redirect_vs_4_addr,
        /* Upon starting a Random VS, pick a random CT instead of a Nintendo course.
         * Thanks to our "In Order" logic, every other course will be a custom track.
         */
        lis r31, totalCupCount@ha;
        lwz r3, totalCupCount@l(r31);
        subi r3, r3, 8;
        slwi r3, r3, 2;
        bl _ctgpr_rng;
        addi r3, r3, 32;
        lwz r4, raceCupTable@l(r31);
        slwi r3, r3, 2;
        lwzx r27, r4, r3;
        stw r27, currentCourse@l(r31);
        b _ctgpr_redirect_vs_random_first_course_picked;
)
MOD_REL(
    mod_redirect_vs_13,
    mod_redirect_vs_4_addr + 0xF8,
    _ctgpr_redirect_vs_random_first_course_picked:
)


/* I've forgotten what these do */
MOD_REL(
    mod_ctgpr_func_4394_1,
    mod_ctgpr_func_4394_1_addr,
        bl _ctgpr_func_4394;
)
MOD_REL(
    mod2_13,
    mod2_13_addr,
        li r3,1;
)
MOD_REL(
    mod2_28,
    mod2_28_addr,
        lis r3,0x8000;
)
MOD_REL(
    mod2_29,
    mod2_28_addr + 0x8,
        lwz r3,0xce8(r3);
)
MOD_REL(
    mod2_45,
    mod2_45_addr,
        li r0,0;
)
MOD_REL(
    mod2_46,
    mod2_45_addr + 0x14,
        li r0,0;
)
MOD_REL(
    mod2_47,
    mod2_47_addr,
        li r0,0;
)
MOD_REL(
    mod2_48,
    mod2_47_addr + 0x14,
        li r0,0;
)

MOD_REL(
    mod2_49,
    mod2_45_addr + 0x28,
        li r0,1;
)
MOD_REL(
    mod2_50,
    mod2_45_addr + 0x44,
        li r0,1;
)
MOD_REL(
    mod2_51,
    mod2_47_addr + 0x34,
        li r0,1;
)
MOD_REL(
    mod2_52,
    mod2_47_addr + 0x50,
        li r0,1;
)

#endif
