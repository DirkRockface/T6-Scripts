#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\gametypes_zm\_hud_message;
#include scripts\zm\dirk_bank;

init()
{
    level endon( "end_game" );
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread showleaderboard();
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

showleaderboard()
{
    self endon("disconnect");


    self.hiallkillline = "";
    self.hiallkillname = leader_name_read("all", 1);
    if(self.hiallkillname=="noleadername")
        self.hiallkillline = "Kill Leader all maps: ^2Nobody yet";
    else
    {
        self.hiallkillnumber = leader_kill_read("all", 1);
        self.hiallkillline = "Kill Leader all maps:       ^2" + self.hiallkillname + "^7 -> ^3" + self convert_to_thousands(self.hiallkillnumber) + " kills^7";
    }

    self.myallkillline = "";
    self.myallkillrank = rank_read("all");
    if(self.myallkillrank=="norank")
        self.myallkillline = "    You have no rank yet";
    else
    {
        self.myallkillnumber = all_kill_read();
        self.myallkillline = "    You rank ^3" + self.myallkillrank + "^7 with ^3" + self convert_to_thousands(self.myallkillnumber) + " kills^7";
    }
    
    self.hikillline = "";
    self.hikillname = leader_name_read("map", 1);
    if(self.hikillname=="noleadername")
        self.hikillline = "Kill Leader this map: ^2Nobody yet";
    else
    {
        self.hikillnumber = leader_kill_read("map", 1);
        self.hikillline = "Kill Leader this map:       ^2" + self.hikillname + "^7 -> ^3" + self convert_to_thousands(self.hikillnumber) + " kills^7";
    }

    self.mykillline = "";
    self.mykillrank = rank_read("map");
    if(self.mykillrank=="norank")
        self.mykillline = "    You have no rank yet";
    else
    {
        self.mykillnumber = map_kill_read();
        self.mykillline = "    You rank ^3" + self.mykillrank + "^7 with ^3" + self convert_to_thousands(self.mykillnumber) + " kills^7";
    }

    self.hiroundline = "";
    self.hiroundname = leader_roundname_read("map", 1);
    if(self.hiroundname=="noleadername")
        self.hiroundline = "Round Leader this map: ^2Nobody yet";
    else
    {
        self.hiroundnumber = leader_round_read("map", 1);
        self.hiroundline = "Round Leader this map: ^2" + self.hiroundname + "^7 -> ^3Round " + self.hiroundnumber + "^7";
    }

    self.myroundline = "";
    self.myhighround = map_round_read();
    self.myroundline = "    Your high round is ^3" + self.myhighround + "^7";


	self.leaderboard = newClientHudElem(self);
    self.leaderboard.alignx = "left";
    self.leaderboard.aligny = "top";
    self.leaderboard.horzalign = "user_left";
    self.leaderboard.vertalign = "user_top";
    self.leaderboard.x = 5;
    self.leaderboard.y = 38;
    self.leaderboard.fontscale = 1;
	self.leaderboard.alpha = 0;
    self.leaderboard.color = ( 1, 1, 1 );
	self.leaderboard.hidewheninmenu = 1;

    self.leaderboard2 = newClientHudElem(self);
    self.leaderboard2.alignx = "left";
    self.leaderboard2.aligny = "top";
    self.leaderboard2.horzalign = "user_left";
    self.leaderboard2.vertalign = "user_top";
    self.leaderboard2.x = 5;
    self.leaderboard2.y = 85;
    self.leaderboard2.fontscale = 1;
	self.leaderboard2.alpha = 0;
    self.leaderboard2.color = ( 1, 1, 1 );
	self.leaderboard2.hidewheninmenu = 1;

	flag_wait( "initial_blackscreen_passed" );

    self.leaderboard.alpha = 1;
    self.leaderboard2.alpha = 2;
    self.leaderboard setText("^4THIS SEASON'S LEADERBOARD:^7\n" + self.hiallkillline + "\n" + self.myallkillline + "\n" + self.hikillline);
    self.leaderboard2 setText(self.mykillline + "\n" + self.hiroundline + "\n" + self.myroundline);
    wait 22;
	self.leaderboard destroy();
    self.leaderboard2 destroy();
}

show_the_leaders(player, lang)
{
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7===^4<(^3DRF^4)>^7 Clasificación esta temporada===");
    else
        player iprintln("^4<(^3DRF^4)>^7===^4<(^3DRF^4)>^7 Leaderboard this season===");

    for (i = 1; i < 5; i++)
    {
        leader_names[i] = leader_name_read("all", i);
        if(leader_names[i]=="noleadername")
        {
            if(lang=="spanish")
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1Nadie");
            else
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1Nobody");
            wait 1.5;
        }
        else
        {
            leader_kills[i] = leader_kill_read("all", i);
            if(lang=="spanish")
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1" + leader_names[i] + "^7 con ^2" + player convert_to_thousands(leader_kills[i]) + "^7 matar");
            else
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1" + leader_names[i] + "^7 with ^2" + player convert_to_thousands(leader_kills[i]) + "^7 kills");
            wait 1.5;
        }
    }
    wait 2;
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7===Tabla de clasificación esta temporada para este mapa===");
    else
        player iprintln("^4<(^3DRF^4)>^7===Leaderboard this season for this map===");
    for (i = 1; i < 5; i++)
    {
        map_leader_names[i] = leader_name_read("map", i);
        if(map_leader_names[i]=="noleadername")
        {
            if(lang=="spanish")
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1Nadie");
            else
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1Nobody");
            wait 1.5;
        }
        else
        {
            map_leader_kills[i] = leader_kill_read("map", i);
            if(lang=="spanish")
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1" + map_leader_names[i] + "^7 con ^2" + player convert_to_thousands(map_leader_kills[i]) + "^7 matar");
            else
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1" + map_leader_names[i] + "^7 with ^2" + player convert_to_thousands(map_leader_kills[i]) + "^7 kills");
            wait 1.5;
        }
    }
    wait 2;
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7===Ronda alta esta temporada para este mapa===");
    else
        player iprintln("^4<(^3DRF^4)>^7===High Round this season for this map===");
    for (i = 1; i < 5; i++)
    {
        round_leader_names[i] = leader_roundname_read("map", i);
        if(round_leader_names[i]=="noleadername")
        {
            if(lang=="spanish")
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1Nadie");
            else
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1Nobody");
            wait 1.5;
        }
        else
        {
            round_leader_round[i] = leader_round_read("map", i);
            if(lang=="spanish")
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1" + round_leader_names[i] + "^7 : Round ^2" + round_leader_round[i] + "^7");
            else
                player iprintln("^4<(^3DRF^4)>^3  "+i+". ^1" + round_leader_names[i] + "^7 : Round ^2" + round_leader_round[i] + "^7");
            wait 1.5;
        }
    }
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7Las clasificaciones se actualizan cada 15 minutos.");
    else
        player iprintln("^4<(^3DRF^4)>^7Rankings update every 15 minutes.");

}

show_my_rank(player, lang)
{
    my_rank_string = player rank_read("all");
    if(my_rank_string=="norank")
        if(lang=="spanish")
            player iprintln("^4<(^3DRF^4)>^7No tienes una clasificacion en ^4<(^3DRF^4)>^7!");
        else
            player iprintln("^4<(^3DRF^4)>^7You do not have a rank on ^4<(^3DRF^4)>^7 yet!");
    else
    {
        my_kill_count = player all_kill_read();
        if(lang=="spanish")
            player iprintln("^4<(^3DRF^4)>^7Ocupas el puesto ^3" + my_rank_string + "^7 en ^4<(^3DRF^4)> ^7servers con ^2" + player convert_to_thousands(my_kill_count) + "^7 matar");
        else
            player iprintln("^4<(^3DRF^4)>^7You rank ^3" + my_rank_string + "^7 on ^4<(^3DRF^4)> ^7servers with ^2" + player convert_to_thousands(my_kill_count) + "^7 kills");
    }
    wait 2.0;
    my_map_rank_string = player rank_read("map");
    if(my_map_rank_string=="norank")
        if(lang=="spanish")
            player iprintln("^4<(^3DRF^4)>^7Aun no tienes un rango en este mapa!");
        else
            player iprintln("^4<(^3DRF^4)>^7You do not have a rank on this map yet!");
    else
    {
        my_map_kill_count = player map_kill_read();
        if(lang=="spanish")
            player iprintln("^4<(^3DRF^4)>^7Ocupas el puesto ^3" + my_map_rank_string + "^7 en este mapa con ^2" + player convert_to_thousands(my_map_kill_count) + "^7 matar");
        else
            player iprintln("^4<(^3DRF^4)>^7You rank ^3" + my_map_rank_string + "^7 on this map with ^2" + player convert_to_thousands(my_map_kill_count) + "^7 kills");
    }
    wait 2.0;
    my_map_round = player map_round_read();
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7Has llegado a la ronda ^2" + my_map_round + "^7 en este mapa esta temporada!");
    else
        player iprintln("^4<(^3DRF^4)>^7You have made it as high as round ^2" + my_map_round + "^7 on this map this season!");
    wait 1.5;
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7Las clasificaciones se actualizan cada 15 minutos.");
    else
        player iprintln("^4<(^3DRF^4)>^7Rankings update every 15 minutes.");
}