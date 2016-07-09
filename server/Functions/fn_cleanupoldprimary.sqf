//by tankbuster

_myscript = "cleanupoldprimary";
diag_log format ["*** %1 starts %2,%3", _myscript, diag_tickTime, time];
private ["_nvc"];
if (isNull previousmission) exitWith {diag_log "***cleanupoldprimary exits because previous mission is null!"};// ie, its the first target
_nvc = 0.75 * (["notveryclose",500] call BIS_fnc_getParamValue);
{
	if ((_x distance (getpos previousmission)) < _nvc ) then
	{
	deletevehicle _x;
	diag_log format ["***cleanupoldprimary deletes a dead %1", typeof _x];
	};
}foreach allDead;
// ^^ finds and deletes all dead vehicles and men
{
	if ([_x, true] call BIS_fnc_objectSide isEqualTo WEST) then

	{
	diag_log format ["*** cleanupoldprimary didnt delete %1 because it's friendly", typeof _x];
	}
	else
	{
	deleteVehicle _x;
	diag_log format ["*** cleanupoldprimary deletes an old %1 vehicle ", typeof _x];
	};
} foreach  ((getpos previousmission) nearEntities ["LandVehicle", _nvc]);
// ^^ finds and delete civ and russian cars/tanks . leaves anything non russian

{
	deleteVehicle _x;
	diag_log format ["*** cleanupoldprimary deletes some old civilan %1", typeof _x];
} foreach (previousmission nearEntities [["Civilian_F", "CUP_Creatures_Civil_Chernarus_Base"], _nvc]);
// ^^ finds and deletes civilian men. any in cars/tanks etc will have been ejected when their veh was deleted earlier.



// Delete all CQB stuff (Mines, statics, etc)
{
	deleteVehicle _x;
} forEach CQBCleanupArr;
{deleteGroup _x} foreach allGroups;
diag_log format ["*** %1 ends %2,%3", _myscript, diag_tickTime, time];