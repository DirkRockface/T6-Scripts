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

#define FOG_OFF 0
#define FOG_ON 1
#define WAIT_TIME_TINY 1
#define WAIT_TIME_SHORT 2
#define WAIT_TIME_LONG 15

init() // entry point
{
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
        player thread display_welcome(player);
    }
}

onplayerspawned()
{
    
    level endon("game_ended");
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        self setclientdvar("r_fog", FOG_OFF);   //No fog
        self.isfoggy=0;
    }
}

display_welcome(player)
{
    wait WAIT_TIME_LONG;
    player iprintln("^4<(^3DRF^4)>^7type ^3.help ^7or ^3.commands ^7for a list of commands");
    wait WAIT_TIME_SHORT;
    player iprintln("^4<(^3DRF^4)>^7escriba ^3.ayuda ^7o ^3.comandos ^7para obtener una lista de comandos");
}

display_help(player, lang)
{
    if (lang == "spanish") {
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.banco ^7para obtener una lista de comandos bancarios");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.elcasino ^7para ver cómo apostar por premios");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.hudsp ^7fpara obtener una lista de comandos de hud");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.niebla ^7para activar/desactivar la niebla");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.pausar ^7para pausar el juego por ti");
    } else { // default to English
        player iprintln("^4<(^3DRF^4)>^7type ^3.bank ^7for a list of bank commands");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.casino ^7to see how gamble for prizes");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.hud ^7for a list of hud commands");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.fog ^7to toggle fog on/off");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.afk ^7to pause game for you");
    }
}

display_bank_help(player, lang)
{
    if (lang == "spanish") {
        player iprintln("^4<(^3DRF^4)>^7El ^2BANCO ^7se comparte entre todos los servidores ^4<(^3DRF^4)>^7.");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.b ^7para consultar su saldo");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.d xxxx ^7para depositar dinero");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.w xxxx ^7para retirar dinero");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.t xxxx NOMBRE ^7para transferir dinero");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7puedes simplemente escribir el comienzo del nombre de un jugador para transferir");
    } else { // default to English
        player iprintln("^4<(^3DRF^4)>^7The ^2BANK ^7is shared across all ^4<(^3DRF^4)>^7 servers.");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.b ^7to check your balance");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.d xxxx ^7to deposit");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.w xxxx ^7to withdraw");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.t xxxx PLAYERNAME ^7to transfer");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7you can just type the beginning of a player's name to transfer");
    }
}

display_hud_help(player, lang)
{
    if (lang == "spanish") {
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.tog_hud ^7para activar/desactivar el HUD personalizado");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.tog_h ^7para activar/desactivar la información de salud");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.tog_a ^7para activar/desactivar la información de munición");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.tog_z ^7para activar/desactivar el conteo de zombies");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.tog_l ^7para activar/desactivar ubicación");
    } else { // default to English
        player iprintln("^4<(^3DRF^4)>^7type ^3.tog_hud ^7to toggle custom hud on/off");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.tog_h ^7to toggle health info on/off");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.tog_a ^7to toggle ammo count on/off");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.tog_z ^7to toggle zombie count on/off");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.tog_l ^7to toggle location on/off");
    }
}

display_casino_help(player, lang)
{
    if (lang == "spanish") {
        player iprintln("^4<(^3DRF^4)>^7Cuesta ^1$^21,000 ^7para jugar!");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.girar ^7hacer girar la rueda.");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7cuanto mayor sea el número, mayor será el premio!");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7escriba ^3.premios ^7para ver que puedes ganar.");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7déjame saber qué premios quieres ver.");
    } else { // default to English
        player iprintln("^4<(^3DRF^4)>^7It's ^1$^21,000 ^7to play!");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.spin ^7to spin the wheel.");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7the higher the number, the bigger the prize!");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7type ^3.prizes ^7to see what you can win.");
        wait WAIT_TIME_SHORT;
        player iprintln("^4<(^3DRF^4)>^7let me know what prizes you want to see.");
    }
}

display_prizes_help(player, lang)
{
    if (lang == "spanish") {
        player iprintln("^4<(^3DRF^4)>^7Gira para ganar (de mejor a peor):");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Ray Gun Mark 2");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7RPD");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7HAMR");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Monkeys");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^75 Minutos de Libertad");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Municion Maxima");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Puntos dobles");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7InstaKill");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^75 Minutos de Pausar");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Nuke");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Dinero");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Muerte (próximamente)");
    } else { // default to English
        player iprintln("^4<(^3DRF^4)>^7Spin to win (from best to worst):");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Ray Gun Mark 2");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7RPD");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7HAMR");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Monkeys");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^75 Minutes of Freedom");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Max Ammo");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Double Points");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7InstaKill");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^75 Minute Pause");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Nuke");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7Money");
        wait WAIT_TIME_TINY;
        player iprintln("^4<(^3DRF^4)>^7DEATH! (coming soon)");
    }
}

toggle_fog(player)
{
    player.isfoggy = !player.isfoggy;
    player setclientdvar("r_fog", player.isfoggy ? FOG_ON : FOG_OFF);
}

//make a shop
//fine tune casino odds and prizes