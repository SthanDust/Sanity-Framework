;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Terminals:TERM_JBSCSStartTerminal_060AB3E2 Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
JBSCSQuestScript.setupSlaveList(1, 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
JBSCSQuestScript.setupSlaveList(1, 2)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
JBSCSQuestScript.CallConvoy()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JB:JBSCSQuestScript Property JBSCSQuestScript Auto Const Mandatory
