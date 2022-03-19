Scriptname SD:PlayerScript extends ReferenceAlias
{This will attach to the player.}

Actor Property PlayerRef auto
Actor Property Shaun auto
Holotape Property CodsworthHoloTape01 auto
Armor Property Armor_WeddingRing auto
Armor Property Armor_SpouseWeddingRing auto
Potion Property SD_SanityPotion auto
Potion Property SD_SanityOnePotion auto 
Potion Property SD_ShadowLord auto 
Potion Property SD_BeastUnleashed auto 
Location[] Property SD_POI auto mandatory



GlobalVariable Property SD_Setting_ThoughtFrequency auto
GlobalVariable Property SD_Haha auto ;Do you believe in god?  Do you read comments?
GlobalVariable Property SD_HumanFactor auto ; -1 missing a member and +1 you have the member

;bad things for bad problems
Keyword Property ObjectTypeAlcohol auto 
Keyword Property ObjectTypeChem auto
Keyword Property AnimFaceArchetypeDepressed auto
;voices in my head can't stay quiet

int messageFrequency = 20

Keyword Property SD_RandomThought auto 
Keyword Property SD_RandomDrugThought auto 
Keyword Property SD_RandomDrinkThought auto 
Keyword Property SD_RandomDepressionThought auto 
Keyword Property SD_RandomWeatherThought auto 
Keyword Property SD_RandomGriefThought auto 
Keyword Property SD_RandomStressThought auto 
Keyword Property SD_RandomSleepThought auto 

GlobalVariable Property SD_Tolerance auto 
GlobalVariable Property SD_Decay auto
GlobalVariable Property SD_ModH auto
GlobalVariable Property SD_ModM auto
GlobalVariable Property SD_ModL auto

Perk Property SD_Sanity03 auto
Perk Property SD_Sanity04 auto
Perk Property SD_Sanity05 auto

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
float lastEffectCheck = 0.0

;splinter counters
int timesSthan = 0
int timesOne = 0 
int timesAlex = 0



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
    SF_Main.DNotify("Loading")
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
	  SF_Main = Main as SD:SanityFrameworkQuestScript
    SF_Main.LoadSDF()
    messageFrequency = SD_Setting_ThoughtFrequency.GetValueInt()
    RegisterForPlayerSleep()
    SetSexAttributes()
    lastEffectCheck = Utility.GetCurrentGameTime()
    RefreshPlayerEffects(Utility.GetCurrentGameTime())
    float chaos = Utility.RandomFloat(-0.5, 0.5)
    RegisterForRemoteEvent(PlayerRef, "OnLocationChange")
    
    chaos += tickFrequency
    StartTimerGameTime(chaos, tickTimerID)
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
  SetSexAttributes()
  
  bool alreadySaid = false

  ;What's the weather like
  Weather w = Weather.GetCurrentWeather()
  if (w.GetClassification() == 2)
    
    SF_Main.ModifyDepression(PlayerRef, -0.005 + negTolerance)
    if !alreadySaid && (Utility.RandomInt(0,100) < SF_Main.GetDepression(PlayerRef)) && !PlayerRef.IsTalking()
      Say(SD_RandomDepressionThought, PlayerRef) 
      alreadySaid = true
    EndIf
    
  Else
    If !PlayerRef.IsInCombat()
      SF_Main.ModifyStress(PlayerRef, 0.5 + tolerance)
    EndIf
  EndIf
  ;The voices in my head
  if (Utility.RandomInt() < messageFrequency) && !alreadySaid && !PlayerRef.IsTalking()
    Say(SD_RandomThought, PlayerRef)    
  Endif

  int chance
  If (PlayerRef.HasPerk(SD_Sanity03) && (SF_Main.GetSanity(PlayerRef) < 95.00))
    chance = Utility.RandomInt(1,100)
    If (chance <= 12)
      PlayerRef.EquipItem(SD_SanityOnePotion, false, true)
      SF_Main.DNotify("You are One.")
    EndIf
  ElseIf (PlayerRef.HasPerk(SD_Sanity04) && (SF_Main.GetSanity(PlayerRef) < 95.00))
    chance = Utility.RandomInt(1,100)
    If (chance <= 12)
      PlayerRef.EquipItem(SD_BeastUnleashed, false, true)
      SF_Main.DNotify("The Beast.")
    EndIf
  ElseIf (PlayerRef.HasPerk(SD_Sanity05) && (SF_Main.GetSanity(PlayerRef) < 95.00))
    chance = Utility.RandomInt(1,100)
    If (chance <= 12)
      SF_Main.DNotify("You are Shadow.")
      PlayerRef.EquipItem(SD_ShadowLord, false, true)
    EndIf

  EndIf

  alreadySaid = false
  
  RefreshPlayerEffects(Utility.GetCurrentGameTime())
  StartTimerGameTime(tickFrequency, tickTimerID)
EndFunction

Function SetSexAttributes()
  willpower = (Game.GetFormFromFile(0x01000FAB, "FPAttributes.esp") as GlobalVariable).getValueInt()
  selfesteem = (Game.GetFormFromFile(0x01000FAC, "FPAttributes.esp") as GlobalVariable).getValueInt()
  spirit = (Game.GetFormFromFile(0x01007A67, "FPAttributes.esp") as GlobalVariable).getValueInt()
  trauma = (Game.GetFormFromFile(0x101E80B, "FPAttributes.esp") as GlobalVariable).getValueInt()
  intoxicationLevel = (Game.GetFormFromFile(0x101E80C, "FPAttributes.esp") as GlobalVariable).getValueInt()
  tolerance = CalculateModifiers()
  negTolerance = tolerance * -1
  SD_Tolerance.SetValue(tolerance)
  SD_Decay.SetValue(negTolerance)
EndFunction

Function RefreshPlayerEffects(float currentTime)
  SF_Main.DNotify("Last Effect: " + lastEffectCheck)
  if (currentTime > (lastEffectCheck + 30))
    SF_Main.DNotify("Checking Effects")
    lastEffectCheck = currentTime
    PlayerRef.EquipItem(SD_SanityPotion, false, true)
  EndIf
EndFunction

Function EffectWeather()
    RainyWeather = Weather.FindWeather(2)
    int s = Utility.RandomInt()
    if (s < 50)
      RainyWeather.SetActive()
    endif 
EndFunction

Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
  iSleepDesired = afDesiredSleepEndTime
EndEvent

Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
  float x = Utility.GetCurrentGameTime();
  bool alreadySaid = false
  float rng =  Utility.RandomFloat() * 100
  ;You can't be happy if you want to sleep 8 hours and only get 5.  No stress relief for you otherwise.  That's why it's called desired sleep time, silly.
  if (x >= iSleepDesired) && !abInterrupted
    SF_Main.ModifyStress(PlayerRef, -0.5)
  Else
    if (Utility.RandomInt(0,100) < messageFrequency) && !alreadySaid
      Say(SD_RandomSleepThought, PlayerRef)    
      alreadySaid = true
    Endif
  endif
  
  If (Shaun.IsDead())
    ; code to deal with him when i get to him <3
  Else
    rng = Utility.RandomFloat() * 100
    SF_Main.ModifyDepression(PlayerRef, 0.05 + tolerance)
    SF_Main.ModifyGrief(PlayerRef, 0.05 + tolerance)
    If !alreadySaid && (rng < SF_Main.GetGrief(PlayerRef)) && !PlayerRef.IsTalking()
      Say(SD_RandomGriefThought, PlayerRef)  
      alreadySaid = true
    EndIf
  EndIf
  
  
  If (rng < SF_Main.GetDepression(PlayerRef))
    EffectWeather()
    SF_Main.ModifyDepression(PlayerRef, SD_Decay.GetValue())
    if (Weather.GetCurrentWeather().GetClassification() == 2) && !alreadySaid && !PlayerRef.IsTalking()
      Say(SD_RandomDepressionThought, PlayerRef)   
    EndIF
  EndIf
EndEvent



; note, this constant will be a diminishing variable to simulate tolerance.
Event OnItemEquipped(Form akBaseObject, ObjectReference akReference)

  if (akReference == PlayerRef) && akBaseObject.HasKeyword(ObjectTypeAlcohol)
    SF_Main.ModifyStress(PlayerRef, 0.05 + negTolerance)
    SF_Main.ModifyDepression(PlayerRef, 0.05 + negTolerance)
    SF_Main.ModifyGrief(PlayerRef, 0.05 + negTolerance)
    if (Utility.RandomInt() < messageFrequency)
      Say(SD_RandomDrinkThought, PlayerRef)   
    endif
  elseif (akReference == PlayerRef) || akBaseObject.HasKeyword(ObjectTypeChem)
    SF_Main.ModifyStress(PlayerRef, 0.1 + negTolerance)
    SF_Main.ModifyDepression(PlayerRef, 0.1 + negTolerance)
    SF_Main.ModifyGrief(PlayerRef, 0.1 + negTolerance)
    if (Utility.RandomInt() < messageFrequency)
      Say(SD_RandomDrugThought, PlayerRef)   
    endif
  EndIf

  ; I'll need to tag all items with a common keyword
  If (akReference == PlayerRef) && (akBaseObject == Armor_WeddingRing || akBaseObject == Armor_SpouseWeddingRing)
    SF_Main.ModifyGrief(PlayerRef, -1.0)
    Say(SD_RandomGriefThought, PlayerRef) ; TODO: Make this a reference to the opposite sex player voice.  "Hi Honey! I'm dead!"
  EndIF
EndEvent


; These are crucial messages to keep the player engaged in the mod.  A constant reminder that you have other issues to deal with.
Function DMessage(string text)
   Debug.Notification(text)
EndFunction


Function LoadSmokes()
  ;Smoke-able Cigars.esp
EndFunction

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  
  If (SD_POI.Find(akNewLoc) > -1)
    
    SF_Main.ModifyGrief(PlayerRef, -0.5)
  EndIf
  RegisterForRemoteEvent(PlayerRef, "OnLocationChange")
EndEvent

Function Say(Keyword akKey, Actor akActor)
  
  akActor.SayCustom(akKey, None, true)
EndFunction