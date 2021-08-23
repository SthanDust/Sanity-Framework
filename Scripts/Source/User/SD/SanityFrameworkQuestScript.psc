Scriptname SD:SanityFrameworkQuestScript extends Quest conditional
{Main Script for the Sanity Framework}

import Actor
import Debug
import Game


int iTimerID_SDQuestStartupComplete = 100 const

int iStage_Started = 10 const
int iStage_StartupComplete = 20 const 

; float property CurrentSanity auto 
; float property CurrentStress auto 
; float property CurrentAlignment auto 

; ;Sex Attributes
; int wear = 0
; int willpower = 0
; int selfesteem = 0
; int spirit = 0
; int orientation = 0
; int sexReputation = 0
; int trauma = 0
; int intoxicationLevel = 0
; int arousal = 0
; Tracked Stats
string[] TrackedStatsName
int[] TrackedStatsValue
int baseSanity = 100
int baseStress = 0
int baseAlignment = 0
bool showNotifications = true

; AAF:AAF_API AAF_API 
; FPA:FPA_Main fpa_event

; Group Perks 
;   Perk Property SD_Perk_Sanity auto
;   Perk Property SD_Perk_Insanity auto
;   Perk Property SD_Perk_Alignment auto 
;   Perk Property SD_Perk_Stress auto
; EndGroup

; Group Mental_Effects

; EndGroup

Group Player_Values
    Actor property PlayerRef auto const Mandatory
    ActorValue property Experience Auto Mandatory
    ActorValue Property Health Auto Mandatory
    ActorValue Property Strength auto mandatory 
    ActorValue Property Perception auto mandatory 
    ActorValue Property Endurance auto mandatory
    ActorValue Property Charisma auto mandatory
    ActorValue Property Intelligence auto mandatory
    ActorValue Property Agility auto mandatory 
    ActorValue Property Luck auto mandatory 
    ActorValue Property ActionPoints Auto Mandatory 
    ActorValue Property SD_Sanity Auto Mandatory
    ActorValue Property SD_Stress Auto Mandatory
    ActorValue Property SD_Alignment auto mandatory
    Race Property HumanRace auto const mandatory
EndGroup

; Can be accessed by other mods
Group Settings 
    GlobalVariable Property SD_FVersion auto 
    GlobalVariable Property SD_Framework_Enabled auto
    GlobalVariable Property SD_Setting_Integrate_AAF auto  
    GlobalVariable Property SD_Setting_Integrate_SA auto 
    GlobalVariable Property SD_Setting_Integrate_Vio auto
    GlobalVariable Property SD_Setting_Integrate_FPE auto
    GlobalVariable Property SD_Setting_Integrate_WLD Auto 
    GlobalVariable Property SD_Setting_Integrate_JB auto
EndGroup


Group Items
    Book Property SD_SanityBook auto 
EndGroup 

CustomEvent OnSanityUpdate
CustomEvent OnStressUpdate
CustomEvent OnAlignmentUpdate

Event OnQuestInit()
  RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
  RegisterForRemoteEvent(PlayerRef, "OnKill")
    
EndEvent

Event OnTrackedStatsEvent(string arStatName, int aiStatValue)
  TrackedStatsValue[TrackedStatsName.Find(arStatName)] = aiStatValue
  DNotify("Tracked Stat: " + arStatName + " = " + aiStatValue )
  RegisterForTrackedStatsEvent(arStatName, aiStatValue + 1)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
  DNotify("Loading Game...")
  LoadSDF()
EndEvent

Event Actor.OnKill(Actor akSender, Actor akVictim)
  if akSender == PlayerRef && akVictim.GetRace() != HumanRace
    DNotify("Player killed: " + akVictim.GetLeveledActorBase().GetName())
    ModifySanity(-0.1)
    ModifyStress(0.1)
  Endif
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
  if showNotifications
    Debug.Notification("Sanity: " + text)
  endif
EndFunction

Function LoadSDF()
  
  DNotify("Sanity Framework Initialized...")
  ;initialize everytime the game loads as save

EndFunction


float function GetSanity()
  return PlayerRef.GetValue(SD_Sanity)
EndFunction

Function ModifySanity(float nSanity)
   float sanity = GetSanity() + nSanity
    if sanity < 100 && sanity > -100 ; can't go over 100
      PlayerRef.ModValue(SD_Sanity, nSanity)
      DNotify("Sanity has changed...")
      SendCustomEvent("OnSanityUpdate")
    Else
      DNotify("Sanity cannot be more or less than 100")
    EndIf
   
EndFunction

float function GetAlignment()
  return PlayerRef.GetValue(SD_Alignment)
EndFunction

Function ModifyAlignment(float nAlign)
  float align = GetAlignment() + nAlign
  If align <= 100 && align >= -100
    PlayerRef.ModValue(SD_Alignment, nAlign)
    SendCustomEvent("OnAlignmentUpdate")
  Else
    DNotify("Alignment cannot be more or less than 100")
  EndIf
EndFunction

float function GetStress()
 return PlayerRef.GetValue(SD_Stress)
EndFunction

Function ModifyStress(float nStress)
  float stress = GetStress() + nStress
  if stress <= 100 && stress >=0
    PlayerRef.ModValue(SD_Stress, nStress)
    SendCustomEvent("OnStressUpdate", None)
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
    TrackedStatsValue[5] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[6] = "Days Survived"
    TrackedStatsValue[6] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[7] = "Happiness"
    TrackedStatsValue[7] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[8] = "Hours Slept"
    TrackedStatsValue[8] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[9] = "Items Stolen"
    TrackedStatsValue[9] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[10] = "Murders"
    TrackedStatsValue[10] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[11] = "Times Addicted"
    TrackedStatsValue[11] = Game.QueryStat(TrackedStatsName[4])
    TrackedStatsName[12] = "Trespasses"
    TrackedStatsValue[12] = Game.QueryStat(TrackedStatsName[4])
    DNotify("Tracked Stats initialized...")
    int index = 0
    While (index < TrackedStatsName.Length)
      RegisterForTrackedStatsEvent(TrackedStatsName[index], TrackedStatsValue[index]+ 1)
      ; code
      index += 1
    EndWhile
EndFunction

; ; See if player is a "slut"
; Perk slut = Game.GetFormFromFile(0x1019452, "FPAttributes.esp") as Perk
; if slut != none && playerRef.hasPerk(slut)
; 	; Player is a slut!
; endif

; ; See if player is desperate for sex
; Perk desperate = Game.GetFormFromFile(0x101A38C, "FPAttributes.esp") as Perk
; if desperate != none && playerRef.hasPerk(desperate)
; 	; Player is desperate for sex!
; endif

; 

; Function RegisterModsAndEvents()
;   ;Is Sex Attributes Installed    
;   if fpa_event == none 
;         Quest Main = Game.GetFormFromFile(0x00000F99, "FPAttributes.esp") as quest
;         fpa_event = Main as FPA:FPA_Main
;           if !fpa_event
;             Debug.Notification("Sex Attributes is not installed.  Those values will not be used in sanity.")
;             return 
;           Else 
;             wear = (Game.GetFormFromFile(0x01000FAA, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             willpower = (Game.GetFormFromFile(0x01000FAB, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             selfesteem = (Game.GetFormFromFile(0x01000FAC, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             spirit = (Game.GetFormFromFile(0x01007A67, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             orientation = (Game.GetFormFromFile(0x01000FAD, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             sexReputation = (Game.GetFormFromFile(0x101944F, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             trauma = (Game.GetFormFromFile(0x101E80B, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             intoxicationLevel = (Game.GetFormFromFile(0x101E80C, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             arousal = (Game.GetFormFromFile(0x101E80D, "FPAttributes.esp") as GlobalVariable).getValueInt()
;             RegisterForCustomEvent(fpa_event, "OnWearUpdate")
;             RegisterForCustomEvent(fpa_event, "OnWillpowerUpdate")
;             RegisterForCustomEvent(fpa_event, "OnSelfEsteemUpdate")
;             RegisterForCustomEvent(fpa_event, "OnSpiritUpdate")
;             RegisterForCustomEvent(fpa_event, "OnOrientationUpdate")
;           EndIf
;       EndIf

;     if AAF_API == none 
;       AAF_API = Game.GetFormFromFile(0x00000F99, "AAF.esm") as AAF:AAF_API
;       if !AAF_API
;           Debug.Notification("AAF is not installed.  Sex acts will not be considered in sanity.")
;           return 
;       Else
;           RegisterForCustomEvent(AAF_API, "OnAnimationStop")
;           Debug.Notification("Attaching to AAF...")
          
;       EndIf
;     EndIf
; EndFunction

; Event AAF:AAF_API.OnAnimationStop(AAF:AAF_API akSender, Var[] akArgs)
;     ; Who is having sex
;     Actor[] actors = Utility.VarToVarArray(akArgs[1]) as Actor[]
;     int idx = actors.Find(PlayerRef)
;     if idx <= -1
;       ;player not involved in sex
;       return
;     endif 


; EndEvent

; Event FPA:FPA_Main.OnWearUpdate(FPA:FPA_Main akSender, Var[] akArgs)
; 	int wear = akArgs[0] as int
; 	; do something here
; EndEvent

; Event FPA:FPA_Main.OnWillpowerUpdate(FPA:FPA_Main akSender, Var[] akArgs)
; 	int will = akArgs[0] as int
; 	; do something here
; EndEvent

; Event FPA:FPA_Main.OnSelfEsteemUpdate(FPA:FPA_Main akSender, Var[] akArgs)
; 	int esteem = akArgs[0] as int
; 	; do something here
; EndEvent

; Event FPA:FPA_Main.OnSpiritUpdate(FPA:FPA_Main akSender, Var[] akArgs)
; 	spirit = akArgs[0] as int
; 	; do something here
; EndEvent

; Event FPA:FPA_Main.OnOrientationUpdate(FPA:FPA_Main akSender, Var[] akArgs)
; 	int orient = akArgs[0] as int
; 	; do something here
; EndEvent

; Grab FPA script object
; Quest FPA_Main = Game.GetFormFromFile(0x00000F99, "FPAttributes.esp") as quest
; ScriptObject fpa_script = FPA_Main.CastAs("FPA:FPA_Main")

; ; Increase orientation by 1
; var[] orVar = new var[1]
; orVar[0] = 1
; fpa_script.CallFunction("ModifyOrientation", orVar)

; ; Decrease willpower by 5
; var[] willVar = new var[1]
; willVar[0] = -1 * 5
; fpa_script.CallFunction("ModifyWillpower", willVar)

; ; Increase Self-Esteem by 5
; var[] seVar = new var[1]
; seVar[0] = 5
; fpa_script.CallFunction("ModifySelfEsteem", seVar)

; ; Increase Sex Addiction Level by 5
; var[] saVar = new var[1]
; saVar[0] = 5
; fpa_script.CallFunction("ModifySexLevel", saVar)

; ; Increase Sex Reputation Level by 5
; var[] srVar = new var[1]
; srVar[0] = 5
; fpa_script.CallFunction("ModifySexReputation", srVar)

; ; Increase Sex Reputation Level by 5, but dont go over 50
; var[] srcVar = new var[2]
; srcVar[0] = 5
; srcVar[1] = 50
; fpa_script.CallFunction("ModifySexReputationWithUpperCap", srcVar)

; ; Increase Arousal Level by 5
; var[] srVar = new var[1]
; srVar[0] = 5
; fpa_script.CallFunction("ModifyArousal", srVar)

; ; Grab FPA script object
; Quest FPA_Main = Game.GetFormFromFile(0x00000F99, "FPAttributes.esp") as quest
; ScriptObject fpa_script = FPA_Main.CastAs("FPA:FPA_Main")

; ; Get intimidate success chance. Returned value will be between 0 to 100
; int intimidateChance = fpa_script.CallFunction("GetIntimidateSuccessChance", new var[0]) as int
	
; ; Get NPC persuasion success chance. Returned value will be between 0 to 100
; Var[] params = new Var[1]
; params[0] = 3 ; Hard persuasion. 1 = Easy, 2 = Medium, 3 = Hard
; int persuadeChance = fpa_script.CallFunction("GetNPCPersuasionChance", params) as int