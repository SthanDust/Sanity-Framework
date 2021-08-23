ScriptName JB:JBSceneAssemblyInfoScript extends TopicInfo const

JB:JBSexEventsQuestScript Property JBSexEvents Auto Const Mandatory

Int Property akTypeSexScene Auto Const

Bool Property Initiation = false Auto Const

Bool Property withPlayer = false Auto Const

Event OnEnd(ObjectReference akSpeakerRef, bool abHasBeenSaid)
	Actor akSpeaker = akSpeakerRef as Actor
	JBSexEvents.SceneAssembly(akSpeaker, akTypeSexScene, Initiation, withPlayer)
endEvent