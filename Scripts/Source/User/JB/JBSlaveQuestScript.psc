Scriptname JB:JBSlaveQuestScript extends Quest Conditional

JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory

WorkshopParentScript Property WorkshopParent Auto Const Mandatory
DLC04:DLC04WorkshopParentScript Property DLC04WorkshopParent auto const mandatory

JB:JBCompatibilityQuestScript Property JBCompatibilityQuest Auto Const Mandatory
JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory

Group SlaveCollections
	RefCollectionAlias Property JBSlaveCollection Auto Const
	RefCollectionAlias Property JBSlaveFollowersCollection Auto Const
	RefCollectionAlias Property JBProstituteSlaveCollection Auto Const
	RefCollectionAlias Property JBProstitutesInBusiness Auto Const
	ReferenceAlias[] Property JBSlaveFollower Auto Const
EndGroup

Group SlaveActorValue
	ActorValue Property JBIsSubmissive Auto
	ActorValue Property JBSlaveSexSkill Auto
	ActorValue Property JBSlaveProstituteSkill Auto
EndGroup

Group SlaveData
	Faction Property JBSlaveFaction Auto Const
	MagicEffect Property JBMarkEffect Auto Const
	FormList Property JBRestrictList Auto Const
EndGroup

Group SlaveSource
	LeveledActor Property JBLCharSlaveHumanGhoul Auto Const
	LeveledActor Property JBLCharSlaveGen1Synth Auto Const
	LeveledActor Property JBLCharSlaveGen2Synth Auto Const
	LeveledActor Property JBLCharSlaveSupermutant Auto Const
	ActorBase Property JBSlaveHumanGhoul Auto Const
	ActorBase Property JBSlaveGen1Synth Auto Const
	ActorBase Property JBSlaveGen2Synth Auto Const
	ActorBase Property JBSlaveSupermutant Auto Const
EndGroup

Group EscapeQuestData
	Quest Property JBEscapeQuest Auto Const
	ReferenceAlias Property runawaySlave Auto Const
EndGroup

Group QuartermasteryData
	Actor Property JBQuartermasteryBrahminRef Auto Const
	ReferenceAlias Property JBQuartermasteryAlias Auto Const
	ReferenceAlias Property JBQMBrahminAlias Auto Const
	Perk Property JBWorkshopBrahminPerk Auto Const
	Container Property JBQMTransferContainer Auto Const
EndGroup

Group JBKeywords
	Keyword Property JBSlaveWorkObject Auto Const
	Keyword Property JBSlaveRestricted Auto Const
	Keyword Property JBWorkplaceProstitutes Auto Const
	Keyword Property JBWhoreOnService Auto Const
EndGroup

Group Messages
	Message Property JBSlaveInfoMessageBox auto Const

	Message Property JBSlaveCountMSG Auto Const
	Message Property JBlabelNameMSG Auto Const
	Message Property JBlabelSubmissiveMSG Auto Const
	Message Property JBlabelSexSkillMSG Auto Const
	Message Property JBlabelProstituteSkillMSG Auto Const

	Message Property JBNeedsSubmissive50MSG Auto Const
	Message Property JBNeedsSubmissive80MSG Auto Const
	Message Property JBNeedsSubmissive100MSG Auto Const

	Message Property JBRenameLabel Auto Const

	Message Property JBSlaveRestrictedMSG Auto Const

	Message Property JBUpdateMSG Auto Const

	Message Property JBAskAboutFurnitureMSG Auto Const

	Message Property JBAskAboutPackagesMSG Auto Const

	Message Property JBProstituteFoundClientMSG Auto Const
EndGroup

Group Keywords
	Keyword Property ActorTypeNPC Auto Const
	Keyword Property ActorTypeSuperMutant Auto Const
	Keyword Property ActorTypeSynth Auto Const
	Keyword Property TeammateDontUseAmmoKeyword Auto Const
EndGroup

Group Debug
	String Property userlogName = "JustBusiness" Auto Const Hidden
	String Property currentModVersion = "0.7.5" Auto Const
	String Property previousModVersion Auto
EndGroup

Armor Property Collar Auto Const

Furniture Property PowerArmorFrameFurnitureNoCore Auto Const

Idle Property ElevatorFaceCamera Auto
Idle Property ElevatorBodyCamera Auto

RefCollectionAlias Property JBRestrictedDeviceCollection Auto Const

ReferenceAlias Property editableSlave Auto Const

ReferenceAlias Property Companion Auto Const

Holotape Property JBSCSHolotape Auto Const

ObjectReference Property JBdeadXRef Auto Const

Form Property XMarker Auto Const

Struct ActorSourceData
	LeveledActor sourceLeveledActor
	ActorBase sourceActorBase
EndStruct


Event OnQuestInit()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterCustomEvents()
	if (Game.GetPlayer().GetItemCount(JBSCSHolotape) == 0)
		Game.GetPlayer().AddItem(JBSCSHolotape)
	endIf
	previousModVersion = currentModVersion
EndEvent

Function JBSlaveInfoMessage(Actor akActor)
	int ButtonPressed = JBSlaveInfoMessageBox.Show()
	if ButtonPressed == 0
		Debug.MessageBox((JBlabelNameMSG as Form).GetName()+" "+akActor.GetDisplayName()+"<br>"+(JBlabelSubmissiveMSG as Form).GetName()+" "+akActor.GetValue(JBIsSubmissive)+"<br>"+(JBlabelSexSkillMSG as Form).GetName()+" "+akActor.GetValue(JBSlaveSexSkill)+"<br>"+(JBlabelProstituteSkillMSG as Form).GetName()+" "+akActor.GetValue(JBSlaveProstituteSkill))
		;Debug.MessageBox("Name: "+akActor.GetDisplayName()+"<br>Submission: "+akActor.GetValue(JBIsSubmissive))
	ElseIf ButtonPressed == 1
		If JBCompatibilityQuest.TextInputMenuInstalled
			RenameSlave(akActor)
		EndIf
	ElseIf ButtonPressed == 2
		If akActor.IsInPowerArmor() == false && akActor.HasKeyword(ActorTypeNPC)
			EditSlaveLook(akActor)
		EndIf
	ElseIf ButtonPressed == 3
		ResetSlave(akActor)
	EndIf
EndFunction

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	If akNewLoc && akNewLoc.HasKeyword(WorkshopParent.LocTypeWorkshopSettlement)
		;Debug.Notification("The new location is a settlement")
		WorkshopScript workshopRef = WorkshopParent.GetWorkshopFromLocation(akNewLoc)
		If workshopRef
			ObjectReference[] workshopObjects = workshopRef.GetWorkshopResourceObjects(aiOption=2)
			int i = 0
			While i < workshopObjects.Length
				If JBRestrictList.HasForm(workshopObjects[i].GetBaseObject()) && JBRestrictedDeviceCollection.Find(workshopObjects[i]) < 0
					WorkshopObjectScript workshopObject = workshopObjects[i] as WorkshopObjectScript
					If !workshopObject.IsActorAssigned()
						;Debug.Notification("A restrictive device has been added to the collection.")
						JBRestrictedDeviceCollection.AddRef(workshopObjects[i])
					EndIf
				EndIf
				i += 1
			EndWhile
		EndIf
	EndIf
EndEvent

Event WorkshopParentScript.WorkshopObjectBuilt(WorkshopParentScript akSender, Var[] akArgs)
	WorkshopObjectScript workshopObject = akArgs[0] as WorkshopObjectScript
	If JBRestrictList.HasForm(workshopObject.GetBaseObject())
		;Debug.Notification("A restrictive device has been added to the collection.")
		JBRestrictedDeviceCollection.AddRef(workshopObject)
	EndIf
EndEvent

Event WorkshopParentScript.WorkshopObjectDestroyed(WorkshopParentScript akSender, Var[] akArgs)
	WorkshopObjectScript workshopObject = akArgs[0] as WorkshopObjectScript
	If JBRestrictList.HasForm(workshopObject.GetBaseObject())
		;Debug.Notification("The restrictive device has been removed from the collection.")
		JBRestrictedDeviceCollection.RemoveRef(workshopObject)
	EndIf
EndEvent

Event WorkshopParentScript.WorkshopActorAssignedToWork(WorkshopParentScript akSender, Var[] akArgs)
	if (akArgs.Length > 0)
		WorkshopObjectScript newObject = akArgs[0] as WorkshopObjectScript
		WorkshopScript workshopRef = akArgs[1] as WorkshopScript
		Actor assignedActor = newObject.GetActorRefOwner()
		If assignedActor && JBSlaveCollection.Find(assignedActor) > -1 && JBRestrictList.HasForm(newObject.GetBaseObject())
			assignedActor.AddKeyword(JBSlaveRestricted)
			;(assignedActor as JB:JBSlaveNPCScript).RegisterForRestrictedFurniture(newObject as ObjectReference)
			If assignedActor.Is3DLoaded()
				JBSlaveRestrictedMSG.Show()
			EndIf
		EndIf

		If JBRestrictList.HasForm(newObject.GetBaseObject()) && JBRestrictedDeviceCollection.Find(newObject) > -1
			;Debug.Notification("The restrictive device has been removed from the collection.")
			JBRestrictedDeviceCollection.RemoveRef(newObject)
		EndIf

		If workshopRef.HasKeyword(WorkshopParent.WorkshopType02) && GetWorkshopSlaves(workshopRef).Length > 0
			If newObject.GetBaseValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingFood].resourceValue) > 0
				RestoreRaiderHappinessPenalty(workshopRef)
			EndIf
		EndIf

		; If DLC04WorkshopParent.RaiderWorkshops.Find(workshopRef) > -1 && JBSlaveCollection.Find(assignedActor) > -1
		; 	If newObject.HasMultiResource()
		; 		float mValue = (assignedActor as WorkshopNPCScript).multiResourceProduction*3
		; 		assignedActor.SetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue, mValue)
		; 	ElseIf assignedActor.GetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue) > 0
		; 		(assignedActor as JB:JBSlaveNPCScript).ResetHappinesBonus()
		; 	EndIf
		; ElseIf JBSlaveCollection.Find(assignedActor) > -1 && assignedActor.GetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue) > 0
		; 	(assignedActor as JB:JBSlaveNPCScript).ResetHappinesBonus()
		; EndIf
	endif
EndEvent

Event WorkshopParentScript.WorkshopActorUnassigned(WorkshopParentScript akSender, Var[] akArgs)
	if (akArgs.Length > 0)
		WorkshopObjectScript newObject = akArgs[0] as WorkshopObjectScript
		WorkshopScript workshopRef = akArgs[1] as WorkshopScript

		If JBRestrictList.HasForm(newObject.GetBaseObject()) && JBRestrictedDeviceCollection.Find(newObject) < 0
			;Debug.Notification("A restrictive device has been added to the collection.")
			JBRestrictedDeviceCollection.AddRef(newObject)
		EndIf

		If workshopRef.HasKeyword(WorkshopParent.WorkshopType02) && GetWorkshopSlaves(workshopRef).Length > 0
			If newObject.GetBaseValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingFood].resourceValue) > 0
				RestoreRaiderHappinessPenalty(workshopRef)
			EndIf
		EndIf
	endif
EndEvent

Event WorkshopParentScript.WorkshopDailyUpdate(WorkshopParentScript akSender, Var[] akArgs)
	int i = 0
	While i < DLC04WorkshopParent.RaiderWorkshops.Length
		WorkshopScript workshopRef = DLC04WorkshopParent.RaiderWorkshops[i]
		RestoreRaiderHappinessPenalty(workshopRef)
		i += 1
	EndWhile
	
	If JBMCM.allowEscape == true
		CheckToEscape()
	EndIf
EndEvent

Event DLC04:DLC04WorkshopParentScript.DLC04WorkshopVassalSettlementEvent(DLC04:DLC04WorkshopParentScript akSender, Var[] akArgs)
	If JBMCM.allowManageVassal
		WorkshopScript workshopRef = akArgs[0] as WorkshopScript
		workshopRef.myLocation.AddLinkedLocation(DLC04WorkshopParent.DLC04NukaWorldWorkshopREF.myLocation, WorkshopParent.WorkshopCaravanKeyword)
		; make player owned
		workshopRef.SetOwnedByPlayer(true)
	EndIf
EndEvent

;********************************************************************************************************
;*******************************************Escape  functions********************************************
;********************************************************************************************************

Function CheckToEscape()
	;Debug.Notification("CheckToEscape")
	int count = JBSlaveCollection.GetCount()
	If count > 0
		int i = 0
		While i < count
			Actor akSlave = JBSlaveCollection.GetActorAt(i)
			If akSlave.GetValue(JBIsSubmissive) < 100
				float rand = Utility.RandomInt()
				float s = akSlave.GetValue(JBIsSubmissive)
				If (s - rand) < 0 && !JBEscapeQuest.IsRunning() && !akSlave.IsInLocation(Game.GetPlayer().GetCurrentLocation()) && !akSlave.HasKeyword(JBSlaveRestricted) && JBSlaveFollowersCollection.Find(akSlave) < 0
					JBEscapeQuest.SetStage(10)
					WorkshopParent.RemoveActorFromWorkshopPUBLIC(akSlave as WorkshopNPCScript)
					; If JBWorkshopSlaveCollection.Find(akSlave) > -1
					; 	JBWorkshopSlaveCollection.RemoveRef(akSlave)
					; EndIf
					If JBProstituteSlaveCollection.Find(akSlave) > -1
						(akSlave as JB:JBSlaveNPCScript).SetAsProstitute(false)
					EndIf
					JBSlaveCollection.RemoveRef(akSlave)
					runawaySlave.ForceRefTo(akSlave)
					akSlave.AllowPCDialogue(false)
					akSlave.EvaluatePackage()
				EndIf
			EndIf
			i += 1
		EndWhile
	EndIf
EndFunction


Function StopEscape(Actor akActor)
	akActor.ResetHealthAndLimbs()
	akActor.SetNoBleedoutRecovery(false)
	runawaySlave.Clear()
	JB:JBSlaveNPCScript theSlave = akActor as JB:JBSlaveNPCScript
	int aliasIndex = GetEmptySlaveFollowerIndex()
	If aliasIndex == -1
		;theSlave.bIsJBRelax = true
	Else
		JBSlaveFollowersCollection.AddRef(akActor)
		JBSlaveFollower[aliasIndex].ForceRefTo(akActor)
		If JBMCM.bAllowTeleportToInstitute
			theSlave.RegisterForTeleport()
		EndIf
		theSlave.bIsJBFollower = true
		theSlave.SetCommandMode()
	EndIf
	JBSlaveCollection.addRef(akActor)
	int sCount = JBSlaveCollection.GetCount()
	Debug.Notification((JBSlaveCountMSG as Form).GetName()+sCount)
	(akActor as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBIsSubmissive, 20)
	akActor.EvaluatePackage()
EndFunction

;********************************************************************************************************
;***************************************Quartermastery functions*****************************************
;********************************************************************************************************

Function BrahminWait(bool bSet)
	JB:JBQuartermasteryBrahminScript Brahmin = (JBQuartermasteryBrahminRef as ObjectReference) as JB:JBQuartermasteryBrahminScript
	Brahmin.bWait = bSet
	If bSet == false
		JBQuartermasteryBrahminRef.MoveToIfUnloaded(JBQuartermasteryAlias.GetReference())
	EndIf
	JBQuartermasteryBrahminRef.EvaluatePackage()
EndFunction

ObjectReference tContainer
Function QMContainer()
	;Debug.Notification("QMContainer - Start")
	tContainer = Game.GetPlayer().PlaceAtMe(JBQMTransferContainer)
	Utility.Wait(0.1)
	tContainer.Activate(Game.GetPlayer())
	RegisterForMenuOpenCloseEvent("ContainerMenu")
EndFunction

;********************************************************************************************************
;*******************************************Renamed functions********************************************
;********************************************************************************************************

Function RenameSlave(Actor akActor)
	string label = (JBRenameLabel as Form).GetName()
	string slaveName = akActor.GetDisplayName()
	editableSlave.ForceRefTo(akActor)
	TIM:TIM.Open(1, label, slaveName)
	RegisterForExternalEvent("TIM::Accept","SetName")
	RegisterForExternalEvent("TIM::Cancel","NoSetName")
EndFunction

Function SetName(string freq)
	;Debug.MessageBox("frequency will set at "+ freq)
	Actor akActor = editableSlave.GetActorRef()
	If JBCompatibilityQuest.RenameAnythingInstalled
		RenameAnything.SetRefName(akActor as ObjectReference, freq)
		If akActor is JBSlaveNPCScript
			(akActor as JBSlaveNPCScript).pName = freq
		EndIf
	Else
		LL_FourPlay.ObjectReferenceSetSimpleDisplayName(akActor as ObjectReference, freq)
		If akActor is JBSlaveNPCScript
			(akActor as JBSlaveNPCScript).pName = freq
		EndIf
	EndIf
	UnRegisterForExternalEvent("TIM::Accept")
	UnRegisterForExternalEvent("TIM::Cancel")
	editableSlave.Clear()
EndFunction

Function NoSetName(string freq)
	;Debug.MessageBox("input frequency was aborted at "+ freq)
	UnRegisterForExternalEvent("TIM::Accept")
	UnRegisterForExternalEvent("TIM::Cancel")
	editableSlave.Clear()
EndFunction

;********************************************************************************************************
;****************************************Appearance functions********************************************
;********************************************************************************************************

InputEnableLayer SlaveEditLayer
ObjectReference lookMarker
Actor tempActor
Function EditSlaveLook(Actor akActor)
	editableSlave.ForceRefTo(akActor)
	RegisterForMenuOpenCloseEvent("LooksMenu")
	;RegisterForLooksMenuEvent()
	; Disable movement and combat
	akActor.SetLookAt(Game.GetPlayer())
	akActor.SetPlayerControls(true)
	lookMarker = akActor.PlaceAtMe(XMarker)
	akActor.SetAlpha(0)
	akActor.ClearLookAt()
	akActor.SetPlayerControls(false)
	Utility.Wait(0.3)
	akActor.MoveTo(Game.GetPlayer(), 0.0, 50.0)
	Utility.Wait(0.3)
	ActorBase tempAB = GetSlaveBase(akActor)
	tempActor = lookMarker.PlaceAtMe(tempAB) as Actor
	tempActor.SetRestrained()
	tempActor.RemoveAllItems()
	tempActor.StopCombatAlarm()
	tempActor.StopCombat()
	While !tempActor.Is3DLoaded()
		Utility.Wait(0.1)
	EndWhile
	Utility.Wait(0.5)
	tempActor.SetLookAt(Game.GetPlayer())
	;tempActor.StopTranslation()
	;tempActor.SetPosition(lookMarker.GetPositionX(), lookMarker.GetPositionY(), lookMarker.GetPositionZ())
	;tempActor.SetAngle(0.0, 0.0, lookMarker.GetAngleZ())
	tempActor.SetPlayerControls(true)
	SlaveEditLayer = InputEnableLayer.Create()
	SlaveEditLayer.DisablePlayerControls(abCamSwitch = True)
	;make sure actor has CharGen Skeleton for editing
	tempActor.SetHasCharGenSkeleton()
	;make sure actor face is neutral
	tempActor.ChangeAnimFaceArchetype(None)
	;storedActor.PlayIdle(ElevatorFaceCamera)
	Game.ShowRaceMenu(tempActor as ObjectReference)
EndFunction

;handle actor transitioning between body and face 
; Event OnLooksMenuEvent(int aiFlavor)
; 	;Debug.Notification("OnLooksMenuEvent - Start")
; 	Actor akActor = editableSlave.GetActorRef()
; 	;actor edits body
; 	If aiFlavor == 10
; 		akActor.PlayIdle(ElevatorBodyCamera)
; 	;actor edits face
; 	ElseIf aiFlavor == 11
; 		akActor.PlayIdle(ElevatorFaceCamera)
; 	EndIf
; EndEvent

;when menus close, re-pop the main menu
Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
	;Debug.Notification("OnMenuOpenCloseEvent - Start")
	If (asMenuName == "LooksMenu") && (abOpening == False)
		;Debug.Notification("OnMenuOpenCloseEvent - LooksMenu - Close")
		Actor akActor = editableSlave.GetActorRef()
		tempActor.ClearLookAt()
		tempActor.SetPlayerControls(false)
		SlaveEditLayer.Delete()
		tempActor.SetHasCharGenSkeleton(False)
		UnregisterForMenuOpenCloseEvent("LooksMenu")
		;UnregisterForLooksMenuEvent()
		tempActor.KillEssential()
		tempActor.Disable()
		akActor.SetAlpha(1)
		akActor.QueueUpdate()
		akActor.MoveTo(lookMarker)
		editableSlave.Clear()
    ElseIf (asMenuName == "ContainerMenu") && (abOpening == False)
    	;Debug.Notification("OnMenuOpenCloseEvent - ContainerMenu - Close")
    	JB:JBQuartermasteryBrahminScript Brahmin = (JBQuartermasteryBrahminRef as ObjectReference) as JB:JBQuartermasteryBrahminScript
    	ObjectReference brahminContainer = Brahmin.GetContainer()
    	tContainer.RemoveAllItems(brahminContainer)
    	UnregisterForMenuOpenCloseEvent("ContainerMenu")
	EndIf
EndEvent

;********************************************************************************************************
;****************************************Follower functions**********************************************
;********************************************************************************************************

int Function GetEmptySlaveFollowerIndex()
	int aliasIndex = -1
	int i = 0
	While i < JBSlaveFollower.Length && aliasIndex == -1
		If JBSlaveFollower[i].GetReference() == None
			aliasIndex = i
		EndIf
		i += 1
	EndWhile
	return aliasIndex
EndFunction

ReferenceAlias Function GetFollowerAlias(JB:JBSlaveNPCScript akSlave)
	int iFollower = -1
	int i = 0
	While i < JBSlaveFollower.Length && iFollower == -1
		If JBSlaveFollower[i].GetActorReference() == akSlave as Actor
			iFollower = i
		EndIf
		i += 1
	EndWhile
	If iFollower > -1
		return JBSlaveFollower[iFollower]
	Else
		return None
	EndIf
EndFunction

ReferenceAlias Function GetEmptyFollowerAlias(int index)
	return JBSlaveFollower[index]
EndFunction

;*********************************************************************************************************
;****************************************Helper functions*************************************************
;*********************************************************************************************************

JB:JBSlaveNPCScript Function CreateClone(Actor akTarget, Bool bReset = false)
	;Debug.Notification("JB - Create clone start")

	If (akTarget is WorkshopNPCScript)
		If (akTarget as WorkshopNPCScript).GetWorkshopID() > -1
			WorkshopParent.RemoveActorFromWorkshopPUBLIC(akTarget as WorkshopNPCScript)
		EndIf
	EndIf

	; LeveledActor sourceLeveledActor = None
	; ActorBase sourceActorBase = None
	; If akTarget.HasKeyword(ActorTypeNPC)
	; 	sourceLeveledActor = JBLCharSlave
	; 	sourceActorBase = JBSlaveNPC
	; ElseIf akTarget.HasKeyword(ActorTypeSynth)
	; 	sourceLeveledActor = JBLCharSlaveSynth
	; 	sourceActorBase = JBSlaveSynth
	; ElseIf akTarget.HasKeyword(ActorTypeSuperMutant)
	; 	sourceLeveledActor = JBLCharSlaveSupermutant
	; 	sourceActorBase = JBSlaveSupermutant
	; EndIf

	ActorSourceData actorData = GetSourceActorData(akTarget)

	If actorData.sourceLeveledActor == None || actorData.sourceActorBase == None
		Debug.Notification("Error: Race is incompatible.")
		return None
	EndIf

	ActorBase baseClone = GetSlaveBase(akTarget)

	;int iLevel = akTarget.GetLevel()

	actorData.sourceLeveledActor.Revert()
	actorData.sourceLeveledActor.AddForm(baseClone as Form, 1)

	Actor akTargetClone = akTarget.PlaceAtMe(actorData.sourceActorBase, 1, true, false, false) as Actor

	akTargetClone.SetAlpha(0)

	CopyName(akTarget, akTargetClone)
	CopyStats(akTarget, akTargetClone)

	If akTarget.IsInPowerArmor()
		ObjectReference pArmor = akTarget.PlaceAtMe(PowerArmorFrameFurnitureNoCore, 1, TRUE)
		akTargetClone.SwitchToPowerArmor(pArmor)
	EndIf

	Utility.Wait(0.5)

	TransferOfEquipment(akTarget, akTargetClone)

	; If akTargetClone.HasKeyword(ActorTypeNPC)
	; 	akTargetClone.EquipItem(Collar, true)
	; EndIf

	; If akTargetClone.HasKeyword(ActorTypeSuperMutant) || (!akTargetClone.HasKeyword(ActorTypeNPC) && akTargetClone.HasKeyword(ActorTypeSynth))
	; 	akTargetClone.SetValue(JBIsSubmissive, 100.0)
	; EndIf

	If actorData.sourceLeveledActor == JBLCharSlaveHumanGhoul
		akTargetClone.EquipItem(Collar, true)
	Else
		akTargetClone.SetValue(JBIsSubmissive, 100.0)
	EndIf

	If !bReset
		akTargetClone.Kill()
	EndIf

	Utility.Wait(2.0)

	akTargetClone.SetAlpha(1)
	akTargetClone.EvaluatePackage()

	akTargetClone.StopCombat()
	akTargetClone.StopCombatAlarm()

	JB:JBSlaveNPCScript newSlave = akTargetClone as JB:JBSlaveNPCScript
	
	akTarget.KillEssential()
	If (akTarget.IsDead() == True) && (bReset || JBMCM.RemoveCorpse == true)
		akTarget.MoveTo(JBdeadXRef)
		akTarget.Disable()
	EndIf

	return newSlave
EndFunction

ActorSourceData Function GetSourceActorData(Actor akActor)
	ActorSourceData newData = new ActorSourceData
	Form sourceActorRace = akActor.GetRace() as Form

	If JBCompatibilityQuest.JBRaceHumanGhoulList.HasForm(sourceActorRace)
		;Debug.Notification("Race - Human or Ghoul")
		newData.sourceLeveledActor = JBLCharSlaveHumanGhoul
		newData.sourceActorBase = JBSlaveHumanGhoul
	ElseIf JBCompatibilityQuest.JBRaceSupermutantList.HasForm(sourceActorRace)
		;Debug.Notification("Race - Supermutant")
		newData.sourceLeveledActor = JBLCharSlaveSupermutant
		newData.sourceActorBase = JBSlaveSupermutant
	ElseIf JBCompatibilityQuest.JBRaceGen1SynthList.HasForm(sourceActorRace)
		;Debug.Notification("Race - Gen1Synth")
		newData.sourceLeveledActor = JBLCharSlaveGen1Synth
		newData.sourceActorBase = JBSlaveGen1Synth
	ElseIf JBCompatibilityQuest.JBRaceGen2SynthList.HasForm(sourceActorRace)
		;Debug.Notification("Race - Gen2Synth")
		newData.sourceLeveledActor = JBLCharSlaveGen2Synth
		newData.sourceActorBase = JBSlaveGen2Synth
	Else
		newData.sourceLeveledActor = None
		newData.sourceActorBase = None
	EndIf

	return newData
EndFunction

ActorBase Function GetSlaveBase(Actor akTarget)
	ActorBase TargetBase = akTarget.GetLeveledActorBase().GetTemplate()
	If (!TargetBase)
		TargetBase = akTarget.GetActorBase()
	EndIf
	Return TargetBase
EndFunction

Function CopyStats(Actor sourceActor, Actor targetActor)
	targetActor.SetValue(Game.GetHealthAV(), sourceActor.GetValue(Game.GetHealthAV()))
	;SPECIAL
	targetActor.SetValue(Game.GetStrengthAV(), sourceActor.GetValue(Game.GetStrengthAV()))
	targetActor.SetValue(Game.GetPerceptionAV(), sourceActor.GetValue(Game.GetPerceptionAV()))
	targetActor.SetValue(Game.GetEnduranceAV(), sourceActor.GetValue(Game.GetEnduranceAV()))
	targetActor.SetValue(Game.GetCharismaAV(), sourceActor.GetValue(Game.GetCharismaAV()))
	targetActor.SetValue(Game.GetIntelligenceAV(), sourceActor.GetValue(Game.GetIntelligenceAV()))
	targetActor.SetValue(Game.GetAgilityAV(), sourceActor.GetValue(Game.GetAgilityAV()))
	targetActor.SetValue(Game.GetLuckAV(), sourceActor.GetValue(Game.GetLuckAV()))
	;jb
	targetActor.SetValue(JBIsSubmissive, sourceActor.GetValue(JBIsSubmissive))
	targetActor.SetValue(JBSlaveSexSkill, sourceActor.GetValue(JBSlaveSexSkill))
	targetActor.SetValue(JBSlaveProstituteSkill, sourceActor.GetValue(JBSlaveProstituteSkill))
EndFunction

Function CopyName(Actor sourceActor, Actor targetActor)
	String name = sourceActor.GetDisplayName()
	String cloneName = targetActor.GetDisplayName()
	If name && name != cloneName
		If JBCompatibilityQuest.RenameAnythingInstalled == true
			RenameAnything.SetRefName(targetActor as ObjectReference, name)
			(targetActor as JBSlaveNPCScript).pName = name
		Else
			LL_FourPlay.ObjectReferenceSetSimpleDisplayName(targetActor as ObjectReference, name)
			(targetActor as JBSlaveNPCScript).pName = name
		EndIf
	EndIf
EndFunction

Function TransferOfEquipment(Actor sourceActor, Actor targetActor)
	;targetActor.RemoveAllItems()

	Form[] clothes = New Form[0]
	int index = 0
	int end = 43
	While index <= end
		Form akItem = sourceActor.GetWornItem(index).Item
		Armor akClothe = akItem as Armor
		If akClothe != None && akItem != None && LL_FourPlay.GetActorBaseSkinForm(sourceActor) != akItem
			clothes.Add(akItem)
		EndIf
		index += 1
	EndWhile

	sourceActor.UnequipAll()

	index = 0
	While index < clothes.Length
		sourceActor.RemoveItem(clothes[index], 1, true, targetActor)
		index += 1
	EndWhile

	index = 0
	While index < clothes.Length
   		targetActor.EquipItem(clothes[index], False, True)
	    index += 1
	EndWhile

	Utility.Wait(0.5)

	Form[] items = New Form[0]
	items = sourceActor.GetInventoryItems()
	index = 0
	While index < items.Length
		int count = sourceActor.GetItemCount(items[index])
		sourceActor.RemoveItem(items[index], count, true, targetActor)
		index += 1
	EndWhile

	;sourceActor.RemoveAllItems(targetActor)
EndFunction

ObjectReference[] Function GetWorkshopSlaves(WorkshopScript workshopRef)
	int sCount = JBSlaveCollection.GetCount()
	int sIndex = 0
	;int wIndex = WorkshopParent.GetWorkshopID(workshopRef)
	ObjectReference[] slaves = new ObjectReference[0]
	While sIndex < sCount
		Actor thisSlave = JBSlaveCollection.GetAt(sIndex) as Actor
		WorkshopNPCScript workshopSlave = thisSlave as WorkshopNPCScript
		If workshopSlave.GetWorkshopID() == workshopRef.GetWorkshopID()
			slaves.Add(thisSlave)
		EndIf
		sIndex += 1
	EndWhile
	Return slaves
endFunction

location function AddSlaveToWorkshopPlayerChoice(Actor actorToAssign = NONE, bool bWaitForActorToBeAdded = true, bool bPermanentActor = false)

	; this only works on actors with the workshop script
	WorkShopNPCScript workshopActorToAssign = actorToAssign as WorkShopNPCScript
	if !workshopActorToAssign
		return None
	endif

	keyword keywordToUse = WorkshopParent.WorkshopAssignHome
	if bPermanentActor
		keywordToUse = WorkshopParent.WorkshopAssignHomePermanentActor
	endif

	WorkshopScript previousWorkshop = WorkshopParent.GetWorkshop(workshopActorToAssign.GetWorkshopID())
	Location previousLocation = NONE
	if previousWorkshop
		previousLocation = previousWorkshop.myLocation
	endif

	; 102314: allow non-population actors to be assigned to any workshop
	;FormList excludeKeywordList
	;if workshopActorToAssign.bCountsForPopulation
		;excludeKeywordList = WorkshopParent.WorkshopSettlementMenuExcludeList
	;endif 
	Location newLocation = workshopActorToAssign.OpenWorkshopSettlementMenuEx(akActionKW=keywordToUse, aLocToHighlight=previousLocation)

	if bWaitForActorToBeAdded && newLocation
		; wait for menu to resolve (when called in scenes)
		int failsafeCount = 0
		while failsafeCount < 5 && workshopActorToAssign.GetWorkshopID() == -1
			;wsTrace("...waiting...")
			failsafeCount += 1
			utility.wait(0.5)
		endWhile
	endif
	;wsTrace("AddActorToWorkshopPlayerChoice DONE")

	return newLocation	
endFunction

float raiderFarmingHappinessPenaltyRestore = 3.0 const
;function RestoreRaiderHappinessPenalty(WorkshopDataScript:WorkshopRatingKeyword[] ratings, WorkshopScript workshopRef)
Function RestoreRaiderHappinessPenalty(WorkshopScript workshopRef)
	Utility.Wait(1.0)
	;Debug.Notification("Restore Raider Happiness Penalty")
	ObjectReference[] WorkshopSlaves = GetWorkshopSlaves(workshopRef)

	int i = 0
	float multiResourceProduction = 0.0
	While i < WorkshopSlaves.Length
		;Actor slaveRef = WorkshopSlaves[i] as Actor
		WorkShopNPCScript slaveRef = WorkshopSlaves[i] as WorkShopNPCScript
		;If WorkshopParent.WorkshopRatings[slaveRef.GetValue(JBassignedMultiResource) as int].resourceValue == WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingFood].resourceValue
		If slaveRef.assignedMultiResource == WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingFood].resourceValue
			;multiResourceProduction = multiResourceProduction + slaveRef.GetValue(JBmultiResourceProduction)
			multiResourceProduction = multiResourceProduction + slaveRef.multiResourceProduction
		EndIf
		i += 1
	EndWhile

	int foodProduction = multiResourceProduction as int
	;Debug.Notification("foodProduction "+foodProduction)
	float happinessPenaltyRestore = foodProduction * raiderFarmingHappinessPenaltyRestore
	;Debug.Notification("happinessPenaltyRestore "+happinessPenaltyRestore)
	WorkshopParent.SetHappinessModifier(workshopRef, happinessPenaltyRestore)

	; update happiness stats
	workshopRef.DailyUpdate(false) ; not a "real" update, just to recalc happiness
Endfunction

Function CheckNames()
	Int index = 0
	While index < JBSlaveCollection.GetCount()
		Actor Slave = JBSlaveCollection.GetActorAt(index)
		JB:JBSlaveNPCScript theSlave = Slave as JB:JBSlaveNPCScript
		String storedName = theSlave.pName
		String currentName = Slave.GetDisplayName()
		If (storedName != "") && (storedName != currentName)
			If JBCompatibilityQuest.RenameAnythingInstalled == true
				RenameAnything.SetRefName(Slave as ObjectReference, storedName)
			Else
				LL_FourPlay.ObjectReferenceSetSimpleDisplayName(Slave as ObjectReference, storedName)
			EndIf
		ElseIf (storedName == "")
			If JBCompatibilityQuest.RenameAnythingInstalled == true
				RenameAnything.SetRefName(Slave as ObjectReference, currentName)
				theSlave.pName = currentName
			Else
				LL_FourPlay.ObjectReferenceSetSimpleDisplayName(Slave as ObjectReference, currentName)
				theSlave.pName = currentName
			EndIf
		EndIf
		index += 1
	EndWhile
EndFunction

;*********************************************************************************************************
;****************************************Update functions*************************************************
;*********************************************************************************************************

Event Actor.OnPlayerLoadGame(actor aSender)
	If currentModVersion != previousModVersion
		Update()
		previousModVersion = currentModVersion
	EndIf
	RegisterCustomEvents()
	CheckNames()
EndEvent

Event OnPlayerTeleport()
	;Debug.Notification("OnPlayerTeleport Event")
	CheckNames()
EndEvent

Function RegisterCustomEvents()
	RegisterForPlayerTeleport()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
	;RegisterForCustomEvent(WorkshopParent, "WorkshopEnterMenu")
	RegisterForCustomEvent(WorkshopParent, "WorkshopActorAssignedToWork")
	RegisterForCustomEvent(WorkshopParent, "WorkshopActorUnassigned")
	RegisterForCustomEvent(WorkshopParent, "WorkshopDailyUpdate")
	RegisterForCustomEvent(WorkshopParent, "WorkshopObjectBuilt")
	RegisterForCustomEvent(WorkshopParent, "WorkshopObjectDestroyed")
	;RegisterForCustomEvent(DLC04WorkshopParent, "DLC04WorkshopRaiderSettlementEvent")
	RegisterForCustomEvent(DLC04WorkshopParent, "DLC04WorkshopVassalSettlementEvent")
	;RegisterForExternalEvent("OnMCMSettingChange|Just Business", "OnMCMSettingChange")
EndFunction

Function UpdateScriptRegistration()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterCustomEvents()
EndFunction

Function Update()
	;Script Registers Update
	UpdateScriptRegistration()
	JBMCM.UpdateScriptRegistration()
	JBSexEvents.UpdateScriptRegistration()
	JBCompatibilityQuest.UpdateScriptRegistration()

	;Update for new system
	Int index = 0
	Actor[] tempSaveList = new Actor[0]
	While index < JBSlaveCollection.GetCount()
		Actor Slave = JBSlaveCollection.GetActorAt(index)
		JB:JBSlaveNPCScript theSlave = Slave as JB:JBSlaveNPCScript
		If !theSlave
			tempSaveList.Add(Slave)
		EndIf
		index += 1
	EndWhile

	If tempSaveList.Length > 0
		Debug.Notification("JB - "+tempSaveList.Length+" slaves need updating")
		Debug.Notification("JB - Slaves upgrade - Wait...")
		index = 0
		While index < tempSaveList.Length
			Debug.Notification("JB - Cleaning of collections")
			Actor tActor = tempSaveList[index]
			If JBSlaveCollection.Find(tActor) > -1
				JBSlaveCollection.RemoveRef(tActor)
			EndIf
			If JBSlaveFollowersCollection.Find(tActor) > -1
				JBSlaveFollowersCollection.RemoveRef(tActor)
			EndIf
			; If JBWorkshopSlaveCollection.Find(tActor) > -1
			; 	JBWorkshopSlaveCollection.RemoveRef(tActor)
			; EndIf
			; If JBCaravanSlaveCollection.Find(tActor) > -1
			; 	JBCaravanSlaveCollection.RemoveRef(tActor)
			; EndIf
			If JBProstituteSlaveCollection.Find(tActor) > -1
				JBProstituteSlaveCollection.RemoveRef(tActor)
			EndIf
			int i = 0
			While i < JBSlaveFollower.Length
				If JBSlaveFollower[i].GetActorReference() == tActor
					JBSlaveFollower[i].Clear()
				EndIf
				i += 1
			EndWhile
			index += 1
		EndWhile
		Utility.Wait(1.5)
		index = 0
		While index < tempSaveList.Length
			Utility.Wait(0.5)
			Actor slaveForUpgrade = tempSaveList[index]
			Utility.Wait(0.5)
			WorkshopScript workshopRef = WorkshopParent.GetWorkshop(slaveForUpgrade.GetValue(WorkshopParent.workshopIDActorValue) as int)
			JB:JBSlaveNPCScript upgradedSlave = CreateClone(slaveForUpgrade, true)
			Utility.Wait(0.5)
			upgradedSlave.SlaveRelax()
			Utility.Wait(0.5)
			If workshopRef
				WorkshopParent.AddActorToWorkshopPUBLIC(((upgradedSlave as Actor) as WorkshopNPCScript), workshopRef)
			EndIf
			If upgradedSlave
				Debug.Notification("JB - Slave index - ["+index+"] - updated successfully")
			Else
				Debug.Notification("JB - Slave index - ["+index+"] - UPDATE ERROR")
			EndIf
			index += 1
		EndWhile
		Debug.Notification("JB - Slaves upgrade - Done.")
		tempSaveList.Clear()
	Else
		Debug.Notification("JB - Slaves do not need to be updated")
	EndIf

	If (Game.GetPlayer().HasPerk(JBMCM.JBHuntingPerk))
		JBMCM.JBbIsHunterModeActivated = true
	Else
		JBMCM.JBbIsHunterModeActivated = false
	EndIf
	If (Game.GetPlayer().HasPerk(JBMCM.JBRenamePerk))
		JBMCM.JBbIsRenameModeActivated = true
	Else
		JBMCM.JBbIsRenameModeActivated = false
	EndIf
	If (Game.GetPlayer().HasPerk(JBMCM.JBAdditionalDialogsPerk))
		JBMCM.JBbIsAdditionalDialogsModeActivated = true
	Else
		JBMCM.JBbIsAdditionalDialogsModeActivated = false
	EndIf

	if (Game.GetPlayer().GetItemCount(JBSCSHolotape) == 0)
		Game.GetPlayer().AddItem(JBSCSHolotape)
	endIf

	JBUpdateMSG.Show()
EndFunction

;********************************************************************************************************
;****************************************Debug functions*************************************************
;********************************************************************************************************

Function ResetSlave(Actor akTarget)
	If JBQuartermasteryAlias.GetActorReference() == akTarget
		(akTarget as JB:JBSlaveNPCScript).AssignedQuartermastery(false)
	EndIf
	(akTarget as JB:JBSlaveNPCScript).SlaveRelax()
	JBSlaveCollection.RemoveRef(akTarget)
	; If JBWorkshopSlaveCollection.Find(akTarget) > -1
	; 	JBWorkshopSlaveCollection.RemoveRef(akTarget)
	; EndIf

	JB:JBSlaveNPCScript rSlave = CreateClone(akTarget, true)

	;(rSlave as Actor).SetValue(JBIsSubmissive, akTarget.GetValue(JBIsSubmissive))
	;(rSlave as Actor).SetValue(JBSlaveSexSkill, akTarget.GetValue(JBSlaveSexSkill))
	;(rSlave as Actor).SetValue(JBSlaveProstituteSkill, akTarget.GetValue(JBSlaveProstituteSkill))
EndFunction

function jbTrace(string traceString, int severity = 0, bool bNormalTraceAlso = false) DebugOnly
	debug.traceUser(userlogName, " " + traceString, severity)
;	if bNormalTraceAlso
;		;debug.Trace(self + " " + traceString, severity)
;	endif
endFunction

Function OpenLog()
	debug.OpenUserLog(userlogName)
EndFunction
