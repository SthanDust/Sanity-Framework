Scriptname SD:SanityFrameworkQuestScript extends Quest
{Main Script for the Sanity Framework}


string[] TrackedStatsName
int[] TrackedStatsValue
int baseSanity = 100
int baseStress = 0
int baseAlignment = 0
string thisMod = "SD_MainFramework"
string logName = "SanityFramework"



Group Filter_Properties
  Race[] Property SD_SanityRaces auto
EndGroup

Group Calculated_Values
  GlobalVariable Property SD_AverageSleep auto
EndGroup

Group Player_Values
  Actor property PlayerRef auto const Mandatory
  ActorValue Property SD_Sanity Auto Mandatory
  ActorValue Property SD_Stress Auto Mandatory
  ActorValue Property SD_Alignment auto Mandatory
  Race Property HumanRace auto const
  GlobalVariable Property SD_SanityMult auto
  GlobalVariable Property SD_StressMult auto 
  GlobalVariable Property SD_AlignMult auto
  ActorValue Property Strength auto 
  ActorValue Property Perception auto 
  ActorValue Property Endurance auto 
  ActorValue Property Charisma auto
  ActorValue Property Intelligence auto 
  ActorValue Property Agility auto
  ActorValue Property Luck auto 
EndGroup

; Can be accessed by other mods
Group MCM_Settings 
  GlobalVariable Property SD_FVersion auto 
  GlobalVariable Property SD_Framework_Enabled auto
  GlobalVariable Property SD_Framework_Debugging auto
  GlobalVariable Property SD_Setting_Integrate_Vio auto
  GlobalVariable Property SD_Setting_Integrate_FPE auto
  GlobalVariable Property SD_Setting_Integrate_WLD Auto 
  GlobalVariable Property SD_Setting_Integrate_JB auto
  GlobalVariable Property SD_Setting_Integrate_HBW auto
  GlobalVariable Property SD_Internal_MCMLoaded auto 
  GlobalVariable Property SD_Internal_FirstLoad auto
  Message Property SD_FrameworkInit Auto
  Message Property SD_StatisticsMessage auto
  GlobalVariable Property SD_Setting_ThoughtFrequency auto
EndGroup

import MCM
import Actor
import Debug
import Game
import SUP_F4SE

CustomEvent OnSanityUpdate
CustomEvent OnStressUpdate
CustomEvent OnAlignmentUpdate


Event OnQuestInit()
  StartTimer(1,0)
  OpenLog()
  DNotify("Main: Quest Init")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
  OpenLog()
  DNotify("Main: Player Load")
  StartTimer(2, 0)
EndEvent


Event OnTrackedStatsEvent(string arStatName, int aiStatValue)
  TrackedStatsValue[TrackedStatsName.Find(arStatName)] = aiStatValue
  RegisterForTrackedStatsEvent(arStatName, aiStatValue + 1)
  CalculateTrackedStats()
EndEvent

; This function looks to see what the player has killed in combat.  If its a creature, it has a set amount.Function AddInventoryEventFilter(Form akFilter)
; If its a human, it has two outcomes.  If the Victim was aggressive, less sanity and stress are affected, otherwise, higher penalties.
Event Actor.OnKill(Actor akSender, Actor akVictim)
  if akSender == PlayerRef && akVictim.GetRace() != HumanRace
    ModifySanity(akSender, -0.1)
    ModifyStress(akSender, 0.1)
  ElseIf akSender == PlayerRef && akVictim.GetRace() == HumanRace
    if akVictim.GetValue(Game.GetAggressionAV()) >= 2.0
      ModifySanity(PlayerRef, -0.2)
      ModifyStress(PlayerRef, 0.2)
    Else
      ModifySanity(PlayerRef, -0.5)
      ModifyStress(PlayerRef, 0.5)
    Endif
  Endif
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
   If akTarget != PlayerRef
      ModifyStress(PlayerRef, -0.005)
   ElseIf akTarget == PlayerRef
      ModifyStress(PlayerRef, 0.005)
   EndIf
   RegisterForHitEvent(PlayerRef)
EndEvent

Event OnTimer(int aiTimerID)
  if(aiTimerID == 0)
      IntializeStartup()
      RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
  EndIf
EndEvent

Function IntializeStartup()
  ; Do initial Startup for the quest
  if (SD_Internal_FirstLoad.GetValue() == 0)
    DNotify("Sanity Framework Initializing...")
    PlayerRef.SetValue(SD_Alignment, baseAlignment)
    PlayerRef.SetValue(SD_Sanity, baseSanity)
    PlayerRef.SetValue(SD_Stress, baseStress)
    SD_Internal_FirstLoad.SetValue(1)
    SD_FrameworkInit.Show()
  EndIf
  LoadSDF()
  PopulateTrackedStats()
EndFunction

Function DNotify(string text)

    Debug.Notification("[SDF] " + text)
    Debug.Trace("[SDF] " + text, 0) ; just to get started
    Debug.TraceUser(logName, "[SDF] " + text)

EndFunction

Function LoadSDF()
  RegisterForRemoteEvent(PlayerRef, "OnKill")
  RegisterForHitEvent(PlayerRef)
 
EndFunction

Function OpenLog()
  Debug.Notification("Opening Debug Log...")
  Debug.OpenUserLog(logName)
EndFunction


float function GetSanity(Actor akTarget)
  return akTarget.GetValue(SD_Sanity)
EndFunction

Function ModifySanity(Actor akTarget, float nSanity)
   float sanity = GetSanity(akTarget) + nSanity
    if sanity < 100 && sanity > 0 ; can't go over 100
      akTarget.ModValue(SD_Sanity, nSanity)
      SendCustomEvent("OnSanityUpdate")
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
    
    
    int index = 0
    While (index < TrackedStatsName.Length)
      RegisterForTrackedStatsEvent(TrackedStatsName[index], TrackedStatsValue[index]+ 1)
      ; code
      index += 1
    EndWhile
    CalculateTrackedStats()
EndFunction

Function CalculateTrackedStats()
  ;Calculates the average amount of sleep
  float aSleep = TrackedStatsValue[8] / TrackedStatsValue[5] 
  SD_AverageSleep.SetValue(aSleep)
EndFunction

Function ShowStatistics()
  SD_StatisticsMessage.Show(PlayerRef.GetValue(SD_Sanity), PlayerRef.GetValue(SD_Stress), PlayerRef.GetValue(SD_Alignment), SD_AverageSleep.GetValue())
EndFunction



