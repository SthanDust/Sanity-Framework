Scriptname SD:PlayerScript extends ReferenceAlias
{This will attach to the player.}

Actor Property PlayerRef auto
Actor Property Shaun auto


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

Keyword Property SD_RandomThought auto 


 

;It can't rain all the time, can it?  When you're sad, can you tell the difference between rain and shine, buttercup?
Weather RainyWeather

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
float negTolerance = 0.0
float baseDecay = 0.01

float function CalculateModifiers()
  float weightWill = 0.3
  float weightEsteem = 0.1 
  float weightSpirit = 0.2 
  float weightTrauma = 0.4 
  float baseNormal = 500.0

  float DecayModifier = (weightWill * willpower) + (weightEsteem * selfesteem) + (weightSpirit * spirit) + (weightTrauma * (trauma * 20))
  float finalVal = (DecayModifier / baseNormal) + baseDecay
  ;
  return finalVal
EndFunction

Event OnInit()
    StartTimer(1,1)
EndEvent

Event OnPlayerLoadGame()
    StartTimer(3, 1)
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
  negTolerance = tolerance * -1
  
  ;What's the weather like
  Weather w = Weather.GetCurrentWeather()
  if (w.GetClassification() == 2)
    
    SF_Main.ModifyDepression(PlayerRef, 0.005 + tolerance)
    int i = Utility.RandomInt(0, WeatherDepressedMessages.Length - 1)
    lastMessage = WeatherDepressedMessages[i]
  Else
    
    SF_Main.ModifyDepression(PlayerRef, -0.005 + negTolerance)
    If !PlayerRef.IsInCombat()
    SF_Main.ModifyStress(PlayerRef, -0.5 + negTolerance)
    EndIf
  EndIf
  ;The voices in my head
  if Utility.RandomInt() < messageFrequency
    PlayerRef.SayCustom(SD_RandomThought, PlayerRef, true, None)    
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
EndFunction

Function EffectWeather()
    RainyWeather = Weather.FindWeather(2)
    int s = Utility.RandomInt()
    if s < 50
      RainyWeather.SetActive()
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
    SF_Main.ModifyDepression(PlayerRef, 0.05 + tolerance)
    SF_Main.ModifyGrief(PlayerRef, 0.05 + Tolerance)
  EndIf
  float rng =  Utility.RandomFloat() * 100
  
  If (rng < SF_Main.GetDepression(PlayerRef))
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
    SF_Main.ModifyStress(PlayerRef, -0.05 + negTolerance)
    SF_Main.ModifyDepression(PlayerRef, -0.05 + negTolerance)
    if Utility.RandomInt() < messageFrequency
      int a = Utility.RandomInt(0, DrinkMessages.Length - 1)
      DMessage(DrinkMessages[a])
    endif
  elseif akReference == PlayerRef || akBaseObject.HasKeyword(ObjectTypeChem)
    SF_Main.ModifyStress(PlayerRef, -0.5 + negTolerance)
    SF_Main.ModifyDepression(PlayerRef, -0.5 + negTolerance)
    if Utility.RandomInt() < messageFrequency
      int d = Utility.RandomInt(0, DrugMessages.Length - 1)
      DMessage(DrugMessages[d])
    endif
  EndIf
EndEvent


; These are crucial messages to keep the player engaged in the mod.  A constant reminder that you have other issues to deal with.
Function DMessage(string text)
   Debug.Notification(text)
EndFunction

Function LoadSmokes()
  ;Smoke-able Cigars.esp
EndFunction
