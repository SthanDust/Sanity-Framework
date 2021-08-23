;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:TopicInfos:TIF_JBSlaveQuest_060A9249 Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE JB:JBSlaveQuestScript
JB:JBSlaveQuestScript kmyQuest = GetOwningQuest() as JB:JBSlaveQuestScript
;END AUTOCAST
;BEGIN CODE
JBSexEvents.AddSlaveToTwoSlaveSexAction(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory
