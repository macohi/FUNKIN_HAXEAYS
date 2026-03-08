import modding.ModCore;
import states.PlayState;
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
	public function instanceInitalization() {
		ModCore.instance = new ModCore();
		ModCore.instance.init();

		Conductor.instance = new Conductor();

		SongRegistry.instance = new SongRegistry();
		CharacterRegistry.instance = new CharacterRegistry();
		StageRegistry.instance = new StageRegistry();
	}

	public function generalScriptInitalization() {
		ScriptManager.generalScriptHolder = new ScriptHolder();
		ScriptManager.generalScriptHolder.scriptFiles = ScriptManager.readScriptFolder('assets/scripts', function(s) {
			return new GeneralScript(s);
		});

		for (mod in ModCore.instance.allMods) {
			var modScriptFiles = ScriptManager.readScriptFolder('mods/$mod/scripts', function(s) {
				return new GeneralScript(s);
			});

			for (script in modScriptFiles)
				ScriptManager.generalScriptHolder.scriptFiles.push(script);
		}
	}

	override function create() {
		super.create();

		FlxSprite.defaultAntialiasing = true;

		FlxG.mouse.visible = false;

		instanceInitalization();

		generalScriptInitalization();

		if (!FlxG.signals.postUpdate.has(fKeys))
			FlxG.signals.postUpdate.add(fKeys);

		FlxG.switchState(() -> new states.SongSelectState());
	}

	public function fKeys() {
		if (FlxG.keys.justReleased.F3) {
			if (PlayState.instance != null)
				PlayState.instance.song.pauseAudio();
			FlxG.resetGame();
		}

		if (FlxG.keys.justReleased.F5) {
			instanceInitalization();
			generalScriptInitalization();

			FlxG.resetState();
		}
	}
}
