;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:TopicInfos:TIF_JBHuntingQuest_060A4F11 Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
JBSexEvents.PlayerSlaveRape(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory