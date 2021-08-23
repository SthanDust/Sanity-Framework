ScriptName JB:JBSetToConvoyInfoScript extends TopicInfo const

Bool Property bSet = false Auto Const

Bool Property bAsHead = false Auto Const

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	JB:JBSlaveNPCScript akSpeaker = akSpeakerRef as JB:JBSlaveNPCScript
	akSpeaker.SetToConvoy(bSet, bAsHead)
endEvent