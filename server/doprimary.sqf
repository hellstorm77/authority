//by tankbuster
 #include "..\includes.sqf"
_myscript = "doprimary.sqf";
__tky_starts;
private ["_npt","_handle","_handle1","_flagpos","_t","_mytruck","_radarpos","_radartype","_hqtype","_hqpos","_testradius"];
vehiclecleanup= []; mancleanup = []; roadblockreturndata = nil; roadblockscleared = false;pt_tripmines = [];
sleep 10;
__tky_debug
if !(testmode) then {sleep 40;};
if (primarytargetcounter > 1) then
	{
	// 2nd, 3rd , 4th targets, etc
	handle_cnp_finished = false;
	_npt = [cpt_position] execVM "server\choosenextprimary.sqf";// creates global variable nextpt which is a logic
	waitUntil {handle_cnp_finished};
	sleep 0.1;
	primarytarget = nextpt;// <-- dont forget nextpt is a logic
	_handle = [primarytarget] execVM "server\PT_ai\ai_spawnroadblocks.sqf";
	waitUntil {sleep 0.2;(!(isnil "roadblockreturndata"))};
	}else
	{
	roadblockscleared = true;// this is the first target, no roadblocks so set it to true so it's ignored
	};
__tky_debug
//Reset goodguy scores.
reinforcementcounter = 0;
heartandmindscore = 0;
civkillcount = 0;
reinforcementcounter = 0;
captivekillcounter = 0;
deadgatecount = 0;
cpt_position = getpos nextpt;
cpt_radius = (nextpt getVariable "targetradius");
cpt_type = (nextpt getVariable "targettype");
cpt_name = (nextpt getVariable "targetname");
cpt_island = (nextpt getVariable "targetlandmassid");
primarytarget = nextpt;
publicVariable "primarytarget";
__tky_debug
// Spawn Enemy Horde.
handle_spt_finished = false;
_handle1 = [primarytarget] execVM "server\spawnprimarytargetunits.sqf";//<< must send a target logic, ie on with variables stored on it
__tky_debug
waitUntil {handle_spt_finished};
__tky_debug
// Spawn Enemy CQB
handle_ai_pcqb_finished = false;
_handle1 = [position primarytarget, cpt_radius] execVM "server\PT_ai\ai_populateCQBBuildings2.sqf";//
__tky_debug
waitUntil {handle_ai_pcqb_finished};
__tky_debug
_flagpos = [cpt_position,0,20,0,0,20,0] call bis_fnc_findSafePos;
cpt_flag = "Flag_Red_F" createVehicleLocal _flagpos;
// create a marker
cpt_marker = createMarker [("cpt_marker_" + str primarytargetcounter), cpt_position];
cpt_marker setMarkerShape "ELLIPSE";
cpt_marker setMarkerType "Flag";
cpt_marker setMarkerSize [cpt_radius,cpt_radius];
cpt_marker setMarkerColor "ColorRed";
__tky_debug
// make trigger that senses when town is empty of enemies
trg2 = createTrigger ["EmptyDetector", cpt_position];
trg2 setTriggerArea [(cpt_radius + 200),(cpt_radius + 200),0,false];
trg2 setTriggerActivation  ["EAST", "NOT PRESENT", false];
trg2 setTriggerStatements ["this", "", ""];
__tky_debug
trg3 = createTrigger ["EmptyDetector", cpt_position];
trg3 setTriggerArea [(cpt_radius + 200),(cpt_radius + 200),0,false];
trg3 setTriggerActivation  ["EAST", "NOT PRESENT", false];
trg3 setTriggerStatements ["( (not (alive pt_radar)) and (not (alive pt_hq)) and (roadblockscleared) and (triggerActivated trg2))", "execVM 'server\assaultphasefinished.sqf'", ""];
// task stuff
__tky_debug
taskname = "task" + str primarytargetcounter;
[west, [taskname], ["Clear the target of all enemy forces", "Clear target of enemy forces",(format ["cpt_marker_%1", primarytargetcounter])], cpt_position,1,2,true ] call bis_fnc_taskCreate;
if (
	    (primarytargetcounter == 1) or
	    (cpt_type != 1) or
	    (cpt_radius < 150)
    ) then {roadblockscleared = true};
__tky_debug
if (primarytargetcounter > 1) then
	{
	if ((roadblockreturndata select 4) > 0) then // if this isnt the first target and it has roadblocks spawned
		{
		0 spawn	{
			while {!roadblockscleared} do
				{
				sleep 10;
				deadgatecount = 0;
					{
					if ((_x animationPhase "Door_1_rot" == 0) or (!alive _x) or ((damage _x) > 0.8)) then {deadgatecount = deadgatecount +1};
					} foreach roadblockgates;
				if (deadgatecount >= (count roadblockgates)) then
					{
					roadblockscleared = true;
						{
						_mytruck = _x;
						{_mytruck deleteVehicleCrew _x}foreach (crew _mytruck);
						deleteVehicle _mytruck; roadblockgates = [];
						} foreach roadreinforcementvehicles;
					roadreinforcementvehicles = [];
					}
				};
			};
		};
		if (cpt_type==1) then {0 = execVM "server\PT_ai\ai_roadreinforcementmanager.sqf";};
	};
	__tky_debug
// air radar controls the opfor reinforcements that are bought in by helicopter
_radarpos = [] call tky_fnc_findhighground;
_radartype = selectRandom  opforradartypes;
pt_radar = createVehicle [_radartype, _radarpos,[],0,"NONE"];
pt_radar addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") or ((_this select 4 ) isKindOf "ShellCore")) then { 1; } else { _this select 2; }; }];
pt_radar_alive = true;
pt_radar addEventHandler ["killed", {[_this select 0] execVM "server\pt_radarkilled.sqf"}];
pt_radar setVectorUp [0,0,1];
__tky_debug
// hq vehicle controls opfor air support
_hqtype = selectRandom opforhqtypes;
__tky_debug
_hqpos = [0,0,0];
_testradius = 50;
while {_hqpos in [[0,0,0], islandcentre] } do
	{
	_hqpos = [cpt_position, 10, _testradius, 23, 0, 0.3, 0] call BIS_fnc_findSafePos;
	_testradius = _testradius * 2;
	};
pt_hq = createVehicle [_hqtype, _hqpos, [],0, "NONE"];
pt_hq_alive = true;
_higherhqpos = [_hqpos select 0, _hqpos select 1, 10 ];
__tky_debug
hqnet = createVehicle ["Land_IRMaskingCover_01_F", _higherhqpos, [] ,0, "CAN_COLLIDE" ];
hqnet allowdamage false;
pt_hq addeventhandler ["HandleDamage", {if (((_this select 4) isKindOf "MissileCore") or ((_this select 4 ) isKindOf "ShellCore")) then { 1; } else { _this select 2; }; }];
pt_hq addEventHandler ["Killed", {[_this select 0] execVM "server\pt_hqkilled.sqf"}];
if (_hqtype isKindOf "Car") then
	{
		hqnet setdir 90;
	};
if (_hqtype isKindOf "Building") then
	{
		hqnet setdir 180;
	};
[hqnet, 0] call BIS_fnc_setHeight;
hqnet allowdamage true;
__tky_debug
0 = execVM "server\PT_ai\ai_reinforcementChoppermanager.sqf";
0 = execVM "server\PT_ai\ai_airsupportmanager.sqf";
0 = execVM "server\killlastfewai.sqf";

{
	if ((cpt_position distance2d _x) > (cpt_radius + 100)) then
		{
			diag_log format ["%1 too far outside the target (%2m), so destroying it now", _x, (_x distance cpt_position)];
			_x setdamage 1;
		};
} foreach [pt_radar, pt_hq];
//stuff that needs to be check constantly runs here

__tky_ends