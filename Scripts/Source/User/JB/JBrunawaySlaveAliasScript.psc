Scriptname JB:JBrunawaySlaveAliasScript extends ReferenceAlias


Message Property JBActorInBleedoutMSG Auto Const

Scene Property JBEscapeScene01 Auto Const

Actor escapeSlave


Event OnEnterBleedout()
	;Debug.Notification("Actor in bleedout")
	JBActorInBleedoutMSG.Show()
	escapeSlave = GetActorRef()
	escapeSlave.SetNoBleedoutRecovery(true)
	escapeSlave.StopCombat()
	escapeSlave.StopCombatAlarm()
	escapeSlave.AllowBleedoutDialogue(true)
	escapeSlave.AllowPCDialogue(true)
	
	RegisterForHitEvent(escapeSlave)
	
EndEvent


Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	;Debug.Notification("OnHit Event")
	escapeSlave = GetActorRef()
	
	If (escapeSlave.IsBleedingOut())
		escapeSlave.StopCombat()
		RegisterForHitEvent(escapeSlave)
	EndIf

EndEvent

Event OnActivate(ObjectReference akActionRef)
	If (akActionRef == Game.GetPlayer()) && (escapeSlave.IsBleedingOut())
		JBEscapeScene01.Start()
	EndIf
EndEvent
