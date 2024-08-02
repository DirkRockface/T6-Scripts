#include scripts\zm\dirk_bank;
#include scripts\zm\dirk_box;
#include scripts\zm\dirk_casino;
#include scripts\zm\dirk_hud;
#include scripts\zm\dirk_pause;
#include scripts\zm\dirk_weapon;
#include scripts\zm\dirk_welcome;
#include scripts\zm\dirk_leaderboard;

main()
{
	level thread commandthread();
}

commandthread()
{
	level endon( "end_game" );
	while ( true )
	{
		level waittill( "say", message, player, isHidden );
		args = strTok( message, " " );
		command = tolower(args[ 0 ]);
		switch ( command )
		{
			case ".movebox":
				player move_the_box();
				break;
			case ".leaders":
				thread show_the_leaders(player, "english");
				break;
			case ".lideres":
				thread show_the_leaders(player, "spanish");
				break;
			case ".myrank":
				thread show_my_rank(player, "english");
				break;
			case ".mirango":
				thread show_my_rank(player, "spanish");
				break;
			case ".fog":
			case ".niebla":
			 	thread toggle_fog(player);
				break;
			case ".help":
			case ".commands":
			 	thread display_help(player, "english");
				break;
			case ".ayuda":
			case ".comandos":
				thread display_help(player, "spanish");
				break;
            case ".bank":
			 	thread display_bank_help(player, "english");
				break;
			case ".banco":
				thread display_bank_help(player, "spanish");
				break;
			case ".hud":
			 	thread display_hud_help(player, "english");
				break;
			case ".hudsp":
				thread display_hud_help(player, "spanish");
				break;
			case ".casino":
				thread display_casino_help(player, "english");
				break;
			case ".elcasino":
				thread display_casino_help(player, "spanish");
				break;
			case ".prizes":
				thread display_prizes_help(player, "english");
				break;
			case ".premios":
				thread display_prizes_help(player, "spanish");
				break;
			case ".w":
			case ".with":
			case ".withdraw":
			 	withdraw_logic(player, args[ 1 ]);
				break;
			case ".d":
			case ".dep":
			case ".deposit":
				deposit_logic(player, args[ 1 ]);
				break;
			case ".t":
			case ".trans":
			case ".transfer":
			case ".give":
				transfer_logic(player, args[ 1 ], args[ 2 ]);
				break;
			case ".b":
			case ".bal":
			case ".balance":
				balance_logic(player);
				break;
			case ".tog_h":
			 	player toggle_health();
				break;
            case ".tog_z":
			 	player toggle_zombies();
				break;
            case ".tog_a":
                player toggle_ammo();
                break;
			case ".tog_l":
				player toggle_zone();
				break;
            case ".tog_hud":
                player toggle_hud();
                break;
			case ".afk":
            case ".pause":
			 	player thread go_afk("english", 60, 0);
				break;
			case ".longpause":
				player thread go_afk("english", 300, 1);
				break;
			case ".largapausar":
				player thread go_afk("spanish", 300, 1);
				break;
			case ".freedom":
				player thread go_afk("english", 300, 2);
				break;
			case ".libertad":
				player thread go_afk("spanish", 300, 2);
				break;
			case ".pausar":
				player thread go_afk("spanish", 60, 0);
				break;
			//case ".testing":
			//	player thread go_afk("english", 600, 0);
			//	break;
            case ".back":
			case ".reanudar":
				player thread back_afk();
				break;
			case ".gamble":
			case ".spin":
			case ".roll":
				player thread roll_the_dice("english");
				break;
			case ".jugar":
			case ".girar":
			case ".rollo":
				player thread roll_the_dice("spanish");
				break;
			default:
				break;
		}
	}
}