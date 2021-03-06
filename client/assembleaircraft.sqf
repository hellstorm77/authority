//by tankbuster
 #include "..\includes.sqf"
_myscript = "assembleaircraft";
__tky_starts;
private ["_mycaller","_prizeclass","_prizeclassscreenname","_sleep","_prizepos","_bestvisibility","_bestdir","_d","_testpos","_cansee","_prizevec"];
_mycaller = _this select 0;
mybox = nearestObject [(getpos _mycaller),"Cargo_base_F"];
_prizeclass = mybox getvariable "eventualtype";
_prizeclassscreenname = [_prizeclass] call tky_fnc_getscreenname;
_sleep = 15;
if (((typeOf _mycaller) find "ngineer") > -1) then // string "ngineer" is in the classname of the caller, ie, is an engineer
	{
		_sleep = 10;
	};
hint format ["Assembling %1. Please wait %2 seconds. If you go away from the container and salute it (default key #), the aircraft will spawn facing you.", _prizeclassscreenname, _sleep];
playersetdir = -1;

saluteeh = player addEventHandler ["AnimDone", {if ((_this select 1) find "salute" >= 0) then// salute is in current anim
		{
		playersetdir = (mybox getDir player);
		hint "At ease. Aircraft will spawn facing you";
		}
	}];

sleep _sleep;
_prizepos = getpos mybox;
_bestvisibility = 0;
_bestdir = 0;
for "_d" from 0 to 315 step 45 do
	{
		_testpos = mybox getrelpos [60 , _d];
		_testpos set [2, 1];
		_cansee = [player, "VIEW"] checkVisibility [(ATLToASL _prizepos),(ATLToASL _testpos)];
		if (_cansee > _bestvisibility) then
			{
				_bestvisibility = _cansee;
				_bestdir = _d;
			};
	};
deletevehicle mybox;
sleep 1;
_prizevec = createVehicle [_prizeclass, _prizepos, [],0,"NONE"];
if (playersetdir > -1) then {_prizevec setdir playersetdir} else { _prizevec setdir _bestdir};

switch (_prizeclass) do
	{
	case blufordropaircraft:
		{
		[_prizevec, "bf"] call fnc_setvehiclename;
		nul = execVM "server\tky_bf_killed_eh.sqf";
		};
	case bluforslingloadlifter: {[_prizevec, "huron"] call fnc_setvehiclename;	} ;
	default {[_prizevec, (format ["prize%1", prizecounter])] call fnc_setvehiclename;}


	};
player removeEventHandler ["AnimDone", saluteeh];

airprizeawaitingassmbly = false;
publicVariable "airprizeawaitingassmbly";

__tky_ends