Scriptname SD:TentacleSlimeEffect extends activemagiceffect 

Armor TentacleSlime
Actorbase AggressiveTentacleSpawn
Potion Property SD_TentacleDeath auto
GlobalVariable Property SD_Setting_Integrate_Tent auto
GlobalVariable Property SD_Beastess_Tentacle_Spawn auto 
Actor Property PlayerRef auto
SD:SanityFrameworkQuestScript SDF

Event OnEffectStart(Actor akTarget, Actor akCaster)
    
    TentacleSlime = Game.GetFormFromFile(0x00000812, "Zaz Particle Effects.esp") as Armor
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
    
    SDF = Main as SD:SanityFrameworkQuestScript
    ;SDF.DNotify("You are filled with warm, pulsating slime")
    Debug.Notification("You are filled with warm, pulsating slime.  It feels as if it is moving")
    PlayerRef.EquipItem(TentacleSlime, false, true)
    
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    PlayerRef.RemoveItem(TentacleSlime, 1, true, PlayerRef.GetContainer())
    Debug.Notification("The fluid has left you and seeps into the ground beneath you.")
    int t = Utility.RandomInt()
    if t < SD_Beastess_Tentacle_Spawn.GetValueInt()
        AggressiveTentacleSpawn = Game.GetFormFromFile(0x000035C0, "AnimatedTentacles.esp") as ActorBase
        Actor tempt = PlayerRef.PlaceAtMe(AggressiveTentacleSpawn) as Actor
        tempt.EquipItem(SD_TentacleDeath, true, true)
        Debug.Notification("A more aggressive tentacle has emerged from the fluid that leaked out of you.  Run before it gets you!")
    endif
    ;SDF.DNotify("The sickening fluid has left you.")
EndEvent