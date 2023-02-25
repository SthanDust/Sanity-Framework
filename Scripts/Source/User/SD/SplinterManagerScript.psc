Scriptname SD:SplinterManagerScript extends Quest

Group Perks
    Perk Property SD_SplinterAlex auto 
    Perk Property SD_SplinterSthan auto
    Perk Property SD_SplinterBeast auto 
    Perk Property SD_SplinterOne auto 
    Perk Property SD_SplinterOlivia auto 
    Perk Property SD_SplinterJack auto 
    Perk Property SD_SplinterYou auto 
    Perk Property SD_SplinterGabryal auto 
EndGroup

Group Player_Variables
    Actor property PlayerRef auto 
    
EndGroup

SD:SanityFrameworkQuestScript SDF 

Event OnInit()
    StartTimer(1,0)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    StartTimer(2, 0)
EndEvent

Event OnTimer(int aiTimerID)
    If aiTimerID == 0
      Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
      SDF = Main as SD:SanityFrameworkQuestScript
      RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    EndIf
EndEvent
