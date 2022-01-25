Scriptname SD:PlayerScript extends ReferenceAlias
{This will attach to the player.}

Actor Property PlayerRef auto

GlobalVariable Property SD_Setting_Integrate_SA auto 

SD:SanityFrameworkQuestScript SF_Main

FPA:FPA_Main fpa_event
int wear
int willpower
int selfesteem
int spirit
int orientation
int sexReputation
int trauma
int intoxicationLevel
int arousal

Weather RainyWeather
Weather CloudyWeather

Event OnInit()
    StartTimer(1,1)
EndEvent

Event OnPlayerLoadGame()
    StartTimer(8, 1)
EndEvent


Event OnTimer(int aiTimerID)
  if(aiTimerID == 1)
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
	SF_Main = Main as SD:SanityFrameworkQuestScript
    SF_Main.CheckIntegrations()
    SF_Main.DNotify("Checking Integrations")
    RegisterForPlayerSleep()
    If SD_Setting_Integrate_SA.GetValue() == 1
        SetSexAttributes()
    EndIF
  EndIf
EndEvent

Function SetSexAttributes()
    wear = (Game.GetFormFromFile(0x01000FAA, "FPAttributes.esp") as GlobalVariable).getValueInt()
    willpower = (Game.GetFormFromFile(0x01000FAB, "FPAttributes.esp") as GlobalVariable).getValueInt()
    selfesteem = (Game.GetFormFromFile(0x01000FAC, "FPAttributes.esp") as GlobalVariable).getValueInt()
    spirit = (Game.GetFormFromFile(0x01007A67, "FPAttributes.esp") as GlobalVariable).getValueInt()
    orientation = (Game.GetFormFromFile(0x01000FAD, "FPAttributes.esp") as GlobalVariable).getValueInt()
    sexReputation = (Game.GetFormFromFile(0x101944F, "FPAttributes.esp") as GlobalVariable).getValueInt()
    trauma = (Game.GetFormFromFile(0x101E80B, "FPAttributes.esp") as GlobalVariable).getValueInt()
    intoxicationLevel = (Game.GetFormFromFile(0x101E80C, "FPAttributes.esp") as GlobalVariable).getValueInt()
    arousal = (Game.GetFormFromFile(0x101E80D, "FPAttributes.esp") as GlobalVariable).getValueInt()
	
    Quest Main = Game.GetFormFromFile(0x00000F99, "FPAttributes.esp") as quest
	fpa_event = Main as FPA:FPA_Main

	RegisterForCustomEvent(fpa_event, "OnWearUpdate")
	RegisterForCustomEvent(fpa_event, "OnWillpowerUpdate")
	RegisterForCustomEvent(fpa_event, "OnSelfEsteemUpdate")
	RegisterForCustomEvent(fpa_event, "OnSpiritUpdate")
	RegisterForCustomEvent(fpa_event, "OnOrientationUpdate")
    SF_Main.DNotify("Sex Attributes Loaded.")
EndFunction

Function EffectWeather()
    RainyWeather = Weather.FindWeather(2)
    Utility.RandomInt()
EndFunction

float iSleeptime = 0.0
float iSleepEnd = 0.0
float iSleepDesired = 0.0

Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
  iSleepTime = afSleepStartTime
  iSleepDesired = afDesiredSleepEndTime
EndEvent

Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
  iSleepEnd = Utility.GetCurrentGameTime() - iSleeptime
  if iSleepEnd < iSleepDesired
    SF_Main.DNotify("Player didn't get enough sleep. Time: " + (iSleepEnd as string))
  else
    SF_Main.DNotify("Player got enough sleep " + (iSleepEnd as string))
  endif
EndEvent







