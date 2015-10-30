/* rmcp.ld
 *  by Chadderz
 *
 * Defines RMCP specific symbols for use in the CTGP-R extension.
 */
 
PROVIDE(game = 0x50); /* P */

INCLUDE rmc.ld;

/* game methods */
PROVIDE(memcpy = 0x80005F34);
PROVIDE(main = 0x800060A4);
PROVIDE(initRegs = 0x80006210);
PROVIDE(mod_mod0_entry_addr = 0x8004c0ac);
PROVIDE(gx_draw = 0x8016EAB0);
PROVIDE(malloc = 0x80229814);
PROVIDE(branch_to_mod2_addr = 0x8023B230);
PROVIDE(mod_mod0_texture_addr = 0x80244F88);
PROVIDE(mod_raceCupTable_11_addr = 0x8052f20c);
PROVIDE(mod_redirect_course_5_addr = 0x8052f224);
PROVIDE(mod_raceCupTable_12_addr = 0x80531f9c);
PROVIDE(mod_time_limit_addr = 0x8053f3b8);
PROVIDE(mod_raceTrackNameTable_5_addr = 0x805407fc);
PROVIDE(mod_raceTrackNameTable_1_addr = 0x80540848);
PROVIDE(mod_raceTrackNameTable_4_addr = 0x80541b98);
PROVIDE(mod2_45_addr = 0x80549134);
PROVIDE(mod2_13_addr = 0x8054fec0);
PROVIDE(mod_raceCupTable_9_addr = 0x80552d90);
PROVIDE(mod_currentCourse_2_addr = 0x80553df8);
PROVIDE(displayTimer = 0x805C4380);
PROVIDE(mod_redirect_course_6_addr = 0x805e1e94);
PROVIDE(mod_offset_battle_8_addr = 0x805e2a4a);
PROVIDE(mod_raceCupTable_7_addr = 0x805e3ff8);
PROVIDE(mod_onScrollTime_addr = 0x805ef104);
PROVIDE(mod_onScroll_addr = 0x805ef940);
PROVIDE(mod2_129_addr = 0x805f0f38);
PROVIDE(mod_onIsActive_addr = 0x805f1904);
PROVIDE(mod_redirect_course_2_addr = 0x80609fa0);
PROVIDE(mod_offset_battle_7_addr = 0x80615fe6);
PROVIDE(mod2_128_addr = 0x80622570);
PROVIDE(mod_install_scroll_addr = 0x80627a3c);
PROVIDE(mod_onDemo_addr = 0x8063b200);
PROVIDE(mod_offset_battle_2_addr = 0x806440cc);
PROVIDE(mod_offset_battle_3_addr = 0x80644338);
PROVIDE(mod_timeout3_addr = 0x8064aaf8);
PROVIDE(mod_redirect_course_3_addr = 0x80650eb4);
PROVIDE(mod_online_region_2_addr = 0x80653644);
PROVIDE(mod_redirect_course_9_addr = 0x80654ec0);
PROVIDE(mod_redirect_course_10_addr = 0x806552ec);
PROVIDE(mod_online_region_1_addr = 0x8065920c);
PROVIDE(mod_online_region_3_addr = 0x8065a034);
PROVIDE(mod_offset_battle_6_addr = 0x80660464);
PROVIDE(mod_valid_vote_1_addr = 0x80663f2c);
PROVIDE(mod_valid_vote_9_addr = 0x80664250);
PROVIDE(mod_max_track_1_addr = 0x80664506);
PROVIDE(mod_valid_vote_17_addr = 0x8066c350);
PROVIDE(mod2_28_addr = 0x807101f8);
PROVIDE(mod_currentCourse_1_addr = 0x80710a28);
PROVIDE(mod_trophy_brres_addr = 0x8074c8fc);
PROVIDE(mod_ctgpr_wrap_page_addr = 0x807e45e4);
PROVIDE(mod_ctgpr_menu_scroll_0_r31_addr = 0x807e4740);
PROVIDE(mod_raceCupTable_3_addr = 0x807e5148);
PROVIDE(mod2_16_addr = 0x807e59d8);
PROVIDE(mod_ctgpr_scroll_toscreen_addr = 0x807e5b20);
PROVIDE(mod_cup_buttons_addr = 0x807e5c1c);
PROVIDE(mod_menu_refresh_addr = 0x807e5c54);
PROVIDE(mod_raceCupTable_1_addr = 0x807e6004);
PROVIDE(mod2_23_addr = 0x807e610c);
PROVIDE(ovr1_2_addr = 0x807eefac);
PROVIDE(mod_bmg_track_addr = 0x80833674);
PROVIDE(detect_wifi_cup_filter_return = 0x8083da78);
PROVIDE(mod2_22_addr = 0x808404c0);
PROVIDE(mod_timeout_addr = 0x80840670);
PROVIDE(mod_redirect_course_1_addr = 0x808409d4);
PROVIDE(mod2_19_addr = 0x80841174);
PROVIDE(mod_timeout2_addr = 0x80841534);
PROVIDE(mod_raceCupTable_5_addr = 0x80841810);
PROVIDE(mod_redirect_course_4_addr = 0x80841834);
PROVIDE(mod_random_enable_addr = 0x80841f68);
PROVIDE(mod_currentCourse_4_addr = 0x808552b0);
PROVIDE(mod2_47_addr = 0x80855f4c);
PROVIDE(mod_redirect_course_7_addr = 0x8085a940);
PROVIDE(mod_ctgpr_func_4394_1_addr = 0x8085c134);
/* game data */
PROVIDE(defaultHeap = 0x80399238);
PROVIDE(mod_blue_drag_addr = 0x808a5b30);
PROVIDE(mod_detect_wifi_cup_filter_addr = 0x808d92f0);
PROVIDE(raceData = 0x809bd728);
PROVIDE(raceData2 = 0x809bd730);
PROVIDE(playerBase = 0x809C18F8);
PROVIDE(menuData = 0x809c1e38);
PROVIDE(playerDataUNK = 0x809C3618);
