;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Perks:PRKF_JBRenamePerk_05094A94 Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_00
Function Fragment_Entry_00(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor settler = akTargetRef as Actor
JBSlaveQuest.RenameSlave(settler)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
