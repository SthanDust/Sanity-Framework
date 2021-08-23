Scriptname JB:JBSlaveCollectionScript extends RefCollectionAlias


workshopparentscript Property WorkshopParent Auto Const Mandatory
jb:jbslavequestscript Property JBSlaveQuest Auto Const Mandatory

ReferenceAlias Property aliasSlaveSpeaker Auto Const
Scene Property JBSlaveScene01 Auto Const

Armor Property Collar Auto Const


Event OnActivate(ObjectReference akSenderRef, ObjectReference akActionRef)
	;Actor Slave = akSenderRef as Actor
	;ActorBase akBase = JBSlaveQuest.GetSlaveBase(Slave)
	;LL_FourPlay.PrintConsole("ActorBase = "+akBase)
	;;debug.trace(self + "OnActivate " + akActionRef)
	;Debug.Notification("Activate actor")
	; If akActionRef == Game.GetPlayer()
	; 	Actor Slave = akSenderRef as Actor
	; 	aliasSlaveSpeaker.ForceRefTo(Slave)
	; 	JBSlaveScene01.Start()
	; EndIf
	; if WorkshopParent.GetWorkshop(JBSlaveQuest.GetWorkshopID(Slave)).OwnedByPlayer
	; 	;;debug.trace(self + " Owned by player")
	; 	if Slave.IsDoingFavor(); && akActionRef == self && bCommandable ; must be commandable so this doesn't trigger for companions
	; 		;debug.trace(self + " OnActivate - workshop commandable")
	; 		;iSelfActivationCount += 1
	; 		;if iSelfActivationCount > 1
	; 			; toggle favor state
	; 			Slave.setDoingFavor(false, true)
	; 		;endif
	; 	endif
	; endif
EndEvent

Event OnCommandModeGiveCommand(ObjectReference akSenderRef, int aeCommand, ObjectReference akTarget)
	
	Actor Slave = akSenderRef as Actor
	WorkshopObjectScript workObject = akTarget as WorkshopObjectScript
	;WorkshopScript workshopRef = WorkshopParent.GetWorkshop(JBSlaveQuest.GetWorkshopID(Slave))


	; if workObject && aeCommand == 10 ; workshop assign command
	; 	;Debug.Notification("Slave - OnCommandModeGiveCommand - Assign command - 10")
	; 	If workObject.GetMultiResourceValue() == WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingSafety].resourceValue && Slave.GetValue(JBSlaveQuest.JBIsSubmissive) < 80
	; 		JBSlaveQuest.JBNeedsSubmissive80MSG.Show()
	; 		;Debug.Notification("Needs Submissive > 80")
	; 	ElseIf workObject.VendorType > -1 && Slave.GetValue(JBSlaveQuest.JBIsSubmissive) < 50
	; 		JBSlaveQuest.JBNeedsSubmissive50MSG.Show()
	; 		;Debug.Notification("Needs Submissive > 50")
	; 	Else
	; 		JBSlaveQuest.ActivatedByWorkshopSlave(workObject, Slave)
	; 	EndIf
	; Else
	; 	;Debug.Notification("Slave - OnCommandModeGiveCommand - command: " + aeCommand)
	; endif
EndEvent

Event OnEnterBleedout(ObjectReference akSenderRef)
	; set this guy as "wounded"
	; Actor Slave = akSenderRef as Actor
	; if JBSlaveQuest.IsWounded(Slave)
	; 	;
	; else
	; 	JBSlaveQuest.WoundSlave(Slave)
	; endif
EndEvent

; WOUNDED STATE: removing visible wounded state for now
Event OnCombatStateChanged(ObjectReference akSenderRef, Actor akTarget, int aeCombatState)
	; Actor Slave = akSenderRef as Actor
	; if aeCombatState == 0 && JBSlaveQuest.IsWounded(Slave)
	; 	JBSlaveQuest.WoundSlave(Slave, false)
	; endif
EndEvent

Event OnDeath(ObjectReference akSenderRef, Actor akKiller)

	int sInd = self.Find(akSenderRef)
	
	;JBSlaveQuest.HandleSlaveDeath(akSenderRef as Actor)

	; If JBSlaveQuest.JBWorkshopSlaveCollection.Find(akSenderRef) > -1
	; 	JBSlaveQuest.JBWorkshopSlaveCollection.RemoveRef(akSenderRef)
	; EndIf

	self.RemoveRef(akSenderRef)
	
	int sCount = self.GetCount()
	Debug.Notification((JBSlaveQuest.JBSlaveCountMSG as Form).GetName()+sCount)
	;Debug.Notification("Slave count: "+sCount)

EndEvent

Event OnLoad(ObjectReference akSenderRef)
	; Actor akAktorRef  = akSenderRef as Actor
	; If !akAktorRef.IsEquipped(Collar) && akAktorRef.GetValue(JBSlaveQuest.JBIsSubmissive) < 100
	; 	akAktorRef.EquipItem(Collar, true)
	; EndIf

	; WOUNDED STATE: removing visible wounded state for now
	;if IsDead() == false && IsWounded()
	; if akAktorRef.IsDead() == false && JBSlaveQuest.IsWounded(akAktorRef)
	;     ;WorkshopParent.WoundActor(self, false)
	;     JBSlaveQuest.WoundSlave(akAktorRef, false)
	; endif			

	; check if I should create caravan brahmin
	;WorkshopParent.CaravanActorBrahminCheck(self)
	;JBSlaveQuest.CaravanSlaveBrahminCheck(akAktorRef)
EndEvent

Event OnUnload(ObjectReference akSenderRef)
	; Actor akSlave = akSenderRef as Actor
	; If JBSlaveQuest.IsWounded(akSlave) && JBSlaveQuest.JBCaravanSlaveCollection.Find(akSlave) > -1 
	; 	JBSlaveQuest.WoundSlave(akSlave, false)
	; EndIf
EndEvent

Event OnWorkshopNPCTransfer(ObjectReference akSenderRef, Location akNewWorkshopLocation, Keyword akActionKW)

	; what kind of transfer?
	; Actor akActorRef = akSenderRef as Actor
	; if akActionKW == WorkshopParent.WorkshopAssignCaravan && akActorRef.GetValue(JBSlaveQuest.JBIsSubmissive) < 100
	; 	;Debug.Notification("Needs Submissive 100")
	; 	JBSlaveQuest.JBNeedsSubmissive100MSG.Show()
	; ElseIf akActionKW == WorkshopParent.WorkshopAssignCaravan && akActorRef.GetValue(JBSlaveQuest.JBIsSubmissive) >= 100
	; 	JBSlaveQuest.AssignCaravanSlavePUBLIC(akActorRef, akNewWorkshopLocation)
	; else
	; 	WorkshopScript newWorkshop = WorkshopParent.GetWorkshopFromLocation(akNewWorkshopLocation)
	; 	if newWorkshop
	; 		if akActionKW == WorkshopParent.WorkshopAssignHome
	; 			;Actor akActorRef = akSenderRef as Actor
	; 			JBSlaveQuest.AddSlaveToWorkshopPUBLIC(akActorRef, newWorkshop)
	; 			akActorRef.SetValue(JBSlaveQuest.JBIsWorkStatus, 5)
	; 			akActorRef.EvaluatePackage()
	; 		elseif akActionKW == WorkshopParent.WorkshopAssignHomePermanentActor
	; 			;Actor akActorRef = akSenderRef as Actor
	; 			JBSlaveQuest.AddSlaveToWorkshopPUBLIC(akActorRef, newWorkshop)
	; 			akActorRef.SetValue(JBSlaveQuest.JBIsWorkStatus, 5)
	; 			akActorRef.EvaluatePackage()
	; 		endif
	; 	endif
	; endif
EndEvent

Event OnPlayerEnterVertibird(ObjectReference akSenderRef, ObjectReference akVertibird)
	
EndEvent

; Event OnCommandModeEnter(ObjectReference akSenderRef)
; 	Debug.Notification("Slave Enter in command mode")
; 	If JBSlaveQuest.JBSlaveFollowersCollection.Find(akSenderRef) < 0
; 		JBSlaveQuest.JBSlaveFollowersCollection.addRef(akSenderRef)
; 	EndIf
; EndEvent

;Event OnCommandModeExit(ObjectReference akSenderRef)
;EndEvent
