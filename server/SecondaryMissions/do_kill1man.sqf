//by tankbuster
 #include "..\includes.sqf"
_myscript = "do_kill1man";
__tky_starts;
private ["_1sttext","_kill1types","_mcode","_searchbuildings","_spawninsidehigh","_spawninsidelow","_spawnoutside","_spawnonroof","_mantokill","_unitinit","_insupports","_outsupports","_mtext","_targetman","_redtargets","_mytown","_tname","_tradius","_nearblds1","_nearblds0","_cblds1","_thisbld","_sof_bld_poss","_clbds2","_clbds1","_cblds2","_cblds3","_mybld","_mybldposs0","_mybldposs2","_mybldposs1","_mveh","_seldpos","_2ndtext","__tky_debug","_smk1mgrp","_mydude","_mandir","_mandist0","_3rdtext","_mandist1","_smcleanup", "_mybld2", "_suppos"];
missionactive = true; publicVariable "missionactive";
missionsuccess = false; publicVariable "missionsuccess";
_smcleanup = [];
_1sttext =  ["Locals report there is a ", "Freindly forces tell us there's a ", "Mobile phone intercepts show there might be a ", "Our forward forces observed a ", "Reports are coming in of a ", "Human gathered intel tells us there is a "];
_kill1types =
	[
		/*["missioncode",
			[objects for nearestterrainobjects],
			[buildings to use (array of classnames)],
			number of buildingposs to filter for, spawninsidehighflag, spawninsidelowflag, spawnoutsideflag, roofonlyflag, nearbybuilding << note that roof only must be exclusive
			[classnames of mantokill],"unitinit",
			["classnames of support units indoors"], << no more than 6 and man units only
			["classnames of support units outdoors"],
			["missiontextstrings"]
			**note** if providing a civilian targetman, best to spawn an opfor and forceadduniform him to prevent rating and scoring issues
			test text for push
		]*/
		["cgl",
			["house"],
			["Land_FuelStation_Build_F", "Land_FuelStation_01_shop_F", "Land_FuelStation_01_workshop_F", "Land_FuelStation_02_workshop_F", "Land_GarageShelter_01_F", "Land_CarService_F"],
			6, false, true, false, false, false,
			["I_C_Soldier_Bandit_7_F"],"",
			[""],
			[""],
			"His activities are disturbing the fragile peace. Take him out"
		 ],
		["htg",
			["house"],
			["House_f"],
			6, false, true, false,false, false,
			["I_C_Soldier_Bandit_1_F"], "",
			["I_C_Soldier_Bandit_4_F"],
			[""],
			"He has been taking hostages for ransom and we believe he's planning another operation. We need him taken out."
		],
		["eof",
			["house"],
			["Land_i_Barracks_V1_F"],
			20, false, true, false,false, false,
			["O_G_officer_F"], "",
			["O_G_Soldier_TL_F", "O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F", "O_G_medic_F", "O_G_Soldier_GL_F", "O_G_Soldier_GL_F"],
			["O_G_Offroad_01_armed_F", "O_APC_Wheeled_02_rcws_F", "O_G_Van_01_transport_F"],
			"He is thought to be planning a major counterattack in the North. Liquidate him, fast to disrupt their operations."
		],
		["sni",
			["house"],
			["House_f"],
			6, false, false, false, true, false,
			["O_T_Sniper_F"], "this setUnitPos 'DOWN'",
			["O_T_Spotter_F", "O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F", "O_G_medic_F"],
			[""],
			"He's been sniping civilians and our troops. He must be stopped quickly."
		],
		["bom",
			["house"],
			["Land_Warehouse_03_F", "Land_Warehouse_01_F", "Land_Warehouse_02_F", "Land_SCF_01_warehouse_F","Land_i_Shed_Ind_F","Land_WIP_F","Land_u_Shed_Ind_F","Land_Factory_Main_F"],
			8,false, true, false, false, false,
			["I_G_Soldier_exp_F"], "",
			["I_G_Soldier_GL_F", "I_G_Soldier_GL_F","I_G_Soldier_GL_F","I_G_Soldier_GL_F", "I_G_medic_F"],
			[""],
			"He's a bombmaker we've tracked from the border. He needs to be taken out before he gets to work."
		],
		["esab",
			["power lines", "house"],
			["Land_PowerLine_01_pole_transformer_F", "Land_PowerLine_01_pole_tall_F", "Land_HighVoltageTower_F", "Land_HighVoltageTower_large_F", "Land_PowLines_Transformer_F", "Land_spp_Transformer_F", "Land_PowerLine_01_pole_junction_F","Land_DPP_01_transformer_F","Land_DPP_01_waterCooler_F"],
			-1,false, false, true, false, false,
			["I_C_Soldier_Para_8_F"], "_this doMove (getpos _mybld)",
			[],
			["I_G_Offroad_01_armed_F", "I_G_Offroad_01_armed_F", "I_C_Soldier_Bandit_4_F", "I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_2_F", "I_C_Soldier_Bandit_5_F"],
			"This guy has already sabotaged some of the island electrical infrastructure and we believe he's going to continue. Stop him, permanently."
		],
		["sci",
			["house"],
			["Land_Shop_City_03_F", "Land_Shop_City_02_F", "Land_Shop_City_01_F", "Land_Supermarket_01_F", "Land_Fuelstation_01_Shop_F", "Land_Shop_Town_03_F", "Land_Shop_Town_01_F", "Land_i_Shop_01_V1_F", "Land_i_Shop_01_V2_F", "Land_i_Shop_01_V3_F","Land_u_Shop_01_V1_F","Land_d_Shop_01_V1_F", "Land_i_Shop_02_V1_F", "Land_i_Shop_02_V2_F", "Land_i_Shop_02_V3_F" ],
			6,false, true, false, false, false,
			["O_G_Survivor_F"], "removeheadgear _this; removeuniform _this; _this forceAddUniform 'U_C_Scientist';",// opfor scientist
			["I_G_Soldier_GL_F", "I_G_Soldier_GL_F","I_G_Soldier_GL_F","I_G_Soldier_GL_F"],
			[],
			"This chemical weapons scientist has finally been seen outside of his heavily protected compound, getting supplies or food. We don't care which, take him out. Note that he's probably not unescorted."
		]
	];
_blacklistedbuildings = ["Land_SCF_01_heap_bagasse_f", "land_slum_01_f", "land_slum_03_f",  "land_pierwooden_02_16m_f", "land_pierwooden_02_barrel_f", "land_pierwooden_02_ladder_f"];
// ^^^ note blacklisted buildings cannot be a base class.
submissiondata = selectRandom _kill1types;
submissiondata params ["_mcode", "_searchobjects", "_searchbuildings","_bposthreshold", "_spawninsidehigh", "_spawninsidelow", "_spawnoutside", "_spawnonroof","_spawnnearby", "_mantokill", "_unitinit", "_insupports", "_outsupports", "_mtext"];
{
diag_log format ["***submissiondata %1, %2", _foreachindex, _x];
}foreach submissiondata;
_targetman = selectRandom _mantokill;
_redtargets = (cpt_position nearEntities ["Logic", 4000]) select {((_x getVariable ["targetstatus", -1]) isEqualTo 1) and {((_x distance2d cpt_position) > 700 and ((_x getVariable ["targetlandmassid", -1]) isEqualTo cpt_island))} };
//^^^ get nearby enemy towns between 700m and 4km away that are not blu town and are on the same island
_mytown = selectRandom _redtargets;
// ^^^ select 1 at random
_nearblds1 = nearestTerrainObjects [_mytown, _searchobjects ,8000, false, true];
diag_log format ["*** dtk1m finds %1 'houses' ", count _nearblds1];
// ^^^ got some terrain objects,now filter it found our wanted building types
_cblds1 = [];// <<candidatebuildings1
_cblds2 = [];
{
	private ["_thisbld"];
	_thisbld = _x;
	{
	if ((_thisbld isKindOf _x) and {(not ((typeof _thisbld) in _blacklistedbuildings)) and ((abs( (boundingBoxReal _thisbld select 1 select 2) - (boundingBoxReal _thisbld select 0 select 2))) > 2) and (not (isObjectHidden _thisbld))}) then
		{
		_cblds1 pushBack _thisbld;
		//diag_log format ["***dk1m pushbacks into cblds1 . loop _searchbuildings says %1 is in the _searchbuildings array, entry %2", _thisbld, _x ];
		};
	} foreach _searchbuildings;
} foreach _nearblds1;
//^^^ cblds1 buildings in our list of classes
diag_log format ["***dk1m has %1 candidate buildings to choose from were in the required class", count _cblds1];
if (_spawnonroof) then
	{
		{// keep only the buildings that have roof positions
		_mybld2 = _x;
		_sof_bld_poss = (_mybld2 buildingPos -1);// the buildingpositions of this building
		//diag_log format ["*** dk1m has building %1 at %2  and is going to send this array of positions to inhouse %3", _mybld2, getpos _mybld2, _sof_bld_poss];
			{
			//sleep 0.5;

			if (((count _x) > 2) and {(_x select 2) > 6} ) then //is it a real position array? for some reason, it gets passed [] sometimes, if it is, is it at least a 1s floor?
				{
					if ([ATLToASL _x] call tky_fnc_inhouse)  then
						{
						//diag_log format ["inhouse says %1 is indoors, building %2 ", _x, _mybld2];
						_donothing = true;//I think youre not allowed to have an empty block in a then statement and have just remarked out the diaglog above
						}
						else
						{// if the tested position is outside ie, on a roof
						//diag_log format ["%1 in building %2 is outdoors and has saved the building for use as a sniper pos", _x, _mybld2];
						_cblds2 pushBackUnique _mybld2;// should be buildings that have roof positions higher than 6m
						};
				};
			} foreach _sof_bld_poss;
		}foreach _cblds1;
	} else
	{
	_cblds2 = _cblds1 select { (_spawnoutside) or ( ( (count (_x buildingPos -1 ) ) > _bposthreshold) and (_spawninsidelow or _spawninsidehigh)  )};
	};

///^^^cblds2 = buildings that conform to spawn hi/low/outside criteria & removes buildings with less than 5 poss as these are small or have only 'porch' positions & are actualy unenterable OR if spawnonroof, array will contain only blds with roof positions
diag_log format ["*** dk1m says _cblds2 is %1", _cblds2];
diag_log format ["*** dk1m has %1 useable buildings (ie, have enough interior positions)", count _cblds2];
_cblds3 = [_cblds2, [] , {_mytown distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
diag_log format ["*** _cblds3 is %1",_cblds3];
_mybld = (_cblds3 select random ((floor ((count _cblds3) /10))));
mybldposition = getpos _mybld; publicVariable "mybldposition";
//^^^ take one of the nearest buildings
_mybldposs0 = (_mybld buildingPos -1);
diag_log format ["*** dk1m chooses %1 at %2, which is a %3, screenname %4 and has %5 positions", _mybld, getpos _mybld, typeOf _mybld, [(_mybld)] call tky_fnc_getscreenname, count _mybldposs0];
if ( not _spawnonroof) then
	{
	_mybldposs1 = _mybldposs0 select {( not ([_x] call tky_fnc_inhouse))};
	diag_log format ["*** dk1m removed roofs and has %1", _mybldposs1];
	}else
	{
	_mybldposs1 = _mybldposs0;
	diag_log format ["***dk1m roofs ok and has %1", _mybldposs1];
	};
// ^^^ if not spawnonroof, then remove all roof positions
_mybldposs2 = [_mybldposs1, [], {_x select 2}, "ASCEND" ] call BIS_fnc_sortBy; // sort them by altitude, lowest first,
if (testmode) then
	{
		{
		_mveh = createvehicle ["Sign_Arrow_f", _x, [],0,"CAN_COLLIDE"];
		} foreach _mybldposs2;
	};
if (_spawninsidehigh and {_spawninsidelow}) then
	{
	_seldpos = selectRandom _mybldposs2;
	_2ndtext = " somewhere in the ";
	};
if (_spawninsidehigh and {not _spawninsidelow}) then
	{
	_seldpos = _mybldposs2 select ( count _mybldposs2 - (ceil random 4) );
	_2ndtext = " inside the ";
	};// will select last, 2nd tolast or third to last
if ((not _spawninsidehigh) and {_spawninsidelow}) then
	{
	_seldpos = _mybldposs2 select (floor (random 3));
	_2ndtext = " in the ";
	};//will select 1st,2nd or 3rd  bpos
if (_spawnoutside) then
	{
	_seldpos = [_mybld, 3, 10, 2,0,0.5,0,1,1] call tky_fnc_findSafePos;
	_2ndtext = selectRandom [" in the vicinity of ", " near the ", " not far from the ", " around the ", " a short distance from the "];
	 };
if (_spawnonroof) then
	{
	_seldpos = _mybldposs2 select ( count _mybldposs2 - (ceil random 2));// select one of the last two positions
	_2ndtext = " on the roof of ";
	};

__tky_debug;
diag_log format ["*** high %1, low %2, outside %3, roof %4 actualpos = %5", _spawninsidehigh, _spawninsidelow, _spawnoutside, _spawnonroof, _seldpos];
_smk1mgrp = createGroup east;
_unitinit = "sk1mguy = this;" + _unitinit;

_targetman createUnit [_seldpos, _smk1mgrp, _unitinit, 0.6, "corporal"];
sk1mguy allowdamage false;
sk1mguy setpos _seldpos;
_smcleanup pushback sk1mguy;
_mybldposs2 = _mybldposs2 - [_seldpos];// remove the used position from the array of positions, just in case we need to put further units in the same building
diag_log format ["*** sk1mguy is at %1, spawned at %2", getpos sk1mguy, _seldpos];
sleep 2;
sk1mguy allowdamage true;

if ((count _insupports) > 0 and {(count _mybldposs2) > 0 }   ) then
	{
	_supportbldposs = +_mybldposs2;
		{
		_suppos = selectRandom _supportbldposs;
		_supportbldposs = _supportbldposs - [_suppos];
		_isman = _smk1mgrp createUnit [_x, _suppos, [], 0, "NONE"];
		_smcleanup pushback _isman;
		} foreach _insupports;
	};// ^^^ if insupports provided, spawn them

if ( (count _outsupports) > 0 ) then
	{
		{
		_ostype = _x;
		if (_ostype isKindOf "LandVehicle") then
			{
			_ospos = [_mybld, (sizeof (typeof _mybld)), 500, 8 ,0,0.5,0,1,1] call tky_fnc_findSafePos;
			_ret = [_ospos, (_ospos getdir alpha_1), _ostype, _smk1mgrp] call BIS_fnc_spawnVehicle;
			_smcleanup pushBack (_ret select 0);
			}
			else
			{//assume its a man unit
			_ospos = [_mybld, (sizeof (typeof _mybld)), 500, 3 ,0,0.5,0,1,1] call tky_fnc_findSafePos;
			_osman = _smk1mgrp createUnit [_x, _ospos, [],0, "NONE"];
			_smcleanup pushback _osman;
			};
		}forEach _outsupports;
	};

//get the new nearest logic, in case mybld is a long way from mytown
_3rdtext = [_mybld] call tky_fnc_distanddirfromtown;
smmissionstring = (selectRandom _1sttext) + ([sk1mguy] call tky_fnc_getscreenname) + _2ndtext +  ([_mybld] call tky_fnc_getscreenname) + " " + _3rdtext + ". " + _mtext;

smmissionstring remoteexecCall ["tky_fnc_usefirstemptyinhintqueue",2,false];
publicVariable "smmissionstring";

failtext = "One of your team died during the operation. That's a failed mission.";

while {missionactive} do
	{
	sleep 3;
	if (FALSE) then// failure is set by killed EH on players. (see client\fn_killedeh)
		{
		missionsuccess = false;
		missionactive = false;
		};

	if (not alive sk1mguy) then
		{
		missionsuccess = true;
		missionactive = false;
		"You killed him! Good job team. Mission success." remoteExecCall ["tky_fnc_usefirstemptyinhintqueue", 2, false];
		};
	};
publicVariable "missionsuccess";
publicVariable "missionactive";
if (not missionsuccess) then {publicVariable "failtext"};
[_smcleanup, 60] execVM "server\Functions\fn_smcleanup.sqf";

__tky_ends
