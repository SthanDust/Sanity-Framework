Scriptname SD:UtilityQuest extends Quest


import MCM
import Actor
import Debug
import BodyGen

Group Sex_Attributes
    GlobalVariable property SD_FPA_WearOral auto
    GlobalVariable property SD_FPA_WearVagi auto
    GlobalVariable property SD_FPA_WearAnal auto
    GlobalVariable property SD_FPA_WearBottom auto
    GlobalVariable property SD_FPA_BellyMorphPower auto
    GlobalVariable property SD_FPA_Willpower auto
    GlobalVariable property SD_FPA_SelfEsteem auto
    GlobalVariable property SD_FPA_Spirit auto
    GlobalVariable property SD_FPA_Orientation auto
    GlobalVariable property SD_FPA_SexAddiction auto
    GlobalVariable property SD_FPA_SexReputation auto
    GlobalVariable property SD_FPA_Trauma auto
    GlobalVariable property SD_FPA_Intox auto
    GlobalVariable property SD_FPA_Arousal auto
    GlobalVariable property SD_FPA_DrugLevel auto
    GlobalVariable property SD_FPA_IsPlayerAddictedToSex auto
    GlobalVariable property SD_Integrate_FPA auto
    Actor Property PlayerRef auto
EndGroup

Group ImageSpace_Modifiers
    ImageSpaceModifier Property SD_MigraineScreenEffect auto
    ImageSpaceModifier Property SD_BlurScreenEffect auto
EndGroup

Group Meds 
    Potion Property SD_SmileXMed auto 
    Potion Property SD_MedX auto
    LeveledItem Property LL_Chems_Any auto
EndGroup

AAF:AAF_API AAF_API
SD:SanityFrameworkQuestScript SDF

bool ChemsAdded = false
Event OnQuestInit()
    StartTimer(2, 1)
    AddChems()
EndEvent

Function PlaceBehindActor(Actor akActor, Actor akActorToPlace)
float fAngle
float fSin
float fCos
float fHeight

SDF.DNotify("Moving " + akActor.GetName())
fAngle = akActor.GetAngleZ() + 180.0
fSin = Math.sin(fAngle)
fCos = Math.cos(fAngle)
fHeight = akActor.GetPositionZ() 
 
akActorToPlace.MoveTo(akActor, 70.0 * fSin, 70.0 * fCos, fHeight, False)
akActor.Enable(true)
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
    StartTimer(2, 1)
EndEvent

Event OnTimer(int aiTimerID)
    If (aiTimerID == 1)
        LoadSA()
        AddChems()
        Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
        SDF = Main as SD:SanityFrameworkQuestScript
    EndIf
EndEvent


Function LoadSA()
    If Game.IsPluginInstalled("FPAttributes.esp")     
        SD_FPA_Willpower.Value = (Game.GetFormFromFile(0x00000FAB, "FPAttributes.esp") as GlobalVariable).GetValueInt()
        SD_FPA_SelfEsteem.Value = (Game.GetFormFromFile(0x00000FAC, "FPAttributes.esp") as GlobalVariable).GetValueInt()
        SD_FPA_Spirit.Value = (Game.GetFormFromFile(0x00007A67, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_Trauma.Value = (Game.GetFormFromFile(0x0001E80B, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_Intox.Value = (Game.GetFormFromFile(0x0001E80C, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_Arousal.Value = (Game.GetFormFromFile(0x0001E80D, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_DrugLevel.Value = (Game.GetFormFromFile(0x0001E80E, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_IsPlayerAddictedToSex.Value = (Game.GetFormFromFile(0x0001FEFE, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_WearAnal.Value = (Game.GetFormFromFile(0x00011A41, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_WearVagi.Value = (Game.GetFormFromFile(0x00011A40, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_FPA_WearOral.Value = (Game.GetFormFromFile(0x00000FAA, "FPAttributes.esp") as GlobalVariable).getValueInt()
        SD_Integrate_FPA.Value = 1
    EndIf
EndFunction

Function MigraineEffect()
    SDF.DNotify("Applying Migraine Effect")
    SD_MigraineScreenEffect.Apply(1.0)
    Utility.Wait(5)
    SD_MigraineScreenEffect.Remove()
EndFunction

Function BlurEffect()
    SDF.DNotify("Applying Blur Effect")
    SD_BlurScreenEffect.Apply(1.0)
    Utility.Wait(5)
    SD_BlurScreenEffect.Remove()
EndFunction

Function AddChems()
    If !ChemsAdded
        LL_Chems_Any.AddForm(SD_SmileXMed, 1, 2)
        LL_Chems_Any.AddForm(SD_MedX, 1, 1)
        ChemsAdded = true
    EndIf
EndFunction 

