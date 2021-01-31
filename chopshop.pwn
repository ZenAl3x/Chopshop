//
// CHOPSHOP SYSTEM FILTERSCRIPT BY ZENAL3X
// 


#include <a_samp>
#include <zcmd>
#include <sscanf2>

#define DIALOG_CHOPSHOP_FIRST		1
#define DIALOG_CHOPSHOP_SECOND		2
#define DIALOG_CHOPSHOP_THIRD		3
#define DIALOG_CHOPSHOP_FINAL		4

new ChopPermission[MAX_PLAYERS];
new ChopCP[MAX_PLAYERS];
new ChopVehid[MAX_PLAYERS];
//-----------------------------------------


public OnFilterScriptInit(){

	print("\n--------------------------------------");
    print("Chopshop system by ZenAl3x");
    print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit(){

	return 1;
}

public OnPlayerEnterCheckpoint(playerid){

	if(ChopCP[playerid] == 1){
		DisablePlayerCheckpoint(playerid);
	}

	return 1;
}

public OnPlayerConnect(playerid){

	ChopPermission[playerid] = 0;
	ChopCP[playerid] = 0;
	ChopVehid[playerid] = 0;

	return 1;
}

//-----------------------------------------

forward BreakTires(vehicleid, playerid);
forward BreakDoors(vehicleid, playerid);
forward BreakEngine(vehicleid, playerid);

public BreakTires(vehicleid, playerid){
	new panels, doors, lights, tires;
	new string[256];
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
	ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_SECOND, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
	new rand = 2000 + random(1000);
	GivePlayerMoney(playerid, rand);
	//pInfo[pMoney][playerid] += rand;
	format(string, sizeof(string), "Ai primit $%d pentru vanzarea rotilor!", rand);
	SendClientMessage(playerid, -1, string);
	return 1;
}

encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door, behind_passenger_door)
{
    #pragma unused behind_driver_door
    #pragma unused behind_passenger_door
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}

public BreakDoors(vehicleid, playerid){
	new panels, doors, lights, tires;
	new string[256];
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	doors = encode_doors(4, 4, 4, 4, 0, 0);
	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
	ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_THIRD, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
	new rand = 2000 + random(2500);
	GivePlayerMoney(playerid, rand);
	//pInfo[pMoney][playerid] += rand;
	format(string, sizeof(string), "Ai primit $%d pentru vanzarea caroseriei!", rand);
	SendClientMessage(playerid, -1, string);
	return 1;
}

public BreakEngine(vehicleid, playerid){
	new string[256];
	SetVehicleHealth(vehicleid, 350.0);
	ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FINAL, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n{02A117}3.  Dezmembreaza motorul - Terminat\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
	new rand = 3000 + random(3500);
	GivePlayerMoney(playerid, rand);
	//pInfo[pMoney][playerid] += rand;
	format(string, sizeof(string), "Ai primit $%d pentru vanzarea motorului!", rand);
	SendClientMessage(playerid, -1, string);
	return 1;
}

ChopCar(vehicleid, playerid){

	new string[256];
	SetVehicleToRespawn(vehicleid);
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	doors = encode_doors(4, 4, 4, 4, 0, 0);
	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
	SetVehicleHealth(vehicleid, 350.0);
	new rand = 5000 + random(25000);   // Trebuie pus ca player-ul sa primeasca 40% din valoarea masinii
	format(string, sizeof(string), "Masina a fost dezmembrata si vanduta cu succes! Ai primit $%d pentru piesele masinii.", rand);
	SendClientMessage(playerid, -1, string);
	GivePlayerMoney(playerid, rand);   // Trebuie pus sa ii dea banii si sa ii updateze in baza de date
	GameTextForPlayer(playerid, "Vehicul dezmembrat", 5000, 1);

	return 1;
}
//-----------------------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){

	if(dialogid == 1){
		if(response){
			if(listitem == 0){
				new vehid = ChopVehid[playerid];
				new panels, doors, lights, tires;
				GetVehicleDamageStatus(vehid, panels, doors, lights, tires);
				if(tires == 15){
					SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja rotile sau acestea sunt intr-o conditie deplorabila!!");
					ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_SECOND, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
				}
				else{
					SetTimerEx("BreakTires", 5000, false, "i", vehid, playerid);
					GameTextForPlayer(playerid, "Se dezmembreaza rotile..", 4900, 1);
				}
			}
			else if(listitem == 1){
				SendClientMessage(playerid, -1, "Error: Dezmembreaza rotile prima data!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FIRST, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "1.  Dezmembreaza rotile\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 2){
				SendClientMessage(playerid, -1, "Error: Dezmembreaza rotile prima data!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FIRST, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "1.  Dezmembreaza rotile\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 3){
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FIRST, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "1.  Dezmembreaza rotile\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 4){
				SendClientMessage(playerid, -1, "Error: Nu ai dezmembrat inca masina!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FIRST, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "1.  Dezmembreaza rotile\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
		}
		else if(!response){
			TogglePlayerControllable(playerid, 1);
			SetCameraBehindPlayer(playerid);
			ChopPermission[playerid] = 0;
		}
	}

	if(dialogid == 2){
		if(response){
			if(listitem == 0){
				SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja rotile!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_SECOND, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 1){
				new vehid = ChopVehid[playerid];
				new panels, doors, lights, tires;
				GetVehicleDamageStatus(vehid, panels, doors, lights, tires);
				if(doors == encode_doors(4, 4, 4, 4, 0, 0) && tires == 15){
					SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja caroseria sau aceasta se afla intr-o stare deplorabila!");
					ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_THIRD, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
				}
				else{
					SetTimerEx("BreakDoors", 5000, false, "i", vehid, playerid);
					GameTextForPlayer(playerid, "Se dezmembreaza caroseria..", 4900, 1);		
				}
			}
			else if(listitem == 2){
				SendClientMessage(playerid, -1, "Error: Dezmembreaza caroseria prima data!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_SECOND, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 3){
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_SECOND, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 4){
				SendClientMessage(playerid, -1, "Error: Nu ai dezmembrat inca masina!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_SECOND, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
		}
		else if(!response){
			TogglePlayerControllable(playerid, 1);
			SetCameraBehindPlayer(playerid);
			ChopPermission[playerid] = 0;
		}
	}

	if(dialogid == 3){
		if(response){
			if(listitem == 0){
				SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja rotile!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_THIRD, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 1){
				SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja caroseria!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_THIRD, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 2){
				new vehid = ChopVehid[playerid], Float: vehhp;
				GetVehicleHealth(vehid, vehhp);
				if(vehhp <= 350.0){
					SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja motorul sau acesta se afla intr-o conditie deplorabila!");
					ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FINAL, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n{02A117}3.  Dezmembreaza motorul - Terminat\n     \n{FFFFFF}4.  Vinde piesele masinii", "Select", "Cancel");
				}
				else{
					SetTimerEx("BreakEngine", 5000, false, "i", vehid, playerid);
					GameTextForPlayer(playerid, "Se dezmembreaza motorul..", 4900, 1);
				}
			}
			else if(listitem == 3){
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_THIRD, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 4){
				SendClientMessage(playerid, -1, "Error: Nu ai dezmembrat inca masina!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_THIRD, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");
			}
		}
		else if(!response){
			TogglePlayerControllable(playerid, 1);
			SetCameraBehindPlayer(playerid);
			ChopPermission[playerid] = 0;
		}
	}

	if(dialogid == 4){
		if(response){
			if(listitem == 0){
				SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja rotile!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FINAL, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n{02A117}3.  Dezmembreaza motorul - Terminat\n     \n{FFFFFF}4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 1){
				SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja caroseria!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FINAL, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n{02A117}3.  Dezmembreaza motorul - Terminat\n     \n{FFFFFF}4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 2){
				SendClientMessage(playerid, -1, "Error: Ai dezmembrat deja motorul!");
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FINAL, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n{02A117}3.  Dezmembreaza motorul - Terminat\n     \n{FFFFFF}4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 3){
				ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FINAL, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "{02A117}1.  Dezmembreaza rotile - Terminat\n{02A117}2.  Dezmembreaza caroseria - Terminat\n{02A117}3.  Dezmembreaza motorul - Terminat\n     \n{FFFFFF}4.  Vinde piesele masinii", "Select", "Cancel");
			}
			else if(listitem == 4){
				new vehid = ChopVehid[playerid];
				ChopCar(vehid, playerid);
				ChopPermission[playerid] = 0;
				TogglePlayerControllable(playerid, 1);
				SetCameraBehindPlayer(playerid);
			}
		}
		else if(!response){
			TogglePlayerControllable(playerid, 1);
			SetCameraBehindPlayer(playerid);
			ChopPermission[playerid] = 0;
		}
	}
	return 1;
}

//-------------------------------------------

CMD:chopshop(playerid, params[]){

	new playerstate = GetPlayerState(playerid);
	new vehid = GetPlayerVehicleID(playerid);
	if(ChopPermission[playerid] != 1) return SendClientMessage(playerid, -1, "Error: Trebuie sa primesti permisiunea de a vinde o masina pe piese de la un Admin 4+");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Error: Trebuie sa fii intr-o masina pentru a face asta!");
	if(playerstate != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, -1, "Error: Trebuie sa fii soferul unei masini pentru a face asta!");
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, 2190.5269, -2267.0112, 13.3369)){
		SendClientMessage(playerid, -1, "Error: Nu esti la locatia potrivita! Ti-am setat un punct pe harta.");
		DisablePlayerCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, 2190.5269, -2267.0112, 13.3369, 3.0);
		ChopCP[playerid] = 1;
		return 1;
	}	
	ChopVehid[playerid] = vehid;
	SetPlayerCameraPos(playerid, 2195.7378, -2272.4409, 14.7743);
	SetPlayerCameraLookAt(playerid, 2190.5269, -2267.0112, 13.3369, 1);
	TogglePlayerControllable(playerid, 0);
	ShowPlayerDialog(playerid, DIALOG_CHOPSHOP_FIRST, DIALOG_STYLE_LIST, "CHOPSHOP - DEZMEMBREAZA MASINA", "1.  Dezmembreaza rotile\n2.  Dezmembreaza caroseria\n3.  Dezmembreaza motorul\n     \n4.  Vinde piesele masinii", "Select", "Cancel");

	return 1;
}

CMD:choppermission(playerid, params[]){

	new userid;
	new string[500];
	//if(!pInfo[pAdmin][playerid] >= 4) return SendClientMessage(playerid, CULOAREA SI MESAJUL DE EROARE DE PE SERVER);
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, -1, "Syntax: /choppermission [Player ID / Part of Name]");
	new playername[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, playername, sizeof(playername));
	new username[MAX_PLAYER_NAME + 1];
	GetPlayerName(userid, username, sizeof(username));
	if(ChopPermission[userid] == 0){
		ChopPermission[userid] = 1;
		format(string, sizeof(string), "I-ai acordat lui %s permisiunea de a folosi sistemul de chopshop!", username);
		SendClientMessage(playerid, -1, string);
		format(string, sizeof(string), "Administratorul %s ti-a acordat permisiunea de a folosi sistemul de chopshop!", playername);
		SendClientMessage(userid, -1, string);
	}
	else if(ChopPermission[userid] == 1){
		ChopPermission[userid] = 0;
		format(string, sizeof(string), "I-ai revocat lui %s permisiunea de a folosi sistemul de chopshop!", username);
		SendClientMessage(playerid, -1, string);
		format(string, sizeof(string), "Administratorul %s ti-a revocat permisiunea de a folosi sistemul de chopshop!", playername);
		SendClientMessage(userid, -1, string);
	}
	return 1;
}

CMD:veh(playerid, params[]){

	new vehtype, vehid, Float: X, Float: Y, Float: Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(sscanf(params, "i", vehtype)) return SendClientMessage(playerid, -1, "Syntax: /veh [VEH ID]");
	vehid = CreateVehicle(vehtype, X, Y, Z, 1.0, -1, -1, 0, 0);
	PutPlayerInVehicle(playerid, vehid, 0);
	return 1;
}












