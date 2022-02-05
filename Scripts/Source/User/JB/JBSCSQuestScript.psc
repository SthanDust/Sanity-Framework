Scriptname JB:JBSCSQuestScript extends Quest Conditional


WorkshopParentScript Property WorkshopParent Auto Const Mandatory
JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBConvoyQuestScript Property JBConvoyQuest Auto Const Mandatory

ObjectReference Property baseTerminal auto

ReferenceAlias Property JBSCSTerminal Auto Const

Int Property SlaveListPage = 0 Auto Conditional
Int Property SlaveListPageCount = 0 Auto Conditional
Int Property SlaveListType = 0 Auto Conditional

bool Property SlaveListNoShowNext = false Auto Conditional
bool Property SlaveListNoShowPrevious = false Auto Conditional

bool Property TerminalInit = false Auto Conditional

bool Property playerInSettlement = false Auto Conditional

Group SlaveListShowNameBools
	bool Property SlaveListShowName0 = true Auto Conditional
	bool Property SlaveListShowName1 = true Auto Conditional
	bool Property SlaveListShowName2 = true Auto Conditional
	bool Property SlaveListShowName3 = true Auto Conditional
	bool Property SlaveListShowName4 = true Auto Conditional
	bool Property SlaveListShowName5 = true Auto Conditional
	bool Property SlaveListShowName6 = true Auto Conditional
	bool Property SlaveListShowName7 = true Auto Conditional
	bool Property SlaveListShowName8 = true Auto Conditional
	bool Property SlaveListShowName9 = true Auto Conditional
EndGroup

Message[] Property JBSCSSlaveNames Auto

Actor Property SelectedSlave Auto

Group StartPageMessage
	Message Property JBSCSSlaveCount Auto
	Message Property JBSCSSlaveCountInCurrentWorkshop Auto

	Message Property JBSCSCurrentLocation Auto
EndGroup

Group SlaveInfoMessages
	Message Property JBSCSSlaveName Auto
	Message Property JBSCSSlaveLevel Auto
	Message Property JBSCSSubmissiveValue Auto

	Message Property JBSCSStrengthAV Auto
	Message Property JBSCSPerceptionAV Auto
	Message Property JBSCSEnduranceAV Auto
	Message Property JBSCSCharismaAV Auto
	Message Property JBSCSIntelligenceAV Auto
	Message Property JBSCSAgilityAV Auto
	Message Property JBSCSLuckAV Auto

	Message Property JBSCSCurrentWork Auto

	Message Property JBSCSNoWork Auto
	Message Property JBSCSCaravanWork Auto
	Message Property JBSCSFarmWork Auto
	Message Property JBSCSQMWork Auto
	Message Property JBSCSGuardWork Auto
	Message Property JBSCSScavengerWork Auto
	Message Property JBSCSFollowerWork Auto
	Message Property JBSCSRestrictWork Auto
	Message Property JBSCSVendorWork Auto
	Message Property JBSCSBarberWork Auto
	Message Property JBSCSSurgeryWork Auto
	Message Property JBSCSArenaWork Auto
	Message Property JBSCSProstituteWork Auto
	Message Property JBSCSHeadConvoyWork Auto
	Message Property JBSCSGuardConvoyWork Auto

	Message Property JBSCSSlaveHome Auto
	Message Property JBSCSSlaveCaravanDestination Auto
	Message Property JBSCSSlaveNoHome Auto
EndGroup

ObjectReference[] slavesInCurrentWorkshop


Function Setup()
	;Debug.Notification("JBSCSQuest Setup")
	RegisterForMenuOpenCloseEvent("TerminalMenu")
	baseTerminal = JBSCSTerminal.GetReference()
	TerminalInit = true
	JBSCSSlaveCount.SetName(JBSlaveQuest.JBSlaveCollection.GetCount() as String)
	baseTerminal.AddTextReplacementData("SlaveCount", JBSCSSlaveCount)
	WorkshopScript workshopRef = WorkshopParent.GetWorkshopFromLocation(Game.GetPlayer().GetCurrentLocation())
	If workshopRef && workshopRef.OwnedByPlayer == true
		slavesInCurrentWorkshop = new ObjectReference[0]
		slavesInCurrentWorkshop = JBSlaveQuest.GetWorkshopSlaves(workshopRef)
		JBSCSSlaveCountInCurrentWorkshop.SetName(slavesInCurrentWorkshop.Length as String)
		Location currentLocation = workshopRef.myLocation
		JBSCSCurrentLocation.SetName(currentLocation.GetName())
		baseTerminal.AddTextReplacementData("CurrentLocation", JBSCSCurrentLocation)
		baseTerminal.AddTextReplacementData("SlaveCountInWorkshop", JBSCSSlaveCountInCurrentWorkshop)
		playerInSettlement = true
	Else
		playerInSettlement = false
	EndIf
EndFunction

Function setupSlaveList(int iPage = 1, int iList = 1)
	SlaveListType = iList
	SlaveListPageCount = SetPageCount(SlaveListType)
	SlaveListPage = iPage
	SetNoShowBools()
	int i = 0
	int startIndex = (SlaveListPage - 1)*10
	int stopIndex = startIndex + 9
	While startIndex <= stopIndex
		Actor Slave = none
		If SlaveListType == 1
			Slave = JBSlaveQuest.JBSlaveCollection.GetActorAt(startIndex)
		ElseIf SlaveListType == 2 && slavesInCurrentWorkshop.Length > startIndex
			Slave = slavesInCurrentWorkshop[startIndex] as Actor
		EndIf
		If Slave != none
			;Debug.Notification("Slave - "+i+" !=none")
			String SlaveName = Slave.GetDisplayName()
			JBSCSSlaveNames[i].SetName(SlaveName)
			baseTerminal.AddTextReplacementData("Slave"+i, JBSCSSlaveNames[i])
			SetShowNameBool(i, true)
		Else
			SetShowNameBool(i, false)
		EndIf
		i += 1
		startIndex += 1
	EndWhile
EndFunction

Int Function SetPageCount(int iList = 1)
	If iList == 1
		int count = Math.Ceiling((JBSlaveQuest.JBSlaveCollection.GetCount() as float)/10.0)
		return count
	ElseIf iList == 2
		int count = Math.Ceiling((slavesInCurrentWorkshop.Length as float)/10.0)
		return count
	EndIf
EndFunction

Function SetShowNameBool(int index, bool bSet)
	If index == 0
		SlaveListShowName0 = bSet
	ElseIf index == 1
		SlaveListShowName1 = bSet
	ElseIf index == 2
		SlaveListShowName2 = bSet
	ElseIf index == 3
		SlaveListShowName3 = bSet
	ElseIf index == 4
		SlaveListShowName4 = bSet
	ElseIf index == 5
		SlaveListShowName5 = bSet
	ElseIf index == 6
		SlaveListShowName6 = bSet
	ElseIf index == 7
		SlaveListShowName7 = bSet
	ElseIf index == 8
		SlaveListShowName8 = bSet
	ElseIf index == 9
		SlaveListShowName9 = bSet
	EndIf
EndFunction

Function SetNoShowBools()
	If SlaveListPageCount <= 1
		SlaveListNoShowNext = true
		SlaveListNoShowPrevious = true
	Else
		If SlaveListPageCount == SlaveListPage
			SlaveListNoShowNext = true
			SlaveListNoShowPrevious = false
		ElseIf SlaveListPage == 1
			SlaveListNoShowNext = false
			SlaveListNoShowPrevious = true
		Else
			SlaveListNoShowNext = false
			SlaveListNoShowPrevious = false
		EndIf
	EndIf
EndFunction

Function nextPage()
	int Page = SlaveListPage + 1
	setupSlaveList(Page, SlaveListType)
	;setupSlaveList(Page)
EndFunction

Function previousPage()
	int Page = SlaveListPage - 1
	setupSlaveList(Page, SlaveListType)
	;setupSlaveList(Page)
EndFunction

Function SelectSlave(int index)
	int slaveIndex = SlaveListPage*10 + index - 11
	If SlaveListType == 1
		SelectedSlave = JBSlaveQuest.JBSlaveCollection.GetActorAt(slaveIndex)
	ElseIf SlaveListType == 2
		SelectedSlave = slavesInCurrentWorkshop[slaveIndex] as Actor
	EndIf

	JBSCSSlaveName.SetName(SelectedSlave.GetDisplayName())
	JBSCSSlaveLevel.SetName(SelectedSlave.GetLevel() as String)
	JBSCSStrengthAV.SetName((SelectedSlave.GetValue(Game.GetStrengthAV()) as int) as String)
	JBSCSPerceptionAV.SetName((SelectedSlave.GetValue(Game.GetPerceptionAV()) as int) as String)
	JBSCSEnduranceAV.SetName((SelectedSlave.GetValue(Game.GetEnduranceAV()) as int) as String)
	JBSCSCharismaAV.SetName((SelectedSlave.GetValue(Game.GetCharismaAV()) as int) as String)
	JBSCSIntelligenceAV.SetName((SelectedSlave.GetValue(Game.GetIntelligenceAV()) as int) as String)
	JBSCSAgilityAV.SetName((SelectedSlave.GetValue(Game.GetAgilityAV()) as int) as String)
	JBSCSLuckAV.SetName((SelectedSlave.GetValue(Game.GetLuckAV()) as int) as String)
	JBSCSSubmissiveValue.SetName(SelectedSlave.GetValue(JBSlaveQuest.JBIsSubmissive) as String)

	SetCurrentWorkMsg()
	SetSlaveHomeMsg()
	
	baseTerminal.AddTextReplacementData("SlaveName", JBSCSSlaveName)
	baseTerminal.AddTextReplacementData("SlaveLevel", JBSCSSlaveLevel)
	baseTerminal.AddTextReplacementData("SlaveStrengthAV", JBSCSStrengthAV)
	baseTerminal.AddTextReplacementData("SlavePerceptionAV", JBSCSPerceptionAV)
	baseTerminal.AddTextReplacementData("SlaveEnduranceAV", JBSCSEnduranceAV)
	baseTerminal.AddTextReplacementData("SlaveCharismaAV", JBSCSCharismaAV)
	baseTerminal.AddTextReplacementData("SlaveIntelligenceAV", JBSCSIntelligenceAV)
	baseTerminal.AddTextReplacementData("SlaveAgilityAV", JBSCSAgilityAV)
	baseTerminal.AddTextReplacementData("SlaveLuckAV", JBSCSLuckAV)
	baseTerminal.AddTextReplacementData("SubmissiveValue", JBSCSSubmissiveValue)
	baseTerminal.AddTextReplacementData("CurrentWork", JBSCSCurrentWork)
	baseTerminal.AddTextReplacementData("CurrentHome", JBSCSSlaveHome)
EndFunction

Function SetCurrentWorkMsg()
	If WorkshopParent.CaravanActorAliases.Find(SelectedSlave) > -1
		JBSCSCurrentWork.SetName(JBSCSCaravanWork.GetName())
	ElseIf JBSlaveQuest.JBQuartermasteryAlias.GetActorRef() == SelectedSlave
		JBSCSCurrentWork.SetName(JBSCSQMWork.GetName())
	;ElseIf SelectedSlave.GetFactionRank(JBSlaveQuest.DLC02WorkshopArenaCombatantFaction) >= 0 || SelectedSlave.GetFactionRank(JBSlaveQuest.DLC02WorkshopArenaCombatantEnemyFaction) >= 0
		;JBSCSCurrentWork.SetName(JBSCSArenaWork.GetName())
	ElseIf (SelectedSlave as WorkshopNPCScript).bIsGuard == true
		JBSCSCurrentWork.SetName(JBSCSGuardWork.GetName())
	ElseIf (SelectedSlave as WorkshopNPCScript).bIsScavenger == true
		JBSCSCurrentWork.SetName(JBSCSScavengerWork.GetName())
	ElseIf (SelectedSlave as JB:JBSlaveNPCScript).bIsJBFollower == true
		JBSCSCurrentWork.SetName(JBSCSFollowerWork.GetName())
	ElseIf (SelectedSlave as JB:JBSlaveNPCScript).bIsProstitute == true
		JBSCSCurrentWork.SetName(JBSCSProstituteWork.GetName())
	ElseIf (SelectedSlave as JB:JBSlaveNPCScript).bIsConvoyHead == true
		JBSCSCurrentWork.SetName(JBSCSHeadConvoyWork.GetName())
	ElseIf (SelectedSlave as JB:JBSlaveNPCScript).bIsConvoyGuard == true
		JBSCSCurrentWork.SetName(JBSCSGuardConvoyWork.GetName())
	ElseIf SelectedSlave.HasKeyword(JBSlaveQuest.JBSlaveRestricted)
		JBSCSCurrentWork.SetName(JBSCSRestrictWork.GetName())
	ElseIf (SelectedSlave as WorkshopNPCScript).assignedMultiResource != None
		JBSCSCurrentWork.SetName(JBSCSFarmWork.GetName())
	ElseIf (SelectedSlave as WorkshopNPCScript).specialVendorType > -1
		JBSCSCurrentWork.SetName(JBSCSVendorWork.GetName())
	;ElseIf SelectedSlave.GetFactionRank(JBSlaveQuest.DLC06WorkshopVendorFactionBarber) >= 0
		;JBSCSCurrentWork.SetName(JBSCSBarberWork.GetName())
	;ElseIf SelectedSlave.GetFactionRank(JBSlaveQuest.DLC06WorkshopVendorFactionSurgery) >= 0
		;JBSCSCurrentWork.SetName(JBSCSSurgeryWork.GetName())
	Else
		CheckAssignedObject()
		;JBSCSCurrentWork.SetName(JBSCSNoWork.GetName())
	EndIf
EndFunction

Function CheckAssignedObject()
	WorkshopScript workshopRef = WorkshopParent.GetWorkshop((SelectedSlave as WorkshopNPCScript).GetWorkshopID())
	If workshopRef
		; ObjectReference[] ResourceObjectsUndamaged = WorkshopParent.GetResourceObjects(workshopRef, NONE, 2)
		; If ResourceObjectsUndamaged.Length > 0
		; 	int i = 0
		; 	While i < ResourceObjectsUndamaged.Length
		; 		WorkshopObjectScript workshopObject = ResourceObjectsUndamaged[i] as WorkshopObjectScript
		; 		If (workshopObject.GetLinkedRef(JBSlaveQuest.JBSlaveWorkObject) as Actor) == SelectedSlave
		; 			JBSCSCurrentWork.SetName((workshopObject.GetBaseObject()).GetName())
		; 			return
		; 		EndIf
		; 		i +=1
		; 	EndWhile
		; EndIf
		ObjectReference[] ResourceObjects = workshopRef.GetWorkshopOwnedObjects(SelectedSlave)
		If ResourceObjects.Length > 0
			int i = 0
			While i < ResourceObjects.Length
				WorkshopObjectScript theObject = ResourceObjects[i] as WorkshopObjectScript
				If theObject && !theObject.IsBed()
					JBSCSCurrentWork.SetName((theObject.GetBaseObject()).GetName())
					return
				EndIf
				i += 1
			EndWhile
		EndIf
		JBSCSCurrentWork.SetName(JBSCSNoWork.GetName())
	Else
		JBSCSCurrentWork.SetName(JBSCSNoWork.GetName())
	EndIf
EndFunction

Function SetSlaveHomeMsg()
	If (SelectedSlave as WorkshopNPCScript).GetWorkshopID() > -1
		Location homeLocation = WorkshopParent.GetWorkshop((SelectedSlave as WorkshopNPCScript).GetWorkshopID()).myLocation
		JBSCSSlaveHome.SetName(homeLocation.GetName())
	Else
		JBSCSSlaveHome.SetName(JBSCSSlaveNoHome.GetName())
	EndIf
EndFunction

Function MoveSlaveToPlayer()
	SelectedSlave.MoveTo(Game.GetPlayer())
EndFunction

Function KillSlave()
	SelectedSlave.KillEssential()
EndFunction

Function CallConvoy()
	JBConvoyQuest.ConvoyCall()
EndFunction

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
	If (asMenuName == "TerminalMenu") && (abOpening == False)
		;Debug.Notification("JBSCSQuest Stop")
		TerminalInit = false
		UnregisterForMenuOpenCloseEvent("TerminalMenu")
		CompleteQuest()
		;Stop()
	EndIf
EndEvent

