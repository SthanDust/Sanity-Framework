Scriptname SD:BeastessQuest extends Quest

import MCM
import Actor
import Debug
import Game
import BodyGen


Group Global_Vars
  GlobalVariable Property SD_Beastess_Canine        auto
  GlobalVariable Property SD_Beastess_Reptile       auto
  GlobalVariable Property SD_Beastess_Human         auto
  GlobalVariable Property SD_Beastess_Necro         auto
  GlobalVariable Property SD_Beastess_Insect        auto
  GlobalVariable Property SD_Beastess_Mollusk       auto 
  GlobalVariable Property SD_Beastess_Mutant        auto
  GlobalVariable Property SD_Beastess_Alien         auto
  GlobalVariable Property SD_Beastess_Tentacle      auto
  GlobalVariable Property SD_Beastess_Canine_Preg   auto
  GlobalVariable Property SD_Beastess_Reptile_Preg  auto
  GlobalVariable Property SD_Beastess_Human_Preg    auto
  GlobalVariable Property SD_Beastess_Necro_Preg    auto
  GlobalVariable Property SD_Beastess_Insect_Preg   auto
  GlobalVariable Property SD_Beastess_Mollusk_Preg  auto 
  GlobalVariable Property SD_Beastess_Mutant_Preg   auto
  GlobalVariable Property SD_Beastess_Alien_Preg           auto
  GlobalVariable Property SD_Beastess_Tentacle_Preg        auto
  GlobalVariable Property SD_Setting_Integrate_Tent        auto 
  GlobalVariable Property SD_Setting_Integrate_FPE         auto
  GlobalVariable Property SD_Setting_Integrate_WLD         auto
  GlobalVariable Property SD_Beastess_DarkGift_Chance      auto 
  GlobalVariable Property SD_Beastess_Tentacle_Preg_Chance auto
  Actor Property PlayerRef auto
  Race Property HumanRace auto
  Potion Property SD_SplinterPotionGabryal auto 
  Potion Property SD_Skokushu auto 
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


Armor TentacleSlime
ActorBase PassiveBrainTentacle
ActorBase PassivePlantTentacle
ActorBase PassiveMechTentacle
ActorBase PassiveTentacle
Sound TentacleSound
Keyword SD_Tentacle
Keyword SD_NoPregKeyword
Float LastTentacleTime 

Keyword property LocSetWaterfront auto

Spell Property SP_TentacleSlime auto 
int tickTimerID = 1
int dayTimerID = 2



Event OnQuestInit()
    StartTimer(1,0)
 
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    StartTimer(2, 0)
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
  If (akSender == PlayerRef && akNewLoc.HasKeyword(LocSetWaterfront))
    
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
      StartTimerGameTime(1, tickTimerID)
      StartTimerGameTime(24, dayTimerID)
      RegisterForCustomEvent(AAF_API, "OnAnimationStop")
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
  EndIF
EndEvent

Function OnTick()
  SDF.DNotify("The Time is " + GetCurrentHourOfDay())
  StartTimerGameTime(1, tickTimerID)
  ObjectReference[] t = PlayerRef.FindAllReferencesOfType(PlayerRef.GetBaseObject(), 500.0)
  if t.length <= 1
    SDF.DNotify("Actor is not alone. " + t.Length)
  EndIf
EndFunction

Function OnDay()
  StartTimerGameTime(24, dayTimerID)
EndFunction

float Function GetCurrentHourOfDay() 
 
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time) ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return Time
 
EndFunction

Function CheckRace(Actor akActor)
  Race akRace = akActor.GetRace()
  If akActor.HasKeyword(SD_Tentacle)
    akRace = SD_TentacleRace
  EndIf
  SDF.DNotify("Beastess Increase: " + akRace.GetName())
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
    If akActor.HasKeyword(SD_Tentacle) 
      akActor.SetRace(SD_TentacleRace)
    EndIF
    SDF.DNotify("Beastess Impregnation: " + akRace.GetName())
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
      
      RegisterForCustomEvent(FPE, "FPFP_GetPregnant")
      RegisterForCustomEvent(FPE, "FPFP_GiveBirth")
      BloodyFanny = BPD.SP_BloodyBirth as Spell 
    endif
EndFunction

Function LoadWLD()
  if (Game.IsPluginInstalled("INVB_WastelandOffspring.esp"))
    SD_Setting_Integrate_WLD.SetValueInt(1)

  EndIf
EndFunction

Function LoadZazEffects()
  If (Game.IsPluginInstalled("Zaz Particle Effects.esp"))
    TentacleSlime = Game.GetFormFromFile(0x00000812, "Zaz Particle Effects.esp") as Armor
  EndIf
EndFunction

Function LoadTentacles()
  If (Game.IsPluginInstalled("AnimatedTentacles.esp") == 1)
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
    SD_Tentacle = Game.GetFormFromFile(0x00001ED6, "AnimatedTentacles.esp") as Keyword
    LoadZazEffects()
  Else
    SD_Setting_Integrate_Tent.SetValue(0)
  EndIf
EndFunction

bool Function IsPregnant()
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
  akBirth = akArgs[2] as bool
  if (akMother == PlayerRef)
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
      beastString += "Tentacle:  Sex - " + SD_Beastess_Tentacle.GetValueInt() + " \n"
      beastString += "Necro:   Sex - " + SD_Beastess_Necro.GetValueInt() + "   Pregnancy - " + SD_Beastess_Necro_Preg.GetValueInt() + "  </font>"
    Debug.MessageBox(beastString)
EndFunction

Function ShowBlood()
    BloodyFanny.Cast(PlayerRef, PlayerRef)
EndFunction

Function ShowPregnancy()
    If IsPregnant()
        string Preggers = "<font face='$ConsoleFont' size='15'>Pregnancy \n \n"
        Preggers += "Father is a " + CurrentFatherRace.GetName() + " \n"

        Preggers += "There are " + NumChildren + " child(ren) \n "
        Debug.MessageBox(Preggers)
    Else
        Debug.MessageBox("<font face='$ConsoleFont' size='15'>Players is not pregnant</font>")
    EndIf
EndFunction

Function ShowBodyGen()
  string[] pMorphs = BodyGen.GetMorphs(PlayerRef, PlayerRef.GetActorBase().GetSex())
  int index = 0
  While (index < pMorphs.Length)
    string item = pMorphs[index]
    string mykey
    Keyword[] keys = BodyGen.GetKeywords(PlayerRef, PlayerRef.GetActorBase().GetSex(), item)
    int keydex = 0
    while (keydex < keys.Length)
      Keyword temp = keys[keydex]
      mykey += "* " + temp.GetName() + " = " + BodyGen.GetMorph(PlayerRef, PlayerRef.GetActorBase().GetSex(), item, temp) + "* "
      keydex += 1
    EndWhile
    SDF.DNotify("Morph: " + item + " Keywords: " + mykey)
    index += 1
  EndWhile
  
EndFunction

Function RemoveTentacle(Actor akActor)
  akActor.Disable(true)
  akActor.Delete()
EndFunction

Function TentacleAmbush(float Distance = 233.0)
  
  
  float maxDistance = Distance
  
  int numTentacles = Utility.RandomInt(1,5)
  int i = 0
  while i < numTentacles
    SpawnTentacle(maxDistance)
    i = i + 1
  EndWhile
  
  Actor[] akActors = PlayerRef.FindAllReferencesWithKeyword(SD_Tentacle, maxDistance) as Actor[]
  ; here we are interrupting the normal pregnancy
  PlayerRef.AddKeyword(SD_NoPregKeyword)
  AAF:AAF_API:SceneSettings sexScene = AAF_API.GetSceneSettings()
  sexScene.meta = "SD_TentacleAmbush"
  sexScene.skipWalk = true 
  sexScene.duration = 34
  SDF.PlaySexAnimation(akActors, sexScene)
  Debug.MessageBox("<font face='$HandwrittenFont' size='20'>Slithering tentacles arise from the ground and grapple at you...</font> \n \n")  
EndFunction

Function TryTentaclePreg(Actor akActor)
  
  float temp = Utility.RandomFloat()

  If !IsPregnant() && (temp <= SD_Beastess_Tentacle_Preg_Chance.Value)
    Game.FadeOutGame(true, true, 0, 2, true)
    PlayerRef.RemoveKeyword(SD_NoPregKeyword)
    ImpregnateRace(akActor)
    akActor.SetPosition(Game.GetPlayer().GetPositionX(),Game.GetPlayer().GetPositionY(), 500.0)
    Race tempRace = GetRandomRace()
    akActor.SetRace(tempRace)
    akActor.EquipItem(SD_SplinterPotionGabryal, false, true)    
    BPD.TrySpermFrom(akActor)
    RemoveTentacle(akActor)
    Game.FadeOutGame(false, true, 0, 2, false)
  EndIf
 
EndFunction

Race Function GetRandomRace()
  
  
  int ran = Utility.RandomInt(0, 100)
  SDF.DNotify("Ran: " + ran)
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
  ElseIf (ran > 74 && ran <= 86)
    int t = Utility.RandomInt(0, SD_MutantRaces.Length -1)
    return SD_MutantRaces[t]
  ElseIf (ran > 86)
    int t = Utility.RandomInt(0, SD_HumanRaces.Length -1)
    return SD_HumanRaces[t]
  EndIF
EndFunction

Function SpawnTentacle(float maxDistance)
  
  int rnd = Utility.RandomInt(0, 3)
  ActorBase akTentacle = SD_Tentacles[rnd] 
  float fAngle
  float fSin
  float fCos
  float fHeight
  float dist = Utility.RandomFloat(100.0, maxDistance)
  float newAngle = Utility.RandomFloat(160.0, 200.0)
  fAngle = Game.GetPlayer().GetAngleZ() + newAngle
  fSin = Math.sin(fAngle)
  fCos = Math.cos(fAngle)
  fHeight = Game.GetPlayer().GetPositionZ() 
  Actor newTent = PlayerRef.PlaceAtMe(akTentacle, 1) as Actor
  float[] pos = newTent.GetSafePosition(dist, dist)
 
  newTent.AddKeyword(SD_Tentacle)
  newTent.SetPosition(Game.GetPlayer().GetPositionX() + (dist * fSin),Game.GetPlayer().GetPositionY() + (dist * fCos), pos[2])
  TentacleSound.Play(newTent)
  
EndFunction


Function DoTentacleAmbush()
  TentacleAmbush(200.0)
ENdFunction

Event AAF:AAF_API.OnAnimationStop(AAF:AAF_API akSender, Var[] akArgs)
  
  Actor[] actors = Utility.VarToVarArray(akArgs[1]) as Actor[]
	Int idx = actors.Find(PlayerRef)
	Actor partnerActor
  int status = akArgs[0] as int
  if idx <= -1 || status != 0
    return
  endif

  if status > 0
    SDF.DNotify("Status Error: " + akArgs[1])
  EndIf
  
  String[] Tags = Utility.VarToVarArray(akArgs[3]) as String[] 
  String position = akArgs[2] as String
  string meta = akArgs[4] as string
   string[] metatag = LL_FourPlay.StringSplit(theString = meta, delimiter = ",")
   actors.Remove(idx)
  
  If (metaTag.Find("SD_TentacleAmbush") > -1)
    SDF.DNotify("Found Tag")
    int i = 0
    int aLength = actors.length
    
    while i < aLength
        
      CheckRace(actors[i])
      if actors[i].HasKeyword(SD_Tentacle)
        If !IsPregnant()
          TryTentaclePreg(actors[i])
        Else 
          RemoveTentacle(actors[i])
        EndIf
        
      EndIf
      i = i + 1
    EndWhile
    If (Utility.RandomInt() <= SD_Beastess_DarkGift_Chance.GetValueInt())
      PlayerRef.AddItem(SD_Skokushu, 1, false)
      Debug.MessageBox("<font face='$HandwrittenFont' size='20'>You have received a gift from the depths...</font> \n \n")
    EndIf
    LastTentacleTime = Utility.GetCurrentGameTime()
  EndIf
EndEvent

