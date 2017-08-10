//by tankbuster
 #include "..\includes.sqf"
_myscript = "do_kill1man";
__tky_starts;
private ["_1sttext","_kill1types","_mcode","_searchbuildings","_spawninsidehigh","_spawninsidelow","_spawnoutside","_mantokill","_unitinit","_insupports","_outsupports","_mtext","_foreachindex","_targetman","_redtargets","_mytown","_tname","_nearblds1","_nearblds0","_cblds1","_thisbld","_cblds2","_cblds3","_mybld","_mybldposs0","_mybldposs2","_mveh","_seldpos","_smk1mgrp","_mydude","_smcleanup", "_2ndtext"];
missionactive = true; publicVariable "missionactive";
missionsuccess = false; publicVariable "missionsuccess";
_1sttext =  ["Locals report there is a ", "Freindly forces tell us there's a ", "Mobile phone intercepts show there might be a ", "Our forward forces observed a ", "Reports are coming in of a ", "Human gathered intel tells us there is a "];
_kill1types =
	[
		/*["missioncode",
			[buildings to use (array of classnames)],
			spawninsidehighflag, spawninsidelowflag, spawnoutsideflag, roofonlyflag << note that roof only must be exculsive
			[classnames of mantokill],"unitinit",
			["classnames of support units indoors"],
			["classnames of support units outdoors"],
			["missiontextstrings"]
		]*/
		["cgl",
			["Land_FuelStation_Build_F", "Land_FuelStation_01_shop_F", "Land_FuelStation_01_workshop_F", "Land_FuelStation_02_workshop_F"],
			false, true, false, false,
			["I_C_Soldier_Bandit_7_F"],"",
			[""],
			[""],
			["His activities are disturbing the fragile peace. Take him out"]
		 ],
		["htg",
			["House_f"],
			false, true, false,false,
			["I_C_Soldier_Bandit_1_F"], "",
			["I_C_Soldier_Bandit_4_F"],
			[""],
			["He has been taking hostages for ransom. We need him taken out."]
		],
		["eof",
			["Land_i_Barracks_V1_F"],
			false, true, false,false,
			["O_G_officer_F"], "",
			["O_G_Soldier_TL_F", "O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F", "O_G_medic_F", "O_G_Soldier_GL_F", "O_G_Soldier_GL_F"],
			["O_G_Offroad_01_armed_F", "O_APC_Wheeled_02_rcws_F", "O_G_Van_01_transport_F"],
			["He is thought to be planning a major counterattack in the North. Liquidate him, fast."]
		],
		["sni",
			["House_f"],
			false, false, true, true,
			["O_T_Sniper_F"], "this setUnitPos 'DOWN'",
			["O_T_Spotter_F", "O_G_Soldier_AR_F","O_G_Soldier_AR_F","O_G_Soldier_AR_F", "O_G_medic_F"],
			[""],
			["He's been sniping civilians and our troops. He must be stopped quickly"]
		]
	];
/*
missiontextstrings explan
random ["Locals report there is a ", "Freindly forces tell us there's a ", "Mobile phone intercepts show there might be a ", "Our forward forces observed a ", "Reports are coming in of a "]
plus
screenname classname of manktokill
plus
if spawninsideflag then "inside" else "near"
plus
distance
plus
cardinaldirection
plus
of nearesttown.
plus
missiontextstring
*/
submissiondata = selectRandom _kill1types;
submissiondata params ["_mcode", "_searchbuildings", "_spawninsidehigh", "_spawninsidelow", "_spawnoutside", "_spawnonroof", "_mantokill", "_unitinit", "_insupports", "_outsupports", "_mtext"];
{
diag_log format ["***submissiondata %1, %2", _foreachindex, _x];

}foreach submissiondata;

_targetman = selectRandom _mantokill;
_redtargets = (cpt_position nearEntities ["Logic", 4000]) select {((_x getVariable ["targetstatus", -1]) isEqualTo 1) and {((_x distance2d cpt_position) > 700 and ((_x getVariable ["targetlandmassid", -1]) isEqualTo cpt_island))} };
//^^^ get nearby enemy towns between 700m and 5km away that are not blu town and on the same island
_mytown = selectRandom _redtargets;
// ^^^ select 1 at random
_tname = _mytown getVariable ["targetname", "Springfield"];
_tradius = _mytown getVariable ["targetradius", 125];
diag_log format ["*** dk1m chooses %1", _tname ];
_nearblds1 = nearestTerrainObjects [_mytown, ["house"], 6000, false, true];
diag_log format ["*** dtk1m finds %1 'houses' ", count _nearblds1];
//_nearblds1 = _nearblds0 select {((typeof _x) find "ouse") > 0 }; //only if its got "ouse" in the classname
// ^^^ got some terrain objects,now filter it found our wanted building types
_cblds1 = [];
{
	private ["_thisbld"];
	_thisbld = _x;
	//diag_log format ["***dk1m _nearblds1 loop has _thisbld %1 and _x %2 (should be the same) ", _thisbld, _x];
	{
	//diag_log format ["*** dk1m looping thru _searchbuildings, currently got %1", _x];
	if (_thisbld isKindOf _x) then
		{
		_cblds1 pushBackUnique _thisbld;
		//diag_log format ["***dk1m loop _searchbuildings says %1 is in the _searchbuildings array, entry %2", _thisbld, _x ];
		};
	} foreach _searchbuildings;
} foreach _nearblds1;
//^^^ cblds1 buildings in our list of classes
diag_log format ["***dk1m has %1 candidate buildings to choose from were in the required class", count _cblds1];

if (_spawnonroof) then
	{

		{// keep only the buildings that have roof positions
		_sof_bld_poss = [_x] call BIS_fnc_buildingPositions;
			{
			if ( not (_x call tky_fnc_house)) exitwith
				{
				_clbds2 pushBackUnique _x;
				};
			} foreach _sof_bld_poss;
		}foreach _clbds1;
	} else
	{
	_cblds2 = _cblds1 select { (_spawnoutside) or ( ( (count (_x call BIS_fnc_buildingPositions) ) > 6) and (_spawninsidelow or _spawninsidehigh) and (not ((_x buildingExit 0)  isEqualTo [0,0,0]) ) )};
	};

///^^^cblds2 = buildings that conform to spawn hi/low/outside criteria & removes buildings with less than 5 poss as these are small or have only 'porch' positions & are actualy unenterable OR if spawnonroof, array will contain only blds with roof positions

diag_log format ["*** dk1m has %1 useable buildings (ie, have enough interior positions)", count _cblds2];
_cblds3 = [_cblds2, [] , {_mytown distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_mybld = _cblds3 select 0;
//^^^ take the nearest building to the remote town
_mybldposs0 = [_mybld] call BIS_fnc_buildingPositions;
diag_log format ["*** dk1m chooses %1 at %2, which is a %3, screenname %4 and has %5 positions", _mybld, getpos _mybld, typeOf _mybld, [(_mybld)] call tky_fnc_getscreenname, count _mybldposs0];
//_mybldposs2 = _mybldposs0 select { _x call tky_fnc_inhouse }; // take only the ones indoors. this isnt very good at flitering out porches, unfort. its also broken, so removed.
if ( not _spawnonroof) then
	{
	_mybldposs1 = _mybldposs0 select {( not [_x] call tky_fnc_inhouse)};
	}else
	{_mybldposs1 = _mybldposs0};
// ^^^ if not spawnonroof, then remove all roof positions
_mybldposs2 = [_mybldposs1 , [], {_x select 2}, "ASCEND" ] call BIS_fnc_sortBy; // sort them by altitude, lowest first,
{
	_mveh = createvehicle ["Sign_Arrow_f", _x, [],0,"CAN_COLLIDE"];
} foreach _mybldposs2;
if (_spawninsidehigh and {_spawninsidelow}) then
	{
	_seldpos = selectRandom _mybldposs2;
	_2ndtext = " somewhere in the ";
	};
if (_spawninsidehigh and {not _spawninsidelow}) then
	{
	_seldpos = _mybldposs2 select ( floor random 3 + ((count _mybldposs2) -4 ) );
	_2ndtext = " inside the ";
	};// will select last, 2nd tolast or third to last
if ((not _spawninsidehigh) and {_spawninsidelow}) then
	{
	_seldpos = _mybldposs2 select (floor (random 3));
	_2ndtext = " in the ";
	};//will select 1st,2nd or 3rd  bpos
if (_spawnoutside) then
	{
	_seldpos = [_mybld, 6, 20, 3,0,0.5,0,1,1] call tky_fnc_findSafePos;
	_2ndtext = selectRandom [" in the vicinity of ", " near the ", " not far from the ", " around the ", " a short distance from the "];
	 };
if (spawnonroof) then
	{
	_mybldposs2 = _mybldposs2 select { not ([_x] call tky_fnc_inhouse)};
	_seldpos = selectRandom _mybldposs2;
	_2ndtext = " on the roof of ";
	};

__tky_debug;
diag_log format ["*** high %1, low %2, outside %3 actualpos = %4", _spawninsidehigh, _spawninsidelow, _spawnoutside, _seldpos];
_smk1mgrp = createGroup east;
_unitinit = "sk1mguy = this;" + _unitinit;

 _targetman createUnit [_seldpos, _smk1mgrp, _unitinit, 0.6, "corporal"];

diag_log format ["*** sk1mguy made at %1", getpos _mydude];

_mandir = [(_mytown getDir _mybld)] call tky_fnc_cardinaldirection;
_mandist0 = floor (_mybld distance2D _mytown);

if (_mandist0 < 50) then {_3rdtext = " in the middle of ";};
if ( (_mandist0 >= 50) and (_mandist0 < _tradius ) )then {_3rdtext = " near the middle ";};// <<< get the town radius & the cardinal direction so we can say "in the northern quarter of"
_mandist1 = str ([_mandist0, 50] call tky_fnc_estimateddistance);
if (_mandist0 >= _tradius) then {_3rdtext = _mandist1 + _mandir + _tname};

smmissionstring = (selectRandom _1sttext) + ([_targetman] call tky_fnc_getscreenname) + _2ndtext +  ([_mybld] call tky_fnc_getscreenname) + _3rdtext + _mtext;

smmissionstring remoteexecCall ["tky_fnc_usefirstemptyinhintqueue",2,false];
publicVariable "smmissionstring";

failtext = "Dudes. You suck texts";

while {missionactive} do
	{
	sleep 3;
	if (FALSE) then
		{
		missionsuccess = false;
		missionactive = false;
		};

	if (not alive sk1guy) then
		{
		missionsuccess = true;
		missionactive = false;
		"Dudes. You rock! Mission successful. Yey." remoteExecCall ["tky_fnc_usefirstemptyinhintqueue", 2, false];
		};
	};
publicVariable "missionsuccess";
publicVariable "missionactive";
[_smcleanup, 60] execVM "server\Functions\fn_smcleanup.sqf";

__tky_ends
