import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState {
	override function create() {
		super.create();

		Conductor.instance = new Conductor();

		FlxG.switchState(() -> new PlayState());
	}
}
