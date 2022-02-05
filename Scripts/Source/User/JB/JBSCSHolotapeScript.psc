Scriptname JB:JBSCSHolotapeScript extends ObjectReference


JB:JBSCSQuestScript Property JBSCSQuestScript Auto Const Mandatory

ReferenceAlias Property JBSCSTerminal Auto Const

Quest Property JBSCSQuest Auto Const


Event OnHolotapePlay(ObjectReference akTerminalRef)
	;baseTerminal = akTerminalRef
	If akTerminalRef != None
		;Debug.Notification("akTerminalRef != None")
		JBSCSQuest.Start()
		;Utility.Wait(0.1)
		JBSCSTerminal.ForceRefTo(akTerminalRef)
		JBSCSQuestScript.Setup()
	Else
		;Debug.Notification("akTerminalRef == None")
	EndIf
EndEvent
