Scriptname SD:PlayerScript extends ReferenceAlias
{This will attach to the player.}

Actor Property PlayerRef auto 


Event OnInit()
    StartTimer(1,1)
EndEvent

Event OnPlayerLoadGame()
    StartTimer(8, 1)
EndEvent






