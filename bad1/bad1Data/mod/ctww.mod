/* ctww.mod
 *  by Chadderz
 *
 * Changes online region of play. Credits to XeR for realising this was a
 * thing.
 */

#if ENABLE_CTWW == 1
 
/* Three patches to change the region number to the constant ONLINE_REGION
 * which is defined in the config files.
 */
MOD_REL(
    mod_online_region_1,
    mod_online_region_1_addr,
        li r7,ONLINE_REGION;
)
MOD_REL(
    mod_online_region_2,
    mod_online_region_2_addr,
        li r5,ONLINE_REGION;
)
MOD_REL(
    mod_online_region_3,
    mod_online_region_3_addr,
        li r4,ONLINE_REGION;
)

/* This mod alters the online time limit to 0x53020 = 340000ms */
MOD_REL(
    mod_time_limit,
    mod_time_limit_addr,
        lis r3,0x5;
        addi r4,r3,0x3020;
)

#if ENABLE_CTS == 1

/* These mods replace the standard mechanics for determining if a track vote
 * is valid online. The old check was simply a less than, but in CTGP-R this
 * is much more compilcated, related to the number of tracks. 0x42 and 0x43
 * are online status codes, so always invalid.
 */
MOD_DOL(
    mod1_5b,
    0x800043bc,
    /* determines whether or not r5 would be a valid vote online. lt in cr0
     * means yes, ge in cr0 means no.
     *
     * Leaf procedure.
     */
    .globl _ctgpr_valid_vote_r5;
    _ctgpr_valid_vote_r5:
        cmpwi   r5,0xfe;
        bgtlr;
        cmpwi   r5,0x42;
        beqlr;
        cmpwi   r5,0x43;
        beq-    0f;
        cmpwi   r5,0x7fff;
        blr;
    0:  cmpwi   r5,0x42;
        blr;
)
MOD_DOL(
    mod1_7,
    0x80004434,
    /* determines whether or not r4 would be a valid vote online. lt in cr0
     * means yes, ge in cr0 means no.
     *
     * Leaf procedure.
     */
    .globl _ctgpr_valid_vote_r4;
    _ctgpr_valid_vote_r4:
        cmpwi   r4,0xfe;
        bgtlr;
        cmpwi   r4,0x42;
        beqlr;
        cmpwi   r4,0x43;
        beq-    0f;
        cmpwi   r4,0x7fff;
        blr;
    0:  cmpwi   r4,0x42;
        blr;

    /* determines whether or not r0 would be a valid vote online. lt in cr0
     * means yes, ge in cr0 means no.
     *
     * Leaf procedure.
     */
    .globl _ctgpr_valid_vote_r0;
    _ctgpr_valid_vote_r0:
        cmpwi   r0,0xfe;
        bgtlr;
        cmpwi   r0,0x42;
        beqlr;
        cmpwi   r0,0x43;
        beq-    0f;
        cmpwi   r0,0x7fff;
        blr;
    0:  cmpwi   r0,0x42;
        blr;
)

MOD_REL(
    mod_valid_vote_1,
    mod_valid_vote_1_addr,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_2,
    mod_valid_vote_1_addr + 0x28,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_3,
    mod_valid_vote_1_addr + 0x54,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_4,
    mod_valid_vote_1_addr + 0x7c,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_5,
    mod_valid_vote_1_addr + 0xa8,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_6,
    mod_valid_vote_1_addr + 0xd0,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_7,
    mod_valid_vote_1_addr + 0xfc,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_8,
    mod_valid_vote_1_addr + 0x124,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_9,
    mod_valid_vote_9_addr,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_10,
    mod_valid_vote_9_addr + 0x28,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_11,
    mod_valid_vote_9_addr + 0x54,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_12,
    mod_valid_vote_9_addr + 0x7c,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_13,
    mod_valid_vote_9_addr + 0xa8,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_14,
    mod_valid_vote_9_addr + 0xd0,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_15,
    mod_valid_vote_9_addr + 0xfc,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_16,
    mod_valid_vote_9_addr + 0x124,
        bl _ctgpr_valid_vote_r5;
)
MOD_REL(
    mod_valid_vote_17,
    mod_valid_vote_17_addr,
        bl _ctgpr_valid_vote_r0;
)
    
/* These mods replace the normal checks for whether a track ID is too big.
 * For simplicity, they modify the second half of a cmplwi instruction.
 */
MOD_REL(
    mod_max_track_1,
    mod_max_track_1_addr,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_2,
    mod_max_track_1_addr + 0xa0,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_3,
    mod_max_track_1_addr + 0xcc,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_4,
    mod_max_track_1_addr + 0xf4,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_5,
    mod_max_track_1_addr + 0x120,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_6,
    mod_max_track_1_addr + 0x148,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_7,
    mod_max_track_1_addr + 0x174,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_8,
    mod_max_track_1_addr + 0x19c,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_9,
    mod_max_track_1_addr + 0x1e0,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_10,
    mod_max_track_1_addr + 0x21c,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_11,
    mod_max_track_1_addr + 0x258,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_12,
    mod_max_track_1_addr + 0x294,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_13,
    mod_max_track_1_addr + 0x2e8,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_14,
    mod_max_track_1_addr + 0x320,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_15,
    mod_max_track_1_addr + 0x358,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_16,
    mod_max_track_1_addr + 0x390,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_17,
    mod_max_track_1_addr + 0x45c,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_18,
    mod_max_track_1_addr + 0x494,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_19,
    mod_max_track_1_addr + 0x4cc,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_20,
    mod_max_track_1_addr + 0x504,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_21,
    mod_max_track_1_addr + 0x554,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_22,
    mod_max_track_1_addr + 0x58c,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_23,
    mod_max_track_1_addr + 0x5c4,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_24,
    mod_max_track_1_addr + 0x5fc,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_25,
    mod_max_track_1_addr + 0x64c,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_26,
    mod_max_track_1_addr + 0x684,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_27,
    mod_max_track_1_addr + 0x6bc,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_28,
    mod_max_track_1_addr + 0x6f4,
        .short 0x00fe;
)
MOD_REL(
    mod_max_track_29,
    mod_max_track_1_addr + 0x78,
        .short 0x00fe;
)

#endif
#endif
