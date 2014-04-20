/* mod0.mod
 *  by Chadderz
 *
 * Patches the game to run bad1.
 */

MOD_DOL(
    mod_mod0_entry,
    mod_mod0_entry_addr,
        b mod0_mod_start;
)
MOD_DOL(
    mod_mod0_start,
    0x80004040,
    /* Method run in order to display the H&S screen. r3 is the location of the
     * image. By altering it, we can choose the image. */
    .globl mod0_mod_start;
    mod0_mod_start:
        stwu r1,-256(r1);
        stmw r0,8(r1);
        mflr r0;
        stw r0,260(r1);
        
        /* branch to bad1code. */
        lwz r12,76(r3);
        add r12,r3,r12;
        mtlr r12;
        blrl;
        
        /* repair the damage we did at mod_mod0_entry. */
        lis r0,0x4800;
        ori r0,r0,0x0008;
        lis r3,mod_mod0_entry_addr@h;
        ori r3,r3,mod_mod0_entry_addr@l;
        stw r0,0(r3);
        
        li r4,0;
        icbi r3,r4;
        
        lwz r0,260(r1);
        mtlr r0;
        lmw r2,16(r1);
        lwz r0,8(r1);
        addi r1,r1,256;
        b mod_mod0_entry_addr+8;
)
/* rename the textures such that CTGP_CODE is the H&S screen. */
MOD_DOL(
    mod_mod0_texture,
    mod_mod0_texture_addr,
        .asciz "CTGP_CODE\0\0\0\0\0\0\0\0\0\0";
        .asciz "CTGP_CODE\0\0\0\0\0\0";
        .asciz "CTGP_CODE\0\0\0\0\0\0\0\0\0\0";
        .asciz "CTGP_CODE";
)
