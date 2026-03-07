import crowplexus.iris.Iris;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState {
	override function create() {
		super.create();

		FlxSprite.defaultAntialiasing = true;

		Conductor.instance = new Conductor();

		FlxG.signals.postUpdate.add(function() {
			if (FlxG.keys.justReleased.F3) {
				if (PlayState.instance != null)
				{
					for (audio in PlayState.instance.audioFiles)
						audio.destroy();
				}

				FlxG.resetGame();
			}
		});

		FlxG.switchState(() -> new PlayState());
	}
}
