Scriptname SD:SanityFrameworkQuestScript extends Quest

Race[] Property SD_SanityRaces auto

Sound Property DLC03OBJDriveInTrailerSlimeScream auto mandatory
Sound Property DLC03NPCFogCrawlerDistantScreamB auto mandatory 
Sound Property UIPerkMenuWastelandWhisperer auto Mandatory
sound Property AMBDeathclawSleepingLP auto Mandatory  


Actor property PlayerRef auto Mandatory
ActorValue Property SD_Sanity Auto Mandatory
ActorValue Property SD_Stress Auto Mandatory
ActorValue Property SD_Alignment auto Mandatory
ActorValue Property SD_Depression auto Mandatory
ActorValue Property SD_Grief auto Mandatory
ActorValue Property SD_Trauma auto Mandatory
Race Property HumanRace auto const


Keyword Property MeanKeyword auto const 
Keyword Property NiceKeyword auto Const
Keyword Property SelfishKeyword auto const 
Keyword Property ViolentKeyword auto const

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


import MCM
import Actor
import Debug
import Game

AAF:AAF_API AAF_API
SD:BeastessQuest Beast

string thisMod = "SD_MainFramework"
string logName = "SanityFramework"
float hour = 0.04200
float lastEffectCheck = 0.0

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
  EndIf
EndEvent

Function IntializeStartup()
  ; Do initial Startup for the quest
  if (SD_Internal_FirstLoad.GetValue() == 1.0)
    DNotify("Sanity Framework Initializing...")
    PlayerRef.SetValue(SD_Alignment, 0)
    PlayerRef.SetValue(SD_Sanity, 100)
    PlayerRef.SetValue(SD_Stress, 0)
    PlayerRef.SetValue(SD_Depression, 0)
    PlayerRef.SetValue(SD_Grief, 0)
    PlayerRef.SetValue(SD_Trauma, 0)
    ;ResetActorValues()
    SD_Internal_FirstLoad.SetValue(0.0)
    SD_FrameworkInit.Show()
  EndIf
  ShowDebugInfo()
  LoadAAF()
  LoadSDF()
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

function ShowDebugInfo()
  Debug.Notification("Debugging:" + SD_Framework_Debugging.GetValue())
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
  If Beast == None
    Quest temp = Game.GetFormFromFile(0x00027F62, "SD_Framework.esp") as Quest
    Beast = temp as SD:BeastessQuest
  EndIf
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
    akTarget.DamageValue(SD_Depression, nDepress * -1)
  ElseIf nDepress > 0
    akTarget.RestoreValue(SD_Depression, nDepress)
  EndIf
  SendCustomEvent("OnDepressionUpdate")
  ;DNotify("Depression: " + self.GetDepression(PlayerRef))
EndFunction

float Function GetGrief(Actor akTarget)
  return akTarget.GetValue(SD_Grief)
EndFunction

Function ModifyGrief(Actor akTarget, float nGrief)
  
  If nGrief < 0
    akTarget.DamageValue(SD_Grief, nGrief * -1)
  ElseIf nGrief > 0
    akTarget.RestoreValue(SD_Grief, nGrief)
  EndIf
  ;SendCustomEvent("OnGriefUpdate")
  ;DNotify("Grief: " + self.GetGrief(PlayerRef))
EndFunction


float Function GetTrauma(Actor akTarget)
  return akTarget.GetValue(SD_Trauma)
EndFunction

Function ModifyTrauma(Actor akTarget, float nTrauma)
  
  If (nTrauma < 0)
    akTarget.DamageValue(SD_Trauma, nTrauma * -1)
  ElseIf (nTrauma > 0)
    akTarget.RestoreValue(SD_Trauma, nTrauma)
  EndIf
  ;DNotify("Trauma: " + self.GetTrauma(PlayerRef))
  SendCustomEvent("OnTraumaUpdate")
EndFunction

float function GetSanity(Actor akTarget)
  return akTarget.GetValue(SD_Sanity)
EndFunction

Function ModifySanity(Actor akTarget, float nSanity)
   
    if nSanity < 0
      akTarget.DamageValue(SD_Sanity, nSanity * -1)
    ElseIf nSanity > 0
      akTarget.RestoreValue(SD_Sanity, nSanity)
    EndIf
    ;DNotify("Sanity: " + self.GetSanity(PlayerRef))
    SendCustomEvent("OnSanityUpdate")
EndFunction

float function GetAlignment(Actor akTarget)
  return akTarget.GetValue(SD_Alignment)
EndFunction

Function ModifyAlignment(Actor akTarget, float nAlign)
  
  If nAlign < 0
    akTarget.DamageValue(SD_Alignment, nalign * -1)
  elseif nAlign > 0
    akTarget.RestoreValue(SD_Alignment, nalign)
  EndIf
  SendCustomEvent("OnAlignmentUpdate")
  ;DNotify("Alignment: " + self.GetAlignment(PlayerRef) )
EndFunction

float function GetStress(Actor akTarget)
 return akTarget.GetValue(SD_Stress)
EndFunction

Function ModifyStress(Actor akTarget, float nStress) 
  if nStress < 0
    akTarget.DamageValue(SD_Stress, nstress * -1)
  ElseIf nStress > 0
    akTarget.RestoreValue(SD_Stress, nstress)
  EndIf
  ;DNotify("Stress: " + self.GetStress(PlayerRef))
  SendCustomEvent("OnStressUpdate")
EndFunction


Function ShowStatistics()
  SD_StatisticsMessage.Show(self.GetSanity(PlayerRef), self.GetStress(PlayerRef), self.GetAlignment(PlayerRef), self.GetDepression(PlayerRef), self.GetGrief(PlayerRef))
EndFunction


Event AAF:AAF_API.OnAnimationStop(AAF:AAF_API akSender, Var[] akArgs)
  DNotify("Animation has stopped")
  Actor[] actors = Utility.VarToVarArray(akArgs[1]) as Actor[]
	Int idx = actors.Find(PlayerRef)
	Actor partnerActor
  int status = akArgs[0] as int
  if idx <= -1 || status != 0
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
    ModifyTrauma(PlayerRef, -2.0 + mod)
    ModifySanity(PlayerRef, -2.0 + mod)
    
  endif

  int i = 0
  DNotify("Begin Beast Check")
  while i < actors.length
    if i != idx
      Beast.CheckRace(actors[i])
      DNotify("Race Check")
    endif
    i += 1
  EndWhile
  
EndEvent

bool Function IsRape(string[] akTags, string akMeta)
  string[] meta = LL_FourPlay.StringSplit(theString = akMeta, delimiter = ",")
  if meta.Find("PlayerRaped") > -1
    ;DNotify("PlayerRaped")
    return true
  elseif akTags.Find("Aggressive") > -1 && akTags.Find("Rough") > -1
    ;DNotify("Player Rough/Agg Sex")
    return false
  Else
    ;DNotify("Consensual")
    return false
  EndIf
EndFunction


Function PlaySexAnimation(Actor[] akList)
  AAF_API.StartScene(akList) 
EndFunction




