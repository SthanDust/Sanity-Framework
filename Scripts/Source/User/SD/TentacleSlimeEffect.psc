Scriptname SD:TentacleSlimeEffect extends activemagiceffect 

Armor TentacleSlime
GlobalVariable Property SD_Setting_Integrate_Tent auto
Actor Property PlayerRef auto
SD:SanityFrameworkQuestScript SDF

Event OnEffectStart(Actor akTarget, Actor akCaster)
    If (SD_Setting_Integrate_Tent.Value == 1)
        TentacleSlime = Game.GetFormFromFile(0x00000812, "Zaz Particle Effects.esp") as Armor
        Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
        SDF = Main as SD:SanityFrameworkQuestScript
        SDF.DNotify("You are filled with warm, pulsating slime")
         
        PlayerRef.EquipItem(TentacleSlime, false, true)
    EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    PlayerRef.RemoveItem(TentacleSlime, 1, true, PlayerRef.GetContainer())
    SDF.DNotify("The sickening fluid has left you.")
EndEvent