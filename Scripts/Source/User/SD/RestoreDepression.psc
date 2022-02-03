Scriptname SD:RestoreDepression extends activemagiceffect Conditional

GlobalVariable Property SD_DepressionLevel auto mandatory 


Event OnEffectStart(Actor akTarget, Actor akCaster)
    float curDepression = SD_DepressionLevel.GetValue()
    if  curDepression > 5
        SD_DepressionLevel.SetValue(curDepression - 5.0)
    EndIf
    
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Dispel()
EndEvent