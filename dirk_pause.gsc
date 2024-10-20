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
#include scripts\zm\dirk_casino;

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
        player.can_i_pause = true;
    }
}

onplayerspawned()
{
    
    level endon("game_ended");
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("spawned_player");
        self.gameispaused = false;
        self.numberofpausesleft = 3;
        self.pauseoverlap = 0;
    }
}

go_afk(lang, time, prize)
{
    if(prize==-1) //testing
    {
        if(self.can_i_pause)
        {
            self thread drawPauseTimer(time, lang, 99);
        }
    }
    if(prize==0)
    {
        if(self.numberofpausesleft < 1 && time==60)
        {
            if(lang == "spanish")
                self iprintln("^4<(^3DRF^4)>^1SE TE ACABARON LAS PAUSAS!");
            else
                self iprintln("^4<(^3DRF^4)>^1YOU ARE OUT OF PAUSES!");
        }
        else if(self.gameispaused)
        {
            if(lang == "spanish")
                self iprintln("^4<(^3DRF^4)>^1YA ESTAS EN PAUSA");
            else
                self iprintln("^4<(^3DRF^4)>^1YOU ARE ALREADY PAUSED!");
        }
        else
        {
            if(self.can_i_pause)
            {
                self.numberofpausesleft--;
                self thread drawPauseTimer(time, lang, 0);
            }
            else
                self iprintln("^4<(^3DRF^4)>^1NICE TRY!");  
        }
    }
    else
    {
        if(prize == 1)  //longpause
        {
            if(self.has_long_pause)
            {
                if(self.gameispaused)
                {
                    if(lang == "spanish")
                        self iprintln("^4<(^3DRF^4)>^1YA ESTAS EN PAUSA");
                    else
                        self iprintln("^4<(^3DRF^4)>^1YOU ARE ALREADY PAUSED!");
                }
                else
                {
                    self thread drawPauseTimer(time, lang, 0);
                    self.has_long_pause=false;
                }
            }
            else
            {
                if(lang == "spanish")
                    self iprintln("^4<(^3DRF^4)>^1NO TIENES NINGUNA PAUSA LARGA!");
                else
                    self iprintln("^4<(^3DRF^4)>^1YOU DON'T HAVE ANY LONG PAUSES!");
            }
        }
        else if(prize == 2)  //freedom
        {
            if(self.has_freedom)
            {
                if(self.gameispaused)
                {
                    if(lang == "spanish")
                        self iprintln("^4<(^3DRF^4)>^1YA ESTAS EN PAUSA");
                    else
                        self iprintln("^4<(^3DRF^4)>^1YOU ARE ALREADY PAUSED!");
                }
                else
                {
                    self thread drawPauseTimer(time, lang, 1);
                    self.has_freedom=false;
                }
            }
            else
            {
                if(lang == "spanish")
                    self iprintln("^4<(^3DRF^4)>^1NO TIENES UN PASE DE LIBERTAD!");
                else
                    self iprintln("^4<(^3DRF^4)>^1YOU DON'T HAVE A FREEDOM PASS!");
            }
        }
    }
}

drawPauseTimer(time, lang, special)
{
    self.pauseoverlap++;
    self.gameispaused = true;  
    self.gamestateone = newClientHudElem(self);
    self.gamestateone.alignx = "center";
    self.gamestateone.aligny = "top";
    self.gamestateone.horzalign = "user_center";
    self.gamestateone.vertalign = "user_top";
    self.gamestateone.x = 0;
    self.gamestateone.y = 20;
    self.gamestateone.fontscale = 1;
    self.gamestateone.hidewheninmenu = 1;
    self.gamestateone.alpha = 1;

    self.pausetimer = newClientHudElem(self);
    self.pausetimer.alignx = "center";
    self.pausetimer.aligny = "top";
    self.pausetimer.horzalign = "user_center";
    self.pausetimer.vertalign = "user_top";
    self.pausetimer.x = 0;
    self.pausetimer.y = 33;
    self.pausetimer.fontscale = 1;
    self.pausetimer.hidewheninmenu = 1;
    self.pausetimer.alpha = 1;
    self.pausetimer.color = (1, 0.2, 0.2);

    self.ignoreme = 1;
    self EnableInvulnerability();

    self.pausetimer setTimer(time);

    if(special == 99) //testing
    {
        self.gamestateone.label = &"^7                                You are testing for                                \n \n                           Type ^2.back ^7to return now.";
    }

    else if(special == 0)
    {
        self.gamestateone setValue(self.numberofpausesleft);
        if(lang == "spanish")
            self.gamestateone.label = &"^7                                        Estas en pausa por                                        \n \n Escriba ^2.reanudar ^7para reanudar.  Número de pausas restantes: ^1";
        else
            self.gamestateone.label = &"^7                                You are paused for                                \n \n Type ^2.back ^7to unpause now.  Number of pauses left: ^1";

        self freezeControls(true);
    }
    else
        if(lang == "spanish")
            self.gamestateone.label = &"^7Libre de hacer lo que quieras durante \n \n         Escriba ^2.reanudar ^7para terminarlo.";
        else
            self.gamestateone.label = &"^7Free to do what you want for \n \n         Type ^2.back ^7to end it.";

    wait time;
    self.pauseoverlap--;
    if(self.pauseoverlap==0)
        self thread back_afk();
}

back_afk()
{
    self DisableInvulnerability();
    self.gamestateone destroy();
    self.pausetimer destroy();
    self freezeControls(false);
    wait 1;
    self.ignoreme = 0;
    self.gameispaused = false;
}