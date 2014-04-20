/* mod2.mod
 *  by Chadderz
 *
 * Runs the MOD2 mods which is where MOD_REL patches are stored.
 */

MOD_DOL(
    branch_to_mod2,
    branch_to_mod2_addr,
        bl _ctgpr_run_mod2;
)

MOD_DOL(
    mod1_2,
    0x80004110,
    /* Runs MOD2.
     * 
     * EABI compliant. Tail calls ctr.
     */
    .globl _ctgpr_run_mod2;
    _ctgpr_run_mod2:
        stwu r1,-256(r1);
        stmw r0,8(r1);
        mflr r0;
        stw r0,260(r1);
        mfctr r0;
        stw r0,136(r1);

        /* prevent second run */
        lis r30,0x4e80;
        ori r30,r30,0x0421;
        lis r31,branch_to_mod2_addr@h;
        ori r31,r31,branch_to_mod2_addr@l;
        stw r30,0(r31);

        /* find MOD2 */
        lis r31,mod2@ha;
        lwz r30,mod2@l(r31);

        /* load mod count */
        lwz r4,12(r30);
        mtctr r4;
        /* set up loop location */
        addi r29,r30,16;

            /* load mod information */
    0:		lwzu r3,16(r29);		/* address */
            lwz r4,4(r29);		/* offset */
            lwz r5,8(r29);		/* length */

            /* make absoulte */
            add r4,r4,r30;

            /* call memcpy */
            lis r12,memcpy@h;
            ori r12,r12,memcpy@l;
            mtlr r12;
            blrl;

            bdnz- 0b;
    

        lwz r0,260(r1);
        mtlr r0;
        lwz r0,136(r1);
        mtctr r0;
        lwz r0,8(r1);
        lmw r2,16(r1);
        addi r1,r1,256;
        bctr;
)
