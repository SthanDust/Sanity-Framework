Scriptname SD:MCMManager extends Quest


SD:SanityFrameworkQuestScript SDF
string thisMod = "SD_MainFramework"
string logName = "SanityFramework"
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
    ActorValue property SD_Sanity auto 
    ActorValue property SD_Stress auto
    Message Property SD_FrameworkInit Auto
    Message Property SD_StatisticsMessage auto
    message Property SD_Updated auto 
    GlobalVariable Property SD_Setting_ThoughtFrequency auto
EndGroup

import MCM
import Actor
import Debug
import Game



Event OnInit()
    OpenLog()
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    SDF = Main as SD:SanityFrameworkQuestScript
    SD_Internal_MCMLoaded.SetValue(0)
    DNotify(logName, "MCM: OnInit")
    if (CheckForMCM(True))
        RegisterForMenuOpenCloseEvent("PauseMenu")
        CheckVersion()
        CheckIntegrations()
        SD_Internal_MCMLoaded.SetValue(1)
    endif
   
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
	RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
    
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    OpenLog()
    ;use this to repeat things
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    SDF = Main as SD:SanityFrameworkQuestScript
    SDF.DNotify("MCM: PlayerLoad")
    if (CheckForMCM())
        RegisterForMenuOpenCloseEvent("PauseMenu")
        CheckVersion()
        CheckIntegrations()
        RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
        RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
        SD_Internal_MCMLoaded.SetValue(1)
    endif
EndEvent

Function OpenLog()
  ;Debug.Notification("Opening Debug Log...")
  Debug.OpenUserLog(logName)
EndFunction

Function CheckVersion()
    float current = SD_FVersion.GetValue()
    DNotify(logName, "MCM: Checking Version: " + current)
    float newVersion = 1.23
    

    if  current < newVersion
        DNotify(logName, "MCM: New Version Detected: " + newVersion)
        DNotify(logName, "MCM: Updating...")
        SDF.Stop()
        SDF.Start()
        DNotify(logName, "MCM: Update Complete to version " + newVersion)
        SD_FVersion.SetValue(newVersion)
        MCM.SetModSettingFloat(thisMod, "fVersion", newVersion)
            ;will be removed
        if (current < 1.22) 
            PlayerRef.RestoreValue(SD_Sanity, 100.0)
            PlayerRef.RestoreValue(SD_Stress, 100.0)
            float sanity = PlayerRef.GetValue(SD_Sanity)
            float stress = PlayerRef.GetValue(SD_Stress)
            if sanity < 100.0
                DNotify(logName, "Mod Sanity")
                PlayerRef.ModValue(SD_Sanity, 100.0 - sanity)
            EndIf
            if stress > 0.0
                DNotify(logName, "Mod Stress") 
                PlayerRef.ModValue(SD_Stress, stress * -1)
            EndIF
        EndIf
        SD_Updated.Show()
    Else
        DNotify(logName, "MCM: Update not Needed for v" + current)
    EndIf



EndFunction

; one time function that will be removed after this release


bool Function CheckForMCM(bool FirstLoad = false)
    ;SDF.DNotify("Checking MCM...")
    If !MCM.IsInstalled()
        If (FirstLoad)
            Utility.Wait(1.0)
            DNotify(logName, "Waiting for MCM to be found")
        else 
            DNotify(logName, "Reinstall the MCM then reset Sanity Framework.")
        EndIf
        Return false
    EndIf
    SD_Internal_MCMLoaded.SetValue(1)
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
    SD_Framework_Debugging.SetValue(MCM.GetModSettingBool(thisMod, "bMCMDebugOn:Debug") as float)
    SD_Framework_Enabled.SetValue(MCM.GetModSettingBool(thisMod, "bMCMModEnabled:Globals") as float)
    SD_Setting_ThoughtFrequency.SetValue(MCM.GetModSettingFloat(thisMod, "fMessageFrequency:Globals"))
EndFunction

function Uninstall()
    DNotify(logName,"Uninstalling Framework.")
    SD_Internal_FirstLoad.SetValue(1.0)
    SD_Internal_MCMLoaded.SetValue(0.0)
    SD_FVersion.SetValue(0.0)
    DNotify(logName,"You may now safely remove this mod from your load order.")
    SDF.Stop()
EndFunction

function ResetMod()
    DNotify(logName,"Resetting the framework... Please wait")
    SD_Internal_FirstLoad.SetValue(1.0)
    SD_FVersion.SetValue(0.0)
    
    SDF.Stop()
    SDF.Start()
    If CheckForMCM()
        MCMUpdate()
        CheckIntegrations()
        DNotify(logName,"Framework has now reset.  Check your MCM for setting changes")
    Else
        DNotify(logName,"Error: MCM is not running.")
    EndIF
    
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

Function DNotify(string lname, string text)
  If SD_Framework_Debugging.GetValue() == 1
    Debug.Notification("[SDF] " + text)
  EndIf
    Debug.Trace("[SDF] " + text, 0) ; just to get started
    Debug.TraceUser(lname, "[SDF] " + text)
EndFunction