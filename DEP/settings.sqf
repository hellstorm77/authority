/*  Copyright 2015 Fluit
    
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

// *************************************************************
// This is the settings file for DEP. Edit to your own liking.
// For a complete list of possible settings visit:
//        https://fluitarma.wordpress.com/dep-settings/
// *************************************************************

//      GENERAL SETTINGS

/*
    setting name:       dep_side
    description:        Units spawned by DEP will be on this side 
    possible values:    east, west, independent
    default value:      east
*/
//dep_side = independent;

/*
    setting name:       dep_own_side
    description:        Units spawned by DEP will be hostile to this side 
    possible values:    east, west, independent
    default value:      west
*/
//dep_own_side = west;

/*
    setting name:       dep_despawn
    description:        Time in minutes after which a location will despawn 
    possible values:    integer greater than 0
    default value:      5
*/
//dep_despawn = 2;

/*
    setting name:       dep_debug
    description:        Enables debug mode (shows enemy locations on the map) 
    possible values:    boolean (true or false)
    default value:      false
*/
// dep_debug = false;

/*
    setting name:       dep_logging
    description:        Writes debug messages to Arma 3 log file
    possible values:    boolean (true or false)
    default value:      true
*/
// dep_logging = true;

/*
    setting name:       dep_chat_logging
    description:        Writes debug messages in chat window
    possible values:    boolean (true or false)
    default value:      false
*/
// dep_chat_logging = false;

/*
    setting name:       dep_safe_zone
    description:        Safe zone position. No enemy positions will spawn here
    possible values:    position or array with positions
    default value:      []

dep_safe_zone = [markerPos "dep_safezone_marker_1", markerPos "dep_safezone_marker_2", markerPos "dep_safezone_marker_3",markerPos "dep_safezone_marker_4",markerPos "dep_safezone_marker_5",markerPos "dep_safezone_marker_6"];
*/
/*
    setting name:       dep_safe_rad
    description:        Safe zone radius in meters.
    possible values:    integer greater than 0
    default value:      800
*/
//dep_safe_rad = 800;

/*
	setting name: 	dep_map_margin
	description: 		Distance in meters from the edges of the map where enemies can spawn.
	possible values: 	integer
	default value: 	400
*/
//dep_map_margin = 400 ???? 

/*
    setting name:       dep_ieds
    description:        Allow DEP to spawn IEDs
    possible values:    boolean (true or false)
    default value:      true
*/
// dep_ieds = true;
 
 /*
    setting name:       dep_mines
    description:        Allow DEP to spawn mines (AP and AT)
    possible values:    boolean (true or false)
    default value:      true
*/
// dep_mines = true;

/*
    setting name:       dep_ied_chance
    description:        Chance of objects and rubble on the road being an IED
    possible values:    decimal number from 0 to 1
    default value:      0.7
*/
// dep_ied_chance = 0.7;

/*
    setting name:       dep_cr_ied
    description:        Restrict possibility to defuse and IED to Explosives Specialist class
    possible values:    boolean (true or false)
    default value:      false
*/
//dep_cr_ied = true;

/*
    setting name:       dep_veh_chance
    description:        Chance of vehicles patroling the roads
    possible values:    decimal number from 0 to 1
    default value:      0.3
*/
// dep_veh_chance = 0.3;

/*
    setting name:       dep_unit_init
    description:        Code to execute on every spawned enemy's init
    possible values:    string
    default value:      ""
*/
//dep_unit_init = "[_this] call tky_fnc_tc_setskill";

/*
    setting name:       dep_useheadless
    description:        When true DEP is ran on the Headless Client instead of the server
    possible values:    boolean (true or false)
    default value:      false
*/
// dep_useheadless = false;

/*
    setting name:       dep_headlessclient
    description:        Specify the headless client if there is more than one
    possible values:    Player or empty string
    default value:      ""
*/
// dep_headlessclient = HeadlessClient;

/*
    setting name:       dep_allow_mortars
    description:        Allows players to use enemy mortars
    possible values:    boolean (true or false)
    default value:      true
*/
//dep_allow_mortars = true;

/*
    setting name:       dep_civilians
    description:        Spawn civilians in urban environments and on roads
    possible values:    boolean (true or false)
    default value:      false
*/
//dep_civilians = true;

/*
    setting name:       dep_fail_civilians
    description:        Number of civilian casualties before mission fail. Mission will never fail if set to 0.
    possible values:    positive integer
    default value:      0
*/
// dep_fail_civilians = 0;

/*
    setting name:       dep_zone_markers
    description:        Set which markers show up on the map.
    possible values:    [], ['all'], ['military', 'roadpop']
    default value:      []
*/
//dep_zone_markers = [];

 /*
    setting name:       dep_civ_fail_script
    description:        Run this scrip when too many civilians have been killed.
    possible values:    string
    default value:      ""
*/
 //dep_civ_fail_script = "";
 
//  PERFORMANCE SETTINGS 

/*
    setting name:       dep_max_ai_loc
    description:        Maximum amount of enemies per location 
    possible values:    integer greater than 0
    default value:      8
*/
//dep_max_ai_loc = 4;

/*
    setting name:       dep_aim_player
    description:        AI multiplier for on the fly modifying the maximum amount of enemies per location
    possible values:    decimal number from 0 to 1
    default value:      0
*/
// dep_aim_player = 0; // this results in 0 players = 8 ai, 10 players = 12 ai.

/*
    setting name:       dep_max_ai_tot
    description:        Maximum total amount of enemy that can be alive at once
    possible values:    integer greater than 0
    default value:      200
*/
//dep_max_ai_tot = 100;

/*
    setting name:       dep_act_dist
    description:        Minimum distance from player to activate a location
    possible values:    integer greater than 0
    default value:      800
*/
//dep_act_dist = 600;

/*
    setting name:       dep_act_height
    description:        Player must be below this height to be able to activate a location
    possible values:    integer greater than 0
    default value:      80
*/
// dep_act_height = 80;

/*
    setting name:       dep_act_speed
    description:        Player must travel below this speed to be able to activate a location
    possible values:    integer greater than 0
    default value:      160
*/
//dep_act_speed = 100;

//   LOCATION TYPES

/*
    setting name:       dep_roadblocks
    description:        Number of roadblocks
    possible values:    integer greater than 0
    default value:      <map specific>
*/
//dep_roadblocks = 30;

/*
	Number of bunkers
	possible values: integer
	default value: <map specific>
*/
//dep_bunkers=30;

/*
	Number of vehicle patrol areas
	possible values: integer
	default value: <map specific>
*/
//dep_patrols=30;

/*
	Number of patroling air vehicles
	possible values: integer
	default value: 1
*/
//dep_air_patrols=1;

/*
    setting name:       dep_aa_camps
    description:        Number of AA camps
    possible values:    integer greater than 0
    default value:      <map specific>
*/
//dep_aa_camps = 20;

/*
    setting name:       dep_housepop
    description:        Number of house population zones
    possible values:    integer greater than 0
    default value:      <map specific>
*/
//dep_housepop = 150;

/*
	Number of ambush zones
	possible values: integer
	default value: <map specific>
*/
//dep_ambushes=12;

/*
	Number of occupied military installations
	possible values: integer
	default value: <map specific>
*/
//dep_military=8;

// *************************************************************
// Change the following settings to use different enemy classes
// *************************************************************

// Military forces
// ***************

// Soldier
// dep_u_soldier       = "I_soldier_F";

// Grenade launcher
// dep_u_gl            = "I_Soldier_GL_F";

// Assault rifle
// dep_u_ar            = "I_Soldier_AR_F";

// Anti tank
// dep_u_at            = "I_Soldier_LAT_F";

// Medic
// dep_u_medic         = "I_medic_F";

// Anti air
// dep_u_aa            = "I_Soldier_AA_F";

// Assistant anti air
// dep_u_aaa           = "I_Soldier_AAA_F";

// Squad leader
// dep_u_sl            = "I_Soldier_SL_F";

// Marksman
// dep_u_marksman      = "I_soldier_M_F";

// Sniper
// dep_u_sniper        = "I_Sniper_F";


// Guerilla forces
// ***************

// Soldier
// dep_u_g_soldier     = "I_G_Soldier_F";

// Grenade launcher
// dep_u_g_gl          = "I_G_Soldier_GL_F";

// Assault rifle
// dep_u_g_ar          = "I_G_Soldier_AR_F";

// Anti tank
// dep_u_g_at          = "I_G_Soldier_LAT_F";

// Medic
// dep_u_g_medic       = "I_G_medic_F";

// Squad leader
// dep_u_g_sl          = "I_G_Soldier_SL_F";

// Marksman
// dep_u_g_marksman    = "I_G_Soldier_M_F";