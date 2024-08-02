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
#include scripts\zm\dirk_weapon;


init() // entry point
{
    if(getDvarIntDefault( "testingstuff", 0 ))
    {
    //    level thread testingit();
    }
    level endon( "end_game" );
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
        player thread drawHealthCounter();
        player thread listenforweaponswitch();
        player thread listenForFragThrow();
        player thread drawAmmoCounter();
        player thread drawZombieCounter();
        player thread drawZoneHud();
    }
}

testingit()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");
    while(true)
    {
        iprintln(level.scr_zm_map_start_location);
        wait 1;
    }
}

onplayerspawned()
{
    
    level endon("game_ended");
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
//        self thread doGetposition();
        self.hudvisible  = true;
        self.healthvisible = true;
        self.ammovisible = true;
        self.zombiesvisible = true;
        self.zonevisibile = true;
        self.nadesslot = array(0,0,0,0,0,0,0,0);
    }
}

doGetposition() 
{
	self endon ("disconnect"); 
	self endon ("death"); 
	print_pos = 1;
	if (print_pos==1)
	{
		for(;;)
		{
			self.corrected_angles = corrected_angles(self.angles);
			self iPrintln("Angles: "+self.corrected_angles+"\nPosition: "+self.origin);
			wait 2;
		}
	}
}
corrected_angles(angles)
{
	angles = angles + (0, 90, 0);
	if (angles[1] < 0)
	{
		angles = angles + (0, 360, 0);
	}
	return angles;
}

toggle_hud()
{
    if(self.hudvisible)
    {
        self.healthvisible = false;
        self.zombiesvisible = false;
        self.ammovisible = false;
        self.zonevisible = false;
        self.hudvisible = false;
    }
    else
    {
        self.healthvisible = true;
        self.zombiesvisible = true;
        self.ammovisible = true;
        self.zonevisible = true;
        self.hudvisible = true;
    }
}

toggle_health()
{
    if(self.healthvisible)
    {
        self.healthvisible = false;
        if(!self.zombiesvisible && !self.ammovisible && !self.zonevisible)
        {
            self.hudvisible = false;
        }
    }
    else
    {
        self.healthvisible = true;
        if(self.zombiesvisible && self.ammovisible && self.zonevisible)
        {
            self.hudvisible = true;
        }
    }
}

toggle_zombies()
{
    if(self.zombiesvisible)
    {
        self.zombiesvisible = false;
        if(!self.healthvisible && !self.ammovisible && !self.zonevisible)
        {
            self.hudvisible = false;
        }
    }
    else
    {
        self.zombiesvisible = true;
        if(self.healthvisible && self.ammovisible && self.zonevisible)
        {
            self.hudvisible = true;
        }
    }
}

toggle_ammo()
{
    if(self.ammovisible)
    {
        self.ammovisible = false;
        if(!self.healthvisible && !self.zombiesvisible && !self.zonevisible)
        {
            self.hudvisible = false;
        }
    }
    else
    {
        self.ammovisible = true;
        if(self.healthvisible && self.zombiesvisible && self.zonevisible)
        {
            self.hudvisible = true;
        }
    }
}

toggle_zone()
{
    if(self.zonevisible)
    {
        self.zonevisible = false;
        if(!self.healthvisible && !self.zombiesvisible && !self.ammovisible)
        {
            self.hudvisible = false;
        }
    }
    else
    {
        self.zonevisible = true;
        if(self.healthvisible && self.zombiesvisible && self.ammovisible)
        {
            self.hudvisible = true;
        }
    }
}

drawHealthCounter()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");
 
    self.namePlayer = self.name;
    self.health_bar_name_text = self createFontString("Objective", 1);
    self.health_bar_name_text setpoint("CENTER", "BOTTOM", 0, -24);
    self.health_bar_name_text setText(self.namePlayer);
    
    self.health_bar = self createprimaryprogressbar();
    self.health_bar.width = 100;
    self.health_bar.height = 3;
    self.health_bar setpoint ("CENTER", "BOTTOM", -18, -13); //190

	self.healthText = self createFontString("hudsmall" , 1);
    self.healthText setPoint("RIGHT", "BOTTOM", 50, -14);
    self.healthText.label = &"";

    self.MaxhealthText = self createFontString("hudsmall", 1);
    self.MaxhealthText setPoint("LEFT", "BOTTOM", 51, -14);
    self.MaxhealthText.label = &"/";    

    self.sprint_bar = self createprimaryprogressbar();
    self.sprint_bar.width = 100;
    self.sprint_bar.height = 1;
    self.sprint_bar setpoint ("CENTER", "BOTTOM", -18, -11);

    self.sprintcount = 3.5;

    while(true)
    {
        if(self.healthvisible)
        {
            self.health_bar.alpha = 0;
            self.sprint_bar.alpha = 0;
            self.health_bar_name_text.alpha = 1;
            self.health_bar.bar.alpha = 1;
            self.health_bar.barframe.alpha = 1;
            self.healthText.alpha = 1;
            self.MaxhealthText.alpha = 1;
            self.sprint_bar.bar.alpha = 1;
            self.sprint_bar.barframe.alpha =1;

            self.healthText setValue(self.health);
            self.MaxhealthText setValue(self.maxhealth);

            self.ScaleHealth = (self.health / self.maxhealth) * 100;

            self.health_bar updatebar(self.health / self.maxhealth);

            self.sprint_bar updatebar(self.sprintcount / self.maxsprintcount);

            if(self.ScaleHealth <= 100 && self.ScaleHealth >= 71)
            {
                self.healthText.color = (0, 1, 0.5);
                self.MaxhealthText.color = (0, 1, 0.5);
                self.health_bar.bar.color = (0, 1, 0.5);
                self.health_bar_name_text.color = (0, 1, 0.5);
            }
            else if(self.ScaleHealth <= 70 && self.ScaleHealth >= 50)
            {
                self.healthText.color = (1, 1, 0);
                self.MaxhealthText.color = (1, 1, 0);
                self.health_bar.bar.color = (1, 1, 0);
                self.health_bar_name_text.color = (1, 1, 0);
            }
            else if(self.ScaleHealth <= 49 && self.ScaleHealth >= 25)
            {
                self.healthText.color = (1, 0.5, 0);
                self.MaxhealthText.color = (1, 0.5, 0);
                self.health_bar.bar.color = (1, 0.5, 0);
                self.health_bar_name_text.color = (1, 0.5, 0);
            }
            else if(self.ScaleHealth <= 24 && self.ScaleHealth >= 0)
            {
                self.healthText.color = (1, 0.2, 0.2);
                self.MaxhealthText.color = (1, 0.2, 0.2);
                self.health_bar.bar.color = (1, 0.2, 0.2);
                self.health_bar_name_text.color = (1, 0.2, 0.2);
            }

            if(self hasperk("specialty_longersprint"))
            {
                self.maxsprintcount = 7.0;
            }
            else{
                self.maxsprintcount = 3.5;
            }

            if(self issprinting() && self.sprintcount > 0)
            {
                self.sprintcount = self.sprintcount - .1;
                wait .05;
            }
            else if(self.sprintcount < .5)
            {
                self.sprintcount = self.sprintcount + .05;
                wait .05;
            }
            else if(self.sprintcount < self.maxsprintcount)
            {
                self.sprintcount = self.sprintcount + .1;
                wait .05;
            }

        }
        else
        {
            self.health_bar.alpha = 0;
            self.sprint_bar.alpha = 0;
            self.health_bar_name_text.alpha = 0;
            self.health_bar.bar.alpha = 0;
            self.health_bar.barframe.alpha = 0;
            self.healthText.alpha = 0;
            self.MaxhealthText.alpha = 0;
            self.sprint_bar.bar.alpha = 0;
            self.sprint_bar.barframe.alpha = 0;
        }
        
        wait 0.005;
    }
}

listenforweaponswitch()
{
    for(;;)
    {
        self waittill("weapon_change");
        if(self isusingoffhand())
            self.rawweaponname = self getcurrentoffhand();
        else
            self.rawweaponname = self getcurrentweapon();
        self.niceweaponname = self getNiceWeaponName(self.rawweaponname);
        self.ammo_text setText(self.niceweaponname);

    }
}

listenForFragThrow()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    while(true)
    {
        if(self.ammovisible)
        {       
            self waittill( "grenade_pullback" );
            for (i = 0; i < 8; i++)
            {
                if(self.nadeslot[i]==0)
                {
                    self.nadeslot[i]=1;
                    self.currentweapon = self getcurrentoffhand();
                    if(self.currentweapon == "frag_grenade_zm")
                    {
                        self thread drawNadeTimer(i, 4);
                    }
                    else
                    {
                        self waittill("grenade_fire");
                        if(self.currentweapon == "sticky_grenade_zm")
                            self thread drawNadeTimer(i, 2);
                        else if(self.currentweapon == "cymbal_monkey_zm")
                            self thread drawNadeTimer(i, 8.5);
                        else if(self.currentweapon == "emp_grenade_zm")
                            self thread drawNadeTimer(i, 1);
                    }
                    break;
                }
            }
        }
        wait 0.001;
    }
}

drawNadeTimer(num, time)
{
    self.nadetimer[num] = newClientHudElem(self);
    self.nadetimer[num].alignx = "left";
    self.nadetimer[num].aligny = "top";
    self.nadetimer[num].horzalign = "user_center";
    self.nadetimer[num].vertalign = "user_bottom";
    self.nadetimer[num].x = 200;
    self.nadetimer[num].y = -55 + (10*num);
    if(num>3)
    {
        self.nadetimer[num].x += 30;
        self.nadetimer[num].y -= 40;
    }
    self.nadetimer[num].fontscale = 1;
    self.nadetimer[num].alpha = 1;
    self.nadetimer[num].color = (1, 0.2, 0.2);
    self.nadetimer[num].hidewheninmenu = 1;

    self.nadetimer[num] setTimer(time);
    wait time+1;

    self.nadetimer[num] destroy();
    self.nadeslot[num]=0;
}

drawAmmoCounter()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    self.ammo_text = self createFontString("Objective", 1);
    self.ammo_text setpoint("CENTER", "BOTTOM", 173, -24);
    self.weaponyoustartwith = self getNiceWeaponName(self getcurrentweapon());
    self.ammo_text setText(self.weaponyoustartwith);

    self.lftclip_text = self createFontString("hudsmall" , 1);
    self.lftclip_text setPoint("RIGHT", "BOTTOM", 155, -13);

    self.curclip_text = self createFontString("hudsmall" , 1);
    self.curclip_text setPoint("RIGHT", "BOTTOM", 168, -13);

    self.curammo_text = self createFontString("hudsmall" , 1);    
    self.curammo_text setPoint("LEFT", "BOTTOM", 169, -13);

    self.lftclip_text.label = &"";
    self.curclip_text.label = &"";
    self.curammo_text.label = &"/";

    while(true)
    {
        if(self.ammovisible)
        {
            self.ammo_text.alpha = 1;
            self.curclip_text.alpha = 1;
            self.curammo_text.alpha = 1;

            if(self isusingoffhand())
            {
                self.currentweapon = self getcurrentoffhand();
            }
            else
            {
                self.currentweapon = self getcurrentweapon();
            }

/*            if( self.is_drinking )
            {
                self.drinkup++;
                if( self.drinkup < 16 )
                {
                    self.predrinktotal = self.num_perks;
                    self.CurrClip = self.predrinktotal;
                }
                else
                {
                    self.CurrClip = self.predrinktotal+1;
                }
                self.FullClip = 4;

                self.FullStock = 4;
                self.CurrStock = level.perk_purchase_limit;
            }      
            else
            { */
                self.FullClip = weaponclipsize(self.currentweapon);
                self.CurrClip = self GetWeaponAmmoClip(self.currentweapon);
                self.FullStock = weaponmaxammo(self.currentweapon);
                self.CurrStock = self GetWeaponAmmoStock(self.currentweapon);
//                self.drinkup=0;
//            }
            if(weaponisdualwield(self.currentweapon))
            {
                self.dw_weapon = weapondualwieldweaponname(self.currentweapon);
                self.CurrClipLH = self GetWeaponAmmoClip( self.dw_weapon );
                self.TotalClip = self.CurrClipLH + self.CurrClip;
                self.lftclip_text.alpha = 1;
                self.lftclip_text setValue(self.CurrClipLH);
                self.FullStock = weaponmaxammo(weapondualwieldweaponname(self.currenteapon)) + self.FullStock;
            }
            else
            {
                self.CurrClipLH = 0;
                self.TotalClip = self.CurrClip;
                self.lftclip_text.alpha = 0;
            }

            self.ScaleClip = (self.CurrClip / self.FullClip) * 100;
            self.ScaleClipLH = (self.CurrClipLH / self.FullClip) * 100;
            self.ScaleStock = ((self.CurrStock + self.CurrClip + self.CurrClipLH) / (self.FullStock + self.FullClip)) * 100;

            self.curclip_text setValue(self.CurrClip);
            self.curammo_text setValue(self.CurrStock);


            // Sets the colors

            if(self.ScaleClip <= 100 && self.ScaleClip >= 71)
            {
                self.curclip_text.color = (0, 1, 0.5);
            }
            else if(self.ScaleClip <= 70 && self.ScaleClip >= 50)
            {
                self.curclip_text.color = (1, 1, 0);
            }
            else if(self.ScaleClip <= 49 && self.ScaleClip >= 25)
            {
                self.curclip_text.color = (1, 0.5, 0);
            }
            else if(self.ScaleClip < 25)
            {
                self.curclip_text.color = (1, 0.2, 0.2);
            }

            if(self.ScaleClipLH <= 100 && self.ScaleClipLH >= 71)
            {
                self.lftclip_text.color = (0, 1, 0.5);
            }
            else if(self.ScaleClipLH <= 70 && self.ScaleClipLH >= 50)
            {
                self.lftclip_text.color = (1, 1, 0);
            }
            else if(self.ScaleClipLH <= 49 && self.ScaleClipLH >= 25)
            {
                self.lftclip_text.color = (1, 0.5, 0);
            }
            else if(self.ScaleClipLH < 25)
            {
                self.lftclip_text.color = (1, 0.2, 0.2);
            }

            if(self.ScaleStock <= 100 && self.ScaleStock >= 71)
            {
                self.curammo_text.color = (0, 1, 0.5);
                self.ammo_text.color = (0, 1, 0.5);
            }
            else if(self.ScaleStock <= 70 && self.ScaleStock >= 50)
            {
                self.curammo_text.color = (1, 1, 0);
                self.ammo_text.color = (1, 1, 0);
            }
            else if(self.ScaleStock <= 49 && self.ScaleStock >= 25)
            {
                self.curammo_text.color = (1, 0.5, 0);
                self.ammo_text.color = (1, 0.5, 0);
            }
            else if(self.ScaleStock < 25)
            {
                self.curammo_text.color = (1, 0.2, 0.2);
                self.ammo_text.color = (1, 0.2, 0.2);
            }
        }
        else{
            self.lftclip_text.alpha = 0;
            self.ammo_text.alpha = 0;
            self.curclip_text.alpha = 0;
            self.curammo_text.alpha = 0;
        }

        wait 0.1;
    }
}

drawZombieCounter()
{
    level endon( "game_ended" );
    self endon("disconnect");
    flag_wait( "initial_blackscreen_passed" );

    self.zombie_text = createFontString( "Objective", 1 );
    self.zombie_text setpoint("RIGHT", "BOTTOM", -160, -24 );
    self.zombie_text setText("Zombies");

    self.zombie_counter = createFontString( "hudsmall", 1 );
    self.zombie_counter setpoint( "RIGHT", "BOTTOM", -170, -13 );
    self.zombie_counter.alpha = 1;
    self.zombie_counter.hidewheninmenu = 1;
    self.zombie_counter.hidewhendead = 1;
    self.zombie_counter.label = &"";
    self.zombie_counter.color  = (1, 0.2, 0.2);

    while(true)
    {
        if(self.zombiesvisible)
        {
            self.zombie_text.alpha = 1;
            self.zombie_counter.alpha = 1;

            if(isdefined(self.afterlife) && self.afterlife)
            {
                self.zombie_counter.alpha = 0.2;
            }
            else
            {
                self.zombie_counter.alpha = 1;
            }
            self.zombie_counter setvalue( level.zombie_total + get_current_zombie_count() );
        }
        else
        {
            self.zombie_text.alpha = 0;
            self.zombie_counter.alpha = 0;
        }
        wait 0.05;
    }
}

drawZoneHud()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    self.the_zone_text = self createFontString("Objective", 1);
    self.the_zone_text setpoint("CENTER", "BOTTOM", 0, -4);

    while(true)
    {
        if(self.zonevisible)
        {	
			self.the_zone_text.alpha = 1;
			if(self.currentzone != self get_current_zone())
			{
				self.currentzone = self get_current_zone();
				self.the_zone_text setText(self getNiceZoneName(self.currentzone));
			}
        }
        else
        {
            self.the_zone_text.alpha = 0;
        }
        wait 0.1;
    }
}

getNiceZoneName(zone)
{
	if (!isDefined(zone))
	{
		return "Unknown";
	}

	if (level.script == "zm_transit" || level.script == "zm_transit_dr")
	{
        switch ( zone )
        {
            case "zone_pri":
                return "Bus Depot";
            case "zone_pri2":
                return "Bus Depot Hallway";
            case "zone_station_ext":
                return "Outside Bus Depot";
            case "zone_trans_2b":
                return "Fog After Bus Depot";
            case "zone_trans_2":
                return "Tunnel Entrance";
            case "zone_amb_tunnel":
                return "Tunnel";
            case "zone_trans_3":
                return "Tunnel Exit";
            case "zone_roadside_west":
                return "Outside Diner";
            case "zone_gas":
                return "Gas Station";
            case "zone_roadside_east":
                return "Outside Garage";
            case "zone_trans_diner":
                return "Fog Outside Diner";
            case "zone_trans_diner2":
                return "Fog Outside Garage";
            case "zone_gar":
                return "Garage";
            case "zone_din":
                return "Diner";
            case "zone_diner_roof":
                return "Diner Roof";
            case "zone_trans_4":
                return "Fog After Diner";
            case "zone_amb_forest":
                return "Forest";
            case "zone_trans_10":
                return "Outside Church";
            case "zone_town_church":
                return "Outside Church To Town";
            case "zone_trans_5":
                return "Fog Before Farm";
            case "zone_far":
                return "Outside Farm";
            case "zone_far_ext":
                return "Farm";
            case "zone_brn":
                return "Barn";
            case "zone_farm_house":
                return "Farmhouse";
            case "zone_trans_6":
                return "Fog After Farm";
            case "zone_amb_cornfield":
                return "Cornfield";
            case "zone_cornfield_prototype":
                return "Prototype";
            case "zone_trans_7":
                return "Upper Fog Before Power Station";
            case "zone_trans_pow_ext1":
                return "Fog Before Power Station";
            case "zone_pow":
                return "Outside Power Station";
            case "zone_prr":
                return "Power Station";
            case "zone_pcr":
                return "Power Station Control Room";
            case "zone_pow_warehouse":
                return "Warehouse";
            case "zone_trans_8":
                return "Fog After Power Station";
            case "zone_amb_power2town":
                return "Cabin";
            case "zone_trans_9":
                return "Fog Before Town";
            case "zone_town_north":
                return "North Town";
            case "zone_tow":
                return "Center Town";
            case "zone_town_east":
                return "East Town";
            case "zone_town_west":
                return "West Town";
            case "zone_town_south":
                return "South Town";
            case "zone_bar":
                return "Bar";
            case "zone_town_barber":
                return "Bookstore";
            case "zone_ban":
                return "Bank";
            case "zone_ban_vault":
                return "Bank Vault";
            case "zone_tbu":
                return "Below Bank";
            case "zone_trans_11":
                return "Fog After Town";
            case "zone_amb_bridge":
                return "Bridge";
            case "zone_trans_1":
                return "Fog Before Bus Depot";
		}
	}
	else if (level.script == "zm_nuked")
	{
        switch ( zone )
        {
            case "culdesac_yellow_zone":
                return "Yellow House Cul-de-sac";
            case "culdesac_green_zone":
                return "Green House Cul-de-sac";
            case "truck_zone":
                return "Truck";
            case "openhouse1_f1_zone":
                return "Green House Downstairs";
            case "openhouse1_f2_zone":
                return "Green House Upstairs";
            case "openhouse1_backyard_zone":
                return "Green House Backyard";
            case "openhouse2_f1_zone":
                return "Yellow House Downstairs";
            case "openhouse2_f2_zone":
                return "Yellow House Upstairs";
            case "openhouse2_backyard_zone":
                return "Yellow House Backyard";
            case "ammo_door_zone":
                return "Yellow House Backyard Door";
		}
	}
	else if (level.script == "zm_highrise")
	{
        switch ( zone )
        {
            case "zone_green_start":
                return "Green Highrise Level 3b";
            case "zone_green_escape_pod":
                return "Escape Pod";
            case "zone_green_escape_pod_ground":
                return "Escape Pod Shaft";
            case "zone_green_level1":
                return "Green Highrise Level 3a";
            case "zone_green_level2a":
                return "Green Highrise Level 2a";
            case "zone_green_level2b":
                return "Green Highrise Level 2b";
            case "zone_green_level3a":
                return "Green Highrise Restaurant";
            case "zone_green_level3b":
                return "Green Highrise Level 1a";
            case "zone_green_level3c":
                return "Green Highrise Level 1b";
            case "zone_green_level3d":
                return "Green Highrise Behind Restaurant";
            case "zone_orange_level1":
                return "Upper Orange Highrise Level 2";
            case "zone_orange_level2":
                return "Upper Orange Highrise Level 1";
            case "zone_orange_elevator_shaft_top":
                return "Elevator Shaft Level 3";
            case "zone_orange_elevator_shaft_middle_1":
                return "Elevator Shaft Level 2";
            case "zone_orange_elevator_shaft_middle_2":
                return "Elevator Shaft Level 1";
            case "zone_orange_elevator_shaft_bottom":
                return "Elevator Shaft Bottom";
            case "zone_orange_level3a":
                return "Lower Orange Highrise Level 1a";
            case "zone_orange_level3b":
                return "Lower Orange Highrise Level 1b";
            case "zone_blue_level5":
                return "Lower Blue Highrise Level 1";
            case "zone_blue_level4a":
                return "Lower Blue Highrise Level 2a";
            case "zone_blue_level4b":
                return "Lower Blue Highrise Level 2b";
            case "zone_blue_level4c":
                return "Lower Blue Highrise Level 2c";
            case "zone_blue_level2a":
                return "Upper Blue Highrise Level 1a";
            case "zone_blue_level2b":
                return "Upper Blue Highrise Level 1b";
            case "zone_blue_level2c":
                return "Upper Blue Highrise Level 1c";
            case "zone_blue_level2d":
                return "Upper Blue Highrise Level 1d";
            case "zone_blue_level1a":
                return "Upper Blue Highrise Level 2a";
            case "zone_blue_level1b":
                return "Upper Blue Highrise Level 2b";
            case "zone_blue_level1c":
                return "Upper Blue Highrise Level 2c";
		}
	}
	else if (level.script == "zm_prison")
	{
        switch ( zone )
        {
            case "zone_start":
                return "D-Block";
            case "zone_library":
                return "Library";
            case "zone_cellblock_west":
                return "Cell Block 2nd Floor";
            case "zone_cellblock_west_gondola":
                return "Cell Block 3rd Floor";
            case "zone_cellblock_west_gondola_dock":
                return "Cell Block Gondola";
            case "zone_cellblock_west_barber":
                return "Michigan Avenue";
            case "zone_cellblock_east":
                return "Times Square";
            case "zone_cafeteria":
                return "Cafeteria";
            case "zone_cafeteria_end":
                return "Cafeteria End";
            case "zone_infirmary":
                return "Infirmary 1";
            case "zone_infirmary_roof":
                return "Infirmary 2";
            case "zone_roof_infirmary":
                return "Roof 1";
            case "zone_roof":
                return "Roof 2";
            case "zone_cellblock_west_warden":
                return "Sally Port";
            case "zone_warden_office":
                return "Warden's Office";
            case "cellblock_shower":
                return "Showers";
            case "zone_citadel_shower":
                return "Citadel To Showers";
            case "zone_citadel":
                return "Citadel";
            case "zone_citadel_warden":
                return "Citadel To Warden's Office";
            case "zone_citadel_stairs":
                return "Citadel Tunnels";
            case "zone_citadel_basement":
                return "Citadel Basement";
            case "zone_citadel_basement_building":
                return "China Alley";
            case "zone_studio":
                return "Building 64";
            case "zone_dock":
                return "Docks";
            case "zone_dock_puzzle":
                return "Docks Gates";
            case "zone_dock_gondola":
                return "Upper Docks";
            case "zone_golden_gate_bridge":
                return "Golden Gate Bridge";
            case "zone_gondola_ride":
                return "Gondola";
		}
	}
	else if (level.script == "zm_buried")
	{
		switch ( zone )
        {
            case "zone_start":
                return "Processing";
            case "zone_start_lower":
                return "Lower Processing";
            case "zone_tunnels_center":
                return "Center Tunnels";
            case "zone_tunnels_north":
                return "Courthouse Tunnels 2";
            case "zone_tunnels_north2":
                return "Courthouse Tunnels 1";
            case "zone_tunnels_south":
                return "Saloon Tunnels 3";
            case "zone_tunnels_south2":
                return "Saloon Tunnels 2";
            case "zone_tunnels_south3":
                return "Saloon Tunnels 1";
            case "zone_street_lightwest":
                return "Outside General Store & Bank";
            case "zone_street_lightwest_alley":
                return "Outside General Store & Bank Alley";
            case "zone_morgue_upstairs":
                return "Morgue";
            case "zone_underground_jail":
                return "Jail Downstairs";
            case "zone_underground_jail2":
                return "Jail Upstairs";
            case "zone_general_store":
                return "General Store";
            case "zone_stables":
                return "Stables";
            case "zone_street_darkwest":
                return "Outside Gunsmith";
            case "zone_street_darkwest_nook":
                return "Outside Gunsmith Nook";
            case "zone_gun_store":
                return "Gunsmith";
            case "zone_bank":
                return "Bank";
            case "zone_tunnel_gun2stables":
                return "Stables To Gunsmith Tunnel 2";
            case "zone_tunnel_gun2stables2":
                return "Stables To Gunsmith Tunnel";
            case "zone_street_darkeast":
                return "Outside Saloon & Toy Store";
            case "zone_street_darkeast_nook":
                return "Outside Saloon & Toy Store Nook";
            case "zone_underground_bar":
                return "Saloon";
            case "zone_tunnel_gun2saloon":
                return "Saloon To Gunsmith Tunnel";
            case "zone_toy_store":
                return "Toy Store Downstairs";
            case "zone_toy_store_floor2":
                return "Toy Store Upstairs";
            case "zone_toy_store_tunnel":
                return "Toy Store Tunnel";
            case "zone_candy_store":
                return "Candy Store Downstairs";
            case "zone_candy_store_floor2":
                return "Candy Store Upstairs";
            case "zone_street_lighteast":
                return "Outside Courthouse & Candy Store";
            case "zone_underground_courthouse":
                return "Courthouse Downstairs";
            case "zone_underground_courthouse2":
                return "Courthouse Upstairs";
            case "zone_street_fountain":
                return "Fountain";
            case "zone_church_graveyard":
                return "Graveyard";
            case "zone_church_main":
                return "Church Downstairs";
            case "zone_church_upstairs":
                return "Church Upstairs";
            case "zone_mansion_lawn":
                return "Mansion Lawn";
            case "zone_mansion":
                return "Mansion";
            case "zone_mansion_backyard":
                return "Mansion Backyard";
            case "zone_maze":
                return "Maze";
            case "zone_maze_staircase":
                return "Maze Staircase";
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (isDefined(self.teleporting) && self.teleporting)
		{
			return "";
		}
        else
        {
            switch ( zone )
            {
                case "zone_start":
                    return "Lower Laboratory";
                case "zone_start_a":
                    return "Upper Laboratory";
                case "zone_start_b":
                    return "Generator 1";
                case "zone_bunker_1a":
                    return "Generator 3 Bunker 1";
                case "zone_fire_stairs":
                    return "Fire Tunnel";
                case "zone_bunker_1":
                    return "Generator 3 Bunker 2";
                case "zone_bunker_3a":
                    return "Generator 3";
                case "zone_bunker_3b":
                    return "Generator 3 Bunker 3";
                case "zone_bunker_2a":
                    return "Generator 2 Bunker 1";
                case "zone_bunker_2":
                    return "Generator 2 Bunker 2";
                case "zone_bunker_4a":
                    return "Generator 2";
                case "zone_bunker_4b":
                    return "Generator 2 Bunker 3";
                case "zone_bunker_4c":
                    return "Tank Station";
                case "zone_bunker_4d":
                    return "Above Tank Station";
                case "zone_bunker_tank_c":
                    return "Generator 2 Tank Route 1";
                case "zone_bunker_tank_c1":
                    return "Generator 2 Tank Route 2";
                case "zone_bunker_4e":
                    return "Generator 2 Tank Route 3";
                case "zone_bunker_tank_d":
                    return "Generator 2 Tank Route 4";
                case "zone_bunker_tank_d1":
                    return "Generator 2 Tank Route 5";
                case "zone_bunker_4f":
                    return "zone_bunker_4f";
                case "zone_bunker_5a":
                    return "Workshop Downstairs";
                case "zone_bunker_5b":
                    return "Workshop Upstairs";
                case "zone_nml_2a":
                    return "No Man's Land Walkway";
                case "zone_nml_2":
                    return "No Man's Land Entrance";
                case "zone_bunker_tank_e":
                    return "Generator 5 Tank Route 1";
                case "zone_bunker_tank_e1":
                    return "Generator 5 Tank Route 2";
                case "zone_bunker_tank_e2":
                    return "zone_bunker_tank_e2";
                case "zone_bunker_tank_f":
                    return "Generator 5 Tank Route 3";
                case "zone_nml_1":
                    return "Generator 5 Tank Route 4";
                case "zone_nml_4":
                    return "Generator 5 Tank Route 5";
                case "zone_nml_0":
                    return "Generator 5 Left Footstep";
                case "zone_nml_5":
                    return "Generator 5 Right Footstep Walkway";
                case "zone_nml_farm":
                    return "Generator 5";
                case "zone_nml_celllar":
                    return "Generator 5 Cellar";
                case "zone_bolt_stairs":
                    return "Lightning Tunnel";
                case "zone_nml_3":
                    return "No Man's Land 1st Right Footstep";
                case "zone_nml_2b":
                    return "No Man's Land Stairs";
                case "zone_nml_6":
                    return "No Man's Land Left Footstep";
                case "zone_nml_8":
                    return "No Man's Land 2nd Right Footstep";
                case "zone_nml_10a":
                    return "Generator 4 Tank Route 1";
                case "zone_nml_10":
                    return "Generator 4 Tank Route 2";
                case "zone_nml_7":
                    return "Generator 4 Tank Route 3";
                case "zone_bunker_tank_a":
                    return "Generator 4 Tank Route 4";
                case "zone_bunker_tank_a1":
                    return "Generator 4 Tank Route 5";
                case "zone_bunker_tank_a2":
                    return "zone_bunker_tank_a2";
                case "zone_bunker_tank_b":
                    return "Generator 4 Tank Route 6";
                case "zone_nml_9":
                    return "Generator 4 Left Footstep";
                case "zone_air_stairs":
                    return "Wind Tunnel";
                case "zone_nml_11":
                    return "Generator 4";
                case "zone_nml_12":
                    return "Generator 4 Right Footstep";
                case "zone_nml_16":
                    return "Excavation Site Front Path";
                case "zone_nml_17":
                    return "Excavation Site Back Path";
                case "zone_nml_18":
                    return "Excavation Site Level 3";
                case "zone_nml_19":
                    return "Excavation Site Level 2";
                case "ug_bottom_zone":
                    return "Excavation Site Level 1";
                case "zone_nml_13":
                    return "Generator 5 To Generator 6 Path";
                case "zone_nml_14":
                    return "Generator 4 To Generator 6 Path";
                case "zone_nml_15":
                    return "Generator 6 Entrance";
                case "zone_village_0":
                    return "Generator 6 Left Footstep";
                case "zone_village_5":
                    return "Generator 6 Tank Route 1";
                case "zone_village_5a":
                    return "Generator 6 Tank Route 2";
                case "zone_village_5b":
                    return "Generator 6 Tank Route 3";
                case "zone_village_1":
                    return "Generator 6 Tank Route 4";
                case "zone_village_4b":
                    return "Generator 6 Tank Route 5";
                case "zone_village_4a":
                    return "Generator 6 Tank Route 6";
                case "zone_village_4":
                    return "Generator 6 Tank Route 7";
                case "zone_village_2":
                    return "Church";
                case "zone_village_3":
                    return "Generator 6 Right Footstep";
                case "zone_village_3a":
                    return "Generator 6";
                case "zone_ice_stairs":
                    return "Ice Tunnel";
                case "zone_bunker_6":
                    return "Above Generator 3 Bunker";
                case "zone_nml_20":
                    return "Above No Man's Land";
                case "zone_village_6":
                    return "Behind Church";
                case "zone_chamber_0":
                    return "The Crazy Place Lightning Chamber";
                case "zone_chamber_1":
                    return "The Crazy Place Lightning & Ice";
                case "zone_chamber_2":
                    return "The Crazy Place Ice Chamber";
                case "zone_chamber_3":
                    return "The Crazy Place Fire & Lightning";
                case "zone_chamber_4":
                    return "The Crazy Place Center";
                case "zone_chamber_5":
                    return "The Crazy Place Ice & Wind";
                case "zone_chamber_6":
                    return "The Crazy Place Fire Chamber";
                case "zone_chamber_7":
                    return "The Crazy Place Wind & Fire";
                case "zone_chamber_8":
                    return "The Crazy Place Wind Chamber";
                case "zone_robot_head":
                    return "Robot's Head";
            }
		}
	}
}