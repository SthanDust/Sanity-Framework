Scriptname SD:MCMManager extends Quest

string thisMod = "SD_MainFramework"
string logName = "SanityFramework"

Group General 
    Actor Property PlayerRef auto
    GlobalVariable Property SD_FVersion auto 
    GlobalVariable Property SD_Framework_Enabled auto
    GlobalVariable Property SD_Framework_Debugging auto
    GlobalVariable Property SD_Setting_Integrate_Vio auto
    GlobalVariable Property SD_Setting_Integrate_FPE auto
    GlobalVariable Property SD_Setting_Integrate_WLD Auto 
    GlobalVariable Property SD_Setting_Integrate_JB auto
    GlobalVariable Property SD_Setting_Integrate_HBW auto
    GlobalVariable Property SD_Setting_Integrate_Tent auto
    GlobalVariable Property SD_Setting_Integrate_TSEX auto 
    GlobalVariable Property SD_Internal_MCMLoaded auto 
    GlobalVariable Property SD_Internal_FirstLoad auto
    GlobalVariable Property SD_Setting_ThoughtsEnabled auto
    GlobalVariable Property SD_Setting_ThoughtFrequency auto
    GlobalVariable Property SD_Tolerance auto 
    GlobalVariable Property SD_Decay auto
    ActorValue property SD_Sanity auto 
    ActorValue property SD_Stress auto
    ActorValue property SD_Grief auto 
    ActorValue property SD_Depression auto
    ActorValue property SD_Trauma auto 
    ActorValue property SD_Alignment auto
    Message Property SD_FrameworkInit Auto
    Message Property SD_StatisticsMessage auto
    message Property SD_Updated auto 
EndGroup

import MCM
import Actor
import Debug
import Game
import SD:SanityFrameworkQuestScript

SD:SanityFrameworkQuestScript SDF
SD:BeastessQuest Beast
SD:UtilityQuest UQuest
SD:SplinterManagerScript Splint

Event OnInit()
    StartTimer(1, 1)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    ;use this to repeat things
    StartTimer(2, 1)
EndEvent

Event OnTimer(int aiTimerID)
    if aiTimerID == 1
        Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
        SDF = Main as SD:SanityFrameworkQuestScript
        Quest BST = Game.GetFormFromFile(0x00027F62, "SD_MainFramework.esp") as Quest
        SD_Internal_MCMLoaded.SetValue(0.0)
        Beast = BST as SD:BeastessQuest
        UQuest = Game.GetFormFromFile(0x0000E580, "SD_MainFramework.esp") as SD:UtilityQuest
        Splint = Game.GetFormFromFile(0x0000E518, "SD_MainFramework.esp") as SD:SplinterManagerScript
        if (CheckForMCM())
            RegisterForMenuOpenCloseEvent("PauseMenu")
            CheckVersion()
            CheckIntegrations()
            RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
            RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
            SD_Internal_MCMLoaded.SetValue(1)
        endif
    EndIf 
EndEvent


Function CheckVersion()
    float current = SD_FVersion.GetValue()    
    float newVersion = 2099.0

    if  (current != newVersion)

        ; SDF.Stop()
        ; Utility.Wait(3)
        ; SDF.Start()
        Beast.Stop()
        Utility.Wait(1)
        Beast.Start()
        UQuest.Stop()
        Utility.Wait(1)
        UQuest.Start()
        Splint.Stop()
        Utility.Wait(1)
        Splint.Start()

        SDF.DNotify("MCM: Update Complete to version " + newVersion)
        SD_FVersion.SetValue(newVersion)
        MCM.SetModSettingFloat(thisMod, "fVersion", newVersion)

    EndIf

EndFunction

; one time function that will be removed after this release


bool Function CheckForMCM(bool FirstLoad = false)

    If !MCM.IsInstalled()
        If (FirstLoad)
            Utility.Wait(1.0)
            SDF.DNotify("Waiting for MCM to be found")
        else 
            SDF.DNotify("Reinstall the MCM then reset Sanity Framework.")
        EndIf
        Return false
    EndIf
        SD_Internal_MCMLoaded.SetValue(1.0)
    Return True
EndFunction

Function OnMCMSettingChange(string modName, string id)
  
  
  RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
EndFunction




function Uninstall()
    SDF.DNotify("Uninstalling Framework.")
    SD_Internal_FirstLoad.SetValue(1.0)
    SD_Internal_MCMLoaded.SetValue(0.0)
    SD_FVersion.SetValue(0.0)
    SDF.DNotify("You may now safely remove this mod from your load order.")
    SDF.Stop()
EndFunction

function ResetMod()
    SDF.DNotify("Resetting the framework... Please wait")
    SD_Internal_FirstLoad.SetValue(1.0)
    SD_FVersion.SetValue(0.0)
    
    SDF.Stop()
    SDF.Reset()
    Beast.Stop()
    Beast.Reset()
    SDF.Start()
    Beast.Start()
    
    CheckVersion()
    If CheckForMCM()
        
        CheckIntegrations()
        SDF.DNotify("Framework has now reset.  Check your MCM for setting changes")
    Else
        SDF.DNotify("Error: MCM is not running.")
    EndIF
    
    
EndFunction

Function ResetActorValues()
  ;to be removed
  SDF.DNotify("Resetting Actor Values.")
  PlayerRef.RestoreValue(SD_Sanity,     10000)
  PlayerRef.RestoreValue(SD_Stress,     10000)
  PlayerRef.RestoreValue(SD_Depression, 10000)
  PlayerRef.RestoreValue(SD_Trauma,     10000)
  PlayerRef.RestoreValue(SD_Grief,      10000)
  PlayerRef.RestoreValue(SD_Alignment,  10000)
  PlayerRef.DamageValue(SD_Depression,     10)
  PlayerRef.DamageValue(SD_Grief,          10)
  PlayerRef.DamageValue(SD_Trauma,          5)
  PlayerRef.DamageValue(SD_Sanity,          5)
EndFunction

Function CheckIntegrations()
    If (Game.IsPluginInstalled("FP_FamilyPlanningEnhanced.esp"))
        SD_Setting_Integrate_FPE.SetValue(1.0)
    Else
        SD_Setting_Integrate_FPE.SetValue(0.0)
    EndIf
    If (Game.IsPluginInstalled("Beggar_Whore.esp"))
        SD_Setting_Integrate_HBW.SetValue(1.0)
    Else
        SD_Setting_Integrate_HBW.SetValue(0.0)
    EndIf
    If (Game.IsPluginInstalled("AAF_Violate.esp"))
        SD_Setting_Integrate_Vio.SetValue(1.0)
    Else
        SD_Setting_Integrate_Vio.SetValue(0.0)
    EndIf

    If (Game.IsPluginInstalled("INVB_WastelandDairy.esp"))
        SD_Setting_Integrate_WLD.SetValue(1.0)
        
    Else
        SD_Setting_Integrate_WLD.SetValue(0.0)
        
    EndIf

    If (Game.IsPluginInstalled("Just Business.esp"))
        SD_Setting_Integrate_JB.SetValue(1.0)
        
    Else
        SD_Setting_Integrate_JB.SetValue(0.0)
        
    EndIf  

    If (Game.IsPluginInstalled("AnimatedTentacles.esp"))
        SD_Setting_Integrate_Tent.SetValue(1.0)
    Else
        SD_Setting_Integrate_Tent.SetValue(0.0)
    EndIf

    If (Game.IsPluginInstalled("TSEX.esm"))
        SD_Setting_Integrate_Tsex.SetValue(1.0)
    Else
        SD_Setting_Integrate_Tsex.SetValue(0.0)
    EndIf
EndFunction


Function DumpStats()
    SDF.DNotify("Statistics *************************")
    SDF.DNotify("Sanity: " + SDF.GetSanity(PlayerRef))
    SDF.DNotify("Trauma: " + SDF.GetTrauma(PlayerRef))
    SDF.DNotify("Depression: " + SDF.GetDepression(PlayerRef))
    SDF.DNotify("Grief: " + SDF.GetGrief(PlayerRef))
    SDF.DNotify("Alignment: " + SDF.GetAlignment(PlayerRef))
    SDF.DNotify("Stress: " + SDF.GetStress(PlayerRef))
    SDF.DNotify("Decay: " + SD_Decay.GetValue())
    SDF.DNotify("Tolerance: " + SD_Tolerance.GetValue())
    SDF.DNotify("EndStatistics ***********************")   
EndFunction