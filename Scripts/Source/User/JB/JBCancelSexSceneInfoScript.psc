ScriptName JB:JBCancelSexSceneInfoScript extends TopicInfo const

JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	;Actor akSpeaker = akSpeakerRef as Actor
	JBSexEvents.ClearSexCollections()
endEvent