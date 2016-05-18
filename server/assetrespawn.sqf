//by tankbuster
_myscript = "assetrespawn.sqf";
// execvmd by the vehiclerespawn module or the mpkilled eh on the vehicles

if (not isServer) exitWith {};
diag_log format ["*** %1 starts %2,%3", _myscript, diag_tickTime, time];
private ["_oldv","_newv","_respawns","_droppoint","_forget","_nul", "_typefpv", "_typefob", "_droppoint2"];
_newv = _this select 0;
_oldv = _this select 1;
diag_log format ["***assetrespawn gets newv %1 and oldv %2", _newv, _oldv];
switch (_newv) do
	{
	case forward: {_typefpv = true; _typefob = false;};
	case fobveh: {_typefpv = false; _typefob = true;};
	default {_typefpv = false; _typefob = false};
	};
if ((_typefpv) and (forwardrespawning)) exitWith {diag_log "***assetrespawn fpv duplication avoided!"};
if ((_typefob) and (fobrespawning)) exitWith {diag_log "***assetrespawn fob duplication avoided!"};
if (_typefpv) then
	{
	forwardrespawning = true;
	publicVariable "forwardrespawning";
	forwardrespawnpositionid call bis_fnc_removeRespawnPosition;
	};
if (_typefob) then
	{
	fobrespawning = true;
	publicVariable "fobrespawning";
	if (fobdeployed) then
		{
		fobrespawnpositionid call bis_fnc_removeRespawnPosition;
		};//if the fob is deployed, remove its respawn id
	};
//diag_log format ["***assetrespawn says _typefpv %1 and _typefob %2", _typefpv, _typefob];
// find the nearest current respawn to the old position
_respawns = [west] call bis_fnc_getRespawnPositions;
//diag_log format ["*** found some respawns %1", _respawns];
_respawns2 = _respawns - [_newv];
//diag_log format ["*** rspawns minus the old veh %1", _respawns2];
//_droppoint = [_respawns2, _newv] call BIS_fnc_nearestPosition; //find the one nearest to the old respawn pos
_droppoint = (nearestObjects [_oldv, ["Flag_Blue_F"], 10000]) select 0; // get the nearest blue flag. there's 1 at the beach and another at each taken target.
/*
_myid = _respawns find _oldv;
 if (_myid > -1) then {[west, _myid] call bis_fnc_removeRespawnPosition;};
 */
switch (typeName _droppoint) do
	{
	case "ARRAY": {_droppoint2 = _droppoint};
	case "STRING": {_droppoint2 = markerpos _droppoint};
	case "OBJECT": {_droppoint2 = getpos _droppoint};
	};
diag_log format ["*** droppoint is %1 type %2", _droppoint, typeName _droppoint];
sleep 1;
switch (true) do
	{
	case _typefpv:
		{
		_nul = [_droppoint2, blufordropaircraft, forwardpointvehicleclassname ] execVM "server\spawnairdrop.sqf";
		diag_log "***ar calls a fpv";
		
		// Place in standard inventory of Forward
		{
			_fn = _x;
			_tp = CQBCleanupArr select _forEachIndex;
			_tar = _tp select 0;
			{
				_n = (_tp select 1) select _forEachIndex;
				_tmp = Forward call compile format [ "_this add%1CargoGlobal[%2,%3]", _fn, _tar, _n ]; 
			} forEach _tar;
				
		}forEach [ "backpack", "item", "magazine", "weapon" ];
		
		forwardrespawning = false;
		publicVariable "forwardrespawning";
		};
	case _typefob:
		{
		_nul = [_droppoint2, blufordropaircraft, fobvehicleclassname ] execVM "server\spawnairdrop.sqf";
		diag_log "***ar calls a fob";
		fobrespawning = true;
		publicVariable "fobrespawning";
		};
	default {diag_log "***default"};
	};
sleep 8;
diag_log format ["*** %1 ends %2,%3", _myscript, diag_tickTime, time];

