ScriptName JB:JBSexualPreferencesProstInfoScript  extends TopicInfo const

int Property iSexualPreference = 0 Auto Const

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	JBSlaveNPCScript Prostitute = (akSpeakerRef as Actor) as JBSlaveNPCScript
	Prostitute.iSexualAttitudes = iSexualPreference
endEvent