/* bmg.mod
 *  by Chadderz
 *
 * Alters the IDs of track names when read from the BMG.
 */

#if ENABLE_CTS == 1

MOD_REL(
    mod_bmg_track,
    mod_bmg_track_addr,
        nop;
        addi    r3,r3,0x4000;
)

#endif
