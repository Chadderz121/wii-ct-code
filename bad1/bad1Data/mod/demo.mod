/* demo.mod
 *  by Chadderz
 *
 * Makes the `demo' sequence on the title screen choose from random CTs instead
 * of always Luigi Circuit.
 */

MOD_REL(
    mod_onDemo,
    mod_onDemo_addr,
        bl onDemo;
)
MOD_DOL(
    code_onDemo,
    0x80003e20,
        /* Randomly selects a CT for the demo. Returns the slot ID for the demo
         * (so the game loads that) and sets up the true id for the demo to the
         * CT.
         *
         * EABI compliant.
         */
        .globl onDemo;
        onDemo:
            stwu r1,-16(r1);
            mflr r0;
            stw r0,20(r1);
            stmw r30,8(r1);

            lis r3,menuData@ha;
            lwz r3,menuData@l(r3);
            lwz r3,0x98(r3);
            lwz r4,0x4d0(r3);
            addi r4,r4,1;
            cmpwi r4,3;
            ble 0f;
            li r4,0;

        0:  stw r4,0x4d0(r3);
            li r4,1;
            stb r4,0x4cc(r3);

            lis r31,totalCupCount@ha;
            lwz r3,totalCupCount@l(r31);
            subi r3,r3,8;
            slwi r3,r3,2;
            bl _ctgpr_rng;
            addi r3,r3,32;

            lwz r4,raceCupTable@l(r31);
            slwi r3,r3,2;
            lwzx r5,r4,r3;

            /* r5 contains track number :3 */

            stw r5,currentCourse@l(r31);
            lwz r4,raceTrackSlotTable@l(r31);
            slwi r3,r5,2;
            lwzx r3,r4,r3;

            lmw r30,8(r1);
            lwz r0,20(r1);
            mtlr r0;
            addi r1,r1,16;
            blr;
)