ScriptName JB:JBSetAsConvoyPrisonerInfoScript extends TopicInfo const

Bool Property bSet = false Auto Const

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	JB:JBSlaveNPCScript akSpeaker = akSpeakerRef as JB:JBSlaveNPCScript
	akSpeaker.SetAsConvoyPrisoner(bSet)
endEvent