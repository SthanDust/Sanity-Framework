Scriptname SD:SanityFrameworkQuestScript extends Quest conditional
{Main Script for the Sanity Framework}

int iTimerID_SDQuestStartupComplete = 100 const

int iStage_Started = 10 const
int iStage_StartupComplete = 20 const 

string[] TrackedStatsName
int[] TrackedStatsValue
int baseSanity = 100
int baseStress = 0
int baseAlignment = 0
bool showNotifications = true
string thisMod = "SD_SanityFramework"

Group Filter_Properties
  Race[] Property SD_SanityRaces auto
EndGroup

Group Perks 
  Perk Property SD_Align01 auto 
  Perk Property SD_Align02 auto 
  Perk Property SD_Align03 auto 
  Perk Property SD_Align04 auto 
  Perk Property SD_Align05 auto 
  Perk Property SD_Insane00 auto 
  Perk Property SD_Insane01 auto 
  Perk Property SD_Insane02 auto  
  Perk Property SD_Insane03 auto 
  Perk Property SD_Insane04 auto 
  Perk Property SD_Insane05 auto
  Perk Property SD_Stressed00 auto 
  Perk Property SD_Stressed01 auto 
  Perk Property SD_Stressed02 auto
  Perk Property SD_Stressed03 auto
  Perk Property SD_Stressed04 auto
  Perk Property SD_Stressed05 auto
EndGroup

Group Mental_Effects
  Spell Property SD_InsomniaSpell auto 
  Spell Property SD_StressedSpell auto
  Spell Property SD_DepressionSpell auto
EndGroup

Group Factions 
  Faction Property SD_FactionInsane auto
  Faction Property SD_FactionStressed auto
  Faction Property SD_FactionEvil auto
  Faction Property SD_FactionGood auto
  Faction Property SD_FactionNeutral auto
EndGroup

Group Player_Values
  ReferenceAlias property PlayerRef auto const Mandatory
  ActorValue Property SD_Sanity Auto Mandatory
  ActorValue Property SD_Stress Auto Mandatory
  ActorValue Property SD_Alignment auto 
  Race Property HumanRace auto const 
EndGroup

; Can be accessed by other mods
Group MCM_Settings 
  GlobalVariable Property SD_FVersion auto 
  GlobalVariable Property SD_Framework_Enabled auto
  GlobalVariable Property SD_Framework_Debugging auto
  GlobalVariable Property SD_Setting_Integrate_AAF auto  
  GlobalVariable Property SD_Setting_Integrate_SA auto 
  GlobalVariable Property SD_Setting_Integrate_Vio auto
  GlobalVariable Property SD_Setting_Integrate_FPE auto
  GlobalVariable Property SD_Setting_Integrate_WLD Auto 
  GlobalVariable Property SD_Setting_Integrate_JB auto
  GlobalVariable Property SD_Setting_Debug auto
  GlobalVariable Property SD_Internal_MCMLoaded auto 
EndGroup

import MCM
import Actor
import Debug
import Game

CustomEvent OnSanityUpdate
CustomEvent OnStressUpdate
CustomEvent OnAlignmentUpdate

Event OnQuestInit()
  RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
  RegisterForRemoteEvent(PlayerRef, "OnKill")
  RegisterForPlayerSleep()
  RegisterForHitEvent(PlayerRef)
EndEvent

Event OnTrackedStatsEvent(string arStatName, int aiStatValue)
  TrackedStatsValue[TrackedStatsName.Find(arStatName)] = aiStatValue
  DNotify("Tracked Stat: " + arStatName + " = " + aiStatValue )
  RegisterForTrackedStatsEvent(arStatName, aiStatValue + 1)
EndEvent

float iSleeptime = 0.0
float iSleepEnd = 0.0
float iSleepDesired

Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
  iSleepTime = afSleepStartTime
  iSleepDesired = afDesiredSleepEndTime
EndEvent

;
Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
  iSleepEnd = Utility.GetCurrentGameTime() - iSleeptime
EndEvent



Event Actor.OnPlayerLoadGame(Actor akSender)
  DNotify("Loading Game...")
  if (SD_FVersion.GetValue() != 0.2)
    SD_FVersion.SetValue(0.2)
  EndIf
  LoadSDF()
EndEvent

Event Actor.OnKill(Actor akSender, Actor akVictim)
  if akSender == PlayerRef.GetActorRef() && akVictim.GetRace() != HumanRace
    DNotify("Player killed: " + akVictim.GetLeveledActorBase().GetName())
    ModifySanity(akSender, -0.1)
    ModifyStress(akSender, 0.1)
  Endif
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
   If akAggressor != PlayerRef.GetActorRef()
      DNotify("Player hit someone")
   EndIf
   RegisterForHitEvent(PlayerRef)
EndEvent

Event OnStageSet(int auiStageID, int auiItemID)
  if (auiStageID == iStage_Started)
    if (IsRunning())
      IntializeStartup()
    Else
      StartTimer(2.0, iTimerID_SDQuestStartupComplete)
    endif 
  endif 
EndEvent

Event OnTimer(int aiTimerID)
  	if(aiTimerID == iTimerID_SDQuestStartupComplete)
		if(IsRunning())
			IntializeStartup()
		else
			StartTimer(2.0, iTimerID_SDQuestStartupComplete)
		endif
	endif
EndEvent


Function IntializeStartup()
  ; Do initial Startup for the quest
  DNotify("Sanity Framework Initializing...")
  PopulateTrackedStats()
  LoadSDF()
  SetStage(iStage_StartupComplete)
EndFunction

Function DNotify(string text)
  if SD_Setting_Debug.GetValue() == 1.0
    Debug.Notification("[SDF] " + text)
    Debug.Trace(text, 0) ; just to get started
  endif
EndFunction

;Check for the MCM
bool Function CheckForMCM(bool FirstLoad = false)
	If !MCM.IsInstalled()
		DNotify("MCM Not Found, default settings will be enabled.")
		If FirstLoad
			Utility.wait(0.2)
			DNotify("MCM Not Found. Default settings will be used.")
		EndIf
		Return False
	EndIf
	; DTrace("MCM installed.")
	Return True
EndFunction

Function LoadSDF()
  DNotify("Sanity Framework Initialized...")
  If CheckForMCM() == true
		RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
		MCMUpdate()
	EndIf
EndFunction

Function MCMUpdate()
  SD_Framework_Debugging.SetValue(MCM.GetModSettingBool(thisMod, "bMCMDebugOn:Debug") as float)
  SD_Framework_Enabled.SetValue(MCM.GetModSettingBool(thisMod, "bMCMModEnabled:Globals") as float)
EndFunction


float function GetSanity(Actor akTarget)
  return akTarget.GetValue(SD_Sanity)
EndFunction

Function ModifySanity(Actor akTarget, float nSanity)
   float sanity = GetSanity(akTarget) + nSanity
    if sanity < 100 && sanity > -100 ; can't go over 100
      akTarget.ModValue(SD_Sanity, nSanity)
      DNotify("Sanity has changed...")
      SendCustomEvent("OnSanityUpdate")
    Else
      DNotify("Sanity cannot be more or less than 100")
    EndIf
EndFunction

float function GetAlignment(Actor akTarget)
  return akTarget.GetValue(SD_Alignment)
EndFunction

Function ModifyAlignment(Actor akTarget, float nAlign)
  float align = GetAlignment(akTarget) + nAlign
  If align <= 100 && align >= -100
    akTarget.ModValue(SD_Alignment, nAlign)
    SendCustomEvent("OnAlignmentUpdate")
  Else
    DNotify("Alignment cannot be more or less than 100")
  EndIf
EndFunction

float function GetStress(Actor akTarget) 
 return akTarget.GetValue(SD_Stress)
EndFunction

Function ModifyStress(Actor akTarget, float nStress) 
  float stress = 0
  stress = GetStress(akTarget) + nStress
  if stress <= 100 && stress >=0
    akTarget.ModValue(SD_Stress, nStress)
    SendCustomEvent("OnStressUpdate")
  Else
    DNotify("Stress cannot be more than 100 or less than 0")
  EndIf
EndFunction

Function PopulateTrackedStats()
    TrackedStatsName = new string[13]
    TrackedStatsValue = new int[13] 
    TrackedStatsName[0] = "Animals Killed"
    TrackedStatsValue[0] = Game.QueryStat(TrackedStatsName[0])
    TrackedStatsName[1] = "Assaults" 
    TrackedStatsValue[1] = Game.QueryStat(TrackedStatsName[1])
    TrackedStatsName[2] = "Chems Taken"
    TrackedStatsValue[2] = Game.QueryStat(TrackedStatsName[2])
    TrackedStatsName[3] = "Corpses Eaten"
    TrackedStatsValue[3] = Game.QueryStat(TrackedStatsName[3])
    TrackedStatsName[4] = "Creatures Killed"
    TrackedStatsValue[4] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[5] = "Days Passed"
    TrackedStatsValue[5] = Game.QueryStat(TrackedStatsName[5])
    TrackedStatsName[6] = "Days Survived"
    TrackedStatsValue[6] = Game.QueryStat(TrackedStatsName[6])
    TrackedStatsName[7] = "Happiness"
    TrackedStatsValue[7] = Game.QueryStat(TrackedStatsName[7])
    TrackedStatsName[8] = "Hours Slept"
    TrackedStatsValue[8] = Game.QueryStat(TrackedStatsName[8])
    TrackedStatsName[9] = "Items Stolen"
    TrackedStatsValue[9] = Game.QueryStat(TrackedStatsName[9])
    TrackedStatsName[10] = "Murders"
    TrackedStatsValue[10] = Game.QueryStat(TrackedStatsName[10])
    TrackedStatsName[11] = "Times Addicted"
    TrackedStatsValue[11] = Game.QueryStat(TrackedStatsName[11])
    TrackedStatsName[12] = "Trespasses"
    TrackedStatsValue[12] = Game.QueryStat(TrackedStatsName[12])
    DNotify("Tracked Stats initialized...")
    int index = 0
    While (index < TrackedStatsName.Length)
      RegisterForTrackedStatsEvent(TrackedStatsName[index], TrackedStatsValue[index]+ 1)
      ; code
      index += 1
    EndWhile
EndFunction