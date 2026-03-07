package ui;

import flixel.FlxState;

class MusicBeatState extends FlxState
{
    var conductor(get, never):Conductor;

    public function new()
    {
        super();

        // Adds conductor callbacks
        conductor.stepHit.add(stepHit);
        conductor.beatHit.add(beatHit);
        conductor.sectionHit.add(sectionHit);
    }

    override public function destroy()
    {
        super.destroy();

        // Removes conductor callbacks
        conductor.stepHit.remove(stepHit);
        conductor.beatHit.remove(beatHit);
        conductor.sectionHit.remove(sectionHit);
    }
    
    function stepHit(step:Int) {}
    function beatHit(beat:Int) {}
    function sectionHit(section:Int) {}

    inline function get_conductor():Conductor
        return Conductor.instance;
}