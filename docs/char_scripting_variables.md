# Character Scripting Variables

- `o` : reset to `false` for functions that are overridable and you can call one of the functions and set `o` for the base behavior not to ensue. Here are the functions that use this variable:
    - `dance` (character script)

- `v` : reset to a default value for functions that allow scripts to add on to a value. Here are the functions that use this variable:
    - `ChartNoteEventKind(kind:Dynamic, character:Int)` (general scripts)
