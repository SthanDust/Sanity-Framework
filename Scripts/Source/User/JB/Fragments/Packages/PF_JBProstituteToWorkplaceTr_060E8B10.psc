;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Packages:PF_JBProstituteToWorkplaceTr_060E8B10 Extends Package Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(Actor akActor)
;BEGIN CODE
JBSexEvents.ProstituteCustomerSex(JBSexEvents.clientForProstitute, JBSexEvents.SlaveProstitute)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory
