#include maps\mp_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm_hud_util;
#include maps\mp\gametypes_zm_hud_message;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;

init()
{
	thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
    level waittill( "connected", player );
        player thread game_timer_hud();
        player thread round_timer_hud();
    }
}

game_timer_hud()
{
    self endon("disconnect");

    self.timer = newClientHudElem(self);
    self.timer.alignx = "left";
    self.timer.aligny = "top";
    self.timer.horzalign = "user_left";
    self.timer.vertalign = "user_top";
    self.timer.x = 5;
    self.timer.y = 2;
    self.timer.fontscale = 1.4;
    self.timer.alpha = 0;
    self.timer.color = ( 1, 1, 1 );
    self.timer.hidewheninmenu = 1;
    flag_wait( "initial_blackscreen_passed" );
    self.timer.alpha = 1;
    self.timer setTimerUp(0);
}

round_timer_hud()
{
    self endon("disconnect");
	
    self.round_timer_hud = newClientHudElem(self);
    self.round_timer_hud.alignx = "left";
    self.round_timer_hud.aligny = "top";
    self.round_timer_hud.horzalign = "user_left";
    self.round_timer_hud.vertalign = "user_top";
    self.round_timer_hud.x = 5;
    self.round_timer_hud.y = 14;
    self.round_timer_hud.fontscale = 1.4;
    self.round_timer_hud.alpha = 0;
    self.round_timer_hud.color = ( 0, 1, 1 );
    self.round_timer_hud.hidewheninmenu = 1;

    flag_wait( "initial_blackscreen_passed" );

    self.round_timer_hud.alpha = 0.75;

    while (1)
    {
        self.round_timer_hud setTimerUp(0);
        start_time = int(getTime() / 1000);

        level waittill( "end_of_round" );

        end_time = int(getTime() / 1000);
        time = end_time - start_time;

        set_time_frozen(self.round_timer_hud, time);
    }
}

set_time_frozen(hud, time)
{
    level endon( "start_of_round" );
    time -= .1; 
    while (1)
    {
        hud setTimer(time);
        wait 0.5;
    }
}