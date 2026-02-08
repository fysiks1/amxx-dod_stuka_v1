#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>

new g_eAirRaidButton
new g_eAirRaidTrigger

public plugin_init()
{
	register_plugin("Air Raid Fix dod_stuka_v1", "1.0", "Fysiks")
	register_clcmd("airraid", "cmdAirRaid", ADMIN_RCON)

	RegisterHam(Ham_Use, "multi_manager", "multi_manager_hamuse_post", 1)

	// Find Air Raid Trigger Entity
	new iEnt = 0, szTargetName[32]
	while( (iEnt = fm_find_ent_by_class(iEnt, "multi_manager")) )
	{
		pev(iEnt, pev_targetname, szTargetName, charsmax(szTargetName))
		if( equal(szTargetName, "rad_rndm") )
		{
			g_eAirRaidTrigger = iEnt
			server_print(">>>Trigger found: %d", iEnt)
			break
		}
	}
	if( !iEnt )
	{
		set_fail_state("Unable to find the air raid trigger")
	}

	// Find Air Raid Button
	iEnt = 0
	while( (iEnt = fm_find_ent_by_class(iEnt, "func_button")) )
	{
		pev(iEnt, pev_targetname, szTargetName, charsmax(szTargetName))
		if( equal(szTargetName, "rad") )
		{
			g_eAirRaidButton = iEnt
			server_print(">>>Button found: %d", iEnt)
			break
		}
	}
	if( !iEnt )
	{
		set_fail_state("Unable to find the air raid button")
	}
}

public multi_manager_hamuse_post(this, idcaller, idactivator, use_type, Float:value)
{
	if( this == g_eAirRaidTrigger )
	{
		set_task(2.0, "CallAirRaid")
	}
}

public CallAirRaid()
{
	ExecuteHamB(Ham_Use, g_eAirRaidButton, 0, 0, 3, 0.0)
}

public cmdAirRaid(id, level, cid)
{
	if( !cmd_access(id, level, cid, 1) )
		return PLUGIN_HANDLED

	CallAirRaid()
	return PLUGIN_HANDLED
}
