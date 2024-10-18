#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_weapons;

init() // entry point
{
    level endon( "end_game" );
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    
    level endon("game_ended");
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("spawned_player");
    }
}

getNiceWeaponName(therawweaponname)
{
    args = strTok( therawweaponname, "+" );
	justweapon = args[ 0 ];
    switch ( justweapon )
    {
        case "dsr50_zm":
            return "DSR 50";
        case "dsr50_upgraded_zm":
            return "Dead Specimen Reactor 5000";
        case "barretm82_zm":
            return "Barrett M82A1";
        case "barretm82_upgraded_zm":
            return "Macro Annihilator";
        case "svu_zm":
            return "SVU-AS";
        case "svu_upgraded_zm":
            return "Shadowy Veil Utilizer";
        case "ak74u_zm":
            return "AK74u";
        case "ak74u_upgraded_zm":
            return "AK74fu2";
        case "mp5k_zm":
            return "MP5";
        case "mp5k_upgraded_zm":
            return "MP115 Kollider";
        case "pdw57_zm":
            return "PDW-57";
        case "pdw57_upgraded_zm":
            return "Predictive Death Wish 57000";
        case "fnfal_zm":
            return "FAL";
        case "fnfal_upgraded_zm":
            return "WN";
        case "m14_zm":
            return "M14";
        case "m14_upgraded_zm":
            return "Mnesia";
        case "saritch_zm":
            return "SMR";
        case "saritch_upgraded_zm":
            return "SMIL3R";
        case "m16_zm":
            return "M16";
        case "m16_gl_upgraded_zm":
            return "Skullcrusher";
        case "tar21_zm":
            return "MTAR";
        case "tar21_upgraded_zm":
            return "Malevolent Toxonomic Anodized Redeemer";
        case "gl_tar21_zm":
            return "MTAR & Grenade Launcher";
        case "galil_zm":
            return "Galil";
        case "galil_upgraded_zm":
            return "Lamentation";
        case "an94_zm":
            return "AN-94";
        case "an94_upgraded_zm":
            return "Actuated Neutralizer 94000";
        case "870mcs_zm":
            return "Remington 870-MCS";
        case "870mcs_upgraded_zm":
            return "Refitted-870 Mechanical Cranium Sequencer";
        case "rottweil72_zm":
            return "Olympia";
        case "rottweil72_upgraded_zm":
            return "Hades";
        case "saiga12_zm":
            return "S12";
        case "saiga12_upgraded_zm":
            return "Synthetic Dozen";
        case "srm1216_zm":
            return "M1216";
        case "srm1216_upgraded_zm":
            return "Mesmerizer";
        case "lsat_zm":
            return "LSAT";
        case "lsat_upgraded_zm":
            return "FSIRT";
        case "hamr_zm":
            return "HAMR";
        case "hamr_upgraded_zm":
            return "SLDG HAMR";
        case "m1911_zm":
            return "M1911";
        case "m1911_upgraded_zm":
            return "Mustang & Sally";
        case "rnma_zm":
            return "Remington New Model Army";
        case "rnma_upgraded_zm":
            return "SASSAFRAS";
        case "judge_zm":
            return "Executioner";
        case "judge_upgraded_zm":
            return "Voice of Justice";
        case "kard_zm":
            return "KAP-40";
        case "kard_upgraded_zm":
            return "Karmic Atom Perforator 4000";
        case "fiveseven_zm":
            return "Five-Seven";
        case "fiveseven_upgraded_zm":
            return "Ultra";
        case "fivesevendw_zm":
            return "Five-Seven Dual Wield";
        case "fivesevendw_upgraded_zm":
            return "Ultra & Violet";
        case "beretta93r_zm":
            return "B23R";
        case "beretta93r_upgraded_zm":
            return "B34R";
        case "usrpg_zm":
            return "RPG";
        case "usrpg_upgraded_zm":
            return "Rocket Propelled Grievance";
        case "m32_zm":
            return "War Machine";
        case "m32_upgraded_zm":
            return "Dystopic Demolisher";
        case "knife_ballistic_zm":
            return "Ballistic Knife";
        case "knife_ballistic_upgraded_zm":
            return "The Krauss Refibrillator";
        case "knife_ballistic_bowie_zm":
            return "Ballistic & Bowie";
        case "knife_ballistic_bowie_upgraded_zm":
            return "The Krauss Refibrillator & Bowie";
        case "knife_ballistic_no_melee_zm":
            return "Ballistic no Melee";
        case "knife_ballistic_no_melee_upgraded_zm":
            return "Krauss no Melee";
        case "ray_gun_zm":
            return "Ray Gun";
        case "ray_gun_upgraded_zm":
            return "Porter's X2 Ray Gun";
        case "raygun_mark2_zm":
            return "Ray Gun Mark II";
        case "raygun_mark2_upgraded_zm":
            return "Porter's Mark II Ray Gun";
        case "slowgun_zm":
            return "Paralyzer";
        case "slowgun_upgraded_zm":
            return "Petrifier";
        case "cymbal_monkey_zm":
            return "Monkeys";
        case "frag_grenade_zm":
            return "Frag Grenade";
        case "claymore_zm":
            return "Claymore";
        case "time_bomb_zm":
            return "Time Bomb";
        case "bowie_knife_zm":
            return "Bowie Knife";
        case "tazer_knuckles_zm":
            return "Galva Knuckles";
        case "knife_zm":
            return "Knife";
        case "equip_turbine_zm":
            return "Turbine";
        case "equip_springpad_zm":
            return "Tramplesteam";
        case "equip_subwoofer_zm":
            return "Subwoofer";
        case "equip_headchopper_zm":
            return "Handchopper";
        case "specialty_armorvest":
        case "zombie_perk_bottle_jugg":
            return "Juggernog";
        case "specialty_quickrevive":
        case "zombie_perk_bottle_revive":
            return "Quick Revive";
        case "specialty_fastreload":
        case "zombie_perk_bottle_sleight":
            return "Speed Cola";
        case "specialty_rof":
        case "zombie_perk_bottle_doubletap":
            return "Double Tap";
        case "specialty_longersprint":
        case "zombie_perk_bottle_marathon":
            return "StaminUp";
        case "specialty_additionalprimaryweapon":
        case "zombie_perk_bottle_additionalprimaryweapon":
            return "Mule Kick";
        case "specialty_nomotionsensor":
        case "zombie_perk_bottle_vulture":
            return "Vulture Aid";
        case "zombie_knuckle_crack":
            return "Upgrade Time!!";
        case "chalk_draw_zm":
            return "Chalk Draw";
        case "syrette_zm":
            return "Syrette";
        case "zombie_bowie_flourish":
            return "Bowie Flourish";
        case "zombie_tazer_flourish":
            return "Tazer Flourish";
        case "p6_anim_zm":
            return "P6";
        case "qcw05_zm":
            return "Chicom CQB";
        case "qcw05_upgraded_zm":
            return "Chicom Cataclismic Quadruple Burst";
        case "type95_zm":
            return "Type 25";
        case "type95_upgraded_zm":
            return "Strain 25";
        case "xm8_zm":
            return "M8A1";
        case "xm8_upgraded_zm":
            return "Micro Aerator";
        case "rpd_zm":
            return "RPD";
        case "rpd_upgraded_zm":
            return "Relativistic Punishment Device";
        case "python_zm":
            return "Python";
        case "python_upgraded_zm":
            return "Cobra";
        case "slipgun_zm":
            return "Sliquifier";
        case "slipgun_upgraded_zm":
            return "Sl1qu1f13r";
        case "sticky_grenade_zm":
            return "Semtex";
        case "specialty_finalstand":
            return "Final Stand!";
        case "zombie_perk_bottle_whoswho":
            return "Who's Who";
        case "thompson_zm":
            return "Thompson";
        case "thompson_upgraded_zm":
            return "Gibs-O-Matic";
        case "uzi_zm":
            return "Uzi";
        case "uzi_upgraded_zm":
            return "Uncle Gal";
        case "ak47_zm":
            return "AK-47";
        case "ak47_upgraded_zm":
            return "Reznov's Revenge";
        case "minigun_alcatraz_zm":
            return "Death Machine";
        case "minigun_alcatraz_upgraded_zm":
            return "Meat Grinder";
        case "blundergat_zm":
            return "Blundergat";
        case "blundergat_upgraded_zm":
            return "The Sweeper";
        case "blundersplat_zm":
            return "Acid Gat";
        case "blundersplat_upgraded_zm":
            return "Vitriolic Withering";
        case "willy_pete_zm":
            return "Smokes";
        case "bouncing_tomahawk_zm":
            return "Tomahawk";
        case "upgraded_tomahawk_zm":
            return "Tomahawk Upgraded";
        case "knife_zm":
            return "Knife";
        case "spoon_zm":
            return "Spoon";
        case "spork_zm":
            return "Spork";
        case "alcatraz_shield_zm":
            return "Riot Shield";
        case "specialty_grenadepulldeath":
            return "Electric Cherry";
        case "zombie_perk_bottle_cherry":
            return "Electric Cherry";
        case "specialty_ads_zombies":
        case "zombie_perk_bottle_deadshot":
            return "Deadshot";
        case "falling_hands_zm":
            return "Falling Hands";
        case "lightning_hands_zm":
            return "Lightning Hands";
        case "syrette_afterlife_zm":
            return "Syrette Afterlife";
        case "tower_trap_zm":
            return "Tower Trap";
        case "tower_trap_upgraded_zm":
            return "Tower Trap Upgraded";
        case "zombie_tomahawk_flourish":
            return "Tomahawk Flourish";
        case "emp_grenade_zm":
            return "EMP";
        case "riotshield_zm":
            return "Riot Shield";
        case "jetgun_zm":
            return "Jet Gun";
        case "equip_electrictrap_zm":
            return "Electric Trap";
        case "equip_turret_zm":
            return "Turret";
        case "specialty_scavenger":
            return "Tombstone";
        case "zombie_perk_bottle_tombstone":
            return "Tombstone";
        case "screecher_arms_zm":
            return "Screecher Arms";
        case "ballista_zm":
            return "Ballista";
        case "ballista_upgraded_zm":
            return "Infused Arbalest";
        case "ak74u_extclip_zm":
            return "AK74u";
        case "ak74u_extclip_upgraded_zm":
            return "AK74fu2";
        case "mp40_zm":
            return "MP-40";
        case "mp40_upgraded_zm":
            return "The Afterburner";
        case "mp40_stalker_zm":
            return "MP-40 Stalker";
        case "mp40_stalker_upgraded_zm":
            return "The Afterburner Stalker";
        case "evoskorpion_zm":
            return "Skorpion";
        case "evoskorpion_upgraded_zm":
            return "Sk0rp10n";
        case "mp44_zm":
            return "MP-44";
        case "mp44_upgraded_zm":
            return "MP-88";
        case "scar_zm":
            return "SCAR-H";
        case "scar_upgraded_zm":
            return "Argarthan Reaper";
        case "ksg_zm":
            return "KSG";
        case "ksg_upgraded_zm":
            return "Mist Maker";
        case "mg08_zm":
            return "MG-08";
        case "mg08_upgraded_zm":
            return "Magna Collider";
        case "c96_zm":
            return "Mauser C96";
        case "c96_upgraded_zm":
            return "Boomhilda";
        case "beretta93r_extclip_zm":
            return "Baretta 93r";
        case "beretta93r_extclip_upgraded_zm":
            return "Baretta 93r Upgrade";
        case "staff_fire_zm":
            return "Staff of Fire";
        case "staff_fire_upgraded_zm":
            return "Kagutsuchi's Blood";
        case "staff_water_zm":
            return "Staff of Ice";
        case "staff_water_upgraded_zm":
            return "Ull's Arrow";
        case "staff_air_zm":
            return "Staff of Wind";
        case "staff_air_upgraded_zm":
            return "Boreas' Fury";
        case "staff_lightning_zm":
            return "Staff of Lightning";
        case "staff_lightning_upgraded_zm":
            return "Kimat's Bite";
        case "staff_revive_zm":
            return "Staff of Revive";
        case "beacon_zm":
            return "G-Strikes";
        case "one_inch_punch_zm":
            return "One Inch Punch";
        case "one_inch_punch_upgraded_zm":
            return "One Inch Punch Upgraded";
        case "one_inch_punch_fire_zm":
            return "One Inch Punch Fire";
        case "one_inch_punch_air_zm":
            return "One Inch Punch Air";
        case "one_inch_punch_ice_zm":
            return "One Inch Punch Ice";
        case "one_inch_punch_lightning_zm":
            return "One Inch Punch Lightning";
        case "equip_dieseldrone_zm":
            return "Maxis Drone";
        case "tomb_shield_zm":
            return "Tomb Shield";
        case "specialty_flakjacket":
        case "zombie_perk_bottle_nuke":
            return "PHD Flopper";
        case "zombie_one_inch_punch_flourish":
            return "One Inch Punch Flourish";
        case "hk416_zm":
            return "M27";
        case "hk416_upgraded_zm":
            return "Mystifier";
        default:
            return "";
    }
}