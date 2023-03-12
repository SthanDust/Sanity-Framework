Scriptname SD:BeastessQuest extends Quest

import MCM
import Actor
import Debug
import Game
import BodyGen
import AAF:AAF_API


Group Global_Vars
  GlobalVariable Property SD_Beastess_Canine auto
  GlobalVariable Property SD_Beastess_Reptile auto
  GlobalVariable Property SD_Beastess_Human auto
  GlobalVariable Property SD_Beastess_Necro auto
  GlobalVariable Property SD_Beastess_Insect auto
  GlobalVariable Property SD_Beastess_Mollusk auto 
  GlobalVariable Property SD_Beastess_Mutant auto
  GlobalVariable Property SD_Beastess_Alien auto
  GlobalVariable Property SD_Beastess_Tentacle auto
  GlobalVariable Property SD_Beastess_Canine_Preg auto
  GlobalVariable Property SD_Beastess_Reptile_Preg auto
  GlobalVariable Property SD_Beastess_Human_Preg auto
  GlobalVariable Property SD_Beastess_Necro_Preg auto
  GlobalVariable Property SD_Beastess_Insect_Preg auto
  GlobalVariable Property SD_Beastess_Mollusk_Preg auto 
  GlobalVariable Property SD_Beastess_Mutant_Preg auto
  GlobalVariable Property SD_Beastess_Alien_Preg auto
  GlobalVariable Property SD_Beastess_Tentacle_Preg auto
  GlobalVariable Property SD_Setting_Integrate_Tent auto 
  GlobalVariable Property SD_Setting_Integrate_FPE auto
  GlobalVariable Property SD_Setting_Integrate_WLD auto
  GlobalVariable Property SD_Beastess_DarkGift_Chance auto 
  GlobalVariable Property SD_Beastess_Tentacle_Preg_Chance auto
  GlobalVariable Property SD_Beastess_Tentacle_Attack_Chance auto
  GlobalVariable Property SD_Beastess_Tentacle_Enabled auto
  GlobalVariable Property SD_Beastess_Tentacle_Attack_Wait auto 
  GlobalVariable Property SD_Beastess_Tentacle_Sex_Duration auto
  GlobalVariable Property SD_Beastess_Tentacle_Spawn_Type auto 
  GlobalVariable Property SD_Beastess_Tentacle_Spawn_Count auto 
  GlobalVariable Property SD_Beastess_Tentacle_Ignore_Preg auto
  Actor Property PlayerRef auto
  Race Property HumanRace auto
  Potion Property SD_SplinterPotionGabryal auto 
  Potion Property SD_Skokushu auto 
  Book Property SD_TentaclesWeSeeYou auto 
  Faction Property PlayerFaction auto 
  Idle Property PlayerHowl auto
  Sound Property PlayerHowling auto 
EndGroup

Group Pregnancy
  Race Property CurrentFatherRace auto
  Actor Property akFather auto
  Actor property akMother auto
  Int property NumChildren auto
  Faction Property Pregnancy auto
  Bool Property IsPregnant auto
  Bool property akBirth auto
  Spell Property BloodyFanny auto
  Keyword Property SD_TentacleEffect auto
EndGroup    

Group Random_Beasts
  Faction Property DLC03_WolfFaction auto 
  Keyword Property ActorTypeDog auto 
  Actor property SummonedWolf auto
EndGroup

Group Tentacles
  Armor Property TentacleSlime auto 
  ActorBase Property PassiveBrainTentacle auto
  ActorBase Property PassivePlantTentacle auto 
  ActorBase Property PassiveMechTentacle auto 
  ActorBase Property PassiveTentacle auto 
  Sound Property TentacleSound auto
  Keyword Property SD_NoPregKeyword auto 
  Float Property LastTentacleTime auto 
  Keyword property LocSetWaterfront auto
  Faction Property SD_TentacleFaction auto 
  string[] Property SP_TentacleAttackMessages auto 
  string[] Property SP_TentacleLeaveMessages auto 
  string[] Property SP_TentacleTeaseMessage auto 
  Potion Property SD_SlimePotion auto 
  string[] Property SD_TentacleMilkingPositions auto
  Potion Property SD_TentacleMilk auto
  Potion Property SD_TentacleDeath2 auto
EndGroup

Group Beast_Races
  Race[] Property SD_CanineRaces auto 
  Race[] Property SD_ReptileRaces auto 
  Race[] Property SD_HumanRaces auto 
  Race[] Property SD_NecroRaces auto 
  Race[] Property SD_InsectRaces auto 
  Race[] Property SD_MolluskRaces auto
  Race[] Property SD_MutantRaces auto
  Race[] Property SD_AlienRaces auto 
  ActorBase[] Property SD_Tentacles auto
  Race Property SD_TentacleRace auto
EndGroup

SD:SanityFrameworkQuestScript SDF
FPFP_Player_Script FPE
FPFP_BasePregData BPD
AAF:AAF_API AAF_API

CustomEvent OnBeastess


float hour = 0.04200
Perk   Cumflated
Potion Spend_Milk
Perk  Lactation
Perk BreastMilkSpent
 
int   tickTimerID = 1
int   dayTimerID = 2
int   sexTimerID = 69
int   debugTimerID = 13
bool  havingSex = false
bool  playerTeleport = false 
bool  playerCrafting = false


Event OnInit()
    StartTimer(1,0)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    StartTimer(2, 0)
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)

EndEvent

Event Actor.OnPlayerUseWorkBench(Actor akSender, ObjectReference akWorkBench)
  If (akSender == PlayerREf)
    playerCrafting = true
  EndIf
EndEvent

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
  If abOpening
    playerCrafting = true
  else 
    playerCrafting = false
  EndIf
EndEvent

Event Actor.OnGetUp(Actor akSender, ObjectReference akFurniture)
  If akSender == PlayerRef
    playerCrafting = false
  EndIf
EndEvent

Event OnTimer(int aiTimerID)
    if(aiTimerID == 0)
      LoadFPE()
      LoadTentacles()
      LoadWLD()
      AAF_API = Game.GetFormFromFile(0x00000F99, "AAF.esm") as AAF:AAF_API
      Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
      SDF = Main as SD:SanityFrameworkQuestScript
      RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
      RegisterForRemoteEvent(PlayerRef, "OnLocationChange")
      RegisterForRemoteEvent(PlayerRef, "OnPlayerUseWorkbench")
      RegisterForRemoteEvent(PlayerRef, "OnGetUp")
      RegisterForMenuOpenCloseEvent("WorkshopMenu")
      RegisterForPlayerTeleport()
      StartTimerGameTime(1, tickTimerID)
      StartTimerGameTime(24, dayTimerID)
      RegisterForCustomEvent(AAF_API, "OnSceneEnd")
    EndIf

    if (aiTimerID == sexTimerID)
      OnSex()
    EndIf
EndEvent

Function ResetBeastess()
  SD_Beastess_Alien.Value = 0
  SD_Beastess_Canine.Value = 0
  SD_Beastess_Human.Value = 0
  SD_Beastess_Insect.Value = 0
  SD_Beastess_Mollusk.Value = 0
  SD_Beastess_Mutant.Value = 0
  SD_Beastess_Necro.Value = 0
  SD_Beastess_Reptile.Value = 0
  SD_Beastess_Alien.Value = 0
  SD_Beastess_Tentacle.Value = 0
  SD_Beastess_Tentacle_Preg.Value = 0
  SD_Beastess_Canine_Preg.Value = 0
  SD_Beastess_Human_Preg.Value = 0
  SD_Beastess_Insect_Preg.Value = 0
  SD_Beastess_Mollusk_Preg.Value = 0
  SD_Beastess_Mutant_Preg.Value = 0
  SD_Beastess_Necro_Preg.Value = 0
  SD_Beastess_Reptile_Preg.Value = 0
EndFunction

Event OnTimerGameTime(int aiTimerID)
  if (aiTimerID == tickTimerID)
    OnTick()
  EndIf
  if (aiTimerID == dayTimerID)
    OnDay()
  EndIf
EndEvent

Function OnTick()
  If SD_Beastess_Tentacle_Enabled.GetValueInt() == 1   
    if !PlayerRef.IsInCombat() && !PlayerRef.IsInScene() && !havingSex && !PlayerRef.IsGhost() && !PlayerRef.HasKeyword(AAF_API.AAF_ActorBusy) && !playerTeleport && !PlayerRef.IsInPowerArmor() && !playerCrafting
      If SD_Beastess_Tentacle_Ignore_Preg.GetValueInt() == 1 && IsPregnant
        int t = Utility.RandomInt(0, SP_TentacleTeaseMessage.Length - 1)
        Debug.Notification(SP_TentacleTeaseMessage[t])
      Else
        DoTentacleAmbush()
      EndIf
    ElseIf playerTeleport
      playerTeleport = false
    EndIf
  EndIF
  StartTimerGameTime(1, tickTimerID)
EndFunction

Function OnDay()
  StartTimerGameTime(24, dayTimerID)
EndFunction

Function OnSex()
  If havingSex
    AAF_API.ChangePosition(PlayerRef)
  EndIf
EndFunction

float Function GetCurrentHourOfDay() 
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time) ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return Time
EndFunction

Function CheckRace(Actor akActor)
  Race akRace = akActor.GetRace()

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
  If akRace.GetName() == "Tentacle"
    SD_Beastess_Tentacle.Value += 1
    SendCustomEvent("OnBeastess")
    return
  EndIf
EndFunction

Function ImpregnateRace(Actor akActor)
    Race akRace = akActor.GetRace()
    if SD_CanineRaces.Find(akRace) > -1
        SD_Beastess_Canine_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    endif
    If SD_ReptileRaces.Find(akRace) > -1
        SD_Beastess_Reptile_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    EndIf
    If SD_HumanRaces.Find(akRace) > -1
        SD_Beastess_Human_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    EndIf

    If SD_NecroRaces.Find(akRace) > -1
        SD_Beastess_Necro_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    EndIf

    If SD_InsectRaces.Find(akRace) > -1
        SD_Beastess_Insect_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    EndIf

    If SD_MolluskRaces.Find(akRace) > -1
        
        SD_Beastess_Mollusk_Preg.Value += 1
        SendCustomEvent("OnBeastess")
    EndIf

    If SD_MutantRaces.Find(akRace) > -1
        
        SD_Beastess_Mutant_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    EndIf

    If SD_AlienRaces.Find(akRace) > -1
        SD_Beastess_Alien_Preg.Value += 1
        SendCustomEvent("OnBeastess")
        return
    EndIf

    If akRace.GetName() == "Tentacle"
      SD_Beastess_Tentacle_Preg.Value += 1
      SendCustomEvent("OnBeastess")
      return
    EndIf
EndFunction

Function LoadFPE()
    if (Game.IsPluginInstalled("FP_FamilyPlanningEnhanced.esp"))
      SD_Setting_Integrate_FPE.SetValueInt(1)
      SD_NoPregKeyword = Game.GetFormFromFile(0x00017742, "FP_FamilyPlanningEnhanced.esp") as Keyword
      Pregnancy = Game.GetFormFromFile(0x00000FA8, "FP_FamilyPlanningEnhanced.esp") as Faction 
      FPE = Game.GetFormFromFile(0x00000F99, "FP_FamilyPlanningEnhanced.esp") as FPFP_Player_Script
      BPD = FPE.GetPregnancyInfo(PlayerRef)
      Cumflated = Game.GetFormFromFile(0x0000C223, "FP_FamilyPlanningEnhanced.esp") as Perk

      RegisterForCustomEvent(FPE, "FPFP_GetPregnant")
      RegisterForCustomEvent(FPE, "FPFP_GiveBirth")
      BloodyFanny = BPD.SP_BloodyBirth as Spell 
      IsPregnant = CheckPregnant()
    endif
EndFunction

Function LoadWLD()
  if (Game.IsPluginInstalled("INVB_WastelandOffspring.esp"))
    SD_Setting_Integrate_WLD.SetValueInt(1)
      Spend_Milk = Game.GetFormFromFile(0x00005C98, "INVB_WastelandDairy.esp") as Potion
      Lactation = Game.GetFormFromFile(0x00012357, "INVB_WastelandDairy.esp") as Perk
      BreastMilkSpent = Game.GetFormFromFile(0x00005C96, "INVB_WastelandDairy.esp") as Perk
  EndIf
EndFunction

Function LoadZazEffects()
  If (Game.IsPluginInstalled("Zaz Particle Effects.esp"))
    TentacleSlime = Game.GetFormFromFile(0x00000812, "Zaz Particle Effects.esp") as Armor
  EndIf
EndFunction

Function LoadTentacles()
  If (Game.IsPluginInstalled("AnimatedTentacles.esp"))
    SD_Setting_Integrate_Tent.SetValue(1)
    SD_Tentacles = new ActorBase[4]
    SD_TentacleRace = Game.GetFormFromFile(0x00000F9A, "AnimatedTentacles.esp") as Race
    TentacleSound = Game.GetFormFromFile(0x00005C5C, "AnimatedTentacles.esp") as Sound
    PassiveBrainTentacle = Game.GetFormFromFile(0x000035C0, "AnimatedTentacles.esp") as ActorBase
    SD_Tentacles[0] = PassiveBrainTentacle
    PassivePlantTentacle = Game.GetFormFromFile(0x00005C5D, "AnimatedTentacles.esp") as ActorBase
    SD_Tentacles[1] = PassivePlantTentacle
    PassiveTentacle = Game.GetFormFromFile(0x00000F9D, "AnimatedTentacles.esp") as ActorBase
    SD_Tentacles[2] = PassiveTentacle
    PassiveMechTentacle = Game.GetFormFromFile(0x00005C62, "AnimatedTentacles.esp") as ActorBase
    SD_Tentacles[3] = PassiveMechTentacle
    LoadZazEffects()
  Else
    SD_Setting_Integrate_Tent.SetValue(0)
    SD_Beastess_Tentacle_Enabled.SetValue(0)
  EndIf
EndFunction

bool Function CheckPregnant()
    if PlayerRef.IsInFaction(Pregnancy) && (PlayerRef.GetFactionRank(Pregnancy) > -1)
        IsPregnant = true
    Else
        IsPregnant = false
    endif
    return IsPregnant
EndFunction

Event FPFP_Player_Script.FPFP_GetPregnant(FPFP_Player_Script akSender, Var[] akArgs)  
    akMother = akArgs[0] as Actor
    if akMother == PlayerRef
        IsPregnant = true
        akFather = akArgs[1] as Actor
        NumChildren = akArgs[2] as int
        CurrentFatherRace = akFather.GetRace()
        ImpregnateRace(akFather)
    EndIF
EndEvent

Event FPFP_Player_Script.FPFP_GiveBirth(FPFP_Player_Script akSender, Var[] akArgs)
  akMother = akArgs[0] as Actor
  
  if (akMother == PlayerRef)
    akBirth = akArgs[2] as bool
    If CurrentFatherRace != HumanRace
      SDF.ModifySanity(PlayerRef, -0.5)
    EndIf
    CurrentFatherRace = None
    IsPregnant = false
    NumChildren = 0
  EndIF
EndEvent

Function GetStats()
    string beastString = "<font face='$HandwrittenFont' size='20'>Beastess Statistics</font> \n \n"
      beastString += "<font face='$ConsoleFont' size='15'>"
      beastString += "Alien:   Sex - " + SD_Beastess_Alien.GetValueInt() + "   Pregnancy - " + SD_Beastess_Alien_Preg.GetValueInt() + "  \n"
      beastString += "Canine:  Sex - " + SD_Beastess_Canine.GetValueInt() + "  Pregnancy - " + SD_Beastess_Canine_Preg.GetValueInt() + " \n"
      beastString += "Human:   Sex - " + SD_Beastess_Human.GetValueInt() + "   Pregnancy - " + SD_Beastess_Human_Preg.GetValueInt() + "  \n"
      beastString += "Reptile: Sex - " + SD_Beastess_Reptile.GetValueInt() + " Pregnancy - " + SD_Beastess_Reptile_Preg.GetValueInt() + "\n"
      beastString += "Marine:  Sex - " + SD_Beastess_Mollusk.GetValueInt() + " Pregnancy - " + SD_Beastess_Mollusk_Preg.GetValueInt() + "\n"
      beastString += "Mutant:  Sex - " + SD_Beastess_Mutant.GetValueInt() + "  Pregnancy - " + SD_Beastess_Mutant_Preg.GetValueInt() + " \n"
      beastString += "Insect:  Sex - " + SD_Beastess_Insect.GetValueInt() + "  Pregnancy - " + SD_Beastess_Insect_Preg.GetValueInt() + " \n"
      beastString += "Tentacle:  Sex - " + SD_Beastess_Tentacle.GetValueInt() + " Pregnancy - " + SD_Beastess_Tentacle_Preg.GetValueInt() + "\n"
      beastString += "Necro:   Sex - " + SD_Beastess_Necro.GetValueInt() + "   Pregnancy - " + SD_Beastess_Necro_Preg.GetValueInt() + "  </font>"
    Debug.MessageBox(beastString)
EndFunction

Function ShowBlood()
    BloodyFanny.Cast(PlayerRef, PlayerRef)
EndFunction

Function ShowPregnancy()
    If CheckPregnant()
        string Preggers = "<font face='$ConsoleFont' size='15'>Pregnancy \n \n"
        Preggers += "Father is a " + CurrentFatherRace.GetName() + " \n"

        Preggers += "There are " + NumChildren + " child(ren) \n "
        Debug.MessageBox(Preggers)
    Else
        Debug.MessageBox("<font face='$ConsoleFont' size='15'>Players is not pregnant</font>")
    EndIf
EndFunction

Function RemoveTentacle(Actor akActor)
  akActor.SetGhost(false)
  akActor.RemoveKeyword(AAF_API.AAF_ActorBusy)
  akActor.EquipItem(SD_TentacleDeath2, false, true)

EndFunction

Function TentacleAmbush(float Distance = 233.0)
  float maxDistance = Distance
  
  int numTentacles = Utility.RandomInt(1, SD_Beastess_Tentacle_Spawn_Count.GetValueInt())
  Actor[] akActors = new Actor[numTentacles]
  int i = 0
  while i < numTentacles
    akActors[i] = SpawnTentacle(maxDistance)
    i = i + 1
  EndWhile
  Utility.Wait(1)
  
  PlayerRef.AddKeyword(SD_NoPregKeyword)
  akActors.Add(PlayerRef)
  ; here we are interrupting the normal pregnancy
  
  AAF:AAF_API:SceneSettings sexScene = AAF_API.GetSceneSettings()
  sexScene.meta = "SD_TentacleAmbush"
  sexScene.duration = SD_Beastess_Tentacle_Sex_Duration.GetValueInt()
  sexScene.skipWalk = true
  int k = Utility.RandomInt(0, SP_TentacleAttackMessages.Length - 1)
  Debug.MessageBox("<font face='$HandwrittenFont' size='20'>" + SP_TentacleAttackMessages[k] + "</font> \n \n") 
  SDF.PlaySexAnimation(akActors, sexScene)
  havingSex = true
  int posSwitch = (SD_Beastess_Tentacle_Sex_Duration.GetValueInt() / 2) as int
  StartTimer(posSwitch, 69)
EndFunction

Function TryTentaclePreg(Actor akActor)
  
  float temp = Utility.RandomFloat()
  PlayerRef.RemoveKeyword(SD_NoPregKeyword)
  Game.FadeOutGame(true, true, 0, 2, true)
  If !CheckPregnant() 
    akActor.SetPosition(Game.GetPlayer().GetPositionX(),Game.GetPlayer().GetPositionY(), 500.0)
    Race tempRace = GetRandomRace()

    akActor.SetRace(tempRace)
    akActor.EquipItem(SD_SplinterPotionGabryal, false, true)    
    if (BPD.TrySpermFrom(akActor))
      ImpregnateRace(akActor)
      Debug.Notification("You feel you've become impregnated by something dreadful.")
    EndIf
    akActor.SetRace(SD_TentacleRace)
  ElseIf CheckPregnant() && BPD.GetCurrentMonth() <= 2

     BPD.TrySpermFrom(akActor)
  EndIf
  RemoveTentacle(akActor)
  Game.FadeOutGame(false, true, 0, 2, false)
 
EndFunction

Race Function GetRandomRace()
  int ran = Utility.RandomInt(0, 100)
  If (ran <= 13)
    int t = Utility.RandomInt(0, SD_CanineRaces.Length -1)
    return SD_CanineRaces[t]
  ElseIf (ran > 13 && ran <=24)
    int t = Utility.RandomInt(0, SD_AlienRaces.Length -1)
    return SD_AlienRaces[t]
  elseIf (ran > 24 && ran <= 36)
    int t = Utility.RandomInt(0, SD_InsectRaces.Length -1)
    return SD_InsectRaces[t]
  ElseIf (ran > 36 && ran <= 51)
    int t = Utility.RandomInt(0, SD_MolluskRaces.Length -1)
    return SD_MolluskRaces[t]
  ElseIf (ran > 51 && ran <= 63)
    int t = Utility.RandomInt(0, SD_NecroRaces.Length -1)
    return SD_NecroRaces[t]
  ElseIf (ran > 63 && ran <= 74)
    int t = Utility.RandomInt(0, SD_ReptileRaces.Length -1)
    return SD_ReptileRaces[t]
  ElseIf (ran > 74 && ran <= 90)
    int t = Utility.RandomInt(0, SD_MutantRaces.Length -1)
    return SD_MutantRaces[t]
  ElseIf (ran > 90)
    int t = Utility.RandomInt(0, SD_HumanRaces.Length -1)
    return SD_HumanRaces[t]
  EndIF
EndFunction

Actor Function SpawnTentacle(float maxDistance)
  
  int rnd

  If (SD_Beastess_Tentacle_Spawn_Type.GetValueInt() == 0)
    rnd = Utility.RandomInt(0, 3)
  Else
    rnd = SD_Beastess_Tentacle_Spawn_Type.GetValueInt() - 1
  EndIf
  
  ActorBase akTentacle = SD_Tentacles[rnd]
  
  float fAngle
  float fSin
  float fCos
  float fHeight
  float dist = Utility.RandomFloat(100.0, maxDistance)
  float newAngle = Utility.RandomFloat(45, 270)
  fAngle = Game.GetPlayer().GetAngleZ() + newAngle
  fSin = Math.sin(fAngle)
  fCos = Math.cos(fAngle)
  fHeight = Game.GetPlayer().GetPositionZ() 
  Actor newTent = PlayerRef.PlaceAtMe(akTentacle, 1) as Actor
  If newTent.GetRace() != SD_TentacleRace
    newTent.SetRace(SD_TentacleRace)
  EndIf
  newTent.SetGhost(true)
  float[] pos = newTent.GetSafePosition(dist, dist)
  newTent.SetPosition(Game.GetPlayer().GetPositionX() + (dist * fSin),Game.GetPlayer().GetPositionY() + (dist * fCos), Game.GetPlayer().GetPositionZ())
  TentacleSound.Play(newTent)
  return newTent
EndFunction

Function DoTentacleAmbush()
  If PlayerRef.IsInInterior()
    return
  EndIf
  int rnd = Utility.RandomInt()
  If ((SD_Beastess_Tentacle_Enabled.Value == 1) && (rnd < SD_Beastess_Tentacle_Attack_Chance.GetValueInt() ))
    float time = Utility.GetCurrentGameTime() - LastTentacleTime
    
    If (time > (hour * SD_Beastess_Tentacle_Attack_Wait.Value))
      TentacleAmbush(50.0)
    EndIf 
  EndIf
ENdFunction

Function DoPostAmbush(int numAttackers)

    PlayerRef.RemoveKeyword(SD_NoPregKeyword)
    int m = Utility.RandomInt(0, SP_TentacleLeaveMessages.Length - 1)
    Debug.Notification(SP_TentacleLeaveMessages[m])
    If (Utility.RandomInt() <= SD_Beastess_DarkGift_Chance.GetValueInt())
      PlayerRef.AddItem(SD_Skokushu, 1, false)
      Debug.Notification("You have received a gift from the depths...")
    EndIf
    If !PlayerRef.IsInFaction(SD_TentacleFaction)
      PlayerRef.AddItem(SD_TentaclesWeSeeYou, 1, false)
      Debug.Notification("They know who you are now...")
      PlayerRef.AddToFaction(SD_TentacleFaction)
    Else 
      PlayerRef.SetFactionRank(SD_TentacleFaction, PlayerRef.GetFactionRank(SD_TentacleFaction) + 1)
    EndIf 
    If numAttackers == 1
      SDF.ModifySanity(PlayerRef, -1.0)
    ElseIf numAttackers > 1 && numAttackers <=3
      SDF.ModifySanity(PlayerRef, -3.0)
    Else 
      SDF.ModifySanity(PlayerRef, -5.0)
    EndIf

    PlayerRef.EquipItem(SD_SlimePotion, false, true)
EndFunction

Event AAF:AAF_API.OnSceneEnd(AAF:AAF_API akSender, Var[] akArgs)
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
  string[] metatag = LL_FourPlay.StringSplit(theString = meta, delimiter = ",")
  havingSex = false

  If (metaTag.Find("SD_TentacleAmbush") > -1)
    
    int i = 0
    int aLength = actors.length

    bool triedPreg = false
    while i < aLength
      int t = Utility.RandomInt()

      If i != idx

        If t < SD_Beastess_Tentacle_Preg_Chance.GetValueInt() && SD_Setting_Integrate_FPE.GetValueInt() && !triedPreg
          TryTentaclePreg(actors[i])

          triedPreg = true
        Else 
          RemoveTentacle(actors[i])   
        EndIf
      EndIf
      i = i + 1
    EndWhile
    CheckTentacleMilk(position)
    DoPostAmbush(aLength)
    LastTentacleTime = Utility.GetCurrentGameTime()
  EndIf

    int ic = 0
    While (ic < actors.Length && ic != idx)
    CheckRace(actors[ic])
    ic = ic + 1
    EndWhile

EndEvent

Event OnPlayerTeleport()
  playerTeleport = true 
endEvent

function ResetAnimVars()
  playerTeleport = false
  playerCrafting = false 
  havingSex = false 
  PlayerRef.RemoveKeyword(SD_NoPregKeyword)
EndFunction

Function CheckTentacleMilk(string akPosition)
  if SD_TentacleMilkingPositions.Find(akPosition) > -1 && PlayerRef.HasPerk(Lactation) && SD_Setting_Integrate_WLD.GetValueInt() == 1 && !PlayerRef.HasPerk(BreastMilkSpent)
    int rnd = Utility.RandomInt()
    if (rnd < 10)
      PlayerRef.AddItem(SD_TentacleMilk, 1, false)
      PlayerRef.EquipItem(Spend_Milk, false, true)
    EndIf
  EndIf
EndFunction