;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Terminals:TERM_JBSynthHackInterface_06101E72 Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
Actor akSynth = victimAlias.GetActorRef()
JBSlaveQuest.CreateClone(akSynth)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
Actor akSynth = victimAlias.GetActorRef()
akSynth.KillEssential()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory

ReferenceAlias Property victimAlias Auto Const
