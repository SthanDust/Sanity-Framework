;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:TopicInfos:TIF_JBSlaveQuest_06105941 Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
JBProstitutesQuest.RemoveFromProstitution()
(akSpeaker as JB:JBSlaveNPCScript).OfferForProstitution()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBProstitutesQuestScript Property JBProstitutesQuest Auto Const Mandatory