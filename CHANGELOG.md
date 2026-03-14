# 0.4 - (3/14/2026)

## a-pimp-named-slickback

- Stage scripts now receive the same function calls as song and character scripts.
- Added new script functions:
    - `refresh()`
    - `checkSongTime(conductorTime)`
    - `onUpdate(elapsed)`

## no-scope

- 0.3.0 changelog is fixed in compiled builds

# 0.3.0 - (3/11/2026)

(Spaghetti and that's a wrap isn't coming soon, I was working on both but thats alot and my fucking perfectionistic head is an asshole.)

## revert

- revert(thats-a-wrap): You can no longer press ESCAPE to leave gameplay after the countdown is done

## feats

- feat(thats-a-wrap): `SongCharacterAnimationEvent(time, animation, character)` general script function
- feat(thats-a-wrap): Note kind Support via scripts (`ChartNoteEventKind(kind, character)` function)
    - Includes VSlice `note.k` field support
- feat(thats-a-wrap): VSlice BPM Changes Support
- feat(thats-a-wrap): New song event object: `SongBPMChangeEvent`
- feat(thats-a-wrap): Psych Engine Chart Support
    - `parsePsychChart(song)` PlayState.instance function
    - `loadPsychChart(song)` PlayState.instance function
    - `PsychSongChart` class
- feat: `addProp` stage script function
- feat(spaghetti): `PerspectiveSprite` (I don't think it really works tho...)
- feat(spaghetti): SserafimShader

## fixes

- fix(thats-a-wrap): Scripts no longer spam the same error messages as long as 4 unique ones haven't appeared after its last logging
- fix(thats-a-wrap): Incorrect VSlice chart parsing error messages when the chart or it's notes are null
- fix: Supported Mod versions are now 0.3+ versions and any before are now labelled as outdated
- fix(spaghetti): `CountdownSprite` is now imported in scripts
- fix(spaghetti): At the start of the song the camera points at the middle of the opponent

## chores

- chore(thats-a-wrap): Some chart parsing functions and variables have been moved to Constants for QOL
    - `CHART_PARSE_NOTE_HOLD_OFFSET`
    - `getNoteDirectionName(direction)`
    - `getCharacterOnDirection(direction)`
    - `addNoteEvent(direction, length, time)`
- chore(chagnelog): New changelog format
- chore(spaghetti): Split `loadVSliceChart` into `parseVSliceChart` and `loadVSliceChart`
    - `parseVSliceChart` gives the VSlice chart note, event data, and metadata
    - `loadVSliceChart` uses `parseVSliceChart` and makes the events according to the data its given

## refactors
- refactor: `dadbattle` is now hardcoded into the base songList to be after fresh and never to be after new songs

# 0.2.0 - (3/8/2026)
- fix: Pause Screen BG fits the screen when the game camera is zoomed out
- fix: VSlice FocusCamera camera tweens cancel previous ones when active (this applies to ZoomCamera too)

- feat: `zoom` stage field
    - chore: mainStage has a zoom of `0.9` now

- feat: VSlice "ZoomCamera" event support
    - refactor: Script errors are now traced via `Iris.error` (it makes it more noticable, if your pc supports ansi anyway...)
    - fix: Iris no longer complains about object casting for traces

- feat: `cameraOffsets` stage character info field
- feat: mainStageErect BG
    - feat: `player`, `damsel`, and `opponent` stage script variables
    - feat: `getNamedProp` stage script function
    - feat: `buildStage` stage script function
    
    - fix: `StageScript` is now imported into scripts
    
    - feat: AdjustColorShader
    
    - fix: The `animations` field is now properly an array of animation data and not singular animation data

    - feat: proper `sparrow` prop support
    - feat: `color` prop field`
    - feat: `startingAnimation` prop field
    - feat: `solid` prop asset type

- fix: The flixel cursor is now invisible (it uses your system cursor now)

- feat: Pause menu now displays the song name, composer / artist, and song time left
- feat: Added Bopeebo (erect)

- fix: The song countdown now fades correctly
- fix: song audio files now are linked once again to the soundtray volume
- fix: `bf` and `dad` have the correct camera offsets again
- fix: Mod song scripts are found once again

# 0.1.0 - (3/8/2026)
- Inital Release
