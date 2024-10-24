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
#include scripts\zm\dirk_welcome;

init()
{
	level thread onplayerconnect();
	thread init_stat_dvars();
	thread init_folder_structure();
	level thread auto_deposit_on_end_game();
	level thread auto_updatekills_on_end_game();
	level thread auto_updatekills();
}

onplayerconnect()
{
	level endon("end_game");
	while(true)
	{
		level waittill("connected", player);
		player thread onplayerspawned();
		player.account_value = player maps\mp\zombies\_zm_stats::get_map_stat("depositBox", "zm_transit");
		namefile = player get_user_filename();
		bankfile = player get_bank_filename();
		allkillfile = player get_allkill_filename();
		mapkillfile = player get_mapkill_filename();
		maproundfile = player get_mapround_filename();
		if(!fileExists(namefile))
            player create_name_file(namefile);
		if(!fileExists(bankfile))							//if a dirk_bank file does not exists
			player create_bank_file(bankfile);
		else												//else the bank file does exist
			player check_bank_balance(bankfile);

		if(!fileExists(allkillfile) && fileExists(namefile))	//if the name exists but a kill file doesn't that means the season reset (kill files were moved to season folder)
		{
			player iprintln("^4<(^3DRF^4)>^7Previous season archived!");
			player iprintln("^4<(^3DRF^4)>^7Kill stats reset. New season, new leaderboard!");
			wait 2;
		}
		if(!fileExists(allkillfile))
			create_kill_file(allkillfile);
		if(!fileExists(mapkillfile))
			create_kill_file(mapkillfile);
		if(!fileExists(maproundfile))
			create_round_file(maproundfile);

//		all_kills = player all_kill_read();
//		map_kills = player map_kill_read();
//		map_round = player map_round_read();
//		wait 2.0;
//		player iprintln("^4<(^3DRF^4)>^7You have killed ^2" + player convert_to_thousands(all_kills) + "^7 zombies on ^4<(^3DRF^4)>^7 servers this season!");
//		wait 2.0;
//		player iprintln("^4<(^3DRF^4)>^7You have killed ^2" + player convert_to_thousands(map_kills) + "^7 zombies on this map this season!");
//		wait 2.0;
//		player iprintln("^4<(^3DRF^4)>^7You have made it as high as round ^2" + map_round + "^7 on this map this season!");
	}
}

onplayerspawned()
{
    level endon("game_ended");
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
		self.old_kill_total = 0;
		self.new_kill_total = 0;
		self.whendidijoin = level.round_number;
    }
}

init_stat_dvars()
{
	level.earn_round_for_rank = getDvarIntDefault( "earnroundforrank", 1 );
	level.earn_point_for_bank = getDvarIntDefault( "earnpointforbank", 1 );
	level.earn_kills_for_rank = getDvarIntDefault( "earnkillsforrank", 1 );
}

init_folder_structure()
{
	level.statsfolderhardcoded = getDvarIntDefault( "hardcodestats", 0 );
	if(level.statsfolderhardcoded)
		level.mapnameforstats = getdvar("mapnameforstats");
	else
		level.mapnameforstats = level.scr_zm_map_start_location;

	name_folder = "custstats/name";
	if (!directoryExists(name_folder))
        createDirectory(name_folder);

    bank_folder = "custstats/bank";
	if (!directoryExists(bank_folder))
        createDirectory(bank_folder);

    allstats_folder = "custstats/all";
	if (!directoryExists(allstats_folder))
        createDirectory(allstats_folder);

	mapstats_folder = "custstats/" + level.mapnameforstats;

	if (!directoryExists(mapstats_folder))
        createDirectory(mapstats_folder);

    all_rankings_folder = "custstats/all/rankings";
	if (!directoryExists(all_rankings_folder))
        createDirectory(all_rankings_folder);

    all_leaders_folder = "custstats/all/leaders";
	if (!directoryExists(all_leaders_folder))
        createDirectory(all_leaders_folder);

	map_rankings_folder = "custstats/" + level.mapnameforstats + "/rankings";
	if (!directoryExists(map_rankings_folder))
        createDirectory(map_rankings_folder);

	map_leaders_folder = "custstats/" + level.mapnameforstats + "/leaders";
	if (!directoryExists(map_leaders_folder))
        createDirectory(map_leaders_folder);

}

get_user_filename()
{
	self.guidnumber = self getGuid();

	path = "custstats/name/" + self.guidnumber + ".name";
	return path;
}

get_bank_filename()
{
	self.guidnumber = self getGuid();

	path = "custstats/bank/" + self.guidnumber + ".bank";
	return path;
}

get_mapkill_filename()
{
	self.guidnumber = self getGuid();

	path = "custstats/" + level.mapnameforstats + "/" + self.guidnumber + ".kill";
	return path;
}

get_allkill_filename()
{
	self.guidnumber = self getGuid();

	path = "custstats/all/" + self.guidnumber + ".kill";
	return path;
}

get_mapround_filename()
{
	self.guidnumber = self getGuid();

	path = "custstats/" + level.mapnameforstats + "/" + self.guidnumber + ".round";
	return path;
}

get_rank_filename(loc)
{
	self.guidnumber = self getGuid();

	if(loc=="map")
		return "custstats/" + level.mapnameforstats + "/rankings/" + self.guidnumber + ".txt";
	else
		return "custstats/all/rankings/" + self.guidnumber + ".txt";
}

get_leader_name_filename(loc, i)
{
	if(loc=="map")
		return "custstats/" + level.mapnameforstats + "/leaders/" + i + ".name";
	else
		return "custstats/all/leaders/" + i + ".name";
}

get_leader_roundname_filename(loc, i)
{
	if(loc=="map")
		return "custstats/" + level.mapnameforstats + "/rounds/" + i + ".name";
	else
		return "custstats/all/round/" + i + ".name";
}

get_leader_kill_filename(loc, i)
{
	if(loc=="map")
		return "custstats/" + level.mapnameforstats + "/leaders/" + i + ".kill";
	else
		return "custstats/all/leaders/" + i + ".kill";
}

get_leader_round_filename(loc, i)
{
	if(loc=="map")
		return "custstats/" + level.mapnameforstats + "/rounds/" + i + ".round";
	else
		return "custstats/all/round/" + i + ".round";
}

check_name_file()
{
	namefile = self get_user_filename();
	if(!fileExists(namefile))
    	self create_name_file(namefile);
}

create_name_file(name)
{
	writeFile(name, self.name);
}

create_bank_file(name)
{
	self iprintln("^4<(^3DRF^4)>^7Creating new bank file...");
	wait 1.5;
	self.tempvalue = self.account_value * 1000;																			// 	see if they have a universal bank account and store it as a temp value
	self.tempstring = ""+self.tempvalue+"";
	if(self.account_value > 10)																							// 	if they do and it's > $10,000
	{																													//
		self iprintln("^4<(^3DRF^4)>^7Copying your ^1" + self convert_to_money(self.tempvalue) + "^7 over...");			//
		wait 1.5;																										//
		writeFile(name, self.tempstring);																				// 		then copy that universal account into their new dirk bank
		self iprintln("^4<(^3DRF^4)>^7You now have ^1" + self convert_to_money(self.tempvalue) + "^7 in the bank!");	//
	}																													//
	else																												//
	{																													//
		self iprintln("^4<(^3DRF^4)>^7Starting you off with ^1$^210,000 ^7in the bank!");								//
		writeFile(name, "10000");																						// 	else give them a new account with $10,000
	}	
}

create_kill_file(name)
{
	writeFile(name, "0");
}

create_round_file(name)
{
	writeFile(name, "1");
}

check_bank_balance(name)
{
	value = int(readFile(name));																						//		then read the bank file
	self iprintln("^4<(^3DRF^4)>^7Checking bank file...");																//
	wait 1.5;																											//
	self iprintln("^4<(^3DRF^4)>^7You have ^1" + self convert_to_money(value) + "^7 in the bank!");						//		and tell them how much they have
}

bank_write(value)
{
    name = self get_bank_filename();
    writeFile(name, ""+value+"");
}

kill_write(all_value, map_value)
{
    all_name = self get_allkill_filename();
	all_name_string = ""+all_name+"";
	all_string = ""+all_value+"";

    writeFile(all_name_string, all_string);
	map_name = self get_mapkill_filename();
	map_name_string = ""+map_name+"";
	map_string = ""+map_value+"";

	writeFile(map_name_string, map_string);
}

round_write(value)
{
	map_name = self get_mapround_filename();
	writeFile(map_name, ""+value+"");
}

bank_read()
{
    name = self get_bank_filename();
    if(!fileExists(name))
	{
		self create_bank_file(name);
		self check_name_file();
	}
    return int(readFile(name));
}

all_kill_read()
{
    name = self get_allkill_filename();
    if(!fileExists(name))
	{
		self create_kill_file(name);
		self check_name_file();
		return 0;
	}
    return int(readFile(name));
}

map_kill_read()
{
    name = self get_mapkill_filename();
    if(!fileExists(name))
	{
		self create_kill_file(name);
		self check_name_file();
		return 0;
	}
    return int(readFile(name));
}

map_round_read()
{
    name = self get_mapround_filename();
    if(!fileExists(name))
	{
		self create_round_file(name);
		self check_name_file();
		return 1;
	}
    return int(readFile(name));
}

rank_read(loc)
{
    name = self get_rank_filename(loc);
    if(!fileExists(name))
        return "norank";
    return readFile(name);
}

leader_name_read(loc, i)
{
    name = self get_leader_name_filename(loc, i);
    if(!fileExists(name))
        return "noleadername";
    return readFile(name);
}

leader_kill_read(loc, i)
{
    name = self get_leader_kill_filename(loc, i);
    if(!fileExists(name))
        return "0";
    return readFile(name);
}

leader_roundname_read(loc, i)
{
	name = self get_leader_roundname_filename(loc, i);
	if(!fileExists(name))
		return "noleadername";
	return readFile(name);
}

leader_round_read(loc, i)
{
    name = self get_leader_round_filename(loc, i);
    if(!fileExists(name))
        return "0";
    return readFile(name);
}

bank_add(value)
{
    current = self bank_read();
    self bank_write(current + value);
}

kill_add(value)
{
    all_current = self all_kill_read();
	map_current = self map_kill_read();
    self kill_write(all_current + value, map_current + value);
}

round_update(value)
{
	round_current = self map_round_read();
	if(value > round_current)
		round_write(value);

}

bank_sub(value)
{
    current = self bank_read();
    self bank_write(current - value);
}

auto_deposit_on_end_game()
{
	level waittill("end_game");
	if(level.earn_point_for_bank)
	{
		foreach(player in level.players)
			player deposit_logic(player, "all");
	}
}

auto_updatekills_on_end_game()
{
	level waittill("end_game");
	wait 1;
	if(level.earn_kills_for_rank)
	{
		foreach(player in level.players)
			player update_the_kills_now();
	}
}

update_the_kills_now()
{
	self.new_kill_total = int(self.kills) - self.old_kill_total;
	self kill_add(self.new_kill_total);
	self.old_kill_total += self.new_kill_total;
	self iPrintLn("^4<(^3DRF^4)>^7Added " + self.new_kill_total + " kills!");
}

auto_updatekills()
{
	while(true)
	{
		level waittill("end_of_round");
		wait 1;
		foreach(player in level.players)
			player update_the_stats_round();
		wait 1;
	}
}

update_the_stats_round()
{
	if(!isDefined(self.old_kill_total))
		self.old_kill_total = 0;
	if(!isDefined(self.new_kill_total))
		self.new_kill_total = 0;
	if(level.earn_kills_for_rank)
	{
		self.new_kill_total = int(self.kills) - self.old_kill_total;
		self kill_add(self.new_kill_total);
		self.old_kill_total += self.new_kill_total;
		self iPrintLn( "^4<(^3DRF^4)>^7Added " + self.new_kill_total + " kills!");
	}
	if(level.earn_round_for_rank)
		self round_update(level.round_number-self.whendidijoin);
}

withdraw_logic(player, amount)
{
	if(level.earn_point_for_bank)
	{
		balance = int(player bank_read());
		if(balance <= 0)
		{
			player iPrintln("^4<(^3DRF^4)>^7Withdraw failed: you have no money in the bank");
			return;
		}
		if(player.score >= 1000000)
		{
			player iPrintLn("^4<(^3DRF^4)>^7Withdraw failed: Max score is ^1$^21,000,000.");
			return;
		}
		if(!isDefined(amount))
		{
			player iPrintLn("^4<(^3DRF^4)>^7Usage ^3.w number ^7or ^3.w all");
			return;
		}
		num_score = int(player.score);
		num_amount = int(amount);
		if(tolower(amount) == "all" || tolower(amount) == "todo" || tolower(amount) == "toda")
			num_amount = balance;
		else if(num_amount > 0)
			num_amount = num_amount;
		else 
		{
			player iPrintLn("^4<(^3DRF^4)>^7Usage ^3.w number ^7or ^3.w all");
			return;
		}

		if(num_amount > balance)								//max withdraw is entire balance
			num_amount = balance;
		
		over_balance = num_score + num_amount - 1000000; 		//withdraw can't put you over 1,000,000 so check how much over you would be
		max_score_available = abs( num_score - 1000000 );		//and check the most you can take out
		if(over_balance > 0)									//if you have an over balance
			num_amount = max_score_available;					//set the withdraw to max allowed to take out
		
		player bank_sub(num_amount);
		player.score += num_amount;
		player iPrintLn("^4<(^3DRF^4)>^7Successfuly withdrew ^1" + convert_to_money(num_amount));
	}
	else
	{
		player iPrintLn("^4<(^3DRF^4)>^7Bank not enabled this session");
	}
}

deposit_logic(player, amount)
{
	if(level.earn_point_for_bank)
	{
		if(player.score <= 0)
		{
			player iPrintLn("^4<(^3DRF^4)>^7Deposit failed: Not enough money");
			return;
		}
		if(!isDefined(amount))
		{
			player iPrintLn("^4<(^3DRF^4)>^7Usage ^3.d number ^7or ^3.d all");
			return;
		}
		num_score = int(player.score);
		num_amount = int(amount);
		if(tolower(amount) == "all" || tolower(amount) == "todo" || tolower(amount) == "toda")
			num_amount = num_score;
		else if(num_amount > 0)
			num_amount = num_amount;
		else 
		{
			player iPrintLn("^4<(^3DRF^4)>^7Usage ^3.d number ^7or ^3.d all");
			return;
		}

		if(num_amount > num_score)								//max deposit is entire score
			num_amount = num_score;

		player bank_add(num_amount);
		player.score -= num_amount;
		player iPrintLn("^4<(^3DRF^4)>^7Successfully deposited ^1" + convert_to_money(num_amount));
	}
	else
	{
		player iPrintLn("^4<(^3DRF^4)>^7Bank not enabled this session");
	}

}

transfer_logic(player, amount, targetplayer)
{
	if(player.score <= 0)
	{
		player iPrintLn("^4<(^3DRF^4)>^7Transfer failed: Not enough money");
	}
	if(!isDefined(amount) || !isDefined(targetplayer))
	{
		player iPrintLn("^4<(^3DRF^4)>^7Usage ^3.t number name");
		return;
	}
	num_amount = int(amount);
	if(tolower(amount) == "all" || tolower(amount) == "todo" || tolower(amount) == "toda")
	{
		num_amount = player.score;
	}
	else if(num_amount >= 0)
	{
		if(num_amount > player.score)
			num_amount = player.score;
	}
	else if(num_amount < 0)
		num_amount = -100;
	else 
	{
		player iPrintLn("^4<(^3DRF^4)>^7Usage ^3.t number name"); 
		return;
	}
	match = 0;
	foreach(q in level.players)
	{
		namepl = q.name;
		partialname = getSubStr(q.name, 0, targetplayer.size);
		if(tolower(partialname) == tolower(targetplayer))
			match++;
	}
	
	if(match == 1)
	{
		foreach(p in level.players)
		{
			namepl = p.name;
			partialname = getSubStr(p.name, 0, targetplayer.size);
			if(tolower(partialname) == tolower(targetplayer))
			{
				if(num_amount >= 0)
				{
					player.score -= num_amount;
					p.score += num_amount;
					player iPrintLn("^4<(^3DRF^4)>^7You transfered ^1" + convert_to_money(num_amount) + " to " + namepl);
				}
				else
				{
					player iPrintLn("^4<(^3DRF^4)>^7Nice try!");
					if(player.score > 100 )
						player.score -= 100;
					else
						player.score = 0;
				}
			}
		}
	}
	else if(match > 1)
		player iPrintLn("^4<(^3DRF^4)>^7Too many matches for " + targetplayer);
	else
		player iPrintLn("^4<(^3DRF^4)>^7No matches for " + targetplayer);
}

balance_logic(player)
{
	value = player bank_read();
	player iPrintLn("^4<(^3DRF^4)>^7Current balance: ^1" + convert_to_money(value));
}

convert_to_money(rawvalue)
{
	return "$^2" + convert_to_thousands(rawvalue);
}

convert_to_thousands(rawvalue)
{
	rawstring = "" + rawvalue;
	leftovers = rawstring.size % 3;
	commasneeded = (rawstring.size - leftovers) / 3;
	if(leftovers==0)
		{
			leftovers=3;
			commasneeded=commasneeded-1;
		}
	if(commasneeded<1)
	{
		return rawvalue;
	}
	else if(commasneeded==1)
	{
		return getSubStr(rawvalue, 0, leftovers) + "," + getSubStr(rawvalue, leftovers, leftovers+3);
	}
	else if(commasneeded==2)
	{
		return getSubStr(rawvalue, 0, leftovers) + "," + getSubStr(rawvalue, leftovers, leftovers+3) + "," + getSubStr(rawvalue, leftovers+3, leftovers+6);
	}
	else if(commasneeded==3)
	{
		return getSubStr(rawvalue, 0, leftovers) + "," + getSubStr(rawvalue, leftovers, leftovers+3) + "," + getSubStr(rawvalue, leftovers+3, leftovers+6) + "," + getSubStr(rawvalue, leftovers+6, leftovers+9);
	}
}