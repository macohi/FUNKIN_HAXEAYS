import registries.StageRegistry;
import registries.CharacterRegistry;
import registries.SongRegistry;
import objects.ScriptHolder;
import scripting.GeneralScript;
import scripting.ScriptManager;
import crowplexus.iris.Iris;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState {
	override function create() {
		super.create();

		FlxSprite.defaultAntialiasing = true;

		Conductor.instance = new Conductor();

		SongRegistry.instance = new SongRegistry();
		CharacterRegistry.instance = new CharacterRegistry();
		StageRegistry.instance = new StageRegistry();

		ScriptManager.generalScriptHolder = new ScriptHolder();
		ScriptManager.generalScriptHolder.scriptFiles = ScriptManager.readScriptFolder('assets/scripts', function(s) {
			return new GeneralScript(s);
		});

		FlxG.signals.postUpdate.add(function() {
			if (FlxG.keys.justReleased.F3) {
				if (PlayState.instance != null) {
					for (audio in PlayState.instance.audioFiles)
						audio.destroy();
				}

				FlxG.resetGame();
			}
		});

		FlxG.switchState(() -> new PlayState());
	}
}
