//by tankbuster
_myscript = "ai_reinforcementChoppermanager.sqf";
diag_log format ["*** %1 starts %2,%3", _myscript, diag_tickTime, time];
_cptc = primarytargetcounter;
waituntil {sleep 10; (west countSide allPlayers) > 0};
while {(alive pt_radar)} do
{
	sleep 1800 + random 900;

	//diag_log "*** arm finished sleeping. now checking if target moved on and radar still up";

	if (_cptc != primarytargetcounter)  exitWith {diag_log "***arm quits because primary target moved on"};
	if !(alive pt_radar) exitwith {diag_log "***arm quits because radar destroyed"};


	if (((west countSide allPlayers) > 1)) then
		{
		nul = [cpt_position, false,2,1,false, true, player,"random", 600, true, false,20,[0.25,0.25,0.8,0.45,0.6,0.45,0.45,0.55,1,0.55],nil,nil,nil] execVM "server\ai_reinforcementChopper.sqf";// only make airreinf if there are playerd

		reinforcementcounter = reinforcementcounter + 1;
		};
};



diag_log format ["*** %1 ends %2,%3", _myscript, diag_tickTime, time];