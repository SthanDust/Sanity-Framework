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
    GlobalVariable Property SD_Setting_Override_Vio auto
    GlobalVariable Property SD_Setting_Override_FPE auto
    GlobalVariable Property SD_Setting_Override_WLD Auto 
    GlobalVariable Property SD_Setting_Override_JB auto
    GlobalVariable Property SD_Setting_Override_HBW auto
    GlobalVariable Property SD_Internal_MCMLoaded auto 
    GlobalVariable Property SD_Internal_FirstLoad auto
    GlobalVariable Property SD_Setting_ThoughtsEnabled auto
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
    float current = SD_FVersion.GetValue() as float
    
    float newVersion = 196
    
   
    if  (current != newVersion)

        SDF.Stop()
        Utility.Wait(3)
        SDF.Start()
        DNotify(logName, "MCM: Update Complete to version " + newVersion)
        SD_FVersion.SetValue(newVersion)
        MCM.SetModSettingFloat(thisMod, "fVersion", newVersion)

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
  RegisterForExternalEvent("OnMCMSettingChange|"+thisMod, "OnMCMSettingChange")
EndFunction

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    ; for later use
EndEvent

Function MCMUpdate()
    SD_Framework_Debugging.SetValue(MCM.GetModSettingBool(thisMod, "bMCMDebugOn:Debug") as float)
    SD_Framework_Enabled.SetValue(MCM.GetModSettingBool(thisMod, "bMCMModEnabled:Globals") as float)
    SD_Setting_ThoughtFrequency.SetValue(MCM.GetModSettingFloat(thisMod, "fMessageFrequency:Globals"))
    SD_Setting_ThoughtsEnabled.SetValue(MCM.GetModSettingFloat(thisMod, "bMCMThoughtsEnabled:Globals"))
    SD_Setting_Override_Vio.SetValue(MCM.GetModSettingBool(thisMod, "bEnableAFV:Override") as float)
    SD_Setting_Override_FPE.SetValue(MCM.GetModSettingBool(thisMod, "bEnableFPE:Override") as float)
    SD_Setting_Override_WLD.SetValue(MCM.GetModSettingBool(thisMod, "bEnableWLD:Override") as float)
    SD_Setting_Override_JB.SetValue(MCM.GetModSettingBool(thisMod, "bEnableJB:Override") as float)
    SD_Setting_Override_HBW.SetValue(MCM.GetModSettingBool(thisMod, "bEnableHBW:Override") as float)
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
    CheckVersion()
    If CheckForMCM()
        MCMUpdate()
        CheckIntegrations()
        DNotify(logName,"Framework has now reset.  Check your MCM for setting changes")
    Else
        DNotify(logName,"Error: MCM is not running.")
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
    Debug.Notification("[SF] " + text)
  EndIf
    Debug.Trace("[SF] " + text, 0) ; just to get started
    Debug.TraceUser(lname, "[SF] " + text)
EndFunction

Function DumpStats()
    DNotify(logName, "Statistics *************************")
    DNotify(logName, "Sanity: " + SDF.GetSanity(PlayerRef))
    DNotify(logName, "Trauma: " + SDF.GetTrauma(PlayerRef))
    DNotify(logName, "Depression: " + SDF.GetDepression(PlayerRef))
    DNotify(logName, "Grief: " + SDF.GetGrief(PlayerRef))
    DNotify(logName, "Alignment: " + SDF.GetAlignment(PlayerRef))
    DNotify(logName, "Stress: " + SDF.GetStress(PlayerRef))
    DNotify(logName, "Decay: " + SD_Decay.GetValue())
    DNotify(logName, "Tolerance: " + SD_Tolerance.GetValue())
    DNotify(logName, "EndStatistics ***********************")
    
EndFunction