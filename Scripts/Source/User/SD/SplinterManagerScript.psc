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
    Perk[] property SD_Splinters auto 
EndGroup

Group Player_Variables
    Actor property PlayerRef auto 
    Faction Property SD_OneFaction auto 
    Faction Property SD_BeastFaction auto
    Faction Property SD_SthanFaction auto
    Faction Property SD_GabryalFaction auto 
    Faction Property SD_YouFaction auto 
    Faction Property SD_OliviaFaction auto 
    Faction Property SD_AlexFaction auto
    Faction Property SD_JackFaction auto
    Faction[] Property SD_PlayerFactions auto 
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
      CheckFactions()
    EndIf
EndEvent

Function CheckSplinters(Perk akPerk)
EndFunction

Function CheckFactions()
    SDF.DNotify("Checking Factions")
    int index = 0
    While (index < SD_PlayerFactions.Length)
        Faction item = SD_PlayerFactions[index]
        If !PlayerRef.IsInFaction(item)
            PlayerRef.AddToFaction(item)
        EndIf
        index += 1
    EndWhile
EndFunction
