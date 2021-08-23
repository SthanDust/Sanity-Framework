Scriptname JB:JBProstitutesQuestScript extends Quest Conditional


JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory
JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory

Bool Property availableForProstitution = false Auto Conditional

Int Property consentCheck = 0 Auto Conditional

Function ProstituteCustomerYesSex()
	;Debug.Notification("Prostitute Customer Yes")
	Actor Customer = JBSexEvents.clientForProstitute.GetActorReference()
	Actor Prostitute = JBSexEvents.SlaveProstitute.GetActorReference()

	int price = (Prostitute as JB:JBSlaveNPCScript).CalculateCostProstitute()
	;Debug.Notification("price = "+price)
	Prostitute.AddItem(Game.GetCaps(), price)

	If (Prostitute.GetValue(JBSlaveQuest.JBIsSubmissive) < 100) && (JBSlaveQuest.JBSlaveCollection.Find(Prostitute) > -1)
		;Prostitute.SetValue(JBIsSubmissive, Prostitute.GetValue(JBIsSubmissive)+0.3)
		(Prostitute as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBIsSubmissive, 0.3)
	EndIf

	JBSlaveQuest.JBProstituteFoundClientMSG.Show()
	JBSlaveQuest.JBProstitutesInBusiness.AddRef(Prostitute)
	If !(self as Quest).IsObjectiveDisplayed(5)
		(self as Quest).SetObjectiveDisplayed(5, true, true)
	EndIf

	If JBMCM.bTravelToProstituteWorkplace
		(Prostitute as JB:JBSlaveNPCScript).bIsProstituteGoToWorkplace = true
		Prostitute.EvaluatePackage()
	Else
		JBSexEvents.ProstituteCustomerSex(JBSexEvents.clientForProstitute, JBSexEvents.SlaveProstitute)
	EndIf

	;clientForProstitute.Clear()
	;SlaveProstitute.Clear()
EndFunction

Function ProstituteCustomerNoSex()
	;Debug.Notification("Prostitute Customer No")
	Actor Prostitute = JBSexEvents.SlaveProstitute.GetActorReference()
	JBSexEvents.clientForProstitute.Clear()
	JBSexEvents.SlaveProstitute.Clear()
	(Prostitute as JB:JBSlaveNPCScript).StartProstituteTimer()
EndFunction

; Function ToOfferProstitute(Actor akActor, int variant = 2)
; 	JBSexEvents.ChosenClientForProstitute.ForceRefTo(akActor)
; 	If variant == 0
; 		JBSexEvents.ChosenClientForProstitute.Clear()
; 		;PlayerOffersProstitute()
; 	ElseIf variant == 1
; 		Actor Prostitute = JBSexEvents.ControlledProstitute.GetActorReference()
; 		(Prostitute as JB:JBSlaveNPCScript).ChangeSlaveSkillValue(JBSlaveQuest.JBSlaveProstituteSkill, 0.1)
; 		Game.GetPlayer().AddItem(Game.GetCaps(), (Prostitute as JB:JBSlaveNPCScript).JBProstituteCost)
; 		JBSexEvents.ProstituteCustomerSex(JBSexEvents.ChosenClientForProstitute, JBSexEvents.ControlledProstitute)
; 		;PlayerOffersProstitute()
; 	EndIf
; 	akActor.EvaluatePackage()
; EndFunction

Function PlayerOffersProstitute()
	If JBSexEvents.ControlledProstitute.GetActorReference() != None
		Actor Prostitute = JBSexEvents.ControlledProstitute.GetActorReference()
		(Prostitute as JB:JBSlaveNPCScript).CalculateCostProstitute()
		int check = (Prostitute as JB:JBSlaveNPCScript).CalculateCustomerAgree()
		int playerBonus = ((Game.GetPlayer().GetValue(Game.GetCharismaAV()))*5) as int
		check = check + playerBonus
		If check < 0
			consentCheck = 0
		Else
			consentCheck = 1
		EndIf
	EndIf
EndFunction

Function RemoveFromProstitution()
	JBSexEvents.ControlledProstitute.Clear()
	availableForProstitution = false
EndFunction
