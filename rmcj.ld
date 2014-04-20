/* rmcj.ld
 *  by Chadderz
 *
 * Defines RMCJ specific symbols for use in the CTGP-R extension.
 */
 
PROVIDE(game = 0x4A); /* J */

INCLUDE rmc.ld;

/* game methods */
PROVIDE(memcpy = 0x80005F34);
PROVIDE(main = 0x800060A4);
PROVIDE(initRegs = 0x80006210);
PROVIDE(mod_mod0_entry_addr = 0x8004bfcc);
PROVIDE(gx_draw = 0x8016E9D0);
PROVIDE(mod_unban_addr = 0x801d0d70);
PROVIDE(malloc = 0x80229734);
PROVIDE(branch_to_mod2_addr = 0x8023B150);
PROVIDE(mod_mod0_texture_addr = 0x80244EA8);
PROVIDE(mod_raceCupTable_11_addr = 0x8052eb8c);
PROVIDE(mod_redirect_course_5_addr = 0x8052eba4);
PROVIDE(mod_raceCupTable_12_addr = 0x8053191c);
PROVIDE(mod_time_limit_addr = 0x8053ed38);
PROVIDE(mod_raceTrackNameTable_5_addr = 0x8054017c);
PROVIDE(mod_raceTrackNameTable_1_addr = 0x805401c8);
PROVIDE(mod_raceTrackNameTable_4_addr = 0x80541518);
PROVIDE(mod2_45_addr = 0x80548ab4);
PROVIDE(mod2_13_addr = 0x8054f840);
PROVIDE(mod_raceCupTable_9_addr = 0x80552710);
PROVIDE(mod_currentCourse_2_addr = 0x80553778);
PROVIDE(displayTimer = 0x805C3D00);
PROVIDE(mod_redirect_course_6_addr = 0x805e1770);
PROVIDE(mod_offset_battle_8_addr = 0x805e2326);
PROVIDE(mod_raceCupTable_7_addr = 0x805e38d4);
PROVIDE(mod_onScrollTime_addr = 0x805ee9e0);
PROVIDE(mod_onScroll_addr = 0x805ef21c);
PROVIDE(mod2_129_addr = 0x805f0814);
PROVIDE(mod_onIsActive_addr = 0x805f11e0);
PROVIDE(mod_redirect_course_2_addr = 0x80609714);
PROVIDE(mod_offset_battle_7_addr = 0x8061575a);
PROVIDE(mod2_128_addr = 0x80621cbc);
PROVIDE(mod_install_scroll_addr = 0x80627188);
PROVIDE(mod_onDemo_addr = 0x8063a8ec);
PROVIDE(mod_offset_battle_2_addr = 0x80643738);
PROVIDE(mod_offset_battle_3_addr = 0x806439a4);
PROVIDE(mod_timeout3_addr = 0x8064a164);
PROVIDE(mod_redirect_course_3_addr = 0x80650520);
PROVIDE(mod_online_region_2_addr = 0x80652cb0);
PROVIDE(mod_redirect_course_9_addr = 0x8065452c);
PROVIDE(mod_redirect_course_10_addr = 0x80654958);
PROVIDE(mod_online_region_1_addr = 0x80658878);
PROVIDE(mod_online_region_3_addr = 0x806596a0);
PROVIDE(mod_offset_battle_6_addr = 0x8065fad0);
PROVIDE(mod_valid_vote_1_addr = 0x80663598);
PROVIDE(mod_valid_vote_9_addr = 0x806638bc);
PROVIDE(mod_max_track_1_addr = 0x80663b72);
PROVIDE(mod_valid_vote_17_addr = 0x8066b9bc);
PROVIDE(mod2_28_addr = 0x8070f864);
PROVIDE(mod_currentCourse_1_addr = 0x80710094);
PROVIDE(mod_trophy_brres_addr = 0x8074bf68);
PROVIDE(mod_ctgpr_wrap_page_addr = 0x807e3c50);
PROVIDE(mod_ctgpr_menu_scroll_0_r31_addr = 0x807e3dac);
PROVIDE(mod_raceCupTable_3_addr = 0x807e47b4);
PROVIDE(mod2_16_addr = 0x807e5044);
PROVIDE(mod_ctgpr_scroll_toscreen_addr = 0x807e518c);
PROVIDE(mod_cup_buttons_addr = 0x807e5288);
PROVIDE(mod_menu_refresh_addr = 0x807e52c0);
PROVIDE(mod_raceCupTable_1_addr = 0x807e5670);
PROVIDE(mod2_23_addr = 0x807e5778);
PROVIDE(ovr1_2_addr = 0x807ee618);
PROVIDE(mod_bmg_track_addr = 0x80832ce0);
PROVIDE(detect_wifi_cup_filter_return = 0x8083d0e4);
PROVIDE(mod2_22_addr = 0x8083fb2c);
PROVIDE(mod_timeout_addr = 0x8083fcdc);
PROVIDE(mod_redirect_course_1_addr = 0x80840040);
PROVIDE(mod2_19_addr = 0x808407e0);
PROVIDE(mod_timeout2_addr = 0x80840ba0);
PROVIDE(mod_raceCupTable_5_addr = 0x80840e7c);
PROVIDE(mod_redirect_course_4_addr = 0x80840ea0);
PROVIDE(mod_random_enable_addr = 0x808415d4);
PROVIDE(mod_currentCourse_4_addr = 0x8085491c);
PROVIDE(mod2_47_addr = 0x808555b8);
PROVIDE(mod_redirect_course_7_addr = 0x80859fac);
PROVIDE(mod_ctgpr_func_4394_1_addr = 0x8085b7a0);
/* game data */
PROVIDE(defaultHeap = 0x80398BB8);
PROVIDE(mod_blue_drag_addr = 0x808a4c90);
PROVIDE(mod_detect_wifi_cup_filter_addr = 0x808d8440);
PROVIDE(raceData = 0x809bc788);
PROVIDE(raceData2 = 0x809bc790);
PROVIDE(playerBase = 0x809C0958);
PROVIDE(menuData = 0x809c0e98);
PROVIDE(playerDataUNK = 0x809C2678);