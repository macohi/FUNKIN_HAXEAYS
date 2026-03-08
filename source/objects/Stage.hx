package objects;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import states.PlayState;
import registries.StageRegistry;
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
		return AssetPaths.path('stages/${this.id}/$path');
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

		if (!StageRegistry.instance.data.exists(id)) {
			DebugLogger.error('Character ${this.id} is missing their metadata file');
			return;
		}

		metadata = StageRegistry.instance.getEntry(id);

		if (metadata != null) {
			loadProps();

			if (metadata.characters != null && PlayState.instance != null)
				parseCharactersField();

			if (metadata.zoom != null)
				PlayState.instance.cameraZoom = metadata.zoom;
		}

		scriptFiles = ScriptManager.readScriptFolder(getPath('scripts'), function(s) {
			return new StageScript(this.id, s);
		});

		scriptSet('stage', this);
		scriptSet('getNamedProp', getNamedProp);
		scriptSet('addProp', addProp);

		scriptSet('player', player);
		scriptSet('damsel', damsel);
		scriptSet('opponent', opponent);

		scriptCall('buildStage');
	}

	public function addProp(id:String, prop:FlxBasic) {
		add(prop);
		propIdtoObj.set(id, prop);
	}

	public var propIdtoObj:Map<String, FlxBasic> = [];

	public function getNamedProp(id:String):FlxBasic {
		if (propIdtoObj.exists(id))
			return propIdtoObj.get(id);

		return null;
	}

	public function loadProps() {
		trace('Loading props for stage: ${this.id}');

		for (prop in metadata?.props ?? []) {
			if (prop == null)
				continue;
			if (prop.assetType == null)
				continue;

			switch (prop.assetType) {
				case image:
					parseImageProp(prop);

				case solid:
					parseSolidProp(prop);

				case sparrow:
					parseSparrowProp(prop);

				default:
					trace('Unimplemented prop asset type: ${prop.assetType}');
			}
		}
	}

	public function parseImageProp(prop:StagePropData) {
		var image:AYSSprite = new AYSSprite();

		if (prop.assetPath != null)
			image.loadGraphic(getPath('props/${prop.assetPath}${Constants.EXT_PNG}'));

		applyConstPropValues(prop, image);

		trace(' * image: ${prop.id}');

		addProp(prop.id, image);
		scriptCall('addSpriteProp', [image, prop.assetType, prop.id]);
	}

	public function parseSolidProp(prop:StagePropData) {
		var solid:AYSSprite = new AYSSprite();

		solid.makeGraphic(1, 1, FlxColor.WHITE);

		applyConstPropValues(prop, solid);

		trace(' * solid: ${prop.id}');

		addProp(prop.id, solid);
		scriptCall('addSpriteProp', [solid, prop.assetType, prop.id]);
	}

	public function parseSparrowProp(prop:StagePropData) {
		var sparrow:AYSSprite = new AYSSprite();

		if (prop.assetPath != null)
			sparrow.frames = AssetPaths.fromSparrow('stages/${this.id}/props/${prop.assetPath}');

		if (prop.animations != null)
			for (a in prop.animations) {
				if (a.type == prefix)
					sparrow.addPrefixAnimation(a.name, a.prefix, a.fps ?? 24, a.looped ?? false);
			}

		if (prop.startingAnimation != null)
			sparrow.playAnim(prop.startingAnimation);

		applyConstPropValues(prop, sparrow);

		trace(' * sparrow: ${prop.id}');

		addProp(prop.id, sparrow);
		scriptCall('addSpriteProp', [sparrow, prop.assetType, prop.id]);
	}

	public function applyConstPropValues(prop:StagePropData, spr:AYSSprite) {
		if (prop.position != null) {
			spr.x = prop.position[0] ?? 0;
			spr.y = prop.position[1] ?? 0;
		}
		if (prop.scale != null) {
			spr.scale.x = prop.scale[0] ?? 0;
			spr.scale.y = prop.scale[1] ?? 0;
		}
		if (prop.scroll != null) {
			spr.scrollFactor.x = prop.scroll[0] ?? 0;
			spr.scrollFactor.y = prop.scroll[1] ?? 0;
		}
		if (prop.zIndex != null)
			spr.zIndex = prop.zIndex;
		if (prop.alpha != null)
			spr.alpha = prop.alpha;
		if (prop.color != null)
			spr.color = FlxColor.fromString(prop.color);
	}

	public function parseCharactersField() {
		for (char in Reflect.fields(metadata.characters)) {
			var playStateChar:Character = Reflect.field(this, char);

			if (playStateChar == null)
				continue;

			var charData:StageCharacterInfoData = Reflect.field(metadata.characters, char);

			applyConstPropValues(cast charData, playStateChar);

			if (charData.cameraOffsets != null) {
				playStateChar.cameraOffsets[0] += charData.cameraOffsets[0] ?? 0;
				playStateChar.cameraOffsets[1] += charData.cameraOffsets[1] ?? 0;
			}
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
