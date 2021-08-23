;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Perks:PRKF_JBHuntingPerk_0100E4CB Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_00
Function Fragment_Entry_00(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor victim = akTargetRef as Actor
JBMarkSpell.cast(victim)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Entry_01
Function Fragment_Entry_01(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor victim = akTargetRef as Actor
victimAlias.ForceRefTo(victim)
if !Game.GetPlayer().IsSneaking()
	Game.GetPlayer().playIdle(IdlePipBoyJackIn)
	; when done, pull up pip-boy interface
	utility.wait(0.833) ; "exact" time is 0.83333
endif
JBSynthHackInterface.ShowOnPipboy()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Spell Property JBMarkSpell Auto Const

Terminal Property JBSynthHackInterface Auto Const

ReferenceAlias Property victimAlias Auto Const

Idle Property IdlePipBoyJackIn Auto Const
