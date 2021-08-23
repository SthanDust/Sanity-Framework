Scriptname JB:JBSlaveNPCScript extends Actor Conditional


WorkshopParentScript Property WorkshopParent Auto Const Mandatory
JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory
JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory
JB:JBProstitutesQuestScript Property JBProstitutesQuest Auto Const Mandatory
JB:JBTradeQuestScript Property JBTradeQuest Auto Const Mandatory
JB:JBConvoyQuestScript Property JBConvoyQuest Auto Const Mandatory
JB:JBCompatibilityQuestScript Property JBCompatibilityQuest Auto Const Mandatory

FormList Property JBBlackListRacesOfClients Auto Const

String Property pName = "" Auto

Int Property JBSlaveCost Auto
Int Property JBProstituteCost Auto

Bool Property bIsJBFollower = false Auto Conditional
Bool Property bIsProstitute = false Auto Conditional
Bool Property bIsConvoyHead = false Auto Conditional
Bool Property bIsConvoyGuard = false Auto Conditional

Bool Property bIsProstituteGoToWorkplace = false Auto Conditional

Int Property iSexualAttitudes = 0 Auto Conditional
{
	0 - any gender
	1 - their sex
	2 - opposite sex
}

Group Messages
	Message Property JBMsgSlaveActivate Auto Const
	Message Property JBMsgProstituteActivate Auto Const
	Message Property JBMsgHeadGuardActivate Auto Const
	Message Property JBMsgConvoyGuardActivate Auto Const
	Message Property JBSlaveCostMSG Auto Const
EndGroup

; timer IDs
int slaveStatsTimerID = 0 const
int prostituteSearchCustomerTimerID = 1 const

; update timer
float updateSlaveStatsInterval = 1.0 const

Event OnInit()
	int aliasIndex = JBSlaveQuest.GetEmptySlaveFollowerIndex()
	If aliasIndex == -1
		;bIsJBRelax = true
		;akNewSlave.SetValue(JBIsWorkStatus, 4)
	Else
		JBSlaveQuest.JBSlaveFollowersCollection.addRef(self)
		JBSlaveQuest.JBSlaveFollower[aliasIndex].ForceRefTo(self)
		If JBMCM.bAllowTeleportToInstitute
			RegisterForTeleport()
		EndIf

		bIsJBFollower = true
		;akNewSlave.SetValue(JBIsWorkStatus, 3)

		SetCommandMode()
	EndIf
	IgnoreFriendlyHits()
	JBSlaveQuest.JBSlaveCollection.AddRef(self)
	int sCount = JBSlaveQuest.JBSlaveCollection.GetCount()
	Debug.Notification((JBSlaveQuest.JBSlaveCountMSG as Form).GetName()+" "+sCount)

	If JBMCM.SlaveDontUseAmmo
		AddKeyword(JBSlaveQuest.TeammateDontUseAmmoKeyword)
	EndIf

	SetActivateTextOverride(JBMsgSlaveActivate)

	StartTimerGameTime(updateSlaveStatsInterval, slaveStatsTimerID)
EndEvent

Function SetCommandMode(bool bSet = true)
	SetCanDoCommand(bSet)
	SetCommandState(bSet)
	SetPlayerTeammate(bSet)
EndFunction

Function UpdateSubmissive()
	If GetValue(JBSlaveQuest.JBIsSubmissive) < 100
		If bIsJBFollower
			ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.5)
		ElseIf HasKeyword(JBSlaveQuest.JBSlaveRestricted)
			ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 1.0)
		ElseIf ((self as Actor) as WorkshopNPCScript).bIsWorker
			ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.2)
		ElseIf bIsProstitute
			ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.3)
		Else
			ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.1)
		EndIf
	EndIf
EndFunction

;*********************************************************************************************************
;****************************************Command functions************************************************
;*********************************************************************************************************

Function SlaveGoHome()
	Location newLocation = JBSlaveQuest.AddSlaveToWorkshopPlayerChoice(self as Actor, true, true)
	If newLocation
		If bIsJBFollower
			If JBMCM.bAllowTeleportToInstitute
				RegisterForTeleport(false)
			EndIf
			If JBTradeQuest.Product.GetActorRef() == self as Actor
				JBTradeQuest.RemoveFromSale()
			EndIf
			If JBSexEvents.ControlledProstitute.GetActorRef() == self as Actor
				JBProstitutesQuest.RemoveFromProstitution()
			EndIf
			ReferenceAlias Follower = JBSlaveQuest.GetFollowerAlias(self)
			Follower.Clear()
			bIsJBFollower = false
		EndIf
		If JBSlaveQuest.JBSlaveFollowersCollection.Find(self) > -1
			JBSlaveQuest.JBSlaveFollowersCollection.RemoveRef(self)
		EndIf
		If JBSlaveQuest.JBProstituteSlaveCollection.Find(self) > -1
			SetAsProstitute(false)
		EndIf
		If GetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue) > 0
			ResetHappinesBonus()
		EndIf
		; If JBSlaveQuest.JBWorkshopSlaveCollection.Find(self) < 0
		; 	JBSlaveQuest.JBWorkshopSlaveCollection.AddRef(self)
		; EndIf
		SetCommandMode(false)
		EvaluatePackage()
	EndIf
EndFunction

Function SlaveFollow()
	int aliasIndex = JBSlaveQuest.GetEmptySlaveFollowerIndex()
	If aliasIndex == -1
		return
	Else
		ReferenceAlias Follower = JBSlaveQuest.GetEmptyFollowerAlias(aliasIndex)
		Follower.ForceRefTo(self)
		If JBMCM.bAllowTeleportToInstitute
			RegisterForTeleport()
		EndIf
	EndIf

	WorkshopNPCScript workshopSlave = (self as Actor) as WorkshopNPCScript

	If workshopSlave.GetWorkshopID() > -1
		WorkshopParent.RemoveActorFromWorkshopPUBLIC(workshopSlave)
		;UnassignSlave(akTargetSlave, true, false)
	EndIf

	SetCommandMode()
	bIsJBFollower = true

	;akTargetSlave.SetValue(JBIsWorkStatus, 3)

	; If JBSlaveQuest.JBWorkshopSlaveCollection.Find(self) > -1
	; 	JBSlaveQuest.JBWorkshopSlaveCollection.RemoveRef(self)
	; EndIf
	If JBSlaveQuest.JBProstituteSlaveCollection.Find(self) > -1
		SetAsProstitute(false)
	EndIf
	If JBSlaveQuest.JBSlaveFollowersCollection.Find(self) < 0
		JBSlaveQuest.JBSlaveFollowersCollection.AddRef(self)
	EndIf
	If bIsConvoyHead || bIsConvoyGuard
		SetToConvoy(false, bIsConvoyHead)
	EndIf
	If JBConvoyQuest.ConvoyPrisoners.Find(self) > -1
		SetAsConvoyPrisoner(false)
	EndIf
	If GetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue) > 0
		ResetHappinesBonus()
	EndIf

	EvaluatePackage()

EndFunction

Function SlaveRelax()
	If bIsJBFollower
		If JBMCM.bAllowTeleportToInstitute
			RegisterForTeleport(false)
		EndIf
		If JBTradeQuest.Product.GetActorRef() == self as Actor
			JBTradeQuest.RemoveFromSale()
		EndIf
		If JBSexEvents.ControlledProstitute.GetActorRef() == self as Actor
			JBProstitutesQuest.RemoveFromProstitution()
		EndIf
		ReferenceAlias Follower = JBSlaveQuest.GetFollowerAlias(self)
		Follower.Clear()
		bIsJBFollower = false
	EndIf

	SetCommandMode(false)

	WorkshopNPCScript workshopSlave = (self as Actor) as WorkshopNPCScript

	bool workshopMode = false
	If workshopSlave.GetWorkshopID() > -1
		workshopMode = true
	EndIf

	If workshopMode
		;akTargetSlave.SetValue(JBIsWorkStatus, 0)
		WorkshopParent.UnassignActor(workshopSlave)
	Else
		;akTargetSlave.SetValue(JBIsWorkStatus, 4)
	EndIf

	If JBSlaveQuest.JBSlaveFollowersCollection.Find(self) > -1
		JBSlaveQuest.JBSlaveFollowersCollection.RemoveRef(self)
	EndIf

	If JBSlaveQuest.JBProstituteSlaveCollection.Find(self) > -1
		SetAsProstitute(false)
		; If workshopMode
		; 	JBSlaveQuest.JBWorkshopSlaveCollection.AddRef(self)
		; EndIf
	EndIf

	If GetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue) > 0
		ResetHappinesBonus()
	EndIf

	EvaluatePackage()
EndFunction

;*********************************************************************************************************
;************************************Quartermastery functions*********************************************
;*********************************************************************************************************

Function AssignedQuartermastery(bool bSet = true)
	JB:JBQuartermasteryBrahminScript Brahmin = (JBSlaveQuest.JBQuartermasteryBrahminRef as ObjectReference) as JB:JBQuartermasteryBrahminScript
	WorkshopNPCScript theSlave = (self as Actor) as WorkshopNPCScript
	If bSet
		If Game.GetPlayer().HasPerk(JBSlaveQuest.JBWorkshopBrahminPerk) == false
			Game.GetPlayer().AddPerk(JBSlaveQuest.JBWorkshopBrahminPerk)
		EndIf
		Brahmin.OwnedByPlayer = true
		Brahmin.BlockActivation(false)
		JBSlaveQuest.JBQuartermasteryAlias.ForceRefTo(self)
		JBSlaveQuest.JBQuartermasteryBrahminRef.MoveTo(self)
		JBSlaveQuest.JBQMBrahminAlias.ForceRefTo(JBSlaveQuest.JBQuartermasteryBrahminRef)
		;SetWorkshopStatus(akActor, false)
		If !bIsJBFollower
			SlaveFollow()
		EndIf
		If JBTradeQuest.Product.GetActorRef() == self as Actor
			JBTradeQuest.RemoveFromSale()
		EndIf
		If JBSexEvents.ControlledProstitute.GetActorRef() == self as Actor
			JBProstitutesQuest.RemoveFromProstitution()
		EndIf
	Else
		If Game.GetPlayer().HasPerk(JBSlaveQuest.JBWorkshopBrahminPerk) == true
			Game.GetPlayer().RemovePerk(JBSlaveQuest.JBWorkshopBrahminPerk)
		EndIf
		Brahmin.OwnedByPlayer = false
		Brahmin.BlockActivation(true)
		JBSlaveQuest.JBQuartermasteryAlias.Clear()
		theSlave.SetWorkshopStatus(true) ;???????
	EndIf
EndFunction

;*********************************************************************************************************
;**************************************Prostitute functions***********************************************
;*********************************************************************************************************

Function SetAsProstitute(bool bSet = true)
	If bSet

		WorkshopNPCScript theSlave = (self as Actor) as WorkshopNPCScript

		;Debug.Notification("Slave set as prostitute")
		If bIsJBFollower
			If JBMCM.bAllowTeleportToInstitute
				RegisterForTeleport(false)
			EndIf
			If JBTradeQuest.Product.GetActorRef() == self as Actor
				JBTradeQuest.RemoveFromSale()
			EndIf
			If JBSexEvents.ControlledProstitute.GetActorRef() == self as Actor
				JBProstitutesQuest.RemoveFromProstitution()
			EndIf
			ReferenceAlias Follower = JBSlaveQuest.GetFollowerAlias(self)
			Follower.Clear()
			bIsJBFollower = false
		EndIf

		SetCommandMode(false)

		bool workshopMode = false
		If theSlave.GetWorkshopID() > -1
			workshopMode = true
		EndIf

		If workshopMode
			WorkshopParent.UnassignActor(theSlave)
		EndIf

		; If JBSlaveQuest.JBWorkshopSlaveCollection.Find(self) > -1
		; 	JBSlaveQuest.JBWorkshopSlaveCollection.RemoveRef(self)
		; EndIf

		If JBSlaveQuest.JBSlaveFollowersCollection.Find(self) > -1
			JBSlaveQuest.JBSlaveFollowersCollection.RemoveRef(self)
		EndIf

		ObjectReference prostituteMarker = self.PlaceAtMe(JBSlaveQuest.XMarker, 1, true, false, false)
		self.SetLinkedRef(prostituteMarker, JBSlaveQuest.JBWorkplaceProstitutes)

		;akSlave.SetValue(JBIsWorkStatus, 6)
		bIsProstitute = true
		JBSlaveQuest.JBProstituteSlaveCollection.AddRef(self)

		;CreateSlaveData(akSlave)

		ProstituteSearchCustomer()

		SetActivateTextOverride(JBMsgProstituteActivate)

		EvaluatePackage()
	Else
		;int index = SlavesData.FindStruct("Slave", akSlave)
		;SlaveData sd = GetSlaveData(akSlave)
		bIsProstitute = false
		CancelTimer(prostituteSearchCustomerTimerID)
		;SlavesData.Remove(index)
		ObjectReference prostituteMarker = self.GetLinkedRef(JBSlaveQuest.JBWorkplaceProstitutes)
		If prostituteMarker != None
			self.SetLinkedRef(None, JBSlaveQuest.JBWorkplaceProstitutes)
			prostituteMarker.Delete()
		EndIf
		If JBSlaveQuest.JBProstituteSlaveCollection.Find(self) > -1
			JBSlaveQuest.JBProstituteSlaveCollection.RemoveRef(self)
		EndIf
		SetActivateTextOverride(JBMsgSlaveActivate)
	EndIf
EndFunction

Function ProstituteSearchCustomer()
	;Debug.Notification("Prostitue search customer - start")
	;SlaveData sd = GetSlaveData(akSlave)
	If Is3DLoaded()
		Actor Customer = Game.FindRandomActorFromRef(self, JBMCM.prostituteSearchCustomerRadius)
		If Customer && Customer.HasKeyword(JBSlaveQuest.ActorTypeNPC) && !Customer.IsHostileToActor(self as Actor) && !Customer.IsInCombat() && !Customer.IsInFaction(JBSlaveQuest.JBSlaveFaction) && Customer != Game.GetPlayer() && !Customer.HasKeyword(JBSexEvents.GetAAFActorBusy()) && !JBBlackListRacesOfClients.HasForm(Customer.GetRace() as Form) && CheckSexualInstructions(Customer)
			;Debug.Notification("Prostitute find customer")
			If JBSexEvents.SlaveProstitute.GetActorReference() == none || JBSexEvents.clientForProstitute.GetActorReference() == none
				TryToSellBody((self as Actor), Customer)
			Else
				;Debug.Notification("Prostitute aliases not empty")
				StartTimer(JBMCM.prostituteSearchCustomerInterval, prostituteSearchCustomerTimerID)
			EndIf
		Else
			;Debug.Notification("Prostitute not find customer")
			StartTimer(JBMCM.prostituteSearchCustomerInterval, prostituteSearchCustomerTimerID)
		EndIf
	Else
		If Utility.RandomInt() > 50
			int check = CalculateCustomerAgree()
			If check < 0
				StartTimer(JBMCM.prostituteSearchCustomerInterval, prostituteSearchCustomerTimerID)
			Else
				int price = CalculateCostProstitute()
				AddItem(Game.GetCaps(), price)
				If (GetValue(JBSlaveQuest.JBSlaveSexSkill) < 100) ;&& (JBSlaveQuest.JBSlaveCollection.Find(self) > -1)
					;akSlave.SetValue(JBSlaveSexSkill, akSlave.GetValue(JBSlaveSexSkill)+0.3)
					ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveSexSkill, 0.3)
				EndIf
				If (GetValue(JBSlaveQuest.JBSlaveProstituteSkill) < 100) ;&& (JBSlaveQuest.JBProstituteSlaveCollection.Find(self) > -1)
					;akSlave.SetValue(JBSlaveProstituteSkill, akSlave.GetValue(JBSlaveProstituteSkill)+0.5)
					ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveProstituteSkill, 0.5)
				EndIf
				StartTimer(JBMCM.prostituteSearchCustomerInterval, prostituteSearchCustomerTimerID)
			EndIf
		Else
			StartTimer(JBMCM.prostituteSearchCustomerInterval, prostituteSearchCustomerTimerID)
		EndIf
	EndIf
EndFunction

Bool Function CheckSexualInstructions(Actor akActor)
	ActorBase Customer = JBSlaveQuest.GetSlaveBase(akActor)
	ActorBase Prostitute = JBSlaveQuest.GetSlaveBase(self as Actor)
	int iCustomerSex = Customer.GetSex()
	int iProstituteSex = Prostitute.GetSex()
	If iSexualAttitudes == 0
		return true
	ElseIf iSexualAttitudes == 1
		If iCustomerSex == iProstituteSex
			return true
		Else
			return false
		EndIf
	ElseIf iSexualAttitudes == 2
		If iCustomerSex != iProstituteSex
			return true
		Else
			return false
		EndIf
	EndIf
EndFunction

Function ProstituteCustomerConversationStart()
	int check = CalculateCustomerAgree()
	If check < 0
		JBSexEvents.JBProstituteCustomerNoScene01.Start()
	Else
		JBSexEvents.JBProstituteCustomerYesScene01.Start()
	EndIf
	;SlaveProstitute.GetActorReference().SetValue(JBbIsWorker, 0)
EndFunction

Function TryToSellBody(Actor akSlave, Actor akCustomer)
	JBSexEvents.SlaveProstitute.ForceRefTo(akSlave)
	JBSexEvents.clientForProstitute.ForceRefTo(akCustomer)
	;akSlave.SetValue(JBbIsWorker, 1)
	akSlave.EvaluatePackage()
	akCustomer.EvaluatePackage()
	;ProstituteCustomerSex()
EndFunction

int Function CalculateCustomerAgree()
	int rand = Utility.RandomInt(0, 130)
	int skill = Math.Floor(GetValue(JBSlaveQuest.JBSlaveProstituteSkill))
	int check = (skill - rand) + 20
	return check
EndFunction

int Function CalculateCostProstitute()
	int startCost = 5
	;int sexValue = Math.Floor(Math.Sqrt(GetValue(JBSlaveQuest.JBSlaveSexSkill)))
	;int prostituteValue = Math.Floor(Math.Sqrt(GetValue(JBSlaveQuest.JBSlaveProstituteSkill)))
	float sexValue = Math.Sqrt(GetValue(JBSlaveQuest.JBSlaveSexSkill))
	float prostituteValue = Math.Sqrt(GetValue(JBSlaveQuest.JBSlaveProstituteSkill))
	;int cost = startCost * sexValue * prostituteValue
	int cost = Math.Ceiling(startCost * sexValue * prostituteValue)
	If cost <= 0
		JBProstituteCost = startCost
	Else
		JBProstituteCost = cost
	EndIf
	;Debug.Notification("JBProstituteCost - "+JBProstituteCost)
	return JBProstituteCost
EndFunction

Function OfferForProstitution()
	JBSexEvents.ControlledProstitute.ForceRefTo(self)
	;CalculateCostProstitute()
	;JBProstitutesQuest.PlayerOffersProstitute()
	JBProstitutesQuest.availableForProstitution = true
EndFunction

;*********************************************************************************************************
;****************************************Trade functions*************************************************
;*********************************************************************************************************

Function OfferForSale()
	JBTradeQuest.Product.ForceRefTo(self)
	CalculateCostSlave()
	JBTradeQuest.availableForSale = true
EndFunction

Function CalculateCostSlave()
	float submissiveValue = Math.Sqrt(GetValue(JBSlaveQuest.JBIsSubmissive))
	float sexValue = Math.Sqrt(GetValue(JBSlaveQuest.JBSlaveSexSkill))
	float prostituteValue = Math.Sqrt(GetValue(JBSlaveQuest.JBSlaveProstituteSkill))
	int cost = 100 * Math.Ceiling(submissiveValue + sexValue + prostituteValue)
	If cost <= 0
		cost = 100
	EndIf
	JBSlaveCost = cost
	Debug.Notification((JBSlaveCostMSG as Form).GetName()+" - "+JBSlaveCost)
EndFunction

;*********************************************************************************************************
;******************************************Convoy functions***********************************************
;*********************************************************************************************************

Function SetToConvoy(bool bSet, bool bAsHead)
	If bSet
		If bAsHead
			JBConvoyQuest.HeadGuard.ForceRefTo(self)
			JBConvoyQuest.bConvoyHeadAppointed = true
		Else
			ReferenceAlias Guard = JBConvoyQuest.GetGuardAlias()
			Guard.ForceRefTo(self)
			JBConvoyQuest.iNumberOfGuards += 1
		EndIf
	Else
		If bAsHead
			JBConvoyQuest.HeadGuard.Clear()
			JBConvoyQuest.bConvoyHeadAppointed = false
			JBConvoyQuest.ClearConvoyGuardsArray()
		Else
			ReferenceAlias Guard = JBConvoyQuest.GetGuardAlias(self)
			Guard.Clear()
			JBConvoyQuest.iNumberOfGuards -= 1
		EndIf
	EndIf
	SetGuardData(bSet, bAsHead)
EndFunction

Function SetGuardData(Bool bSet, Bool bAsHead)
	If bSet
		If bAsHead
			bIsConvoyHead = true
			SetActivateTextOverride(JBMsgHeadGuardActivate)
		Else
			bIsConvoyGuard = true
			SetActivateTextOverride(JBMsgConvoyGuardActivate)
		EndIf
	Else
		If bAsHead
			bIsConvoyHead = false
		Else
			bIsConvoyGuard = false
		EndIf
		SetActivateTextOverride(JBMsgSlaveActivate)
	EndIf
	EvaluatePackage()
EndFunction

Function SetAsConvoyPrisoner(bool bSet = true)
	If bSet
		JBConvoyQuest.ConvoyPrisoners.AddRef(self)
		SlaveRelax()
	Else
		JBConvoyQuest.ConvoyPrisoners.RemoveRef(self)
	EndIf
EndFunction

;*********************************************************************************************************
;****************************************Helper functions*************************************************
;*********************************************************************************************************

Function StartProstituteTimer()
	CancelTimer(prostituteSearchCustomerTimerID)
	StartTimer(JBMCM.prostituteSearchCustomerInterval, prostituteSearchCustomerTimerID)
EndFunction

Function RegisterForTeleport(bool bSet = true)
	If bSet
		self.RegisterForPlayerTeleport()
	Else
		self.UnregisterForPlayerTeleport()
	EndIf
EndFunction

; Function RegisterForRestrictedFurniture(ObjectReference akFurniture = None, bool bSet = true)
; 	If bSet
; 		RegisterForFurnitureEvent(akFurniture)
; 	Else
; 		UnregisterForFurnitureEvent()
; 	EndIf
; EndFunction

Function ChangeSlaveSkillValue(ActorValue akAV, Float akValue)
	SetValue(akAV, GetValue(akAV) + akValue)
	If GetValue(akAV) > 99.9
		SetValue(akAV, 100)
	EndIf
EndFunction

Function ResetHappinesBonus()
	SetValue(WorkshopParent.WorkshopRatings[WorkshopParent.WorkshopRatingBonusHappiness].resourceValue, 0.0)
EndFunction

;*********************************************************************************************************
;************************************************Events***************************************************
;*********************************************************************************************************

Event OnLoad()
	Form SlaveRace = ((self as Actor).GetRace()) as Form

	If pName != (self as ObjectReference).GetDisplayName()
		If JBCompatibilityQuest.RenameAnythingInstalled == true
			RenameAnything.SetRefName((self as ObjectReference), pName)
		Else
			LL_FourPlay.ObjectReferenceSetSimpleDisplayName((self as ObjectReference), pName)
		EndIf
	EndIf

	If JBCompatibilityQuest.JBRaceHumanGhoulList.HasForm(SlaveRace) && !IsEquipped(JBSlaveQuest.Collar) && GetValue(JBSlaveQuest.JBIsSubmissive) < 100
		EquipItem(JBSlaveQuest.Collar, true)
	EndIf
EndEvent

Event OnTimerGameTime(int aiTimerID)
	if aiTimerID == slaveStatsTimerID
		UpdateSubmissive()
		; start timer again
		StartTimerGameTime(updateSlaveStatsInterval, slaveStatsTimerID)
	endif
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == prostituteSearchCustomerTimerID
		ProstituteSearchCustomer()
	EndIf
EndEvent

Event OnPlayerTeleport()
	MoveTo(Game.GetPlayer())
EndEvent

Event OnCommandModeGiveCommand(int aeCommandType, ObjectReference akTarget)
	If aeCommandType == 2 && JBMCM.bAllowTeleportToInstitute == true && bIsJBFollower == true
		RegisterForTeleport()
	ElseIf aeCommandType == 7 && JBMCM.bAllowTeleportToInstitute == true && bIsJBFollower == true
		RegisterForTeleport(false)
	EndIf
EndEvent

Event OnCommandModeEnter()
	; If bIsJBFollower == true
	; 	JBSlaveQuest.followerInCommandMode = true
	; EndIf
EndEvent

Event OnCommandModeExit()
	; If bIsJBFollower == true
	; 	JBSlaveQuest.followerInCommandMode = false
	; EndIf
EndEvent

; Event OnFurnitureEvent(Actor akActor, ObjectReference akFurniture, bool isGettingUp)
; 	If JBSlaveQuest.JBRestrictList.HasForm(akFurniture.GetBaseObject()) && isGettingUp
; 		If akFurniture.GetActorRefOwner() != self as Actor
; 			RemoveKeyword(JBSlaveQuest.JBSlaveRestricted)
; 			RegisterForRestrictedFurniture(None, false)
; 		EndIf
; 	EndIf
; EndEvent

Event OnGetUp(ObjectReference akFurniture)
	;Debug.Notification("We just got up from Furniture")
	If JBSlaveQuest.JBRestrictList.HasForm(akFurniture.GetBaseObject())
		;Debug.Notification("This is restricted Furniture")
		If akFurniture.GetActorRefOwner() != self as Actor && (self as Actor).HasKeyword(JBSlaveQuest.JBSlaveRestricted)
			;Debug.Notification("JBSlaveRestricted Remove")
			RemoveKeyword(JBSlaveQuest.JBSlaveRestricted)
		EndIf
	EndIf
endEvent
