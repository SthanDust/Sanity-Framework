ScriptName JB:JBOpenInventoryInfoScript extends TopicInfo const

bool Property abForceOpen = false Auto Const

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	Actor akSpeaker = akSpeakerRef as Actor
	akSpeaker.OpenInventory(abForceOpen)
endEvent