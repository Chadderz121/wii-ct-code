/* rmce.ld
 *  by Chadderz
 *
 * Defines RMCE specific symbols for use in the CTGP-R extension.
 */
 
PROVIDE(game = 0x45); /* E */

INCLUDE rmc.ld;

/* game methods */
PROVIDE(memcpy = 0x80005F34);
PROVIDE(main = 0x800060A4);
PROVIDE(initRegs = 0x80006210);
PROVIDE(mod_mod0_entry_addr = 0x8004c00c);
PROVIDE(gx_draw = 0x8016EA10);
PROVIDE(malloc = 0x80229490);
PROVIDE(branch_to_mod2_addr = 0x8023AEAC);
PROVIDE(mod_mod0_texture_addr = 0x80244F08);
PROVIDE(mod_raceCupTable_11_addr = 0x8052a6c4);
PROVIDE(mod_redirect_course_5_addr = 0x8052a6dc);
PROVIDE(mod_raceCupTable_12_addr = 0x8052d454);
PROVIDE(mod_time_limit_addr = 0x80539e7c);
PROVIDE(mod_raceTrackNameTable_5_addr = 0x8053b2c0);
PROVIDE(mod_raceTrackNameTable_1_addr = 0x8053b30c);
PROVIDE(mod_raceTrackNameTable_4_addr = 0x8053c65c);
PROVIDE(mod_raceCupTable_9_addr = 0x8054ce38);
PROVIDE(mod_currentCourse_2_addr = 0x8054ddd8);
PROVIDE(mod2_45_addr = 0x80543bf8);
PROVIDE(mod2_13_addr = 0x80550c5c);
PROVIDE(displayTimer = 0x805BB418);
PROVIDE(mod_redirect_course_6_addr = 0x805cc0b8);
PROVIDE(mod_offset_battle_8_addr = 0x805ccc6e);
PROVIDE(mod_redirect_vs_4_addr = 0x805cd52c);
PROVIDE(mod_redirect_vs_1_addr = 0x805cd698);
PROVIDE(mod_raceCupTable_7_addr = 0x805ce21c);
PROVIDE(mod_onScrollTime_addr = 0x805D4630);
PROVIDE(mod_onScroll_addr = 0x805d4e6c);
PROVIDE(mod2_129_addr = 0x805d6464);
PROVIDE(mod_onIsActive_addr = 0x805d6e30);
PROVIDE(mod_redirect_course_2_addr = 0x805e56cc);
PROVIDE(mod_offset_battle_7_addr = 0x805ea5d2);
PROVIDE(mod2_128_addr = 0x805f16bc);
PROVIDE(mod_install_scroll_addr = 0x805f6b88);
PROVIDE(mod_onDemo_addr = 0x80609e60);
PROVIDE(mod_offset_battle_2_addr = 0x80612cac);
PROVIDE(mod_offset_battle_3_addr = 0x80612f18);
PROVIDE(mod_redirect_course_3_addr = 0x8061dba0);
PROVIDE(mod_timeout3_addr = 0x8064e280);
PROVIDE(mod_online_region_2_addr = 0x8064f1bc);
PROVIDE(mod_redirect_course_9_addr = 0x80650a38);
PROVIDE(mod_redirect_course_10_addr = 0x80650e64);
PROVIDE(mod_online_region_1_addr = 0x80654d84);
PROVIDE(mod_online_region_3_addr = 0x80655bac);
PROVIDE(mod_offset_battle_6_addr = 0x80658528);
PROVIDE(mod_valid_vote_1_addr = 0x8065b5d4);
PROVIDE(mod_valid_vote_9_addr = 0x8065b8f8);
PROVIDE(mod_max_track_1_addr = 0x8065bbae);
PROVIDE(mod_valid_vote_17_addr = 0x80664bec);
PROVIDE(mod2_28_addr = 0x80708754);
PROVIDE(mod_currentCourse_1_addr = 0x80708f84);
PROVIDE(mod_trophy_brres_addr = 0x8076d300);
PROVIDE(mod_ctgpr_wrap_page_addr = 0x807de554);
PROVIDE(mod_ctgpr_menu_scroll_0_r31_addr = 0x807de6b0);
PROVIDE(mod_raceCupTable_3_addr = 0x807df0b8);
PROVIDE(mod2_16_addr = 0x807df968);
PROVIDE(mod_ctgpr_scroll_toscreen_addr = 0x807dfab0);
PROVIDE(mod_cup_buttons_addr = 0x807dfbac);
PROVIDE(mod_menu_refresh_addr = 0x807dfbe4);
PROVIDE(mod_raceCupTable_1_addr = 0x807dff94);
PROVIDE(mod2_23_addr = 0x807e009c);
PROVIDE(ovr1_2_addr = 0x807e4c9c);
PROVIDE(mod_bmg_track_addr = 0x8081b774);
PROVIDE(detect_wifi_cup_filter_return = 0x80823018);
PROVIDE(mod2_22_addr = 0x80825a60);
PROVIDE(mod_timeout_addr = 0x80825c10);
PROVIDE(mod_redirect_course_1_addr = 0x80825f74);
PROVIDE(mod2_19_addr = 0x80826714);
PROVIDE(mod_timeout2_addr = 0x80826ad4);
PROVIDE(mod_raceCupTable_5_addr = 0x80826db0);
PROVIDE(mod_redirect_course_4_addr = 0x80826dd4);
PROVIDE(mod_random_enable_addr = 0x80827508);
PROVIDE(mod_redirect_vs_3_addr = 0x8082efb8);
PROVIDE(mod_currentCourse_4_addr = 0x80833820);
PROVIDE(mod2_47_addr = 0x808344bc);
PROVIDE(mod_redirect_course_7_addr = 0x80838eb0);
PROVIDE(mod_redirect_vs_2_addr = 0x808393fc);
PROVIDE(mod_ctgpr_func_4394_1_addr = 0x8083a6a4);
/* game data */
PROVIDE(defaultHeap = 0x80394EB8);
PROVIDE(mod_blue_drag_addr = 0x808a1058);
PROVIDE(mod_detect_wifi_cup_filter_addr = 0x808d3500);
PROVIDE(raceData = 0x809b8f68);
PROVIDE(raceData2 = 0x809b8f70);
PROVIDE(playerBase = 0x809BD110);
PROVIDE(menuData = 0x809bd508);
PROVIDE(playerDataUNK = 0x809BEE20);