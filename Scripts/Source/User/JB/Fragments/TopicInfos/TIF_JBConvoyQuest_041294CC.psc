;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:TopicInfos:TIF_JBConvoyQuest_041294CC Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE jb:jbconvoyquestscript
jb:jbconvoyquestscript kmyQuest = GetOwningQuest() as jb:jbconvoyquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.ChangeConvoyStatus(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
