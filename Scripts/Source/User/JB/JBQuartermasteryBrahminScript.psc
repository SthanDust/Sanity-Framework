Scriptname JB:JBQuartermasteryBrahminScript extends workshopscript


Actor Property JBQuartermasteryBrahminRef Auto Const

Message Property JBHereAnotherWorkshopMSG Auto Const

bool Property bWait = false Auto Conditional

Event OnLoad()
	RegisterForRemoteEvent(JBQuartermasteryBrahminRef, "OnLocationChange")
	; for now, block activation if not "owned" by player
	;BlockActivation(!OwnedByPlayer)
	If WorkshopParent.WorkshopLocations.Find(GetCurrentLocation()) < 0
		BlockActivation(false)
	Else
		BlockActivation(true)
	EndIf
	; grab inventory from linked container if I'm a container myself
	; if (GetBaseObject() as Container)
	; 	; get linked container
	; 	ObjectReference linkedContainer = GetLinkedRef(WorkshopParent.WorkshopLinkContainer)
	; 	if linkedContainer
	; 		linkedContainer.RemoveAllItems(self)
	; 	endif

	; 	; get all linked containers (children)
	; 	ObjectReference[] linkedContainers = GetLinkedRefChildren(WorkshopParent.WorkshopLinkContainer)
	; 	int i = 0
	; 	while i < linkedContainers.Length
	; 		linkedContainer = linkedContainers[i]
	; 		if linkedContainer
	; 			linkedContainer.RemoveAllItems(self)
	; 		endif
	; 		i += 1
	; 	endWhile
	; endif

	; if no location (this is not a settlement location so skipped WorkshopParent init process), get current location
	;if !myLocation
		;myLocation = GetCurrentLocation()
	;endif
EndEvent

; block activation until player "owns" this workbench
Event OnActivate(ObjectReference akActionRef)
	;;debug.trace(self + "OnActivate")
	if akActionRef == Game.GetPlayer()
		CheckOwnership()
		;Debug.Notification("WorkshopID = "+GetWorkshopID())

		if OwnedByPlayer && WorkshopParent.WorkshopLocations.Find(GetCurrentLocation()) < 0
			;Debug.Notification("GetCurrentLocation = "+WorkshopParent.WorkshopLocations.Find(GetCurrentLocation()))
			; go into workshop mode
			StartWorkshop()
		Else
			;Debug.Notification("GetCurrentLocation = "+WorkshopParent.WorkshopLocations.Find(GetCurrentLocation()))
			;Debug.Notification("Here is another workshop")
			JBHereAnotherWorkshopMSG.Show()
		endif
	endif
EndEvent

Event OnWorkshopMode(bool aStart)
	;debug.trace(self + " OnWorkshopMode " + aStart)
	if aStart
		if OwnedByPlayer
			; make this the current workshop
			WorkshopParent.SetCurrentWorkshop(self)
		endif

		Var[] kargs = new Var[2]
		kargs[0] = NONE
		kargs[1] = self
		;WorkshopParent.wsTrace(" 	sending WorkshopEnterMenu event")
		WorkshopParent.SendCustomEvent("WorkshopEnterMenu", kargs)		
	endif

	; Dogmeat scene
	;if aStart && WorkshopParent.DogmeatAlias.GetRef()
		;WorkshopParent.WorkshopDogmeatWhileBuildingScene.Start()
	;else
		;WorkshopParent.WorkshopDogmeatWhileBuildingScene.Stop()
	;endif

	; Companion scene
	;debug.trace(self + " OnWorkshopMode " + WorkshopParent.CompanionAlias.GetRef())
	;if aStart && WorkshopParent.CompanionAlias.GetRef()
		;debug.trace(self + " starting WorkshopParent.WorkshopCompanionWhileBuildingScene")
		;WorkshopParent.WorkshopCompanionWhileBuildingScene.Start()
	;else
		;WorkshopParent.WorkshopCompanionWhileBuildingScene.Stop()
	;endif

	if !aStart
		; show message if haven't before
		if ShowedWorkshopMenuExitMessage == false
			;ShowedWorkshopMenuExitMessage = true
			WorkshopParent.WorkshopExitMenuMessage.ShowAsHelpMessage("WorkshopMenuExit", 10.0, 0, 1, "NoMenu")
		endif
		; make sure resources stay assigned
		;WorkshopParent.TryToAssignResourceObjectsPUBLIC(self)
	endif

	; try recalcing when you enter/exit workshop mode
	;DailyUpdate(bRealUpdate = false)
endEvent

ObjectReference function GetContainer()
	;if (GetBaseObject() as Container)
		;return self
	;else
		return GetLinkedRef(WorkshopParent.WorkshopLinkContainer)
	;endif
endFunction

Event Actor.OnLocationChange(Actor akActor, Location akOldLoc, Location akNewLoc)
	;Debug.Notification("Brahmin change location")
	If WorkshopParent.WorkshopLocations.Find(akNewLoc) < 0
		BlockActivation(false)
	Else
		BlockActivation(true)
	EndIf
EndEvent
