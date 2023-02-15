# Release Notes 2.00 (Asylum Release)

## Game Mechanics

### Bug Fixes

- Removed the cloning spouse issue.  That was a test for another feature.
- Fixed an issue where Grief was not updating properly
- Fixed the looping installation message.
- Fixed the Actor Values not setting properly.
- Removed all Modify AV functions.  Converted to RestoreAV/DamageAV
- Ma

### New Features

- AAF Violate Integration: Player will be heavily affected by Rape Events as defined by the "PlayerRaped" meta tag in the AAF Animation.  If that tag is not seen, I still evaluate the type of animation to determine rape.  SA_SLUT Perk foregoes this check by design in Violate if integration is turn on in that mod.
- AAF is now completely integrated and all AnimationStop events are being considered.
- Introduced a Chaos variable so that the "OnTimer" event has a dynamic tickFrequency which will range between 30 minutes and 90 minutes for each check
- 
- 

# Family Planning Enhanced Redux Motes

## Integration Known Issues

### AAF Violate

- Cumflation: AAF Violate sets the Player to Ghost, which causes the cumflation not to be applied.  This is being worked on.
- 