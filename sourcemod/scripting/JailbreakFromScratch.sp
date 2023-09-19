#define PLUGIN_NAME         "Jailbreak From Scratch"
#define PLUGIN_VERSION      "0.1"
#define PLUGIN_AUTHOR       "blank"
#define PLUGIN_DESCRIPTION  "Minimal TF2 Jailbreak plugin"

#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

public Plugin myinfo =
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "https://github.com/rsedxcftvgyhbujnkiqwe/TF2-Jailbreak-From-Scratch"
};

#include <JBFS/jbfs_vars>
#include <JBFS/jbfs_events>
#include <JBFS/jbfs_commands>
#include <JBFS/jbfs_stocks>
#include <JBFS/stocks>

#include <morecolors>

public void OnPluginStart()
{
    //register cvars
    cvarJBFS[BalanceRatio] = CreateConVar("sm_jbfs_balanceratio","0.5","Default balance ratio of blues to reds.",FCVAR_NOTIFY,true,0.1,true,1.0);
    cvarJBFS[TextChannel] = CreateConVar("sm_jbfs_textchannel","4","Default text channel for JBFS Hud text.",FCVAR_NOTIFY,true,0,true,5);
    cvarJBFS[GuardCrits] = CreateConVar("sm_jbfs_guardcrits","1","Should Guards have crits.\n0 = No Crits\n1 = Crits",FCVAR_NOTIFY,true,0,true,1);
    cvarJBFS[Version] = CreateConVar("jbfs_version",PLUGIN_VERSION,PLUGIN_NAME,FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_SPONLY | FCVAR_DONTRECORD);
    AutoExecConfig(true,"JBFS");

    //regular commands for players
    RegConsoleCmd("sm_w",Command_Warden);
    RegConsoleCmd("sm_warden",Command_Warden);
    //warden commands
    RegConsoleCmd("sm_uw",Command_UnWarden);
    RegConsoleCmd("sm_unwarden",Command_UnWarden);

    //admin commands
    RegConsoleCmd("sm_fw",Command_Admin_ForceWarden,Admin_Generic);
    RegConsoleCmd("sm_forcewarden",Command_Admin_ForceWarden,Admin_Generic);
    RegConsoleCmd("sm_fuw",Command_Admin_ForceUnWarden,Admin_Generic);
    RegConsoleCmd("sm_forceunwarden",Command_Admin_ForceUnWarden,Admin_Generic);
    RegConsoleCmd("sm_lw",Command_Admin_LockWarden,Admin_Generic);
    RegConsoleCmd("sm_lockwarden",Command_Admin_LockWarden,Admin_Generic);
    RegConsoleCmd("sm_ulw",Command_Admin_UnlockWarden,Admin_Generic);
    RegConsoleCmd("sm_unlockwarden",Command_Admin_UnlockWarden,Admin_Generic);

    //hook gameevents for use as functions
    HookEvent("teamplay_round_start",OnPreRoundStart);
    HookEvent("arena_round_start",OnArenaRoundStart);
    HookEvent("player_disconnect",OnPlayerDisconnect);
    HookEvent("player_death",OnPlayerDeath);
    HookEvent("player_spawn",OnPlayerSpawn);

    SetConVars(true);

    //add custom color(s) to morecolors
    CCheckTrie();
    SetTrieValue(CTrie,"day9",0xFFA71A);

    //import translations
    LoadTranslations("common.phrases");
    LoadTranslations("jbfs.phrases");
}

public void OnPluginEnd()
{
    SetConVars(false);
}