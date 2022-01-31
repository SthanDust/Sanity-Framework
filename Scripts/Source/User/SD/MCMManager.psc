Scriptname SD:MCMManager extends Quest
SD:SanityFrameworkQuestScript SDF
string thisMod = "SD_MainFramework"
Group General 
    Actor Property PlayerRef auto const 
    GlobalVariable Property SD_FVersion auto 
    GlobalVariable Property SD_Framework_Enabled auto
    GlobalVariable Property SD_Framework_Debugging auto
    GlobalVariable Property SD_Setting_Integrate_Vio auto
    GlobalVariable Property SD_Setting_Integrate_FPE auto
    GlobalVariable Property SD_Setting_Integrate_WLD Auto 
    GlobalVariable Property SD_Setting_Integrate_JB auto
    GlobalVariable Property SD_Setting_Integrate_HBW auto
    GlobalVariable Property SD_Internal_MCMLoaded auto 
    GlobalVariable Property SD_Internal_FirstLoad auto
    Message Property SD_FrameworkInit Auto
    Message Property SD_StatisticsMessage auto
    GlobalVariable Property SD_Setting_ThoughtFrequency auto
EndGroup



import MCM
import Actor
import Debug
import Game

Event OnInit()
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    SDF = Main as SD:SanityFrameworkQuestScript
    SD_Internal_MCMLoaded.SetValue(0)
    ;SDF.DNotify("MCM: OnInit")
    if (CheckForMCM(True))
        RegisterForMenuOpenCloseEvent("PauseMenu")
        CheckVersion()
    endif
    CheckIntegrations()
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
	RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
    SD_Internal_MCMLoaded.SetValue(1)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    ;use this to repeat things
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    SDF = Main as SD:SanityFrameworkQuestScript
    CheckIntegrations()
    ;SDF.DNotify("MCM: PlayerLoad")
    if (CheckForMCM())
        RegisterForMenuOpenCloseEvent("PauseMenu")
        CheckVersion()
    endif
EndEvent

Function CheckVersion()
    float current = SD_FVersion.GetValue()
    float newVersion = 1.81
    if  current < newVersion
        SDF.DNotify("Updating...")
        SDF.Stop()
        SDF.Start()
        SDF.DNotify("Update Complete to version ")
        SD_FVersion.SetValue(newVersion)
    EndIf
EndFunction

bool Function CheckForMCM(bool FirstLoad = false)
    ;SDF.DNotify("Checking MCM...")
    If !MCM.IsInstalled()
        If (FirstLoad)
            Utility.Wait(1.0)
            SDF.DNotify("Waiting for MCM to be found")
        else 
            SDF.DNotify("Reinstall the MCM then reset Sanity Framework.")
        EndIf
        Return false
    EndIf
    Return True
EndFunction

Function OnMCMSettingChange(string modName, string id)
  if modName == thisMod
      MCMUpdate()
  endif
EndFunction

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    ; for later use
EndEvent

Function MCMUpdate()
    SD_FVersion.SetValue(MCM.GetModSettingFloat(thisMod, "fVersion"))
    SD_Framework_Debugging.SetValue(MCM.GetModSettingBool(thisMod, "bMCMDebugOn:Debug") as float)
    SD_Framework_Enabled.SetValue(MCM.GetModSettingBool(thisMod, "bMCMModEnabled:Globals") as float)
    SD_Setting_ThoughtFrequency.SetValue(MCM.GetModSettingFloat(thisMod, "fMessageFrequency:Globals"))
    ;SDF.DNotify("MCM: Setting Updated")
EndFunction

function Uninstall()
    SDF.DNotify("Uninstalling Framework.")
    SD_Internal_FirstLoad.SetValue(0.0)
    SD_Internal_MCMLoaded.SetValue(0.0)
    SD_FVersion.SetValue(0.0)
    SDF.DNotify("You may now safely remove this mod from your load order.")
    SDF.Stop()
EndFunction

function ResetMod()
    SDF.DNotify("Resetting the framework... Please wait")
    SD_Internal_FirstLoad.SetValue(0.0)
    SD_Internal_MCMLoaded.SetValue(0.0)
    SD_FVersion.SetValue(0.0)
    SDF.Stop()
    SDF.Start()
    CheckVersion()
    CheckIntegrations()
    SDF.DNotify("Framework has now reset.  Check your MCM for setting changes")
EndFunction

Function CheckIntegrations()
  SD_Setting_Integrate_FPE.SetValue(Game.IsPluginInstalled("FP_FamilyPlanningEnhanced.esp") as float)
  MCM.SetModSettingBool(thisMod, "bEnableFPE", SD_Setting_Integrate_FPE.GetValue() as bool)
  SD_Setting_Integrate_HBW.SetValue(Game.IsPluginInstalled("Beggar_Whore.esp") as float)
  MCM.SetModSettingBool(thisMod, "bEnableHBW", SD_Setting_Integrate_HBW.GetValue() as bool)
  SD_Setting_Integrate_Vio.SetValue(Game.IsPluginInstalled("AAF_Violate.esp") as float)
  MCM.SetModSettingBool(thisMod, "bEnableAFV", SD_Setting_Integrate_Vio.GetValue() as bool)
  SD_Setting_Integrate_WLD.SetValue(Game.IsPluginInstalled("INVB_WastelandDairy.esp") as float)
  MCM.SetModSettingBool(thisMod, "bEnableWLD", SD_Setting_Integrate_WLD.GetValue() as bool)
  SD_Setting_Integrate_JB.SetValue(Game.IsPluginInstalled("Just Business.esp") as float)
  MCM.SetModSettingBool(thisMod, "bEnableJB", SD_Setting_Integrate_FPE as bool)
EndFunction