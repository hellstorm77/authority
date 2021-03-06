/*  Copyright 2016 Fluit

    This file is part of Dynamic Enemy Population.

    Dynamic Enemy Population is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation version 3 of the License.

    Dynamic Enemy Population is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dynamic Enemy Population.  If not, see <http://www.gnu.org/licenses/>.
*/
// This file spawns barracks type 2.

private ["_pos", "_dir", "_newpos", "_campgroup", "_prop", "_soldier", "_fire","_totalenemies","_groups","_objects","_enemypositions"];
_pos 				= _this select 0; // Camp position
_dir 				= _this select 1; // Camp direction

// Try to align the camp with the nearest road
_road = [_pos, 50] call dep_fnc_nearestroad;
if !(isNull _road) then {
    _dir = [_road] call dep_fnc_roaddir;
};

_totalenemies = 0;
_groups = [];
_objects = [];

_prop = "Land_ClutterCutter_medium_F" createVehicle _pos;
_fire = "Campfire_burning_F" createVehicle _pos;

_newpos = _fire getPos [1, (_dir + 270)];
_prop = "Land_WoodenLog_F" createVehicle _newpos;
_prop = (selectRandom ["Land_BakedBeans_F","Land_Canteen_F","Land_CerealsBox_F","Land_Matches_F"]) createVehicle _newpos;

_newpos =  _fire getPos [11, (_dir + 90)];
_prop = (selectRandom ["Land_i_Stone_HouseSmall_V1_F", "Land_i_Stone_HouseSmall_V2_F", "Land_i_Stone_HouseSmall_V3_F"]) createVehicle _newpos;
_prop setDir (_dir + 90);
_enemypositions = _prop buildingpos -1;

_newpos = _fire getPos [6, (_dir + 90)];
_prop = "Land_WoodenTable_large_F" createVehicle _newpos;
_prop setDir _dir;

_newpos = _fire getPos [13, (_dir)];
_prop = (selectRandom ["Land_i_Stone_Shed_V1_F", "Land_i_Stone_Shed_V2_F", "Land_i_Stone_Shed_V3_F"]) createVehicle _newpos;
_prop setDir (_dir);
_buildpos = _prop buildingpos -1;
_enemypositions = _enemypositions + _buildpos;

_newpos = _fire getpos [2, (random 360)];
_enemypositions = _enemypositions + [_newpos];
_newpos = _fire getpos [2, (random 360)];
_enemypositions = _enemypositions + [_newpos];
_newpos = _fire getPos [2, (random 360)];
_enemypositions = _enemypositions + [_newpos];

if ((random 1) < 0.5) then
{
    _newpos = _fire getPos [10, (_dir + 270)];
    _prop = (selectRandom dep_civ_veh) createVehicle _newpos;
    _prop setDir _dir;
    _prop setFuel (1 - (random 1));
};

_campgroup = createGroup dep_side;
_groups = _groups + [_campgroup];
_totalenemies = _totalenemies + dep_max_ai_loc;

for "_e" from 1 to dep_max_ai_loc do {
    _newbuildpos = [];
    if ((count _enemypositions) > 0) then {
        _newbuildpos = selectRandom _enemypositions;
        _enemypositions = _enemypositions - [_newbuildpos];
    } else {
        _newbuildpos = (getPos _fire) findEmptyPosition [0,20];
        if ((count _newbuildpos) == 0) then { _newbuildpos = (getPos _fire); };
    };
    _soldiername = selectrandom dep_guer_units;
    _soldier = [_campgroup, _soldiername, _newbuildpos] call dep_fnc_createunit;
    _soldier setDir (random 360);
};
[_campgroup] spawn dep_fnc_enemyspawnprotect;
doStop (units _campgroup);

{
    if ((_x distance _fire) <= 5) then {
        _x lookAt _fire;
        _x disableAI "ANIM";
        _x action ["SitDown", _x];
        _x enableAI "ANIM";
    };
} forEach(units _campgroup);

[_totalenemies,_groups,_objects];