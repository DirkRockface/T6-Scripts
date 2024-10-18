#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include scripts\zm\dirk_bank;

init()
{
	level thread onPlayerConnect();
	thread initServerDvars();
}

onPlayerConnect()
{
	level endon( "end_game" );
    self endon( "disconnect" );
	for (;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
		player thread spawnIfRoundOneOrTwo();
		player thread waitForTheNuke();
		player thread waitForTheMaxAmmo();
	}
}

onPlayerSpawned()
{
	level endon( "end_game" );
    self endon( "disconnect" );
	for(;;)
	{
		self waittill( "spawned_player" );
	}
}

initServerDvars()
{
	level.player_starting_points = getDvarIntDefault( "playerStartingPoints", 500 );            //sets player starting points
	level.perk_purchase_limit = getDvarIntDefault( "perkLimit", 4 );                            //sets the perk limit for all players
	level.zombie_ai_limit = getDvarIntDefault( "zombieAiLimit", 24 );                           //sets the maximum number of zombies that can be on the map at once 32 max
	level.disableWalkers = getDvarIntDefault( "disableWalkers", 0 );                            //sets walkers or no walkers
	if ( level.disableWalkers )
	{
		level.speed_change_round = undefined;
	}
	level.drfZombieSpawnRate = getDvarFloatDefault( "drfZombieSpawnRate", 2 );                    //sets zombie spawn rate; max is 0.08 this is in seconds
	level.zombie_vars[ "zombie_spawn_delay" ] = level.drfZombieSpawnRate;
	//level.mixed_rounds_enabled = getDvarIntDefault( "midroundDogs", 1 );                        //enables hellhounds WARNING don't use on maps that aren't bus, town, or farm or fix to override
	level.default_solo_laststandpistol = getDvar( "soloLaststandWeapon" );                      //sets the solo laststand pistol
	level.default_laststandpistol = getDvar( "coopLaststandWeapon" );                           //the default laststand pistol
	level.start_weapon = getDvar( "startWeaponZm" );                                            //set the starting weapon
	level.round_number = getDvarIntDefault( "roundNumber", 1 );                                 //sets the round number any value between 1-255
	level.disableSoloMode = getDvarIntDefault( "soloModeDisabled", 0 );                         //set afterlives on mob to 1 like a normal coop match and sets the prices of doors on origins to be higher
	if ( level.disableSoloMode )
	{
		level.is_forever_solo_game = undefined;
	}	
	level.maxPowerupsPerRound = getDvarIntDefault( "maxPowerupsPerRound", 4 );                  //sets the maximum number of drops per round
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = level.maxPowerupsPerRound;
	level.powerupDropRate = getDvarIntDefault( "powerupDropRate", 2000 );                       //sets the powerup drop rate lower is better
	level.zombie_vars["zombie_powerup_drop_increment"] = level.powerupDropRate;
	level.customSpectatorsRespawn = getDvarIntDefault( "customSpectatorsRespawn", 1 );          //sets whether spectators respawn at the end of the round
	level.zombie_vars[ "spectators_respawn" ] = level.customSpectatorsRespawn;
	level.zombieIntermissionTime = getDvarIntDefault( "zombieIntermissionTime", 20 );           //sets the time that the game takes during the end game intermission
	level.zombie_vars["zombie_intermission_time"] = level.zombieIntermissionTime;
	level.zombieBetweenRoundTime = getDvarIntDefault( "zombieBetweenRoundTime", 15 );           //the time between rounds
	level.zombie_vars["zombie_between_round_time"] = level.zombieBetweenRoundTime;
	level.roundStartDelay = getDvarIntDefault( "roundStartDelay", 0 );                          //time before the game starts 
	level.zombie_vars[ "game_start_delay" ] = level.roundStartDelay;
	level.empPerkExplosionRadius = getDvarIntDefault( "empPerkExplosionRadius", 420 );          //sets the radius of emps explosion lower this to 1 to render emps useless
	level.zombie_vars[ "emp_perk_off_range" ] = level.empPerkExplosionRadius;
	level.empPerkOffDuration = getDvarIntDefault( "empPerkOffDuration", 90 );                   //sets the duration of emps on perks set to 0 for infiinite emps
	level.zombie_vars[ "emp_perk_off_time" ] = level.empPerkOffDuration;
	level.riotshieldHitPoints = getDvarIntDefault( "riotshieldHitPoints", 2250 );               //riotshield health 
	level.zombie_vars[ "riotshield_hit_points" ] = level.riotshieldHitPoints;
	level.juggHealthBonus = getDvarIntDefault( "juggHealthBonus", 160 );                        //jugg health bonus
	level.zombie_vars[ "zombie_perk_juggernaut_health" ] = level.juggHealthBonus;	
	level.permaJuggHealthBonus = getDvarIntDefault( "permaJuggHealthBonus", 190 );              //perma jugg health bonus 
	level.zombie_vars[ "zombie_perk_juggernaut_health_upgrade" ] = level.permaJuggHealthBonus;
	level.minPhdExplosionDamage = getDvarIntDefault( "minPhdExplosionDamage", 1000 );           //phd min explosion damage
	level.zombie_vars[ "zombie_perk_divetonuke_min_damage" ] = level.minPhdExplosionDamage;
	level.maxPhdExplosionDamage = getDvarIntDefault( "maxPhdExplosionDamage", 5000 );           //phd max explosion damage
	level.zombie_vars[ "zombie_perk_divetonuke_max_damage" ] = level.maxPhdExplosionDamage;
	level.phdDamageRadius = getDvarIntDefault( "phdDamageRadius", 300 );                        //phd explosion radius
	level.zombie_vars[ "zombie_perk_divetonuke_radius" ] = level.phdDamageRadius;
	disable_specific_powerups();
	checks();
}

checks()
{
	if ( level.start_weapon == "" || level.start_weapon== "m1911_zm" )
	{
		level.start_weapon = "m1911_zm";
		if ( level.script == "zm_tomb" )
		{
			level.start_weapon = "c96_zm";
		}
	}
	if ( level.default_laststandpistol == "" || level.default_laststandpistol == "m1911_zm" )
	{
		level.default_laststandpistol = "m1911_zm";
		if ( level.script == "zm_tomb" )
		{
			level.default_laststandpistol = "c96_zm";
		}
	}
	if ( level.default_solo_laststandpistol == "" || level.default_solo_laststandpistol == "m1911_upgraded_zm" )
	{
		level.default_solo_laststandpistol = "m1911_upgraded_zm";
		if ( level.script == "zm_tomb" )
		{
			level.default_solo_laststandpistol = "c96_upgraded_zm";
		}
	}
//	if ( level.mixed_rounds_enabled )
//	{
//		if ( level.script != "zm_transit" || is_classic() || level.scr_zm_ui_gametype == "zgrief" )
//		{
//			level.mixed_rounds_enabled = 0;
//		}
//	}
}

disable_specific_powerups()
{
	level.powerupNames = array( "fast_feet", "unlimited_ammo", "pack_a_punch", "money_drop", "nuke", "insta_kill", "full_ammo", "double_points", "fire_sale", "free_perk", "carpenter" );
	array = level.powerupNames;

	level.zmPowerupsEnabled = [];
	level.zmPowerupsEnabled[ "fast_feet" ] = spawnstruct();
	level.zmPowerupsEnabled[ "fast_feet" ].name = "fast_feet";
	level.zmPowerupsEnabled[ "fast_feet" ].active = getDvarIntDefault( "zmPowerupsFastFeetEnabled", 1 );
	level.zmPowerupsEnabled[ "unlimited_ammo" ] = spawnstruct();
	level.zmPowerupsEnabled[ "unlimited_ammo" ].name = "unlimited_ammo";
	level.zmPowerupsEnabled[ "unlimited_ammo" ].active = getDvarIntDefault( "zmPowerupsUnlimitedAmmoEnabled", 1 );
	level.zmPowerupsEnabled[ "pack_a_punch" ] = spawnstruct();
	level.zmPowerupsEnabled[ "pack_a_punch" ].name = "pack_a_punch";
	level.zmPowerupsEnabled[ "pack_a_punch" ].active = getDvarIntDefault( "zmPowerupsPackAPunchEnabled", 1 );
	level.zmPowerupsEnabled[ "money_drop" ] = spawnstruct();
	level.zmPowerupsEnabled[ "money_drop" ].name = "money_drop";
	level.zmPowerupsEnabled[ "money_drop" ].active = getDvarIntDefault( "zmPowerupsMoneyDropEnabled", 1 );
	level.zmPowerupsEnabled[ "nuke" ] = spawnstruct();
	level.zmPowerupsEnabled[ "nuke" ].name = "nuke";
	level.zmPowerupsEnabled[ "nuke" ].active = getDvarIntDefault( "zmPowerupsNukeEnabled", 1 );
	level.zmPowerupsEnabled[ "insta_kill" ] = spawnstruct();
	level.zmPowerupsEnabled[ "insta_kill" ].name = "insta_kill";
	level.zmPowerupsEnabled[ "insta_kill" ].active = getDvarIntDefault( "zmPowerupsInstaKillEnabled", 1 );
	level.zmPowerupsEnabled[ "full_ammo" ] = spawnstruct();
	level.zmPowerupsEnabled[ "full_ammo" ].name = "full_ammo";
	level.zmPowerupsEnabled[ "full_ammo" ].active = getDvarIntDefault( "zmPowerupsMaxAmmoEnabled", 1 );
	level.zmPowerupsEnabled[ "double_points" ] = spawnstruct();
	level.zmPowerupsEnabled[ "double_points" ].name = "double_points";
	level.zmPowerupsEnabled[ "double_points" ].active = getDvarIntDefault( "zmPowerupsDoublePointsEnabled", 1 );
	level.zmPowerupsEnabled[ "fire_sale" ] = spawnstruct();
	level.zmPowerupsEnabled[ "fire_sale" ].name = "fire_sale";
	level.zmPowerupsEnabled[ "fire_sale" ].active = getDvarIntDefault( "zmPowerupsFireSaleEnabled", 1 );
	level.zmPowerupsEnabled[ "free_perk" ] = spawnstruct();
	level.zmPowerupsEnabled[ "free_perk" ].name = "free_perk";
	level.zmPowerupsEnabled[ "free_perk" ].active = getDvarIntDefault( "zmPowerupsPerkBottleEnabled", 1 );
	level.zmPowerupsEnabled[ "carpenter" ] = spawnstruct();
	level.zmPowerupsEnabled[ "carpenter" ].name = "carpenter";
	level.zmPowerupsEnabled[ "carpenter" ].active = getDvarIntDefault( "zmPowerupsCarpenterEnabled", 1 );
	level.zmPowerupsEnabled[ "zombie_blood" ] = spawnstruct();
	level.zmPowerupsEnabled[ "zombie_blood" ].name = "zombie_blood";
	level.zmPowerupsEnabled[ "zombie_blood" ].active = getDvarIntDefault( "zmPowerupsZombieBloodEnabled", 1 );
		
	for ( i = 0; i < array.size; i++ )
	{	
		if ( !level.zmPowerupsEnabled[ array[ i ] ].active )
		{
			name = level.zmPowerupsEnabled[ array[ i ] ].name;
			if ( isInArray( level.zombie_include_powerups, name ) )
			{
				arrayremovevalue( level.zombie_include_powerups, name );
			}
			if ( isInArray( level.zombie_powerups, name ) )
			{
				arrayremovevalue( level.zombie_powerups, name );
			}
			if ( isInArray( level.zombie_powerup_array, name ) )
			{
				arrayremovevalue( level.zombie_powerup_array, name );
			}
		}
	}
}

spawnIfRoundOneOrTwo()
{
	wait 3;
	if ( self.sessionstate == "spectator" && level.round_number < 3 )
		self iprintln("Get ready to be spawned!");
	wait 5;
	if ( self.sessionstate == "spectator" && level.round_number < 3 )
	{
		self [[ level.spawnplayer ]]();
		if ( level.script != "zm_tomb" || level.script != "zm_prison" || !is_classic() )
			thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
	}
}

waitForTheNuke()
{
	self thread giveBetterNukePoints();
}

giveBetterNukePoints()
{
	while(true)
	{
		self waittill("nuke_triggered");
        points = (get_current_zombie_count() * (40 * (5-level.players.size)));
		iprintln("^4<(^3DRF^4)>^7SuperNuke! ^2" + convert_to_thousands(points) + "^7 extra points!");
		foreach ( player in level.players )
        {
        	player.score += points;
        }
        wait 0.02;
    }
}

waitForTheMaxAmmo()
{
	self thread giveBetterMaxAmmo();
}

giveBetterMaxAmmo()
{
	while(true)
	{
		self waittill("zmb_max_ammo");
		iprintln("^4<(^3DRF^4)>^7Max Ammo Stock and Clip!");
		foreach ( player in level.players )
        {
			currentWeapon = self getcurrentweapon();
			if ( currentWeapon != "none" )
        	{
	            self setweaponammoclip( currentWeapon, weaponclipsize(currentWeapon) );
	            self givemaxammo( currentWeapon );
	        }

	        currentoffhand = self getcurrentoffhand();
	        if ( currentoffhand != "none" )
			{
	            self givemaxammo( currentoffhand );
		    }
        }
        wait 0.02;
    }
}