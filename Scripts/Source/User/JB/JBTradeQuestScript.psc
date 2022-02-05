Scriptname JB:JBTradeQuestScript extends Quest Conditional


JB:JBSlaveQuestScript Property JBSlaveQuest Auto Const Mandatory
JB:JBMCMQuestScript Property JBMCM Auto Const Mandatory

RefCollectionAlias Property JBSlavesSoldCollection Auto Const

ReferenceAlias Property Customer Auto Const
ReferenceAlias Property Product Auto Const

bool Property availableForSale = false Auto Conditional

Function ToOfferSlave()
	Actor Slave = Product.GetActorRef()
	If (Slave as JB:JBSlaveNPCScript).bIsJBFollower
		If JBMCM.bAllowTeleportToInstitute
			(Slave as JB:JBSlaveNPCScript).RegisterForTeleport(false)
		EndIf
		ReferenceAlias Follower = JBSlaveQuest.GetFollowerAlias(Slave as JB:JBSlaveNPCScript)
		Follower.Clear()
	EndIf

	(Slave as JB:JBSlaveNPCScript).SetCommandMode(false)
	JBSlaveQuest.JBSlaveCollection.RemoveRef(Slave)
	JBSlaveQuest.JBSlaveFollowersCollection.RemoveRef(Slave)
	Slave.RemoveFromFaction(JBSlaveQuest.JBSlaveFaction)
	Slave.SetActivateTextOverride(None)
	Game.GetPlayer().AddItem(Game.GetCaps(), (Slave as JB:JBSlaveNPCScript).JBSlaveCost)
	RemoveFromSale()
	JBSlavesSoldCollection.AddRef(Slave)
	Slave.EvaluatePackage()
EndFunction

Function RemoveFromSale()
	Product.Clear()
	availableForSale = false
EndFunction
