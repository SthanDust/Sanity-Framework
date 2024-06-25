Scriptname SD:SanityQuest extends Quest Conditional

Group Locations 
    Keyword[] property SD_Locations auto
EndGroup



import MCM
import Actor
import Debug
import Game
import Utility
import SD:SanityFrameworkQuestScript

ReferenceAlias Property PlayerRef auto 

SD:SanityFrameworkQuestScript SDF


Event OnInit()
    StartTimer(2, 1)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    StartTimer(1, 1)
EndEvent 

Event OnTimer(int aiTimerID)
    If (aiTimerID == 1)
        Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
        SDF = Main as SD:SanityFrameworkQuestScript
        RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    EndIf
EndEvent


String Function ChooseRainSentence()
    String[] RainArray
    RainArray = new String[10]
    RainArray[0] = "Bloody rain, ruining everything..."
    RainArray[1] = "Just my luck to be caught in this downpour..."
    RainArray[2] = "Can't wait to get out of these wet clothes..."
    RainArray[3] = "The rain's so heavy, I can hardly see a thing..."
    RainArray[4] = "I hate being wet and cold..."
    RainArray[5] = "Why does it always rain when I'm out here?"
    RainArray[6] = "This rain's making everything feel so dreary..."
    RainArray[7] = "Wish I had an umbrella or something..."
    RainArray[8] = "Just what I needed, more water to wade through..."
    RainArray[9] = "I can't believe it's still raining, when will it stop?"

    return RainArray[Utility.RandomInt(0, 19)]
EndFunction