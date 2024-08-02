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
#include scripts\zm\dirk_box;


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
        player thread display_the_dice();
    }
}

onplayerspawned()
{
    
    level endon("game_ended");
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        self.is_rolling = false;
        self.is_playing = false;
        self.has_long_pause = false;
        self.has_freedom = false;
    }
}

roll_the_dice(lang)
{
    if(self.is_playing)
    {
        if(lang=="spanish")
            self iprintln("^4<(^3DRF^4)>^7Espere hasta que se complete el rollo anterior!");
        else
            self iprintln("^4<(^3DRF^4)>^7Wait until previous roll is complete!");
    }
    else
    {   
        if(self.score < 1000)
        {
            if(lang=="spanish")
                self iprintln("^4<(^3DRF^4)>^7Necesitas ^1$^21,000 ^7para girar!");
            else
                self iprintln("^4<(^3DRF^4)>^7You need ^1$^21,000 ^7to spin!");
        }
        else
        {
            self.the_dice_text = newClientHudElem(self);
            self.the_dice_text.alignx = "left";
            self.the_dice_text.aligny = "bottom";
            self.the_dice_text.horzalign = "user_left";
            self.the_dice_text.vertalign = "user_bottom";
            self.the_dice_text.x = 10;
            self.the_dice_text.y = -120;
            self.the_dice_text.fontscale = 2;
            if(lang=="spanish")
                self.the_dice_text setText("Girando...");
            else
                self.the_dice_text setText("Spinning...");

            self.the_dice = newClientHudElem(self);
            self.the_dice.alignx = "left";
            self.the_dice.aligny = "bottom";
            self.the_dice.horzalign = "user_left";
            self.the_dice.vertalign = "user_bottom";
            self.the_dice.x = 30;
            self.the_dice.y = -100;
            self.the_dice.fontscale = 2;
            self.the_dice.label = &"";

            self play_sound_at_pos( "music_chest", self.origin );
            self.score -= 1000;
            self.is_playing = true;
            self.is_rolling = true;
            wait 4;
            self.is_rolling = false;
            wait 2;
            self.the_dice_text destroy();
            self.the_dice destroy();
            self give_the_prize(lang);
            self.is_playing = false;
        }
    }
}

display_the_dice()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    while(true)
    {
        if(self.is_rolling)
        {
            self.dice_result = randomint(100);
            self.the_dice setValue(self.dice_result);
            self set_dice_color();
        }
        wait .1;
    }
}

set_dice_color()
{
    if(self.dice_result <= 100 && self.dice_result >= 78)
        self.the_dice.color = (0, 1, 0.5);
    else if(self.dice_result <= 80 && self.dice_result >= 38)
        self.the_dice.color = (1, 1, 0);
    else if(self.dice_result <= 40 && self.dice_result >= 21)
        self.the_dice.color = (1, 0.5, 0);
    else if(self.dice_result <= 25 && self.dice_result >= 0)
        self.the_dice.color = (1, 0.2, 0.2);
}

give_the_prize(lang)
{
    if(self.dice_result > 97)
        self winWeapon( "raygun_mark2_zm" );
    else if(self.dice_result > 92)
        self winWeapon( "rpd_zm" );
    else if(self.dice_result > 87)
        self winWeapon( "hamr_zm" );
    else if(self.dice_result > 82)
        self winWeapon( "cymbal_monkey_zm" );
    else if(self.dice_result > 77)
        self winOtherPrize(lang, 2); //freedom
    else if(self.dice_result > 69)
        self winPowerUp( "full_ammo" );
    else if(self.dice_result > 61)
        self winPowerUp( "double_points" );
    else if(self.dice_result > 53)
        self winPowerUp( "insta_kill" );
    else if(self.dice_result > 45)
        self winOtherPrize(lang, 1); //longpause
    else if(self.dice_result > 37)
        self winPowerUp( "nuke" );
    else if(self.dice_result > 29)
        self winPoints(2000);
    else if(self.dice_result > 24)
        self winPoints(1000);
    else if(self.dice_result > 20)
        self winPoints(500);
    else if(self.dice_result == 0)
        self winOtherPrize(lang, 0); //death
    //{
        //play_sound_at_pos( "grab_metal_bar", self.origin );
        //self.health = 1;
        //earthquake(0.6,10,self.origin,100000);
        //self winOtherPrize(2); //longpause
    //}  
    else
    {
        foreach (player in level.players)
            player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 didn't win anything!!");
    }
}

winOtherPrize(lang, prize)
{
    if(prize==0) //death
    {
        foreach (player in level.players)
            player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 rolled a ^10 ^7and now has to die!");
        wait 2;
        if(level.players.size > 1)
        {
            self dodamage(self.health, self.origin);
        }
        else
        {
            if(lang=="spanish")
                self iprintln("^4<(^3DRF^4)>^7Olvídalo... no hay nadie que te reviva!");
            else
                self iprintln("^4<(^3DRF^4)>^7Never mind... there's no one to revive you!");
        }

    }
    else if(prize==1) //longpause
    {
        self.has_long_pause = true;
        foreach (player in level.players)
            player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 won ^2a 5 Minute Pause^7!");
        if(lang=="spanish")
            self iprintln("^4<(^3DRF^4)>^7úsalo con ^2.largapausar^7!");
        else
            self iprintln("^4<(^3DRF^4)>^7Use it with ^2.longpause^7!");
    }
    else if(prize==2) //5 minutes in heaven
    {
        self.has_freedom = true;
        foreach (player in level.players)
            player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 won ^25 Minutes of Freedom^7!");
        if(lang=="spanish")
            self iprintln("^4<(^3DRF^4)>^7úsalo con ^2.libertad^7!");
        else
            self iprintln("^4<(^3DRF^4)>^7Use it with ^2.freedom^7!");
    }
}

winPowerUp(powerupName)
{
    level.powerup_drop_count = 0;
    powerup = level specific_powerup_drop(powerupName, self.origin + vectorscale( ( 0, 0, 1 ), 40.0 ));
    powerup thread powerup_timeout();
    nicepowerupname = self getNicePowerUpName(powerupName);
    foreach (player in level.players)
        player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 won ^2" + nicepowerupname + "^7!");
}

winWeapon(weaponName)
{
    self set_the_box(weaponName);
    niceweaponname = self getNicePrizeName(weaponName);
    foreach (player in level.players)
        player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 won ^2" + niceweaponname + "^7!");
    if(self.requestedlanguage == 0)
        self iprintln("^4<(^3DRF^4)>^7Your Next Box Spin will be ^2" + niceweaponname + "^7!");
    else if(self.requestedlanguage == 1)
        self iprintln("^4<(^3DRF^4)>^7Tu próximo giro de MagicBox será ^2" + niceweaponname + "^7!");
}

winPoints(points)
{
    num_amount = points;
    over_balance = self.score + points - 1000000;
	max_score_available = abs( self.score - 1000000 );
	if ( over_balance > 0 ) // 50 > 0
		num_amount = max_score_available;
	self.score += num_amount;

    foreach (player in level.players)
        player iprintln("^4<(^3DRF^4)>^2" + self.name + "^7 won ^1" + convert_to_money(points) + " ^7!");
}

getNicePrizeName(therawweaponname)
{
    switch ( therawweaponname )
    {
        case "raygun_mark2_zm":
            return "^7a ^2Ray Gun Mark II";
        case "rpd_zm":
            return "^7an ^2RPD";
        case "hamr_zm":
            return "^7a ^2HAMR";
        case "cymbal_monkey_zm":
            return "^7some ^2Monkeys";
        default:
            return "";
    }
}

getNicePowerUpName(therawpowerupname)
{
    switch ( therawpowerupname )
    {
        case "nuke":
            return "^7a ^2Nuke";
        case "insta_kill":
            return "^7an ^2Insta Kill";
        case "double_points":
            return "Double Points";
        case "full_ammo":
            return "^7a ^2Max Ammo";
        default:
            return "";
    }
}