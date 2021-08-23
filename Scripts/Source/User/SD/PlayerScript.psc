Scriptname SD:PlayerScript extends ReferenceAlias
{This will attach to the player.}

Actor Property PlayerRef auto 
Group Perks 
  Perk Property SD_Perk_Sanity auto
  Perk Property SD_Perk_Insanity auto
  Perk Property SD_Perk_Alignment auto 
  Perk Property SD_Perk_Stress auto
EndGroup


string[] trackedStats auto 


Event OnInit()
    StartTimer(1,1)
EndEvent

Event OnPlayerLoadGame()
    StartTimer(8, 1)
EndEvent

Function RegisterForTrackedStatEvents()

EndFunction




