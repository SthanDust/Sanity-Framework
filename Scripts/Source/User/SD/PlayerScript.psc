Scriptname SD:PlayerScript extends ReferenceAlias

Actor Property PlayerRef auto
Actor Property Shaun auto
Holotape Property CodsworthHoloTape01 auto
Armor Property Armor_WeddingRing auto
Armor Property Armor_SpouseWeddingRing auto
Potion Property SD_SanityPotion auto
Spell Property SD_SanitySpell auto
Potion Property SD_SplinterPotionOne auto 
Potion Property SD_SplinterPotionGabryal auto 
Potion Property SD_SplinterPotionBeast auto 
Location[] Property SD_POI auto 
Location[] Property SD_POIInsanity auto 
Race Property HumanRace auto 

Faction Property SD_OneFaction auto 
Faction Property SD_BeastFaction auto
Faction Property SD_SthanFaction auto
Faction Property SD_GabryalFaction auto 
Faction Property SD_YouFaction auto 
Faction Property SD_OliviaFaction auto 
Faction Property SD_AlexFaction auto
Faction Property SD_JackFaction auto 

Faction Property Pregnancy auto
bool Property IsPregnant auto
Race Property CurrentFatherRace auto
Actor Property akFather auto
Actor property akMother auto
Int property NumChildren auto
Bool property akBirth auto

GlobalVariable Property SD_Setting_ThoughtsEnabled auto
GlobalVariable Property SD_Setting_ThoughtFrequency auto
GlobalVariable Property SD_Haha auto ;Do you believe in god?  Do you read comments?
GlobalVariable Property SD_HumanFactor auto ; -1 missing a member and +1 you have the member
GlobalVariable Property SD_Setting_Integrate_Vio auto
GlobalVariable Property SD_Setting_Integrate_FPE auto
GlobalVariable Property SD_Setting_Integrate_WLD Auto 
GlobalVariable Property SD_Setting_Integrate_JB auto
GlobalVariable Property SD_Setting_Integrate_HBW auto
GlobalVariable Property SD_Tolerance auto 
GlobalVariable Property SD_Decay auto
GlobalVariable Property SD_ModH auto
GlobalVariable Property SD_ModM auto
GlobalVariable Property SD_ModL auto

;bad things for bad problems
Keyword Property ObjectTypeAlcohol auto 
Keyword Property CA_ObjType_ChemBad auto
Keyword Property SD_RandomThought auto 
Keyword Property SD_RandomDrugThought auto 
Keyword Property SD_RandomDrinkThought auto 
Keyword Property SD_RandomDepressionThought auto 
Keyword Property SD_RandomWeatherThought auto 
Keyword Property SD_RandomGriefThought auto 
Keyword Property SD_RandomStressThought auto 
Keyword Property SD_RandomSleepThought auto 
KeyWord Property SD_SplinterEffect auto 

Perk Property SD_SplinterOne auto
Perk Property SD_SplinterGabryal auto
Perk Property SD_SplinterBeast auto
Perk Property SD_SplinterYou auto
Perk Property SD_SplinterOlivia auto
Perk Property SD_SplinterSthan auto
Perk Property SD_SplinterJack auto
Perk Property SD_SplinterAlex auto
Perk[] Property SD_Mutations auto

;It can't rain all the time, can it?  When you're sad, can you tell the difference between rain and shine, buttercup?
Weather Property RainyWeather Auto
int messageFrequency = 20




float tickFrequency = 1.0
int tickTimerID = 34
int dayTimerID = 24
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
string[] Property ImpregnatedRaces auto

FPFP_Player_Script property FPE auto hidden
FPFP_PlayerPregData property BabyInfo auto hidden
SD:SanityFrameworkQuestScript property SF_Main auto hidden


float function CalculateModifiers()
  float weightWill = 0.3
  float weightEsteem = 0.1 
  float weightSpirit = 0.2 
  float weightTrauma = 0.4 
  float baseNormal = 500.0
 
  float DecayModifier = (weightWill * willpower) + (weightEsteem * selfesteem) + (weightSpirit * spirit) + (weightTrauma * (trauma * 20))
  float finalVal = (DecayModifier / baseNormal) + baseDecay
  ;SF_Main.DNotify("New Trauma: " + finalVal);
  return finalVal
EndFunction

Event OnInit()
    StartTimer(1,1)
    
EndEvent

Event OnPlayerLoadGame()
    StartTimer(3, 1)
    PlayerRef.EquipItem(SD_SanityPotion, false, true)
    if (ImpregnatedRaces.Length == 0)
      ImpregnatedRaces = new string[25]
    EndIf
EndEvent

Event OnTimer(int aiTimerID)
  if(aiTimerID == 1)
    
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    
  
    SF_Main = Main as SD:SanityFrameworkQuestScript
    SF_Main.LoadSDF()
    ImpregnatedRaces = new string[25]
    if (Game.IsPluginInstalled("FP_FamilyPlanningEnhanced.esp") && SD_Setting_Integrate_FPE.Value == 1)
      Pregnancy = Game.GetFormFromFile(0x00000FA8, "FP_FamilyPlanningEnhanced.esp") as Faction
      FPE = Game.GetFormFromFile(0x00000F99, "FP_FamilyPlanningEnhanced.esp") as FPFP_Player_Script
      BabyInfo = Game.GetFormFromFile(0x00000F99, "FP_FamilyPlanningEnhanced.esp") as FPFP_PlayerPregData
      FPFP_BasePregData BPD = FPE.GetPregnancyInfo(PlayerRef)
      RegisterForCustomEvent(FPE, "FPFP_GetPregnant")
      RegisterForCustomEvent(FPE, "FPFP_GiveBirth")
      if PlayerRef.IsInFaction(Pregnancy)
        IsPregnant = true
        
      Else
        IsPregnant = false
      endif
    endif
	  
    
    messageFrequency = SD_Setting_ThoughtFrequency.GetValueInt()
    RegisterForPlayerSleep()
    SetSexAttributes()
    lastEffectCheck = Utility.GetCurrentGameTime()
    RefreshPlayerEffects(Utility.GetCurrentGameTime())
    float chaos = Utility.RandomFloat(-0.5, 0.5)
    RegisterForRemoteEvent(PlayerRef, "OnLocationChange")
    RegisterForRemoteEvent(PlayerRef, "OnCombatStateChanged")
    RegisterForRadiationDamageEvent(PlayerRef)
    chaos += tickFrequency
    StartTimerGameTime(chaos, tickTimerID)
    StartTimerGameTime(24, dayTimerID)
    LoadMessages()
  EndIf
EndEvent

function LoadMessages()
  ;SF_Main.DNotify("Player Pregnancy: " + IsPregnant)
EndFunction

Event FPFP_Player_Script.FPFP_GetPregnant(FPFP_Player_Script akSender, Var[] akArgs)  
	akMother = akArgs[0] as Actor
  akFather = akArgs[1] as Actor
	NumChildren = akArgs[2] as int
  ;RegisterForCustomEvent(FPE, "FPFP_GetPregnant")
  if akMother == PlayerRef
    IsPregnant = true;
    if (ImpregnatedRaces.Find(akFather.GetRace() as string) == -1)
      ImpregnatedRaces.Add(akFather.GetRace() as string)
      CurrentFatherRace = akFather.GetRace()
      Utility.Wait(2.0)
      ;SF_Main.DNotify("Player Impregnated by a " + CurrentFatherRace.GetName())
    EndIf
  EndIF
  ;SF_Main.DNotify(akMother.GetActorBase().GetName() + " got Pregnant by a " + akFather.GetRace().GetName() + " with " + NumChildren)
EndEvent

Event FPFP_Player_Script.FPFP_GiveBirth(FPFP_Player_Script akSender, Var[] akArgs)
  akMother = akArgs[0] as Actor
  akBirth = akArgs[2] as bool
  if (akMother == PlayerRef)
    IsPregnant = false 
    If CurrentFatherRace != HumanRace
      SF_Main.ModifySanity(PlayerRef, -0.5)
    EndIf
    CurrentFatherRace = None
    
  EndIF
  ;RegisterForCustomEvent(FPE, "FPFP_GiveBirth")
  ;SF_Main.DNotify("Gave Birth.")
EndEvent

Event OnTimerGameTime(int aiTimerID)
  if (aiTimerID == tickTimerID)
    OnTick()
  EndIf
  if (aiTimerID == dayTimerID)
    OnDay()
  EndIF
EndEvent

function OnDay()
  SF_Main.DNotify("A day has passed.")
EndFunction

;I wasted time, now doth time waste me
Function OnTick()
  string lastMessage;
  SetSexAttributes()

  If (SD_Setting_Integrate_FPE.GetValue() == 1)
     HandleFamilyPlanning()
  EndIf

 
  bool alreadySaid = false

  ;What's the weather like
  Weather w = Weather.GetCurrentWeather()
  if (w.GetClassification() == 2)
    
    SF_Main.ModifyDepression(PlayerRef, -0.05 + negTolerance)
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

  alreadySaid = false
  
  RefreshPlayerEffects(Utility.GetCurrentGameTime())
  StartTimerGameTime(tickFrequency, tickTimerID)
EndFunction

Function ManageSplinters()
  int chance

  If (PlayerRef.HasEffectKeyword(SD_SplinterEffect))
    SF_Main.DNotify("Player already has an effect.")
    return
  EndIf
  
  IF (SF_Main.GetSanity(PlayerRef) < 95.00)
    IF (PlayerRef.IsInCombat())
      If (PlayerRef.HasPerk(SD_SplinterBeast))
        chance = Utility.RandomInt(1,100)
        ;SF_Main.DNotify(" Chance You: " + chance + " Current Rank: " + PlayerRef.GetFactionRank(SD_BeastFaction))
        If (chance <= 5)
          PlayerRef.EquipItem(SD_SplinterPotionBeast, false, true)
          ;SF_Main.DNotify("The Beast Whispers.")
          PlayerRef.AddToFaction(SD_BeastFaction)
          PlayerRef.ModFactionRank(SD_BeastFaction,1)
          return
        EndIf
      EndIf
      If (PlayerRef.HasPerk(SD_SplinterGabryal))
        chance = Utility.RandomInt(1,100)
        ;SF_Main.DNotify(" Chance You: " + chance + " Current Rank: " + PlayerRef.GetFactionRank(SD_GabryalFaction))
        If (chance <= 5)
          ;SF_Main.DNotify("You are Shadow.")
          PlayerRef.EquipItem(SD_SplinterPotionGabryal, false, true)
          PlayerRef.AddToFaction(SD_GabryalFaction)
          PlayerRef.ModFactionRank(SD_GabryalFaction, 1)
          return
        EndIf
      EndIf
    EndIF

    If (PlayerRef.HasPerk(SD_SplinterOne))
      chance = Utility.RandomInt(1,100)
      ;SF_Main.DNotify(" Chance You: " + chance + " Current Rank: " + PlayerRef.GetFactionRank(SD_OneFaction))
      If (chance <= 5)
        ;SF_Main.DNotify("You are One.")
        PlayerRef.EquipItem(SD_SplinterPotionOne, false, true)
        PlayerRef.AddToFaction(SD_OneFaction)
        PlayerRef.ModFactionRank(SD_OneFaction, 1)
        return
      EndIf
    EndIF

    
    chance = Utility.RandomInt(1,100)
    ;SF_Main.DNotify(" Chance You: " + chance + " Current Rank: " + PlayerRef.GetFactionRank(SD_YouFaction))
    If (chance <= 5)
      SF_Main.ModifySanity(PlayerRef, 1)
      ;SF_Main.DNotify("You.")
      PlayerRef.AddToFaction(SD_YouFaction)
      PlayerRef.ModFactionRank(SD_YouFaction, 1)
    EndIf

  EndIf
 

EndFunction

Function SetSexAttributes()
  willpower = (Game.GetFormFromFile(0x00000FAB, "FPAttributes.esp") as GlobalVariable).getValueInt()
  selfesteem = (Game.GetFormFromFile(0x00000FAC, "FPAttributes.esp") as GlobalVariable).getValueInt()
  spirit = (Game.GetFormFromFile(0x00007A67, "FPAttributes.esp") as GlobalVariable).getValueInt()
  trauma = (Game.GetFormFromFile(0x0001E80B, "FPAttributes.esp") as GlobalVariable).getValueInt()
  intoxicationLevel = (Game.GetFormFromFile(0x0001E80C, "FPAttributes.esp") as GlobalVariable).getValueInt()
  tolerance = CalculateModifiers()
  negTolerance = tolerance * -1
  SD_Tolerance.SetValue(tolerance)
  SD_Decay.SetValue(negTolerance)
EndFunction

Function HandleFamilyPlanning()
  if (IsPregnant)
   
    SF_Main.ModifyGrief(PlayerRef, 0.1)
    SF_Main.ModifySanity(PlayerRef, 0.1)
    SF_Main.ModifyDepression(PlayerRef, 0.1)
    SF_Main.ModifyStress(PlayerRef, -0.05)
    SF_Main.ModifyTrauma(PlayerRef, 0.1)
  EndIf
EndFunction

Function RefreshPlayerEffects(float currentTime)
  
  if (currentTime > (lastEffectCheck + 30))
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
    SF_Main.ModifyStress(PlayerRef, 0.5)
    SF_Main.ModifySanity(PlayerRef, 0.05)
    SF_Main.ModifyTrauma(PlayerRef, 5)
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
    SF_Main.DNotify("Weather Effect.")
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
  elseif (akReference == PlayerRef) || akBaseObject.HasKeyword(CA_ObjType_ChemBad)
    SF_Main.ModifyStress(PlayerRef, 0.1 + negTolerance)
    SF_Main.ModifyDepression(PlayerRef, 0.1 + negTolerance)
    SF_Main.ModifyGrief(PlayerRef, 0.1 + negTolerance)
    if (Utility.RandomInt(0,100) < messageFrequency)
      Say(SD_RandomDrugThought, PlayerRef)   
    endif
  EndIf

  ; I'll need to tag all items with a common keyword
  If (akReference == PlayerRef) && (akBaseObject == Armor_WeddingRing || akBaseObject == Armor_SpouseWeddingRing)
    SF_Main.ModifyGrief(PlayerRef, -1.0)
    Say(SD_RandomGriefThought, PlayerRef) ; TODO: Make this a reference to the opposite sex player voice.  "Hi Honey! I'm dead!"
  EndIF
  ; Add bit to remove mutations
EndEvent

Event OnRadiationDamage(ObjectReference akTarget, bool abIngested)
  IF akTarget == PlayerRef
    RegisterForRadiationDamageEvent(PlayerRef)
  EndIF
EndEvent

; These are crucial messages to keep the player engaged in the mod.  A constant reminder that you have other issues to deal with.
Function DMessage(string text)
   Debug.Notification(text)
EndFunction



Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  
  If (SD_POI.Find(akNewLoc) > -1)
    SF_Main.DNotify("Grief Location.")
    SF_Main.ModifyGrief(PlayerRef, -0.5)
  EndIf

EndEvent

Function Say(Keyword akKey, Actor akActor)
  if (SD_Setting_ThoughtsEnabled.GetValueInt() == 1)
    akActor.SayCustom(akKey, None, true)
  EndIf
EndFunction

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    if (aeCombatState == 0)
    elseif (aeCombatState == 1)
      ManageSplinters()
    endIf
endEvent