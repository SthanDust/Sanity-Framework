;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Packages:PF_JBConvoyMoveToDestination_0411E43A Extends Package Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(Actor akActor)
;BEGIN CODE
If (akActor as JB:JBSlaveNPCScript).bIsConvoyHead
	JBConvoyQuest.ConvoyArrived()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBConvoyQuestScript Property JBConvoyQuest Auto Const Mandatory
