/* speedo.mod
 *  by Chadderz
 *
 * Support patches for the OVR1 speedometer.
 */
 
#if ENABLE_SOM == 1

/* two patches to support OVR1. Although the first of these could go in MOD1,
 * for simplicity, OVR1 just statically looks at the first two entires of MOD2.
 */

/* Branch from the game's draw method to allow the extra rendering. Since OVR1
 * doesn't have fixed address, do a branch to 80000000, then we'll patch it up.
 */
MOD_REL(
    ovr1_1,
    gx_draw,
        /* This synthesises a forwards branch to 80000000, which is absurd
            * but OVR1 will patch it. */
        .int 0x48000000 - . + 0x80000000;
)
/* Branch from one of the methods that deals with characters so we can record
 * the speed to be displayed. Since OVR1 doesn't have fixed address, do a
 * branch to 80000000, then we'll patch it up.
 */
MOD_REL(
    ovr1_2,
    ovr1_2_addr,
        bl arena1low;
)

#endif
