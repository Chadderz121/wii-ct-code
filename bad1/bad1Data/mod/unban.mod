/* unban.mod
 *  by Chadderz
 *
 * A simple unban code.
 */

#if ENABLE_UNBAN == 1
 
/* Changes the number of MAC bytes to be copied down from 6 to 3. Thus, the MAC
 * address sent to the server will be the first 3 bytes of the real MAC, plus
 * whatever trash was on the stack at the time in the last 3 bytes.
 */
MOD_DOL(
	mod_unban,
	mod_unban_addr,
		li r5,3;
)

#endif
