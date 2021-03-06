//by tankbuster
 #include "..\includes.sqf"
_myscript = "do_destroyradiotower";
__tky_starts
private ["_n","_cpos","_candiposs","_sortedcandiposs","_sortedcandiposs2","_finalpos","_tower","_dtreldir","_dtdist","_ii","_mypos","_drt_opfor1","_smcleanup","_drt_opfor3"];
_candiposs = []; _smcleanup = [];
missionactive = true; missionsuccess = false; publicVariable "missionactive"; publicVariable "missionsuccess";
failtext = "Error if players read this. Mission has no failure condition"; publicVariable "failtext";
// find some nice high ground
for "_n" from 0 to 10 do
	{
	_cpos =  [cpt_position, 3000, 400,50] call bis_fnc_findOverwatch;
	_candiposs pushBackUnique _cpos;
	};
if (count _cpos < 1) then
	{
	diag_log "***drt didn't find highpoint using normal search, going again with easirer criteria";
	for "_n" from 0 to 10 do
		{
		_cpos =  [cpt_position, 6000, 200] call bis_fnc_findOverwatch;
		_candiposs pushBackUnique _cpos;
		};
	};
_finalpos =  selectRandom _candiposs;
_tower = createVehicle ["Land_TTowerBig_2_F",_finalpos, [],0,"NONE"];
//_tower addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") or ((_this select 4 ) isKindOf "ShellCore")) then { 1; } else { _this select 2; }; }];

_tower setVectorUp [0,0,1];
_smcleanup pushBack _tower;

_mtext = [(getpos _tower)] call tky_fnc_distanddirfromtown;
smmissionstring = format ["Freindly force commanders have called in the position of a radio relay %1. If we can destroy it, it will be a great help to them and us.", _mtext];
smmissionstring remoteExecCall ["tky_fnc_usefirstemptyinhintqueue", 2, false];
publicVariable "smmissionstring";
for "_ii" from 0 to ((ceil (playersNumber west ) /2) min 5) do
	{
	_mypos = [_tower, 5, 800, 6,0,0.5,0,1,1] call tky_fnc_findSafePos;
	_drt_opfor1 = createvehicle [(selectRandom opforpatrollandvehicles), _mypos, [],0,"NONE"];
	createVehicleCrew _drt_opfor1;
	NUL = [group (effectiveCommander _drt_opfor1), getpos _tower, 200 ] call BIS_fnc_taskpatrol;
	sleep 0.5;
	_smcleanup pushback _drt_opfor1;
	};
for "_ii" from 0 to ((ceil (playersNumber west ) /4) min 5) do
	{
	_mypos = [_tower , 15, 100, 8,0,0.5,0,1,1] call tky_fnc_findSafePos;
	_drt_opfor3 = [_mypos, east, (configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad_Weapons")] call BIS_fnc_spawnGroup;
	[_drt_opfor3, getpos _tower] call BIS_fnc_taskDefend;
	_smcleanup pushback _drt_opfor3;
	sleep 0.5
	};
while {missionactive} do
	{
	sleep 3;
	if (not(alive _tower) or (damage _tower > 0.5)) then
		{
		_tower setdamage 1;
		missionsuccess = true; publicVariable "missionsuccess";
		missionactive = false; publicVariable "missionactive";
		"That's good work. Their communications have been severely disrupted. Command is pleased." remoteExecCall ["tky_fnc_usefirstemptyinhintqueue", 2, false];
		};
	};
[_smcleanup, 60] execVM "server\Functions\fn_smcleanup.sqf";
__tky_ends
