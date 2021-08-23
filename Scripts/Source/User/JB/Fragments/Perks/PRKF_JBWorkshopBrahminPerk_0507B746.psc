;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname JB:Fragments:Perks:PRKF_JBWorkshopBrahminPerk_0507B746 Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_01
Function Fragment_Entry_01(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
JB:JBQuartermasteryBrahminScript akBrahmin = akTargetRef as JB:JBQuartermasteryBrahminScript
ObjectReference brahminContainer = akBrahmin.GetContainer()
brahminContainer.Activate(Game.GetPlayer())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
