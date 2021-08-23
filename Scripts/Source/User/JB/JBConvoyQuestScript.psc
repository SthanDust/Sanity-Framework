Scriptname JB:JBConvoyQuestScript extends Quest Conditional

WorkshopParentScript Property WorkshopParent Auto Const Mandatory
JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory

ReferenceAlias Property HeadGuard Auto Const
ReferenceAlias[] Property ConvoyGuards Auto Const
RefCollectionAlias Property ConvoyPrisoners Auto Const
LocationAlias Property ConvoyDestination Auto Const

Message Property JBConvoyArrivedMSG Auto const

Faction Property JBConvoyFaction Auto Const

Bool Property bConvoyHeadAppointed = false Auto Conditional

Int Property iNumberOfGuards = 0 Auto Conditional

Int Property iConvoyStatus = -1 Auto Conditional
{
	0 - goes to the player
	1 - waiting for a command
	2 - goes to destination
}


ReferenceAlias Function GetGuardAlias(Actor akActor = None)
	int i = 0
	If akActor == None
		While i < ConvoyGuards.Length
			If ConvoyGuards[i].GetReference() == None
				return ConvoyGuards[i]
			EndIf
			i += 1
		EndWhile
	Else
		While i < ConvoyGuards.Length
			If ConvoyGuards[i].GetActorReference() == akActor
				return ConvoyGuards[i]
			EndIf
			i += 1
		EndWhile
	EndIf
EndFunction

Function ChangeConvoyStatus(int iStatus = -1)
	iConvoyStatus = iStatus
	Actor Guard
	Actor Head = HeadGuard.GetActorReference()
	If iStatus == -1
		Head.RemoveFromFaction(JBConvoyFaction)
		(self as Quest).SetObjectiveDisplayed(5, false)
	Else
		Head.AddToFaction(JBConvoyFaction)
		If !(self as Quest).IsObjectiveDisplayed(5)
			(self as Quest).SetObjectiveDisplayed(5, true, true)
		EndIf
	EndIf
	Head.EvaluatePackage()
	If iNumberOfGuards > 0
		int i = 0
		While i < ConvoyGuards.Length
			If ConvoyGuards[i].GetReference() != None
				Guard = ConvoyGuards[i].GetActorReference()
				If iStatus == -1
					Guard.RemoveFromFaction(JBConvoyFaction)
				Else
					Guard.AddToFaction(JBConvoyFaction)
				EndIf
				Guard.EvaluatePackage()
			EndIf
			i += 1
		EndWhile
	EndIf
EndFunction

Function ClearConvoyGuardsArray()
	int i = 0
	While i < ConvoyGuards.Length
		If ConvoyGuards[i] != None
			JB:JBSlaveNPCScript Guard = ConvoyGuards[i].GetReference() as JB:JBSlaveNPCScript
			ConvoyGuards[i].Clear()
			Guard.SetGuardData(false, false)
		EndIf
		i += 1
	EndWhile
	iNumberOfGuards = 0
EndFunction

Function ConvoyCall()
	ChangeConvoyStatus(0)
	If !HeadGuard.GetReference().Is3DLoaded() && JBMCM.bFastArrivalOnCall
		;Debug.Notification("convoy moved")
		HeadGuard.GetReference().MoveTo(Game.GetPlayer(), 2000)
		HeadGuard.GetReference().MoveToNearestNavmeshLocation()
		int i = 0
		While i < ConvoyGuards.Length
			If ConvoyGuards[i] != None
				ConvoyGuards[i].GetReference().MoveTo(HeadGuard.GetReference())
			EndIf
			i += 1
		EndWhile
	EndIf
EndFunction

Function DepartureConvoy()
	WorkShopNPCScript workshopActorToAssign = HeadGuard.GetReference() as WorkShopNPCScript
	Keyword keywordToUse = WorkshopParent.WorkshopAssignHomePermanentActor
	WorkshopScript previousWorkshop = WorkshopParent.GetWorkshop(workshopActorToAssign.GetWorkshopID())
	Location previousLocation = NONE
	if previousWorkshop
		previousLocation = previousWorkshop.myLocation
	endif
	Location destinationLocation = workshopActorToAssign.OpenWorkshopSettlementMenuEx(akActionKW=keywordToUse, aLocToHighlight=previousLocation)
	If destinationLocation
		ConvoyDestination.ForceLocationTo(destinationLocation)
		ChangeConvoyStatus(2)
		RegisterForRemoteEvent(HeadGuard, "OnUnload")
	EndIf
EndFunction

Function ConvoyArrived()
	JBConvoyArrivedMSG.Show()
	;Debug.Notification("The convoy has arrived at its destination.")
	int i = 0
	WorkshopScript newWorkshop = WorkshopParent.GetWorkshopFromLocation(ConvoyDestination.GetLocation())

	;ObjectReference[] workshopObjects = newWorkshop.GetWorkshopResourceObjects(aiOption=2)
	;ObjectReference[] workshopObjects = newWorkshop.GetWorkshopResourceObjects()
	;Debug.Notification("Count workshop objects = "+workshopObjects.Length)
	WorkshopObjectScript[] restrictedObjects = new WorkshopObjectScript[0]
	While i < JBSlaveQuest.JBRestrictedDeviceCollection.GetCount()
		WorkshopObjectScript restrictedObject = JBSlaveQuest.JBRestrictedDeviceCollection.GetAt(i) as WorkshopObjectScript
		If WorkshopParent.GetWorkshop(restrictedObject.workshopID) == newWorkshop
			restrictedObjects.Add(restrictedObject)
		EndIf
		i+= 1
	EndWhile
	;Debug.Notification("Count restricted objects = "+restrictedObjects.Length)

	WorkshopNPCScript assignedActor = HeadGuard.GetReference() as WorkshopNPCScript
	;WorkshopParent.AddActorToWorkshopPUBLIC(assignedActor, newWorkshop)

	i = 0
	While i < ConvoyGuards.Length
		If ConvoyGuards[i] != None
			assignedActor = ConvoyGuards[i].GetReference() as WorkshopNPCScript
			WorkshopParent.AddActorToWorkshopPUBLIC(assignedActor, newWorkshop)
		EndIf
		i += 1
	EndWhile

	ChangeConvoyStatus()

	ObjectReference[] Prisoners = new ObjectReference[0]
	i = 0
	While i < ConvoyPrisoners.GetCount()
		If ConvoyPrisoners.GetAt(i) != None
			Prisoners.Add(ConvoyPrisoners.GetAt(i))
		EndIf
		i += 1
	EndWhile
	;Debug.Notification("Prisoners count = "+Prisoners.Length)

	i = 0
	While i < Prisoners.Length
		JB:JBSlaveNPCScript Slave = Prisoners[i] as JB:JBSlaveNPCScript
		Slave.SetAsConvoyPrisoner(false)
		i += 1
	EndWhile

	i = 0
	While i < Prisoners.Length
		assignedActor = Prisoners[i] as WorkshopNPCScript
		WorkshopParent.AddActorToWorkshopPUBLIC(assignedActor, newWorkshop)
		If restrictedObjects.Length > 0
			WorkshopObjectScript assignedObject = restrictedObjects[restrictedObjects.Length-1] as WorkshopObjectScript
			;assignedObject.ActivatedByWorkshopActor(assignedActor)
			WorkshopParent.AssignActorToObjectPUBLIC(assignedActor, assignedObject)
			restrictedObjects.RemoveLast()
			;Debug.Notification("Count restricted objects = "+restrictedObjects.Length)
		EndIf
		i += 1
	EndWhile

	;UnregisterForRemoteEvent(HeadGuard, "OnUnload")
EndFunction

Event ReferenceAlias.OnUnload(ReferenceAlias akSender)
	;Debug.Notification("Head guard OnUnload Event Start")
	If akSender == HeadGuard && JBMCM.bFastArrivaAtDestination
		WorkshopScript workshopRef = WorkshopParent.GetWorkshopFromLocation(ConvoyDestination.GetLocation())
		If workshopRef.myLocation.IsLoaded() == false
			HeadGuard.GetReference().MoveTo(workshopRef.GetLinkedRef(WorkshopParent.WorkshopLinkCenter))
			int i = 0
			While i < ConvoyGuards.Length
				If ConvoyGuards[i] != None
					ConvoyGuards[i].GetReference().MoveTo(workshopRef.GetLinkedRef(WorkshopParent.WorkshopLinkCenter))
				EndIf
				i += 1
			EndWhile
			If ConvoyPrisoners.GetCount() > 0
				ConvoyPrisoners.MoveAllTo(workshopRef.GetLinkedRef(WorkshopParent.WorkshopLinkCenter))
			EndIf
		EndIf
	EndIf
	UnregisterForRemoteEvent(HeadGuard, "OnUnload")
EndEvent
