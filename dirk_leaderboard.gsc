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



show_the_leaders(player, lang)
{
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7===^4<(^3DRF^4)>^7 Clasificación esta temporada===");
    else
        player iprintln("^4<(^3DRF^4)>^7===^4<(^3DRF^4)>^7 Leaderboard this season===");

    for (i = 1; i < 4; i++)
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
    for (i = 1; i < 4; i++)
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
    for (i = 1; i < 4; i++)
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
    wait 1.5;
    if(lang=="spanish")
        player iprintln("^4<(^3DRF^4)>^7Las clasificaciones se actualizan cada 15 minutos.");
    else
        player iprintln("^4<(^3DRF^4)>^7Rankings update every 15 minutes.");
}