package ui;

import flixel.util.FlxSort;
import flixel.FlxState;

class MusicBeatState extends FlxState {
	var conductor(get, never):Conductor;

	public function new() {
		super();

		// Adds conductor callbacks
		conductor.stepHit.add(stepHit);
		conductor.beatHit.add(beatHit);
		conductor.sectionHit.add(sectionHit);
	}

	override public function destroy() {
		super.destroy();

		// Removes conductor callbacks
		conductor.stepHit.remove(stepHit);
		conductor.beatHit.remove(beatHit);
		conductor.sectionHit.remove(sectionHit);
	}

	public function stepHit(step:Int) {}

	public function beatHit(beat:Int) {}

	public function sectionHit(section:Int) {}

	inline function get_conductor():Conductor
		return Conductor.instance;

	public function refresh() {
		members.sort((b1, b2) -> Constants.sortByZIndex(FlxSort.ASCENDING, b1, b2));
	}
}
