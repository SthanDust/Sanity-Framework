Scriptname SD:PlayerScript extends ReferenceAlias
{This will attach to the player.}

Actor Property PlayerRef auto
Actor Property Shaun auto

GlobalVariable Property SD_DepressionLevel auto
GlobalVariable Property SD_GriefLevel auto
GlobalVariable Property SD_TraumaLevel auto
GlobalVariable Property SD_Setting_ThoughtFrequency auto
GlobalVariable Property SD_Haha auto ;Do you believe in god?  Do you read comments?
GlobalVariable Property SD_HumanFactor auto ; -1 missing a member and +1 you have the member
;bad things for bad problems
Keyword Property ObjectTypeAlcohol auto 
Keyword Property ObjectTypeChem auto
Keyword Property AnimFaceArchetypeDepressed auto
;voices in my head can't stay quiet
string[] Property WeatherDepressedMessages auto
string[] Property DrugMessages auto
string[] Property DrinkMessages auto
string[] Property RandomThoughts auto
string[] Property SleepMessages auto
int messageFrequency = 20
 

;It can't rain all the time, can it?  When you're sad, can you tell the difference between rain and shine, buttercup?
Weather RainyWeather
Weather CloudyWeather
SD:SanityFrameworkQuestScript SF_Main
float tickFrequency = 1.0
int tickTimerID = 34
float iSleepDesired = 0.0
;0 none, <20 Weak, <50 Low, <60 Average, <80 High, <100 Strong, 100 Soaring
int willpower
;Same stratification as above
int selfesteem
; Same as above
int spirit
; 0 None, 1 Traumatized, 2 Increased, 3 greatly, 4 extremely, 5 overwhelmed
int trauma
;0 sober, 1 buzzed, 2 tipsy, 3 intoxicated, 4 drunk, 5 hammered
int intoxicationLevel
;this will be replaced with a function to reduce or improve tolerance over time.   
float tolerance = 0.0
float baseDecay = 0.01

float function CalculateModifiers()
  float weightWill = 0.3
  float weightEsteem = 0.1 
  float weightSpirit = 0.2 
  float weightTrauma = 0.4 
  float baseNormal = 500.0

  float DecayModifier = (weightWill * willpower) + (weightEsteem * selfesteem) + (weightSpirit * spirit) + (weightTrauma * (trauma * 20))
  float finalVal = (DecayModifier / baseNormal) + baseDecay
  ;DMessage("Decay : " + finalVal)
  return finalVal
EndFunction

Event OnInit()
    StartTimer(1,1)
EndEvent

Event OnPlayerLoadGame()
    StartTimer(5, 1)
EndEvent

Event OnTimer(int aiTimerID)
  if(aiTimerID == 1)
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
	  SF_Main = Main as SD:SanityFrameworkQuestScript
    SF_Main.LoadSDF()
    messageFrequency = SD_Setting_ThoughtFrequency.GetValueInt()
    RegisterForPlayerSleep()
    SetSexAttributes()
    ;RegisterForRemoteEvent(PlayerRef, "OnLocationChange")
    StartTimerGameTime(tickFrequency, tickTimerID)
  EndIf
EndEvent

Event OnTimerGameTime(int aiTimerID)
  if (aiTimerID == tickTimerID)
    OnTick()
  EndIf
EndEvent

;I wasted time, now doth time waste me
Function OnTick()
  string lastMessage;

  tolerance = CalculateModifiers()
  
  ;What's the weather like
  Weather w = Weather.GetCurrentWeather()
  if (w.GetClassification() == 2)
    ModDepression(0.005)
    int i = Utility.RandomInt(0, WeatherDepressedMessages.Length - 1)
    lastMessage = WeatherDepressedMessages[i]
  Else
    ModDepression(-0.005)
    If !PlayerRef.IsInCombat()
      SF_Main.ModifyStress(PlayerRef, -0.5)
    EndIf
  EndIf
  ;The voices in my head
  if Utility.RandomInt() < messageFrequency
    int r = Utility.RandomInt(0, RandomThoughts.Length)
    lastMessage = RandomThoughts[r]
  Endif
  ;don't want to overload the message queue
  DMessage(lastMessage)
  StartTimerGameTime(tickFrequency, tickTimerID)
EndFunction

Function SetSexAttributes()
  willpower = (Game.GetFormFromFile(0x01000FAB, "FPAttributes.esp") as GlobalVariable).getValueInt()
  selfesteem = (Game.GetFormFromFile(0x01000FAC, "FPAttributes.esp") as GlobalVariable).getValueInt()
  spirit = (Game.GetFormFromFile(0x01007A67, "FPAttributes.esp") as GlobalVariable).getValueInt()
  trauma = (Game.GetFormFromFile(0x101E80B, "FPAttributes.esp") as GlobalVariable).getValueInt()
  intoxicationLevel = (Game.GetFormFromFile(0x101E80C, "FPAttributes.esp") as GlobalVariable).getValueInt()
  tolerance = CalculateModifiers()
  DMessage("Tolerance: " + tolerance as string)
EndFunction

Function EffectWeather()
    RainyWeather = Weather.FindWeather(2)
    CloudyWeather = Weather.FindWeather(1)
    int s = Utility.RandomInt()
    if s < 50
      RainyWeather.SetActive()
    Else
      CloudyWeather.SetActive()
    endif 
EndFunction

Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
  iSleepDesired = afDesiredSleepEndTime
EndEvent

Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
  float x = Utility.GetCurrentGameTime();
  ;You can't be happy if you want to sleep 8 hours and only get 5.  No stress relief for you otherwise.  That's why it's called desired sleep time, silly.
  if x >= iSleepDesired && !abInterrupted
    SF_Main.ModifyStress(PlayerRef, -0.5)
  Else
    if Utility.RandomInt() < messageFrequency
      int s = Utility.RandomInt(0, SleepMessages.Length - 1)
      DMessage(SleepMessages[s])
    Endif
  endif
  
  If (Shaun.IsDead())
    ; code to deal with him when i get to him <3
  Else
    ModDepression(0.05)
    ModGrief(0.05)
  EndIf
  float rng =  Utility.RandomFloat() * 100
  
  If (rng < SD_DepressionLevel.GetValue())
    EffectWeather()
    if Weather.GetCurrentWeather().GetClassification() == 2
      int i = Utility.RandomInt(0, WeatherDepressedMessages.Length - 1)
      DMessage(WeatherDepressedMessages[i])
    EndIF
  EndIf
EndEvent

; note, this constant will be a diminishing variable to simulate tolerance.
Event OnItemEquipped(Form akBaseObject, ObjectReference akReference)

  if akReference == PlayerRef && akBaseObject.HasKeyword(ObjectTypeAlcohol)
    SF_Main.ModifyStress(PlayerRef, -0.5)
    ModDepression(tolerance)
    if Utility.RandomInt() < messageFrequency
      int a = Utility.RandomInt(0, DrinkMessages.Length - 1)
      DMessage(DrinkMessages[a])
    endif
  elseif akReference == PlayerRef || akBaseObject.HasKeyword(ObjectTypeChem)
    SF_Main.ModifyStress(PlayerRef, -0.5)
    ModDepression(tolerance * -1)
    if Utility.RandomInt() < messageFrequency
      int d = Utility.RandomInt(0, DrugMessages.Length - 1)
      DMessage(DrugMessages[d])
    endif
  EndIf
EndEvent

Function ModDepression(float val)
  float newVal = SD_DepressionLevel.GetValue() + val
  SF_Main.DNotify("Depression: " + SD_DepressionLevel.GetValue() + " Value: " + val)
  if newVal < 0
    SD_DepressionLevel.SetValue(0.0)
  elseif newVal > 100
    SD_DepressionLevel.SetValue(100)
  Else
    SD_DepressionLevel.SetValue(newVal)
  endif
  
EndFunction

Function ModGrief(float val)
  float newVal = SD_GriefLevel.GetValue() + val
  SF_Main.DNotify("Grief: " + SD_GriefLevel.GetValue() + " Increased by: " + val)
  if newVal < 0
    SD_GriefLevel.SetValue(0.0)
  Elseif newVal > 100
    SD_GriefLevel.SetValue(100.0)
  Else 
    SD_GriefLevel.SetValue(newVal)
  EndIf
EndFunction

; These are crucial messages to keep the player engaged in the mod.  A constant reminder that you have other issues to deal with.
Function DMessage(string text)
   Debug.Notification(text)
EndFunction
