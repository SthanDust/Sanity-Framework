Scriptname JB:JBCompatibilityQuestScript extends Quest

JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory

Group FormLists
	FormList Property JBRestrictList Auto Const
	FormList Property JBBlackListRacesOfClients Auto Const
EndGroup

Group RaceFormLists
	FormList Property JBRaceHumanGhoulList Auto Const
	FormList Property JBRaceSupermutantList Auto Const
	FormList Property JBRaceGen1SynthList Auto Const
	FormList Property JBRaceGen2SynthList Auto Const
EndGroup

Group Messages
	Message Property JBRestrictListResetMSG Auto Const
	Message Property JBContraptionsWorkshopInstalledMSG Auto Const
	Message Property JBTortureDevicesInstalledMSG Auto Const
	Message Property JBCrimsomriderUniqueFurnitureInstalledMSG Auto Const
	Message Property JBPrisonerShacklesInstalledMSG Auto Const
	Message Property JBZaZOut4InstalledMSG Auto Const
	Message Property JBCRXInstalledMSG Auto Const
EndGroup

Group OfficialDLCGroup
	String Property ContraptionsWorkshop = "DLCworkshop02.esm" Auto Const
	Bool Property ContraptionsWorkshopInstalled = false Auto
EndGroup

Group ModGroup
	String Property TortureDevices = "TortureDevices.esm" Auto Const
	Bool Property TortureDevicesInstalled = false Auto

	String Property CrimsomriderUniqueFurniture = "Crimsomrider's Unique Furniture.esp" Auto Const
	Bool Property CrimsomriderUniqueFurnitureInstalled = false Auto

	String Property PrisonerShackles = "Prisoner Shackles.esp" Auto Const
	Bool Property PrisonerShacklesInstalled = false Auto

	String Property ZaZOut4 = "ZaZOut4.esp" Auto Const
	Bool Property ZaZOut4Installed = false Auto

	String Property CRX = "CRX.esp" Auto Const
	Bool Property CRXInstalled = false Auto
EndGroup

Group F4SEpluginsGroup
	String Property RenameAnythingPlugin = "rename_anything" Auto Const
	Bool Property RenameAnythingInstalled = false Auto

	String Property TextInputMenu = "TIM" Auto Const
	Bool Property TextInputMenuInstalled = false Auto
EndGroup


Event OnInit()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	Update()
EndEvent

Event Actor.OnPlayerLoadGame(actor aSender)
	Update()
EndEvent

Function Update()
	If F4SE.GetPluginVersion(RenameAnythingPlugin) > -1
		RenameAnythingInstalled = true
	Else
		RenameAnythingInstalled = false
	EndIf
	If F4SE.GetPluginVersion(TextInputMenu) > -1
		TextInputMenuInstalled = true
	Else
		TextInputMenuInstalled = false
	EndIf
	If !TextInputMenuInstalled
		JBMCM.JBRenameSettlersModeSwitch()
	EndIf
	If !Game.IsPluginInstalled(ContraptionsWorkshop) && ContraptionsWorkshopInstalled
		ResetFormLists()
	ElseIf !Game.IsPluginInstalled(TortureDevices) && TortureDevicesInstalled
		ResetFormLists()
	ElseIf !Game.IsPluginInstalled(CrimsomriderUniqueFurniture) && CrimsomriderUniqueFurnitureInstalled
		ResetFormLists()
	ElseIf !Game.IsPluginInstalled(PrisonerShackles) && PrisonerShacklesInstalled
		ResetFormLists()
	ElseIf !Game.IsPluginInstalled(ZaZOut4) && ZaZOut4Installed
		ResetFormLists()
	ElseIf !Game.IsPluginInstalled(CRX) && CRXInstalled
		ResetFormLists()
	EndIf
	Utility.Wait(0.3)
	If Game.IsPluginInstalled(ContraptionsWorkshop) && !ContraptionsWorkshopInstalled
		LoadContraptionsWorkshop()
	EndIf
	If Game.IsPluginInstalled(TortureDevices) && !TortureDevicesInstalled
		LoadTortureDevices()
	EndIf
	If Game.IsPluginInstalled(CrimsomriderUniqueFurniture) && !CrimsomriderUniqueFurnitureInstalled
		LoadCrimsomriderUniqueFurniture()
	EndIf
	If Game.IsPluginInstalled(PrisonerShackles) && !PrisonerShacklesInstalled
		LoadPrisonerShackles()
	EndIf
	If Game.IsPluginInstalled(ZaZOut4) && !ZaZOut4Installed
		LoadZaZOut4()
	EndIf
	If Game.IsPluginInstalled(CRX) && !CRXInstalled
		LoadCRX()
	EndIf
EndFunction

Function LoadContraptionsWorkshop()
	;Debug.Notification("ContraptionsWorkshop Added")
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00000AAD, ContraptionsWorkshop))
	JBBlackListRacesOfClients.AddForm(Game.GetFormFromFile(0x000008AB, ContraptionsWorkshop))
	ContraptionsWorkshopInstalled = true
	JBContraptionsWorkshopInstalledMSG.Show()
EndFunction

Function LoadTortureDevices()
	;Debug.Notification("TortureDevices Added")
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00001737, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000173C, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00001ED6, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00002681, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00003D4B, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00003D4C, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004C99, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000543B, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000543C, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000072C0, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000081EB, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00008989, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000098C7, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000098CA, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000A802, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000A804, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000AFA3, TortureDevices))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000AFA4, TortureDevices))
	TortureDevicesInstalled = true
	JBTortureDevicesInstalledMSG.Show()
EndFunction

Function LoadCrimsomriderUniqueFurniture()
	;Debug.Notification("CrimsomriderUniqueFurniture Added")
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AC7, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AC8, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AC9, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6ACD, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6ACF, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AD1, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AD7, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AD8, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000E6AD9, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000EAF2B, CrimsomriderUniqueFurniture))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000EF37D, CrimsomriderUniqueFurniture))
	CrimsomriderUniqueFurnitureInstalled = true
	JBCrimsomriderUniqueFurnitureInstalledMSG.Show()
EndFunction

Function LoadPrisonerShackles()
	;Debug.Notification("PrisonerShackles Added")
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000018CF, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000029A3, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000042D7, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006CDA, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006CDC, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006CDE, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006CE3, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006CE5, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006CE6, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000754F, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00008632, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000096FE, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000096FF, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00009704, PrisonerShackles))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000970C, PrisonerShackles))
	PrisonerShacklesInstalled = true
	JBPrisonerShacklesInstalledMSG.Show()
EndFunction

Function LoadZaZOut4()
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00002670, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004CA1, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004CA3, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004CA5, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004CA9, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004CAC, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00004CAE, ZaZOut4))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00006341, ZaZOut4))
	ZaZOut4Installed = true
	JBZaZOut4InstalledMSG.Show()
EndFunction

Function LoadCRX()
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000266E, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000266F, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00005410, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0000727A, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0001C8BB, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x000286D3, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x0002E20C, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00030FB2, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00031EE8, CRX))
	JBRestrictList.AddForm(Game.GetFormFromFile(0x00037293, CRX))
	CRXInstalled = true
	JBCRXInstalledMSG.Show()
EndFunction

Function ResetFormLists()
	;Debug.Notification("RestrictList Reset")
	JBRestrictList.Revert()
	ContraptionsWorkshopInstalled = false
	TortureDevicesInstalled = false
	CrimsomriderUniqueFurnitureInstalled = false
	PrisonerShacklesInstalled = false
	ZaZOut4Installed = false
	CRXInstalled = false
	JBRestrictListResetMSG.Show()
EndFunction

Function UpdateScriptRegistration()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	Update()
EndFunction