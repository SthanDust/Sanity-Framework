Scriptname JB:JBSexEventsQuestScript extends Quest Conditional

JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory

Quest Property JBSlaveProstitutesQuest Auto Const

ReferenceAlias Property SlaveForSexA Auto Const
ReferenceAlias Property SlaveForSexB Auto Const

ReferenceAlias Property SlaveProstitute Auto Const
ReferenceAlias Property clientForProstitute Auto Const

ReferenceAlias Property ControlledProstitute Auto Const
;ReferenceAlias Property ChosenClientForProstitute Auto Const

ReferenceAlias Property ActorForSex01 Auto Const

;RefCollectionAlias Property NowInAnimationCollection Auto Const

RefCollectionAlias Property PartyOrgyCollection Auto Const

;RefCollectionAlias Property PunishmentSexCollection Auto Const
;RefCollectionAlias Property ProstituteSexCollection Auto Const
;RefCollectionAlias Property RapeSexCollection Auto Const
;RefCollectionAlias Property ConsensualSexCollection Auto Const

RefCollectionAlias[] Property SexTypeCollections Auto Const
{
	0 - PunishmentSexCollection
	1 - ProstituteSexCollection
	2 - RapeSexCollection
	3 - ConsensualSexCollection
}

Scene Property JBProstituteCustomerYesScene01 Auto Const
Scene Property JBProstituteCustomerNoScene01 Auto Const

int Property numberOfParticipantsInOrgy = 0 Auto Conditional

int Property numberOfParticipants = 0 Auto Conditional

int Property iPlayerPreparesScene = -1 Auto Conditional

AAF:AAF_API AAF_API


Event OnQuestInit()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterCustomEvents()
	LoadAAF()
EndEvent

Function PlayerSlaveRape(Actor akSlave)
	akSlave.ResetHealthAndLimbs()
	akSlave.SetNoBleedoutRecovery(false)
	;Utility.Wait(5)
	Actor PlayerRef = Game.GetPlayer()
	bool inBleedOut = true
	While inBleedOut == true
		If akSlave.IsBleedingOut()
			;
		Else
			akSlave.StopCombat()
			akSlave.StopCombatAlarm()
			;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
			Actor[] actors = new Actor[2]
			actors[0] = PlayerRef
			actors[1] = akSlave

			StartSexScene(actors, 3)

			inBleedOut = false
		EndIf
	EndWhile
EndFunction

Function CompanionSlaveRape(Actor akSlave)
	akSlave.ResetHealthAndLimbs()
	akSlave.SetNoBleedoutRecovery(false)
	Actor CompanionRef = JBSlaveQuest.Companion.GetActorReference()
	bool inBleedOut = true
	While inBleedOut == true
		If akSlave.IsBleedingOut()
			;
		Else
			akSlave.StopCombat()
			akSlave.StopCombatAlarm()
			;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
			Actor[] actors = new Actor[2]
			actors[0] = CompanionRef
			actors[1] = akSlave

			StartSexScene(actors, 3)

			inBleedOut = false
		EndIf
	EndWhile
EndFunction

Function PlayerCompanionSlaveRape(Actor akSlave)
	akSlave.ResetHealthAndLimbs()
	akSlave.SetNoBleedoutRecovery(false)
	Actor PlayerRef = Game.GetPlayer()
	Actor CompanionRef = JBSlaveQuest.Companion.GetActorReference()
	bool inBleedOut = true
	While inBleedOut == true
		If akSlave.IsBleedingOut()
			;
		Else
			akSlave.StopCombat()
			akSlave.StopCombatAlarm()
			;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
			Actor[] actors = new Actor[3]
			actors[0] = PlayerRef
			actors[1] = akSlave
			actors[2] = CompanionRef

			StartSexScene(actors, 3)

			inBleedOut = false
		EndIf
	EndWhile
EndFunction

Function PlayerSlaveSex(Actor akSlave)
	Actor PlayerRef = Game.GetPlayer()
	If (akSlave.GetValue(JBSlaveQuest.JBIsSubmissive) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(akSlave) > -1)
		;akSlave.SetValue(JBIsSubmissive, akSlave.GetValue(JBIsSubmissive)+0.3)
		(akSlave as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.3)
	EndIf

	;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
	Actor[] actors = new Actor[2]
	; actors[0] = PlayerRef
	; actors[1] = akSlave
	actors[0] = akSlave
	actors[1] = PlayerRef

	StartSexScene(actors, 1)

EndFunction

Function CompanionSlaveSex(Actor akSlave)
	Actor CompanionRef = JBSlaveQuest.Companion.GetActorReference()
	If (akSlave.GetValue(JBSlaveQuest.JBIsSubmissive) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(akSlave) > -1)
		;akSlave.SetValue(JBIsSubmissive, akSlave.GetValue(JBIsSubmissive)+0.3)
		(akSlave as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.3)
	EndIf
	;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
	Actor[] actors = new Actor[2]
	; actors[0] = CompanionRef
	; actors[1] = akSlave
	actors[0] = akSlave
	actors[1] = CompanionRef

	StartSexScene(actors, 1)

EndFunction

Function PlayerCompanionSlaveSex(Actor akSlave)
	Actor PlayerRef = Game.GetPlayer()
	Actor CompanionRef = JBSlaveQuest.Companion.GetActorReference()
	If (akSlave.GetValue(JBSlaveQuest.JBIsSubmissive) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(akSlave) > -1)
		;akSlave.SetValue(JBIsSubmissive, akSlave.GetValue(JBIsSubmissive)+0.3)
		(akSlave as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.3)
	EndIf
	;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
	Actor[] actors = new Actor[3]
	; actors[0] = PlayerRef
	; actors[1] = akSlave
	; actors[2] = CompanionRef
	actors[0] = akSlave
	actors[1] = PlayerRef
	actors[2] = CompanionRef

	StartSexScene(actors, 1)

EndFunction

Function AddSlaveToTwoSlaveSexAction(Actor akSlave)
	If SlaveForSexA.GetReference() == None
		SlaveForSexA.ForceRefTo(akSlave)
	ElseIf SlaveForSexB.GetReference() == None
		SlaveForSexB.ForceRefTo(akSlave)
	EndIf
	Utility.Wait(0.2)
	If SlaveForSexA.GetReference() != None && SlaveForSexB.GetReference() != None
		TwoSlaveSex()
	EndIf
EndFunction

Function TwoSlaveSex()
	Actor SlaveA = SlaveForSexA.GetActorReference()
	Actor SlaveB = SlaveForSexB.GetActorReference()
	If (SlaveA.GetValue(JBSlaveQuest.JBIsSubmissive) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(SlaveA) > -1)
		;SlaveA.SetValue(JBIsSubmissive, SlaveA.GetValue(JBIsSubmissive)+0.2)
		(SlaveA as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.2)
	EndIf
	If (SlaveB.GetValue(JBSlaveQuest.JBIsSubmissive) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(SlaveB) > -1)
		;SlaveB.SetValue(JBIsSubmissive, SlaveB.GetValue(JBIsSubmissive)+0.2)
		(SlaveB as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.2)
	EndIf
	;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
	Actor[] actors = new Actor[2]
	actors[0] = SlaveA
	actors[1] = SlaveB

	StartSexScene(actors, 1)

	SlaveForSexA.Clear()
	SlaveForSexB.Clear()
EndFunction

Function AddParticipantToOrgy(Actor akActor)
	PartyOrgyCollection.AddRef(akActor)
	numberOfParticipantsInOrgy += 1
EndFunction

Function StartOrgySex(int iMode = 0)
	Actor[] actors = new Actor[0]
	int i = 0
	While i < PartyOrgyCollection.GetCount()
		Actor Party = PartyOrgyCollection.GetAt(i) as Actor
	 	actors.Add(Party)
		i += 1
	EndWhile

	If iMode == 1
		Actor PlayerRef = Game.GetPlayer()
		actors.Add(PlayerRef)
	ElseIf iMode == 2
		Actor CompanionRef = JBSlaveQuest.Companion.GetActorReference()
		actors.Add(CompanionRef)
	ElseIf iMode == 3
		Actor PlayerRef = Game.GetPlayer()
		Actor CompanionRef = JBSlaveQuest.Companion.GetActorReference()
		actors.Add(PlayerRef)
		actors.Add(CompanionRef)
	EndIf


	StartSexScene(actors, 4)

	PartyOrgyCollection.RemoveAll()
	numberOfParticipantsInOrgy = 0

EndFunction

Function ProstituteCustomerSex(ReferenceAlias akCustomer, ReferenceAlias akProstitute)
	Actor Customer = akCustomer.GetActorReference()
	Actor Prostitute = akProstitute.GetActorReference()

	;AAF_API = Game.GetFormFromFile(0x01000F99, "AAF.esp") as AAF:AAF_API ;AAF
	Actor[] actors = new Actor[2]
	;actors[0] = Customer
	;actors[1] = Prostitute
	actors[0] = Prostitute
	actors[1] = Customer

	StartSexScene(actors, 2)

EndFunction

; Function ToConsensualSex(Actor akActor, int variant = 2)
; 	ActorForSex01.ForceRefTo(akActor)
; 	If variant == 0
; 		ActorForSex01.Clear()
; 	ElseIf variant == 1
; 		PlayerConsensualSex(ActorForSex01)
; 	EndIf
; 	akActor.EvaluatePackage()
; EndFunction

; Function PlayerConsensualSex(ReferenceAlias akPartner)
; 	Actor Partner = akPartner.GetActorReference()
; 	Actor PlayerRef = Game.GetPlayer()

; 	Actor[] actors = new Actor[2]
; 	actors[0] = Partner
; 	actors[1] = PlayerRef

; 	StartSexScene(actors, 5)
; EndFunction

;*********************************************************************************************************
;****************************************Sex and settings functions***************************************
;*********************************************************************************************************

;type
;0 - Punishment
;1 - Prostitute
;2 - Rape
;3 - Consensual
Function SceneAssembly(Actor akActor, int akTypeSexScene, bool initiation = false, bool withPlayer = false)
	iPlayerPreparesScene = akTypeSexScene
	AddToSexCollections(akActor, akTypeSexScene)
	If initiation
		InitiationScene(akTypeSexScene, withPlayer)
	EndIf
	akActor.EvaluatePackage()
EndFunction

Function InitiationScene(int akTypeSexScene, bool withPlayer)
	Actor[] actors = new Actor[0]
	int i = 0
	While i < SexTypeCollections[akTypeSexScene].GetCount()
		Actor Participant = SexTypeCollections[akTypeSexScene].GetAt(i) as Actor
	 	actors.Add(Participant)
		i += 1
	EndWhile

	If withPlayer
		Actor PlayerRef = Game.GetPlayer()
		actors.Add(PlayerRef)
	EndIf

	If akTypeSexScene == 1
		Actor Prostitute = ControlledProstitute.GetActorReference()
		(Prostitute as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveProstituteSkill, 0.1)
		Game.GetPlayer().AddItem(Game.GetCaps(), (Prostitute as JB:JBSlaveNPCScript).JBProstituteCost)
	EndIf

	StartSexScene(actors, akTypeSexScene)

EndFunction

Function StartSexScene(Actor[] actors, Int akTypeSexScene)
	;Debug.Notification("Start Sex Scene")
	bool bFurniture = false
	bool bPackages = true

	If JBMCM.preventFurniture == 1
		bFurniture = true
	ElseIf JBMCM.preventFurniture == 2
		bFurniture = AskAboutFurniture()
	EndIf

	If JBMCM.usePackages == 1
		bPackages = false
	ElseIf JBMCM.usePackages == 2
		bPackages = AskAboutPackages()
	EndIf

	AAF:AAF_API:SceneSettings settings = AAF_API.GetSceneSettings()

	settings.duration = JBMCM.sexDuration
	settings.preventFurniture = bFurniture
	settings.usePackages = bPackages



	string sIncludeTags = CheckIncludeTagsList(akTypeSexScene)
	If sIncludeTags != ""
		;Debug.Notification("sIncludeTags = "+sIncludeTags)
		settings.includeTags = sIncludeTags
	;Else
		;Debug.Notification("IncludeTags = None")
	EndIf
	string sExcludeTags = CheckExcludeTagsList(akTypeSexScene)
	If sExcludeTags != ""
		;Debug.Notification("sExcludeTags = "+sExcludeTags)
		settings.excludeTags = sExcludeTags
	;Else
		;Debug.Notification("ExcludeTags = None")
	EndIf

	settings.furniturePreference = CheckFurniturePreference(akTypeSexScene)
	settings.scanRadius = CheckScanRadius(akTypeSexScene)

	AAF_API.StartScene(actors, settings)

	ClearSexCollections()

EndFunction

Function AddToSexCollections(Actor akActor, int akTypeSexScene)
	If SexTypeCollections[akTypeSexScene].Find(akActor) < 0
		If akTypeSexScene == 1
			Actor Prostitute = ControlledProstitute.GetActorReference()
			SexTypeCollections[akTypeSexScene].AddRef(Prostitute)
			numberOfParticipants += 1
		EndIf
		SexTypeCollections[akTypeSexScene].AddRef(akActor)
		numberOfParticipants += 1
	EndIf
EndFunction

Function ClearSexCollections()
	int i = 0
	While i < SexTypeCollections.Length
		SexTypeCollections[i].RemoveAll()
		i = i + 1
	EndWhile
	numberOfParticipants = 0
	iPlayerPreparesScene = -1
EndFunction

Bool Function AskAboutFurniture()
	int ButtonPressed = JBSlaveQuest.JBAskAboutFurnitureMSG.Show()
	If ButtonPressed == 0
		return false
	ElseIf ButtonPressed == 1
		return true
	EndIf
EndFunction

Bool Function AskAboutPackages()
	int ButtonPressed = JBSlaveQuest.JBAskAboutPackagesMSG.Show()
	If ButtonPressed == 0
		return true
	ElseIf ButtonPressed == 1
		return false
	EndIf
EndFunction

String Function CheckIncludeTagsList(int akTypeSexScene)
	If akTypeSexScene == 0
		string sIncludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "PunishmentIncludeTags")
		return sIncludeTags
	ElseIf akTypeSexScene == 1
		string sIncludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "ProstituteIncludeTags")
		return sIncludeTags
	ElseIf akTypeSexScene == 2
		string sIncludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "RapeIncludeTags")
		return sIncludeTags
	; ElseIf akTypeSexScene == 4
	; 	string sIncludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "GroupIncludeTags")
	; 	return sIncludeTags
	ElseIf akTypeSexScene == 3
		string sIncludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "ConsensualIncludeTags")
		return sIncludeTags
	EndIf
EndFunction

String Function CheckExcludeTagsList(int akTypeSexScene)
	If akTypeSexScene == 0
		string sExcludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "PunishmentExcludeTags")
		return sExcludeTags
	ElseIf akTypeSexScene == 1
		string sExcludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "ProstituteExcludeTags")
		return sExcludeTags
	ElseIf akTypeSexScene == 2
		string sExcludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "RapeExcludeTags")
		return sExcludeTags
	; ElseIf akTypeSexScene == 4
	; 	string sExcludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "GroupExcludeTags")
	; 	return sExcludeTags
	ElseIf akTypeSexScene == 3
		string sExcludeTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", "ConsensualExcludeTags")
		return sExcludeTags
	EndIf
EndFunction

Int Function CheckFurniturePreference(int akTypeSexScene)
	If akTypeSexScene == 0
		return JBMCM.furniturePreference00
	ElseIf akTypeSexScene == 1
		return JBMCM.furniturePreference01
	ElseIf akTypeSexScene == 2
		return JBMCM.furniturePreference02
	ElseIf akTypeSexScene == 3
		return JBMCM.furniturePreference03
	; ElseIf akTypeSexScene == 5
	; 	return JBMCM.furniturePreference05
	EndIf
EndFunction

Float Function CheckScanRadius(int akTypeSexScene)
	If akTypeSexScene == 0
		return JBMCM.scanRadius00
	ElseIf akTypeSexScene == 1
		return JBMCM.scanRadius01
	ElseIf akTypeSexScene == 2
		return JBMCM.scanRadius02
	ElseIf akTypeSexScene == 3
		return JBMCM.scanRadius03
	; ElseIf akTypeSexScene == 5
	; 	return JBMCM.scanRadius05
	EndIf
EndFunction

Function CheckLoadedPositionTags(String[] akTagsArray)
	String[] tagsSettings = new String[8]
	tagsSettings[0] = "PunishmentIncludeTags"
	tagsSettings[1] = "PunishmentExcludeTags"
	tagsSettings[2] = "ProstituteIncludeTags"
	tagsSettings[3] = "ProstituteExcludeTags"
	tagsSettings[4] = "RapeIncludeTags"
	tagsSettings[5] = "RapeExcludeTags"
	; tagsSettings[6] = "GroupIncludeTags"
	; tagsSettings[7] = "GroupExcludeTags"
	tagsSettings[6] = "ConsensualIncludeTags"
	tagsSettings[7] = "ConsensualExcludeTags"
	int i = 0
	While i < tagsSettings.Length
		String sTags = LL_FourPlay.GetCustomConfigOption("Just Business.ini", "TagsSettings", tagsSettings[i])
		String[] aTags = LL_FourPlay.StringSplit(sTags)
		int index = 0
		While index < aTags.Length
			If akTagsArray.Find(aTags[index]) < 0
				Debug.MessageBox("Tag: "+aTags[index]+" specified in "+tagsSettings[i]+" missing in the loaded animations")
			EndIf
			index += 1
		EndWhile
		i += 1
	EndWhile
EndFunction

;*********************************************************************************************************
;**********************************************AAF Events*************************************************
;*********************************************************************************************************

Event AAF:AAF_API.OnAAFReady(AAF:AAF_API akSender, Var[] akArgs)
	;Debug.Notification("AAF OnAAFReady Event")
	; Var[] positionTagArrays = Utility.VarToVarArray(akArgs[4]) as Var[]
	; String[] loadedPositionTags = new String[0]
	; int i = 0
	; While i < positionTagArrays.Length
	; 	String[] positionTagArray = Utility.VarToVarArray(positionTagArrays[i]) as String[]
	; 	int index = 0
	; 	While index < positionTagArray.Length
	; 		If loadedPositionTags.Find(positionTagArray[index]) < 0
	; 			loadedPositionTags.Add(positionTagArray[index])
	; 		EndIf
	; 		index += 1
	; 	EndWhile
	; 	i += 1
	; EndWhile
	; ;Debug.Notification("Loaded tags = "+loadedPositionTags.Length)
	; If loadedPositionTags.Length > 0
	; 	String tags = LL_FourPlay.StringJoin(loadedPositionTags)
	; 	LL_FourPlay.SetCustomConfigOption("Just Business.ini", "TagsSettings", "LoadedPositionTags", tags)
	; 	CheckLoadedPositionTags(loadedPositionTags)
	; EndIf
EndEvent

Event AAF:AAF_API.OnSceneInit(AAF:AAF_API akSender, Var[] akArgs)
	;Debug.Notification("AAF OnSceneInit Event")
	int status = akArgs[0] as int
	If status == 0
		;Debug.Notification("AAF OnSceneInit Event - Correct")
	Else
		;Debug.Notification("AAF OnSceneInit Event - Error - "+status)
		Actor[] actors = Utility.VarToVarArray(akArgs[2]) as Actor[]
		int i = 0
		While i < actors.Length
			Actor akActor = actors[i] as Actor
			If akActor == SlaveProstitute.GetActorReference()
				;Debug.Notification("Clear prostitution aliases")
				If JBMCM.bTravelToProstituteWorkplace
					;akActor.SetValue(JBbIsWorker, 0)
					(akActor as JB:JBSlaveNPCScript).bIsProstituteGoToWorkplace = false
				EndIf
				clientForProstitute.Clear()
				SlaveProstitute.Clear()
			; ElseIf akActor == ControlledProstitute.GetActorReference()
			; 	ChosenClientForProstitute.Clear()
			; ElseIf akActor == ActorForSex01.GetActorReference()
			; 	ActorForSex01.Clear()
			EndIf
			If JBSlaveQuest.JBProstitutesInBusiness.Find(akActor) > -1
				JBSlaveQuest.JBProstitutesInBusiness.RemoveRef(akActor)
				If JBSlaveQuest.JBProstitutesInBusiness.GetCount() == 0
					JBSlaveProstitutesQuest.SetObjectiveDisplayed(5, false)
				EndIf
			EndIf
			JB:JBSlaveNPCScript theSlave = akActor as JB:JBSlaveNPCScript
			If theSlave && theSlave.bIsProstitute
				theSlave.StartProstituteTimer()
			EndIf
			; int index = SlavesData.FindStruct("Slave", akActor)
			; If index > -1
			; 	SlaveData sd = SlavesData[index]
			; 	StartTimer(prostituteSearchCustomerInterval, sd.timer_id)
			; EndIf
			If akActor.HasMagicEffect(JBSlaveQuest.JBMarkEffect)
				;Debug.Notification("Actor has JBMarkEffect")
				akActor.SetNoBleedoutRecovery(true)
				akActor.Kill()
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event AAF:AAF_API.OnAnimationStart(AAF:AAF_API akSender, Var[] akArgs)
	int status = akArgs[0] as int
	If status == 0
		;Debug.Notification("AAF Animation Start - Correct")
		Actor[] actors = Utility.VarToVarArray(akArgs[1]) as Actor[]
		int i = 0
		While i < actors.Length
			Actor akActor = actors[i] as Actor
			;NowInAnimationCollection.AddRef(akActor)
			If akActor == SlaveProstitute.GetActorReference()
				;Debug.Notification("Clear prostitution aliases")
				If JBMCM.bTravelToProstituteWorkplace
					;akActor.SetValue(JBbIsWorker, 0)
					(akActor as JB:JBSlaveNPCScript).bIsProstituteGoToWorkplace = false
				EndIf
				clientForProstitute.Clear()
				SlaveProstitute.Clear()
			; ElseIf akActor == ControlledProstitute.GetActorReference()
			; 	ChosenClientForProstitute.Clear()
			; ElseIf akActor == ActorForSex01.GetActorReference()
			; 	ActorForSex01.Clear()
			EndIf
			i += 1
		EndWhile
	Else
		;Debug.Notification("AAF Animation Start - Error")
		Actor[] actors = Utility.VarToVarArray(akArgs[2]) as Actor[]
		int i = 0
		While i < actors.Length
			Actor akActor = actors[i] as Actor
			If akActor == SlaveProstitute.GetActorReference()
				;Debug.Notification("Clear prostitution aliases")
				If JBMCM.bTravelToProstituteWorkplace
					;akActor.SetValue(JBbIsWorker, 0)
					(akActor as JB:JBSlaveNPCScript).bIsProstituteGoToWorkplace = false
				EndIf
				clientForProstitute.Clear()
				SlaveProstitute.Clear()
			; ElseIf akActor == ControlledProstitute.GetActorReference()
			; 	ChosenClientForProstitute.Clear()
			; ElseIf akActor == ActorForSex01.GetActorReference()
			; 	ActorForSex01.Clear()
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event AAF:AAF_API.OnAnimationStop(AAF:AAF_API akSender, Var[] akArgs)
	utility.Wait(0.2)
	int status = akArgs[0] as int
	If status == 0
		;Debug.Notification("AAF Animation Stop - Correct")
		Actor[] actors = Utility.VarToVarArray(akArgs[1]) as Actor[]
		int i = 0
		While i < actors.Length
			Actor akActor = actors[i] as Actor
			If akActor
				JB:JBSlaveNPCScript theSlave = akActor as JB:JBSlaveNPCScript
				If theSlave
					If akActor.GetValue(JBSlaveQuest.JBIsSubmissive) < 100
						theSlave.ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.3)
					EndIf
					If akActor.GetValue(JBSlaveQuest.JBSlaveSexSkill) < 100
						theSlave.ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveSexSkill, 0.3)
					EndIf
					If theSlave.bIsProstitute
						theSlave.ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveProstituteSkill, 0.5)
						theSlave.StartProstituteTimer()
					EndIf
				EndIf

				;If (akActor.GetValue(JBSlaveQuest.JBSlaveSexSkill) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(akActor) > -1)
					;akActor.SetValue(JBSlaveSexSkill, akActor.GetValue(JBSlaveSexSkill)+0.3)
					;(akActor as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveSexSkill, 0.3)
				;EndIf
				;If (akActor.GetValue(JBSlaveQuest.JBSlaveProstituteSkill) < 100) && (JBSlaveQuest.JBProstituteSlaveCollection.Find(akActor) > -1)
					;akActor.SetValue(JBSlaveProstituteSkill, akActor.GetValue(JBSlaveProstituteSkill)+0.5)
					;(akActor as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveProstituteSkill, 0.5)
				;EndIf

				;If NowInAnimationCollection.Find(akActor) > -1
					;NowInAnimationCollection.RemoveRef(akActor)
				;EndIf

				If JBSlaveQuest.JBProstitutesInBusiness.Find(akActor) > -1
					JBSlaveQuest.JBProstitutesInBusiness.RemoveRef(akActor)
					If JBSlaveQuest.JBProstitutesInBusiness.GetCount() == 0
						JBSlaveProstitutesQuest.SetObjectiveDisplayed(5, false)
					EndIf
				EndIf

				; JB:JBSlaveNPCScript theSlave = akActor as JB:JBSlaveNPCScript
				; If theSlave && theSlave.bIsProstitute
				; 	theSlave.StartProstituteTimer()
				; EndIf

				; int index = SlavesData.FindStruct("Slave", akActor)
				; If index > -1
				; 	SlaveData sd = SlavesData[index]
				; 	StartTimer(prostituteSearchCustomerInterval, sd.timer_id)
				; EndIf
				If akActor.HasMagicEffect(JBSlaveQuest.JBMarkEffect)
					;Debug.Notification("Actor has JBMarkEffect")
					akActor.SetNoBleedoutRecovery(true)
					akActor.Kill()
				EndIf
			EndIf
			i += 1
		EndWhile
	Else
		;Debug.Notification("AAF Animation Stop - Error")
		Actor[] actors = Utility.VarToVarArray(akArgs[2]) as Actor[]
		int i = 0
		While i < actors.Length
			Actor akActor = actors[i] as Actor
			If akActor
				If JBSlaveQuest.JBProstitutesInBusiness.Find(akActor) > -1
					JBSlaveQuest.JBProstitutesInBusiness.RemoveRef(akActor)
					If JBSlaveQuest.JBProstitutesInBusiness.GetCount() == 0
						JBSlaveProstitutesQuest.SetObjectiveDisplayed(5, false)
					EndIf
				EndIf

				JB:JBSlaveNPCScript theSlave = akActor as JB:JBSlaveNPCScript
				If theSlave && theSlave.bIsProstitute
					theSlave.StartProstituteTimer()
				EndIf
				; int index = SlavesData.FindStruct("Slave", akActor)
				; If index > -1
				; 	SlaveData sd = SlavesData[index]
				; 	StartTimer(prostituteSearchCustomerInterval, sd.timer_id)
				; EndIf
				If akActor.HasMagicEffect(JBSlaveQuest.JBMarkEffect)
					;Debug.Notification("Actor has JBMarkEffect")
					akActor.SetNoBleedoutRecovery(true)
					akActor.Kill()
				EndIf
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

;*********************************************************************************************************
;****************************************Helper functions*************************************************
;*********************************************************************************************************

Keyword Function GetAAFActorBusy()
	return AAF_API.AAF_ActorBusy
EndFunction

;*********************************************************************************************************
;****************************************Update functions*************************************************
;*********************************************************************************************************

Event Actor.OnPlayerLoadGame(actor aSender)
	RegisterCustomEvents()
	LoadAAF()
EndEvent

Function RegisterCustomEvents()

EndFunction

Function LoadAAF()
    Quest AAF_MainQuest = Game.GetFormFromFile(0x00000F99, "AAF.esm") as Quest
    If !AAF_MainQuest
        ;Debug.Notification("Can't find AAF.")
        utility.wait(0.1)
    Else
    	;Debug.Notification("AAF Registered")
        AAF_API = AAF_MainQuest as AAF:AAF_API
        RegisterForCustomEvent(AAF_API, "OnAAFReady")
        RegisterForCustomEvent(AAF_API, "OnSceneInit")
        RegisterForCustomEvent(AAF_API, "OnAnimationStart")
        ;RegisterForCustomEvent(AAF_API, "OnAnimationChange")
        RegisterForCustomEvent(AAF_API, "OnAnimationStop")
    Endif
EndFunction

Function UpdateScriptRegistration()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterCustomEvents()
	LoadAAF()
EndFunction
