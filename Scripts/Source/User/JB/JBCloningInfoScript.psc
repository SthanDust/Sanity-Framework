ScriptName JB:JBCloningInfoScript extends TopicInfo const

JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	Actor akSpeaker = akSpeakerRef as Actor
	JBSlaveQuest.CreateClone(akSpeaker)
endEvent