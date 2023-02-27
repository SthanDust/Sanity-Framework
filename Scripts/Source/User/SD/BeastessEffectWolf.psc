Scriptname SD:BeastessEffectWolf extends activemagiceffect

Actor Property PlayerRef auto
Keyword Property ActorTypeViciousDogPack auto 
Faction Property DLC03_WolfFaction auto 
Faction Property PlayerFaction auto 
SD:SanityFrameworkQuestScript SDF
Actor SummonedWolf

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ObjectReference[] wolves = PlayerRef.FindAllReferencesWithKeyword(ActorTypeViciousDogPack, 1000)
    Quest Main = Game.GetFormFromFile(0x0001F59A, "SD_MainFramework.esp") as quest
      SDF = Main as SD:SanityFrameworkQuestScript
    int index = 0
    SDF.DNotify("Length: " + wolves.Length)
    If wolves.Length != 0
        While (index < wolves.Length)
            Actor wolf = wolves[index] as Actor
            If (wolf.IsInFaction(DLC03_WolfFaction))
                CallWolf(wolf)
                return
            EndIf
            index += 1
        EndWhile
    Else
        Debug.Notification("Nothing answered your call...")
    EndIf
EndEvent

Function CallWolf(Actor wolf)
    Debug.Notification("A wolf has answered your summoning...")
    wolf.AddToFaction(PlayerFaction)
    wolf.PathToReference(PlayerRef, 1.0)
    Actor[] akActors = new Actor[2]
    akActors[0] = PlayerRef
    akActors[1] = wolf
    SDF.PlaySexAnimation(akActors)
    SummonedWolf = wolf
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Debug.Notification("The wolf has pleased you and returned home...")
    SummonedWolf.MoveToMyEditorLocation()
    SummonedWolf.RemoveFromFaction(PlayerFaction)
EndEvent