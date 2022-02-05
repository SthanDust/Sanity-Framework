Scriptname JB:JBAdditionalDialogsQuestScript extends Quest Conditional


JB:JBProstitutesQuestScript Property JBProstitutesQuest Auto Const Mandatory

ReferenceAlias Property Collocutor Auto Const
;ReferenceAlias Property ChosenClientForProstitute Auto Const
;ReferenceAlias Property ActorForSex01 Auto Const

Scene Property JBAddDialOpeningScene01 Auto Const
Scene Property JBAddDialProstitutionScene01 Auto Const
Scene Property JBAddDialInteractScene01 Auto Const

RefCollectionAlias Property PunishmentSexCollection Auto Const
RefCollectionAlias Property ProstituteSexCollection Auto Const
RefCollectionAlias Property RapeSexCollection Auto Const
RefCollectionAlias Property ConsensualSexCollection Auto Const


Function StartAdditionalDialogs(Actor akActor)
	Collocutor.ForceRefTo(akActor)
	;If ChosenClientForProstitute.GetActorReference() == akActor
	If ProstituteSexCollection.Find(akActor) > -1
		JBAddDialProstitutionScene01.Start()
	;ElseIf ActorForSex01.GetActorReference() == akActor
	ElseIf ConsensualSexCollection.Find(akActor) > -1
		JBAddDialInteractScene01.Start()
	Else
		JBAddDialOpeningScene01.Start()
		JBProstitutesQuest.PlayerOffersProstitute()
	EndIf
EndFunction