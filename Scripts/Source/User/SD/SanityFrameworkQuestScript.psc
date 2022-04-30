Scriptname SD:SanityFrameworkQuestScript extends Quest
{Main Script for the Sanity Framework}


string[] TrackedStatsName
int[] TrackedStatsValue
int baseSanity = 100
int baseStress = 0
int baseAlignment = 0
string thisMod = "SD_MainFramework"
string logName = "SanityFramework"
float hour = 0.04200
float lastEffectCheck = 0.0


Group Filter_Properties
  Race[] Property SD_SanityRaces auto
  Race[] Property SD_CanineRaces auto 
  Race[] Property SD_ReptileRaces auto 
  Race[] Property SD_HumanRaces auto 
  Race[] Property SD_NecroRaces auto 
  Race[] Property SD_InsectRaces auto 
  Race[] Property SD_MolluskRaces auto
  Race[] Property SD_MutantRaces auto
  Race[] Property SD_AlienRaces auto 
EndGroup

Group Calculated_Values
  GlobalVariable Property SD_AverageSleep auto
EndGroup

Group Actor_Values
  Actor property PlayerRef auto Mandatory
  ActorValue Property SD_Sanity Auto Mandatory
  ActorValue Property SD_Stress Auto Mandatory
  ActorValue Property SD_Alignment auto Mandatory
  ActorValue Property SD_Depression auto Mandatory
  ActorValue Property SD_Grief auto Mandatory
  ActorValue Property SD_Trauma auto Mandatory
  Race Property HumanRace auto const
  Quest Property SD_PlayerQuest auto 
EndGroup

Group Follower_Data
  Keyword Property MeanKeyword auto const 
  Keyword Property NiceKeyword auto Const
  Keyword Property SelfishKeyword auto const 
  Keyword Property ViolentKeyword auto const
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
  GlobalVariable Property SD_Beastess_Canine auto
  GlobalVariable Property SD_Beastess_Reptile auto
  GlobalVariable Property SD_Beastess_Human auto
  GlobalVariable Property SD_Beastess_Necro auto
  GlobalVariable Property SD_Beastess_Insect auto
  GlobalVariable Property SD_Beastess_Mollusk auto 
  GlobalVariable Property SD_Beastess_Mutant auto
  GlobalVariable Property SD_Beastess_Alien auto
  

  Message Property SD_FrameworkInit Auto
  Message Property SD_StatisticsMessage auto
  GlobalVariable Property SD_Setting_ThoughtFrequency auto
EndGroup

import MCM
import Actor
import Debug
import Game
import FollowersScript
AAF:AAF_API AAF_API

CustomEvent OnSanityUpdate
CustomEvent OnStressUpdate
CustomEvent OnAlignmentUpdate
CustomEvent OnDepressionUpdate
CustomEvent OnGriefUpdate
CustomEvent OnTraumaUpdate
CustomEvent OnBeastess

Event OnQuestInit()
  OpenLog()
  StartTimer(1,0)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
  OpenLog()
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
    ModifySanity(akSender, -0.001)
    ModifyStress(akSender, -0.001)
  ElseIf akSender == PlayerRef && akVictim.GetRace() == HumanRace
    int Aggro = akVictim.GetValue(Game.GetAggressionAV()) as int
    if Aggro >= 2.0
      ModifySanity(akSender, -0.02)
      ModifyStress(akSender, -0.02)
      ModifyAlignment(akSender, 0.05)
    Else
      ModifySanity(akSender, -0.5)
      ModifyStress(akSender, -0.5)
      ModifyAlignment(akSender, -0.05)
    Endif
  Endif
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
   If akTarget != PlayerRef
      ModifyStress(PlayerRef, -0.002)
   ElseIf akTarget == PlayerRef
      ModifyStress(PlayerRef, -0.005)
   EndIf
   RegisterForHitEvent(PlayerRef)
EndEvent

Event OnTimer(int aiTimerID)
  if(aiTimerID == 0)
      IntializeStartup()
      RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
      RegisterForCustomEvent(FollowersScript.GetScript(), "AffinityEvent")
  EndIf
EndEvent

Function IntializeStartup()
  ; Do initial Startup for the quest
  if (SD_Internal_FirstLoad.GetValue() == 1.0)
    DNotify("Sanity Framework Initializing...")
    PlayerRef.SetValue(SD_Alignment, baseAlignment)
    PlayerRef.SetValue(SD_Sanity, baseSanity)
    PlayerRef.SetValue(SD_Stress, baseStress)
    PlayerRef.SetValue(SD_Depression, 0)
    PlayerRef.SetValue(SD_Grief, 0)
    PlayerRef.SetValue(SD_Trauma, 0)
    ;ResetActorValues()
    SD_Internal_FirstLoad.SetValue(0.0)
    SD_FrameworkInit.Show()
  EndIf
  
  LoadAAF()
  LoadSDF()
  PopulateTrackedStats()
EndFunction

Function LoadAAF()
  if AAF_API == none
		AAF_API = Game.GetFormFromFile(0x00000F99, "AAF.esm") as AAF:AAF_API
    	If !AAF_API
        	DNotify("AAF Not Found.  Please Exit and Install AAF.")
        	return
    	Else
        	RegisterForCustomEvent(AAF_API, "OnAnimationStop")
    	Endif
	endif
EndFunction



Function DNotify(string text)
  If SD_Framework_Debugging.GetValue() == 1
    Debug.Notification("[SDF] " + text)
  EndIf
    Debug.Trace("[SDF] " + text, 0) ; just to get started
    Debug.TraceUser(logName, "[SDF] " + text)
EndFunction

Function LoadSDF()
  RegisterForRemoteEvent(PlayerRef, "OnKill")
  RegisterForHitEvent(PlayerRef)
  ;CheckCompanion()
EndFunction

Function CheckCompanion()
   Actor[] Followers =  Game.GetPlayerFollowers()
   int index = 0
   while index < Followers.Length
   index = index + 1
   EndWhile
EndFunction

Function OpenLog()
  ;Debug.Notification("Opening Debug Log...")
  Debug.OpenUserLog(logName)
EndFunction

float function GetDepression(Actor akTarget)
  return akTarget.GetValue(SD_Depression)
endfunction

Function ModifyDepression(Actor akTarget, float nDepress)
  
  If nDepress < 0
    akTarget.DamageValue(SD_Depression, nDepress)
  ElseIf nDepress > 0
    akTarget.RestoreValue(SD_Depression, nDepress)
  EndIf
  SendCustomEvent("OnDepressionUpdate")
EndFunction

float Function GetGrief(Actor akTarget)
  return akTarget.GetValue(SD_Grief)
EndFunction

Function ModifyGrief(Actor akTarget, float nGrief)
  
  If nGrief < 0
    akTarget.DamageValue(SD_Grief, nGrief)
  ElseIf nGrief > 0
    akTarget.RestoreValue(SD_Grief, nGrief)
  EndIf
  SendCustomEvent("OnGriefUpdate")
EndFunction

float Function GetTrauma(Actor akTarget)
  return akTarget.GetValue(SD_Trauma)
EndFunction

Function ModifyTrauma(Actor akTarget, float nTrauma)
  
  If (nTrauma < 0)
    akTarget.DamageValue(SD_Trauma, nTrauma)
  ElseIf (nTrauma > 0)
    akTarget.RestoreValue(SD_Trauma, nTrauma)
  EndIf
  SendCustomEvent("OnTraumaUpdate")
EndFunction

float function GetSanity(Actor akTarget)
  return akTarget.GetValue(SD_Sanity)
EndFunction

Function ModifySanity(Actor akTarget, float nSanity)
   
    if nSanity < 0
      akTarget.DamageValue(SD_Sanity, nSanity)
    ElseIf nSanity > 0
      akTarget.RestoreValue(SD_Sanity, nSanity)
    EndIf
    SendCustomEvent("OnSanityUpdate")
EndFunction

float function GetAlignment(Actor akTarget)
  return akTarget.GetValue(SD_Alignment)
EndFunction

Function ModifyAlignment(Actor akTarget, float nAlign)
  
  If nAlign < 0
    akTarget.DamageValue(SD_Alignment, nalign)
  elseif nAlign > 0
    akTarget.RestoreValue(SD_Alignment, nalign)
  EndIf
  SendCustomEvent("OnAlignmentUpdate")
EndFunction

float function GetStress(Actor akTarget)
 return akTarget.GetValue(SD_Stress)
EndFunction

Function ModifyStress(Actor akTarget, float nStress) 
  if nStress < 0
    akTarget.DamageValue(SD_Stress, nstress)
  ElseIf nStress > 0
    akTarget.RestoreValue(SD_Stress, nstress)
  EndIf
  SendCustomEvent("OnStressUpdate")
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
  SD_StatisticsMessage.Show(PlayerRef.GetValue(SD_Sanity), PlayerRef.GetValue(SD_Stress), PlayerRef.GetValue(SD_Alignment), SD_AverageSleep.GetValue(), self.GetDepression(PlayerRef), self.GetGrief(PlayerRef))
EndFunction

Event FollowersScript.AffinityEvent(FollowersScript akSender, Var[] akArgs)
  ;Keyword  aed = akArgs[0] as Keyword
  ;DNotify("Affinity Event: " + akArgs[0])
EndEvent

Event AAF:AAF_API.OnAnimationStop(AAF:AAF_API akSender, Var[] akArgs)
  Actor[] actors = Utility.VarToVarArray(akArgs[1]) as Actor[]
	Int idx = actors.Find(PlayerRef)
	Actor partnerActor
  int status = akArgs[0] as int
  if idx <= -1 || status != 0
    ;DNotify("Exiting... Player not involved")
    return
  endif
  
  String[] Tags = Utility.VarToVarArray(akArgs[3]) as String[] 
  String position = akArgs[2] as String
  string meta = akArgs[4] as string
  float mod = 0.0

  

  if IsRape(Tags, meta)
    string[] metaTag = LL_FourPlay.StringSplit(theString = Meta, delimiter = ",")
    If metaTag.Find("AAF_Violate") > -1
      mod = -1.0
    EndIf
    if actors.length > 2
      mod = -2.0
    EndIf
    

    ModifyStress(PlayerRef, -2.0 + mod)
    ModifyTrauma(PlayerRef, -5.0 + mod)
    ModifySanity(PlayerRef, -2.0 + mod)
    
  endif

  int i = 0
  
  while i < actors.length
    if i != idx
      CheckRace(actors[i])
    endif
    i += 1
  EndWhile
  
EndEvent

bool Function IsRape(string[] akTags, string akMeta)
  string[] meta = LL_FourPlay.StringSplit(theString = akMeta, delimiter = ",")
  if meta.Find("PlayerRaped") > -1
    return true
  elseif akTags.Find("Aggressive") > -1 && akTags.Find("Rough") > -1
    return true
  Else
    return false
  EndIf
EndFunction

Function CheckRace(Actor akActor)
  Race akRace = akActor.GetRace()  
  DNotify("Beastess Increase: " + akRace.GetName())
  if SD_CanineRaces.Find(akRace) > -1
    SD_Beastess_Canine.Value += 1
    SendCustomEvent("OnBeastess")
    return
  endif
  If SD_ReptileRaces.Find(akRace) > -1
    SD_Beastess_Reptile.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf
  If SD_HumanRaces.Find(akRace) > -1
    SD_Beastess_Human.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf

  If SD_NecroRaces.Find(akRace) > -1
    SD_Beastess_Necro.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf

  If SD_InsectRaces.Find(akRace) > -1
    SD_Beastess_Insect.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf

  If SD_MolluskRaces.Find(akRace) > -1
    SD_Beastess_Mollusk.Value += 1
    SendCustomEvent("OnBeastess")
  EndIf

  If SD_MutantRaces.Find(akRace) > -1
    SD_Beastess_Mutant.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf

  If SD_AlienRaces.Find(akRace) > -1
    SD_Beastess_Alien.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf
EndFunction






