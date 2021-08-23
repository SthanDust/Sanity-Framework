Scriptname JB:JBMCMQuestScript extends Quest Conditional

JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBCompatibilityQuestScript Property JBCompatibilityQuest Auto Const Mandatory

WorkshopParentScript Property WorkshopParent Auto Const Mandatory
DLC04:DLC04WorkshopParentScript Property DLC04WorkshopParent auto const mandatory

Quest Property JBEscapeQuest Auto Const
Quest Property JBSearchNearestSlaveQuest Auto Const

ReferenceAlias Property nearestSlave Auto Const

Group Perks
	Perk Property JBHuntingPerk Auto Const
	Perk Property JBRenamePerk Auto Const
	Perk Property JBAdditionalDialogsPerk Auto Const
EndGroup

Group Messages
	Message Property JBHuntModeON Auto Const
	Message Property JBHuntModeOFF Auto Const
	
	Message Property JBCountsForPopulationON Auto Const
	Message Property JBCountsForPopulationOFF Auto Const

	Message Property JBRenameSettlersModeON Auto Const
	Message Property JBRenameSettlersModeOFF Auto Const

	Message Property JBAdditionalDialogsModeON Auto Const
	Message Property JBAdditionalDialogsModeOFF Auto Const

	Message Property JBClosestSlaveIsNotDefined Auto Const
EndGroup

Group Globals
	GlobalVariable Property JBbCountsForPopulation Auto Conditional
	{
		0 - don't count for total population
		1 - default
	}
	GlobalVariable Property JBSlaveTracking Auto Conditional
EndGroup

Group GameModes
	bool Property JBbIsHunterModeActivated = false Auto
	bool Property JBbIsRenameModeActivated = false Auto
	bool Property JBbIsAdditionalDialogsModeActivated = false Auto
EndGroup

Group SexSceneSettings
	Float Property sexDuration = 30.0 Auto

	Int Property preventFurniture = 0 Auto
	{
		0 - none
		1 - prevent
		2 - ask
	}

	Int Property usePackages = 0 Auto
	{
		0 - use
		1 - not use
		2 - ask
	}

	Int Property furniturePreference00 = 75 Auto
	Int Property furniturePreference01 = 75 Auto
	Int Property furniturePreference02 = 0 Auto
	Int Property furniturePreference03 = 75 Auto
	; Int Property furniturePreference05 = 75 Auto

	Float Property scanRadius00 = 100.0 Auto
	Float Property scanRadius01 = 100.0 Auto
	Float Property scanRadius02 = 100.0 Auto
	Float Property scanRadius03 = 100.0 Auto
	; Float Property scanRadius05 = 100.0 Auto
EndGroup

Group ProstituteSettings
	Float Property prostituteSearchCustomerRadius = 500.0 Auto
	Float Property prostituteSearchCustomerInterval = 120.0 Auto
	Bool Property bTravelToProstituteWorkplace = true Auto
EndGroup

Group ConvoySettings
	Bool Property bFastArrivalOnCall = false Auto
	Bool Property bFastArrivaAtDestination = false Auto
EndGroup

Group SlaveTweaks
	bool Property SlaveDontUseAmmo = false Auto

	bool Property bAllowTeleportToInstitute = false Auto
EndGroup

bool Property RemoveCorpse = true Auto

Bool Property allowEscape = true Auto

Bool Property allowManageVassal = false Auto

Bool Property bPreventADM = false Auto Conditional

Bool Property bDialSlaveInfo = true Auto Conditional


Event OnQuestInit()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterCustomEvents()
EndEvent

Function JBHunterModeSwitch()
	Utility.Wait(0.1)
	If (Game.GetPlayer().HasPerk(JBHuntingPerk))
		Game.GetPlayer().RemovePerk(JBHuntingPerk)
		JBbIsHunterModeActivated = false	
		;Debug.Notification("Hunter mode off")
		JBHuntModeOFF.Show()
	Else
		Game.GetPlayer().AddPerk(JBHuntingPerk)
		JBbIsHunterModeActivated = true
		;Debug.Notification("Hunter mode on")
		JBHuntModeON.Show()
	EndIf
EndFunction

Function JBAdditionalDialogsModeSwitch()
	Utility.Wait(0.1)
	If (Game.GetPlayer().HasPerk(JBAdditionalDialogsPerk))
		Game.GetPlayer().RemovePerk(JBAdditionalDialogsPerk)
		UnregisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeEnter")
		UnregisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeExit")
		JBbIsAdditionalDialogsModeActivated = false
		JBAdditionalDialogsModeOFF.Show()
	Else
		Game.GetPlayer().AddPerk(JBAdditionalDialogsPerk)
		RegisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeEnter")
		RegisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeExit")
		JBbIsAdditionalDialogsModeActivated = true
		JBAdditionalDialogsModeON.Show()
	EndIf
EndFunction

Function JBSlaveTrackingSwitch (float bTracking)
	if (bTracking as bool)
		(JBSlaveQuest as Quest).SetObjectiveDisplayed(10, true, true)
	Else
		(JBSlaveQuest as Quest).SetObjectiveDisplayed(10, false)
	EndIf
EndFunction

Function SetSlaveDontUseAmmo(bool bSet)
	int index = 0
	If bSet
		while (index < JBSlaveQuest.JBSlaveCollection.GetCount())
			actor theActor = JBSlaveQuest.JBSlaveCollection.GetActorAt(index)
			if theActor
				theActor.AddKeyword(JBSlaveQuest.TeammateDontUseAmmoKeyword)
			endif
			index += 1
		endwhile
		SlaveDontUseAmmo = true
	Else
		while (index < JBSlaveQuest.JBSlaveCollection.GetCount())
			actor theActor = JBSlaveQuest.JBSlaveCollection.GetActorAt(index)
			if theActor
				theActor.RemoveKeyword(JBSlaveQuest.TeammateDontUseAmmoKeyword)
			endif
			index += 1
		endwhile
		SlaveDontUseAmmo = false
	EndIf
EndFunction

Function AllowTeleportToInstitute(bool bSet)
	int index = 0
	If bSet
		While index < JBSlaveQuest.JBSlaveFollower.Length
			If JBSlaveQuest.JBSlaveFollower[index].GetReference() != None
				JB:JBSlaveNPCScript Follower = (JBSlaveQuest.JBSlaveFollower[index].GetActorReference()) as JB:JBSlaveNPCScript
				Follower.RegisterForTeleport()
			EndIf
		index += 1
		EndWhile
		bAllowTeleportToInstitute = true
	Else
		While index < JBSlaveQuest.JBSlaveFollower.Length
			If JBSlaveQuest.JBSlaveFollower[index].GetReference() != None
				JB:JBSlaveNPCScript Follower = (JBSlaveQuest.JBSlaveFollower[index].GetActorReference()) as JB:JBSlaveNPCScript
				Follower.RegisterForTeleport(false)
			EndIf
		index += 1
		EndWhile
		bAllowTeleportToInstitute = false
	EndIf
EndFunction

Function JBRenameSettlersModeSwitch()
	Utility.Wait(0.1)
	If JBCompatibilityQuest.TextInputMenuInstalled
		If (Game.GetPlayer().HasPerk(JBRenamePerk))
			Game.GetPlayer().RemovePerk(JBRenamePerk)
			JBbIsRenameModeActivated = false
			JBRenameSettlersModeOFF.Show()
		Else
			Game.GetPlayer().AddPerk(JBRenamePerk)
			JBbIsRenameModeActivated = true
			JBRenameSettlersModeON.Show()
		EndIf
	Else
		If (Game.GetPlayer().HasPerk(JBRenamePerk))
			Game.GetPlayer().RemovePerk(JBRenamePerk)
			JBbIsRenameModeActivated = false
		EndIf
	EndIf
EndFunction

Function ShowSlaveInfo()
	JBSearchNearestSlaveQuest.Start()
	Actor Slave = nearestSlave.GetActorReference()
	JBSearchNearestSlaveQuest.Stop()
	If Slave
		JBSlaveQuest.JBSlaveInfoMessage(Slave)
	Else
		;Debug.Notification("Slave not found")
		JBClosestSlaveIsNotDefined.Show()
	EndIf
EndFunction

Function SetCountForPopulation(float bCount)

EndFunction

Function OnMCMSettingChange(string modName, string id)
	If (modName == "Just Business")
		If (id == "JBAllowEscapeID")
			If allowEscape == false && JBEscapeQuest.IsRunning()
				Actor Slave = JBSlaveQuest.runawaySlave.GetActorReference()
				JBSlaveQuest.StopEscape(Slave)
				JBEscapeQuest.SetStage(15)
				Slave.MoveToIfUnloaded(Game.GetPlayer())
			EndIf
		EndIf
		If (id == "JBAllowVassalID")
			If allowManageVassal == true
				If DLC04WorkshopParent.VassalWorkshops != None
					int i = 0
					While i < DLC04WorkshopParent.VassalWorkshops.Length
						WorkshopScript workshopRef = DLC04WorkshopParent.VassalWorkshops[i]
						If workshopRef
							workshopRef.myLocation.AddLinkedLocation(DLC04WorkshopParent.DLC04NukaWorldWorkshopREF.myLocation, WorkshopParent.WorkshopCaravanKeyword)
							; make player owned
							workshopRef.SetOwnedByPlayer(true)
						EndIf
						i += 1
					EndWhile
				EndIf
			Else
				If DLC04WorkshopParent.VassalWorkshops != None
					int i = 0
					While i < DLC04WorkshopParent.VassalWorkshops.Length
						WorkshopScript workshopRef = DLC04WorkshopParent.VassalWorkshops[i]
						If workshopRef
							workshopRef.myLocation.RemoveLinkedLocation(DLC04WorkshopParent.DLC04NukaWorldWorkshopREF.myLocation, WorkshopParent.WorkshopCaravanKeyword)
							; make player owned
							workshopRef.SetOwnedByPlayer(false)
						EndIf
						i += 1
					EndWhile
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Event ReferenceAlias.OnCommandModeEnter(ReferenceAlias akSender)
	if akSender == JBSlaveQuest.Companion
		;Debug.Notification("Companion enter in command mode")
		bPreventADM = true
	EndIf
EndEvent

Event ReferenceAlias.OnCommandModeExit(ReferenceAlias akSender)
	if akSender == JBSlaveQuest.Companion
		;Debug.Notification("Companion exit from command mode")
		bPreventADM = false
	EndIf
EndEvent

;*********************************************************************************************************
;****************************************Update functions*************************************************
;*********************************************************************************************************

Event Actor.OnPlayerLoadGame(Actor aSender)
	RegisterCustomEvents()
EndEvent

Function RegisterCustomEvents()
	RegisterForExternalEvent("OnMCMSettingChange|Just Business", "OnMCMSettingChange")
	If JBbIsAdditionalDialogsModeActivated
		RegisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeEnter")
		RegisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeExit")
	Else
		UnregisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeEnter")
		UnregisterForRemoteEvent(JBSlaveQuest.Companion, "OnCommandModeExit")
	EndIf
EndFunction

Function UpdateScriptRegistration()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterCustomEvents()
EndFunction
