Scriptname JB:JBSlavesSoldCollectionScript extends RefCollectionAlias



Event OnUnload(ObjectReference akSenderRef)
	Actor Slave = akSenderRef as Actor
	Slave.KillEssential()
	Slave.Disable()
EndEvent
