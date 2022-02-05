Scriptname JB:JBMarkEffectScript extends activemagiceffect

Message Property JBActorInBleedoutMSG Auto Const
Message Property JBActorMarkedMSG Auto Const

ReferenceAlias Property victimAlias Auto Const
Scene Property JBHuntingScene01 Auto Const

;bool startingProtected
bool startingEssential
bool startingNBR
float startingAggression

actor victimActor


Event OnEffectStart(Actor akTarget, Actor akCaster)

	;Debug.Notification("Actor marked")
	JBActorMarkedMSG.Show()
	
	victimActor = akTarget
	
;	startingProtected = akTarget.GetActorBase().IsProtected()
	startingAggression = akTarget.GetValue(Game.GetAggressionAV())
	startingEssential = akTarget.IsEssential()
	startingNBR = akTarget.GetNoBleedoutRecovery()
	
	akTarget.SetEssential(true)
	akTarget.SetNoBleedoutRecovery(true)

EndEvent

Event OnActivate(ObjectReference akActionRef)
	;Debug.Notification("Activate actor")
	If akActionRef == Game.GetPlayer() && victimActor.IsBleedingOut()
		;Debug.Notification("Actor is bleedingout")
		victimAlias.ForceRefTo(victimActor)
		JBHuntingScene01.Start()
	EndIf
EndEvent

Event OnEnterBleedout()

	;Debug.Notification("Actor in bleedout")
	JBActorInBleedoutMSG.Show()
	victimActor.SetValue(Game.GetAggressionAV(), -1)
	victimActor.StopCombat()
	victimActor.StopCombatAlarm()
	victimActor.AllowBleedoutDialogue(true)
	victimActor.AllowPCDialogue(true)
	
	RegisterForHitEvent(victimActor)

	;RegisterForCustomEvent(AAF:AAF_API.GetAPI(), "OnAnimationStop")
	;RegisterForCustomEvent(four_play:Main.GetAPI(), "animation_over")
	
EndEvent


Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	
	If (victimActor.IsBleedingOut())
		victimActor.StopCombat()
		
		RegisterForHitEvent(victimActor)
		
	EndIf

EndEvent

; Event four_play:Main.animation_over(four_play:Main akSender, Var[] akArgs)
; 	;Debug.Notification("animation_over event")
; 	Actor Slave = akArgs[1] as Actor
; 	If victimActor == Slave
; 		Slave.SetNoBleedoutRecovery(true)
; 		Slave.Kill()
; 	EndIf
; EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	
;	Debug.Notification("Actor released")
	
	akTarget.ResetHealthAndLimbs()
	akTarget.SetValue(Game.GetAggressionAV(), startingAggression)
	akTarget.SetNoBleedoutRecovery(startingNBR)
	akTarget.SetEssential(startingEssential)
	
	UnregisterForHitEvent(victimActor)

	;UnregisterForCustomEvent(AAF:AAF_API.GetAPI(), "OnAnimationStop")
	;UnregisterForCustomEvent(four_play:Main.GetAPI(), "animation_over")

EndEvent
