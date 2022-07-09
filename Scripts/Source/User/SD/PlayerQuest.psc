Scriptname SD:PlayerQuest extends Quest Conditional
{Quest To manage the Player Object}

ReferenceAlias Property PlayerRef Auto Const
ActorValue Property SD_Sanity Auto Conditional
ActorValue Property SD_Alignment Auto Conditional
ActorValue Property SD_Stress Auto Conditional
ActorValue Property SD_Grief Auto Conditional
ActorValue Property SD_Depression auto Conditional
ActorValue Property SD_Trauma auto Conditional

Event OnQuestInit()
    Debug.Notification("SD: PlayerQuest Started")
EndEvent