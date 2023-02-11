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
  GlobalVariable Property SD_Beastess_Alien_Preg    auto
  GlobalVariable Property SD_Setting_Integrate_Tent auto 
  Actor Property PlayerRef auto
  Race Property HumanRace auto
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
  Race Property SD_TentacleRace auto
EndGroup

SD:SanityFrameworkQuestScript SDF
FPFP_Player_Script FPE
FPFP_BasePregData BPD

CustomEvent OnBeastess

Event OnQuestInit()
    StartTimer(1,0)
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    SDF = Main as SD:SanityFrameworkQuestScript
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    StartTimer(2, 0)
EndEvent

Event OnTimer(int aiTimerID)
    if(aiTimerID == 0)
      LoadFPE()
      LoadTentacles()
      RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")

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
  SD_Beastess_Canine_Preg.Value = 0
  SD_Beastess_Human_Preg.Value = 0
  SD_Beastess_Insect_Preg.Value = 0
  SD_Beastess_Mollusk_Preg.Value = 0
  SD_Beastess_Mutant_Preg.Value = 0
  SD_Beastess_Necro_Preg.Value = 0
  SD_Beastess_Reptile_Preg.Value = 0
EndFunction

Function CheckRace(Actor akActor)
  Race akRace = akActor.GetRace()  
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
  
EndFunction

Function LoadFPE()
    if (Game.IsPluginInstalled("FP_FamilyPlanningEnhanced.esp"))
      Pregnancy = Game.GetFormFromFile(0x00000FA8, "FP_FamilyPlanningEnhanced.esp") as Faction 
      FPE = Game.GetFormFromFile(0x00000F99, "FP_FamilyPlanningEnhanced.esp") as FPFP_Player_Script
      BPD = FPE.GetPregnancyInfo(PlayerRef)
      RegisterForCustomEvent(FPE, "FPFP_GetPregnant")
      RegisterForCustomEvent(FPE, "FPFP_GiveBirth")
      BloodyFanny = BPD.SP_BloodyBirth as Spell 
    endif
EndFunction

Function LoadTentacles()
  If (SD_Setting_Integrate_Tent.GetValueInt() == 1)
    SD_TentacleRace = Game.GetFormFromFile(0x00000F9A, "AnimatedTentacles.esp") as Race
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