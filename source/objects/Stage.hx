package objects;

import data.song.SongMetaData;
import data.stage.StagePropData;
import data.stage.StageCharacterInfoData;
import flixel.util.FlxSort;
import scripting.ScriptManager;
import scripting.StageScript;
import haxe.Json;
import lime.utils.Assets;
import debugging.DebugLogger;
import sys.FileSystem;
import scripting.BaseScript;
import data.stage.StageMetaData;
import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.FlxBasic;

class Stage extends FlxTypedContainer<FlxBasic> {
	public var id:String = '';

	public var metadata:StageMetaData;

	private var scriptHolder:ScriptHolder;

	public function getPath(path:String):String {
		return 'assets/stages/${this.id}/$path';
	}

	public var player:Character;
	public var damsel:Character;
	public var opponent:Character;

	override public function new(song:SongMetaData) {
		super();

		this.id = song.stage;

		scriptHolder = new ScriptHolder();

		if (song.player != null) {
			player = new Character(song.player);
			player.zIndex = 200;
			add(player);

			player.screenCenter();
			player.x += player.width;
		}

		if (song.damsel != null) {
			damsel = new Character(song.damsel);
			damsel.zIndex = 100;
			add(damsel);

			damsel.screenCenter();
			damsel.y -= 100;
		}

		if (song.opponent != null) {
			opponent = new Character(song.opponent);
			opponent.zIndex = 300;
			add(opponent);

			opponent.screenCenter();
			opponent.x -= opponent.width;
		}

		if (!Assets.exists(getPath('meta${Constants.EXT_STAGE_META}'))) {
			DebugLogger.error('Stage ${this.id} is missing their metadata file');
			return;
		}

		try {
			metadata = Json.parse(Assets.getText(getPath('meta${Constants.EXT_STAGE_META}')));
		} catch (e) {
			DebugLogger.error('Stage ${this.id} had issues loading the metadata file: ${e}');
			metadata = null;
		}

		if (metadata != null) {
			loadProps();

			if (metadata.characters != null && PlayState.instance != null)
				parseCharactersField();
		}

		scriptFiles = ScriptManager.readScriptFolder(getPath('scripts'), function(s) {
			return new StageScript(this.id, s);
		});
	}

	public function loadProps() {
		trace('Loading props for stage: ${this.id}');
		for (prop in metadata.props) {
			if (prop == null)
				continue;
			if (prop.assetType == null)
				continue;

			switch (prop.assetType) {
				case image:
					parseImageProp(prop);

				default:
					trace('Unimplemented prop asset type: ${prop.assetType}');
			}
		}
	}

	public function parseImageProp(prop:StagePropData) {
		var image:AYSSprite = new AYSSprite();

		if (prop.assetPath != null)
			image.loadGraphic(getPath('props/${prop.assetPath}${Constants.EXT_PNG}'));

		if (prop.position != null) {
			image.x = prop.position[0] ?? 0;
			image.y = prop.position[1] ?? 0;
		}
		if (prop.scale != null) {
			image.scale.x = prop.scale[0] ?? 0;
			image.scale.y = prop.scale[1] ?? 0;
		}
		if (prop.scroll != null) {
			image.scrollFactor.x = prop.scroll[0] ?? 0;
			image.scrollFactor.y = prop.scroll[1] ?? 0;
		}
		if (prop.zIndex != null)
			image.zIndex = prop.zIndex;
		if (prop.alpha != null)
			image.alpha = prop.alpha;

		trace(' * image: ${prop.id}');
		add(image);
	}

	public function parseCharactersField() {
		for (char in Reflect.fields(metadata.characters)) {
			var playStateChar:Character = Reflect.field(this, char);

			if (playStateChar == null)
				continue;

			var charData:StageCharacterInfoData = Reflect.field(metadata.characters, char);

			if (charData.position != null) {
				playStateChar.x = charData.position[0] ?? 0;
				playStateChar.y = charData.position[1] ?? 0;
			}
			if (charData.scale != null) {
				playStateChar.scale.x = charData.scale[0] ?? 0;
				playStateChar.scale.y = charData.scale[1] ?? 0;
			}
			if (charData.scroll != null) {
				playStateChar.scrollFactor.x = charData.scroll[0] ?? 0;
				playStateChar.scrollFactor.y = charData.scroll[1] ?? 0;
			}
			if (charData.zIndex != null)
				playStateChar.zIndex = charData.zIndex;
			if (charData.alpha != null)
				playStateChar.alpha = charData.alpha;
		}
	}

	public function refresh() {
		members.sort((b1, b2) -> Constants.sortByZIndex(FlxSort.ASCENDING, b1, b2));
	}

	public var scriptFiles(get, set):Array<BaseScript>;

	function get_scriptFiles():Array<BaseScript> {
		return scriptHolder.scriptFiles;
	}

	function set_scriptFiles(scriptFiles:Array<BaseScript>):Array<BaseScript> {
		return scriptHolder.scriptFiles = scriptFiles;
	}

	public function scriptCall(method:String, ?args:Array<Dynamic>)
		scriptHolder.scriptCall(method, args);

	public function scriptSet(variable:String, value:Dynamic)
		scriptHolder.scriptSet(variable, value);

	public function scriptGet(variable:String):Dynamic
		return scriptHolder.scriptGet(variable);
}
