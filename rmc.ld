/* rmc.ld
 *  by Chadderz
 *
 * Defines region agnostic symbols for use in the CTGP-R extension.
 */
 
PROVIDE(arena1low = 0x80000000);

/* CTGP-R symbols
/* all of these symbols MUST begin with the same top 17 bits as this is assumed
 * throughout the code, and not checked. */
PROVIDE(totalCupCount = 0x80000CC0);
PROVIDE(mod2 = 0x80000CC4);
PROVIDE(raceCupTable = 0x80000CC8);
PROVIDE(raceCupNameTable = 0x80000CCC);
PROVIDE(raceCupNameStringTable = 0x80000CD0);
PROVIDE(battleCupTable = 0x80000CD4);
PROVIDE(battleCupNameTable = 0x80000CD8);
PROVIDE(battleCupNameStringTable = 0x80000CDC);
PROVIDE(raceTrackNameTable = 0x80000CE0);
PROVIDE(raceTrackNameStringTable = 0x80000CE4);
PROVIDE(raceTrackSlotTable = 0x80000CEC);
PROVIDE(battleTrackNameTable = 0x80000CF0);
PROVIDE(battleTrackNameStringTable = 0x80000CF4);
PROVIDE(battleTrackSlotTable = 0x80000CFC);

PROVIDE(cupCount = 0x80000dc8);
PROVIDE(cupStart = 0x80000dcc);
PROVIDE(currentCourse = 0x80000dF4);
PROVIDE(pageNumber = 0x80000df8);

PROVIDE(random_enable = 0x80000E00);
PROVIDE(random_button = 0x80000E01);
PROVIDE(random_action = 0x80000E02);
PROVIDE(random_last_cup = 0x80000E03);
PROVIDE(random_timeout = 0x80000E04);
PROVIDE(random_has_seed = 0x80000E08);
PROVIDE(random_seed = 0x80000E0c);
PROVIDE(saved_cup = 0x80000E10);

/* Speedometer symbols */
PROVIDE(SpeedCounter = 0x80000DE8);
PROVIDE(SpeedValue = 0x80000DEC);
PROVIDE(SpeedFloat = 0x80000DF0);

