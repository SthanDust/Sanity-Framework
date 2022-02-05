;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Perks:PRKF_JBAdditionalDialogsPerk_060F764B Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_00
Function Fragment_Entry_00(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor Collocutor = akTargetRef as Actor
JBAdditionalDialogsQuest.StartAdditionalDialogs(Collocutor)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBAdditionalDialogsQuestScript Property JBAdditionalDialogsQuest Auto Const Mandatory
