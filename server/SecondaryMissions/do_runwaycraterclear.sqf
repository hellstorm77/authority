//by tankbuster
 #include "..\includes.sqf"
_myscript = "do_runwaycraterclear";
__tky_starts;
private ["_candiposs","_runwayposs","_runwayposshuffled","_nx","_craterpos","_crater","_cratereh", "_smcleanup", "_cratercount", "_craterclearedcount", "_thiscrater"];
missionactive = true;missionsuccess = false; mycraters = [];_smcleanup = [];
publicVariable "missionactive"; publicVariable "missionsuccess";
smmissionstring = format ["Enemy action has damaged our main airbase runways and taxiways, probably with runway denial munitions. "];
failtext = "The Bobcat has been lost and there are still some craters on the runways. You've failed this secondary mission";
//smmissionstring remoteExecCall  ["tky_fnc_usefirstemptyinhintqueue", 2, false];
if (count (blubasehelipad nearEntities ["B_APC_Tracked_01_CRV_F", 5000]) < 1) then
	{
	smmissionstring = smmissionstring + "Please clear the Airhead Helipad as a Bobcat CRV is being airdropped there. Use this to push the craters off the runways and taxiways.";
	//_txt = "Please clear the Airhead Helipad, use this vehicle to push craters clear of the runways and taxiways.";
	_nul = [blubasehelipad, blufordropaircraft, "B_APC_Tracked_01_CRV_F", [0,0,0],"", "mybobcat"] execVM "server\spawnairdrop.sqf";
	}
	else
	{
	smmissionstring = smmissionstring + "You already have a Bobcat CRV. Use it to push the craters off the runways and taxiways.";
	//"You already have a Bobcat CRV at the Airhead. Use it to push craters off the runways and taxiways" remoteExecCall ["tky_fnc_usefirstemptyinhintqueue", 2, false];
	};
publicVariable "smmissionstring";
smmissionstring remoteExecCall  ["tky_fnc_usefirstemptyinhintqueue", 2, false];

_candiposs = nearestObjects [blubasehelipad, [], 300, true];
_runwayposs = _candiposs select {((str _x) find "bleroa" > 0) and ((_x distance2D blubasehelipad)> 100) };///find invisibleroadways more than 100m from helipad
_runwayposshuffled = _runwayposs call BIS_fnc_arrayShuffle;
for "_nx" from 0 to ((playersNumber west + (floor (random 4))) min 5) do
	{
	_craterpos = _runwayposshuffled select _nx;
	_crater = createVehicle ["craterlong_small", getpos _craterpos, [],0,"NONE"];
	mycraters pushBack _crater;
	_smcleanup pushback _crater;
	_handle = [_crater] spawn
		{
		while {missionactive} do
			{
			params ["_mycrater"];
			private ["_mybobcat","_craterdir"];
			waitUntil {sleep 0.1; !((_mycrater nearObjects ["B_APC_Tracked_01_CRV_F", 6]) isEqualTo [])};
			_mybobcat = nearestObject [_mycrater, "B_APC_Tracked_01_CRV_F"];
			if (
			    ((attachedObjects _mybobcat) isEqualTo [] ) and
				{   ([(getpos _mybobcat), (getdir mybobcat), 40, getpos _mycrater ] call BIS_fnc_inAngleSector) and
					((speed _mybobcat) > 5)
				}
				) then
					{
					_craterdir = getdir _mycrater;
					_mycrater attachTo [_mybobcat, [0,6,-2]];
					};
			waitUntil {sleep 0.5;(((speed _mybobcat) < -3 ) or (!(alive _mybobcat)))};

			detach _mycrater;
			_mycrater setpos [(getpos _mycrater select 0), (getpos _mycrater select 1), 0] ;
			sleep 0.5;
			};
		};
	};
_cratercount = count mycraters;
waitUntil {sleep 1; not (isNil "mybobcat")};
while {missionactive} do
	{
	sleep 3;
	if (not(alive mybobcat) ) then
		{
		missionsuccess = false;
		missionactive = false;
		publicVariable "failtext";
		};
	_craterclearedcount = 0;
	{
		_thiscrater = _x;
		if (count ((nearestObjects [_thiscrater, [], 13, true]) select {((str _x) find "bleroa" > 0)}) < 1) then // this crater is clear of the runway and taxiways
			{
			_craterclearedcount = _craterclearedcount +1;
			//diag_log format ["***crater pushed off the runway!, cleared count = %1", _craterclearedcount];
			};
	}foreach mycraters;
	if (_craterclearedcount isEqualTo _cratercount) then
		{
		missionsuccess = true;
		missionactive = false;
		"That's good Bobcat driving there, soldier. You've pushed all the craters off the runways. Secondary mission complete." remoteExecCall ["tky_fnc_usefirstemptyinhintqueue", 2, false];
		};
	};
publicVariable "missionsuccess"; publicVariable "missionactive";
[_smcleanup, 60] execVM "server\Functions\fn_smcleanup.sqf";

__tky_ends
