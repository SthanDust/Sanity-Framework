;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:TopicInfos:TIF_JBConvoyQuest_041294C8 Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE jb:jbconvoyquestscript
jb:jbconvoyquestscript kmyQuest = GetOwningQuest() as jb:jbconvoyquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.DepartureConvoy()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
