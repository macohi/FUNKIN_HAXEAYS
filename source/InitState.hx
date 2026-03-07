import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState {
	override function create() {
		super.create();

		FlxSprite.defaultAntialiasing = true;

		Conductor.instance = new Conductor();

		FlxG.switchState(() -> new PlayState());
	}
}
