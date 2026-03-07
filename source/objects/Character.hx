package objects;

import data.objects.ObjectAnimationType;
import data.objects.ObjectTagData;
import animate.FlxAnimateFrames;
import scripting.BaseScript;
import scripting.CharacterScript;
import sys.FileSystem;
import debugging.DebugLogger;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import haxe.Json;
import data.characters.*;
import objects.AYSSprite;

class Character extends AYSSprite {
	public var id:String = '';

	public var metadata:CharacterMetadata;

	private var scriptHolder:ScriptHolder;

	public function getPath(path:String):String {
		return 'assets/characters/${this.id}/$path';
	}

	override public function new(id:String) {
		super();

		this.id = id;

		scriptHolder = new ScriptHolder();

		if (!Assets.exists(getPath('meta${Constants.EXT_CHARACTER_META}'))) {
			DebugLogger.error('Character ${this.id} is missing their metadata file');
			return;
		}

		try {
			metadata = Json.parse(Assets.getText(getPath('meta${Constants.EXT_CHARACTER_META}')));
		} catch (e) {
			DebugLogger.error('Character ${this.id} had issues loading the metadata file: ${e}');
			metadata = null;
		}

		if (metadata != null)
			loadCharacter();

		trace('Reading script folder for character: ${this.id}');
		try {
			final scriptsFolder:Array<String> = FileSystem.readDirectory(getPath('scripts'));

			for (script in scriptsFolder) {
				final getScriptPath = function(s) {
					return getPath('scripts/$s');
				}

				if (FileSystem.isDirectory(getScriptPath(script))) {
					trace(' * subdirectory (unsupported): ${getScriptPath(script)}');
					continue;
				}

				trace(' * file: ${getScriptPath(script)}');

				var characterScript = new CharacterScript(this.id, script);
				scriptHolder.scriptFiles.push(characterScript);
			}

		} catch (e) {
			trace(' * Error reading script folder for character "${this.id}": $e');
		}
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

	public function loadCharacter() {
		trace('Loading character: ${this.id}');

		switch (metadata.type) {
			case sparrow:
				loadSparrowCharacter();

			case textureatlas:
				loadTextureAtlasCharacter();

			default:
				DebugLogger.error('Character "${this.id}" has an unknown type: ${metadata.type}');
		}

		animationOffsets.clear();
		applyGeneralOffsets();

		for (animation in metadata.animations) {
			if (animation.offsets != null)
				animationOffsets.set(animation.name, [(animation?.offsets[0] ?? 0), (animation?.offsets[1] ?? 0),]);
		}

		dance();
	}

	public function loadSparrowCharacter() {
		final imageName = metadata.imageName ?? 'atlas';

		this.frames = FlxAtlasFrames.fromSparrow(getPath('$imageName${Constants.EXT_PNG}'), getPath('$imageName${Constants.EXT_XML}'));

		if (metadata.animations == null) {
			DebugLogger.error('Character "${this.id}" is missing the metadata "animations" field.');
			return;
		}

		for (anim in metadata.animations) {
			if (anim.name == null)
				continue;

			if (![ObjectAnimationType.prefix].contains(anim.type)) {
				trace(' * Unsupported animation (${anim.name}) OAT: ${anim.type}');
				continue;
			}

			trace(' * Adding ${anim.type} animation: ${anim.name}');
			if (anim.type == prefix)
				addPrefixAnimation(anim.name, anim.prefix, anim.fps ?? 24, anim.looped ?? false);
		}
	}

	public function loadTextureAtlasCharacter() {
		final imageName = metadata.imageName ?? 'atlas';

		this.frames = FlxAnimateFrames.fromAnimate(getPath('$imageName'));

		if (metadata.animations == null) {
			DebugLogger.error('Character "${this.id}" is missing the metadata "animations" field.');
			return;
		}

		for (anim in metadata.animations) {
			if (anim.name == null)
				continue;

			if (![ObjectAnimationType.framelabel].contains(anim.type)) {
				trace(' * Unsupported animation (${anim.name}) OAT: ${anim.type}');
				continue;
			}

			trace(' * Adding ${anim.type} animation: ${anim.name}');
			if (anim.type == framelabel)
				addFrameLabel(anim.name, anim.framelabel, anim.fps ?? 24, anim.looped ?? false);
		}
	}

	public function getTag(tagName:String):ObjectTagData {
		for (tag in metadata?.tags ?? [])
			if (tag.name == tagName)
				return tag;

		return null;
	}

	public var danced:Bool = false;

	public function dance() {
		danced = !danced;

		scriptSet('o', false);
		scriptCall('dance');

		// override
		if (scriptGet('o') != null && scriptGet('o') == true)
			return;

		if (getTag('danceIdle') != null) {
			playAnim('dance' + ((danced) ? 'Left' : 'Right'));

			return;
		} else
			playAnim('idle');
	}

	public var animationOffsets:Map<String, Array<Float>> = [];

	override function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		applyGeneralOffsets();
		if (animationOffsets.exists(animName))
			offset.add(animationOffsets?.get(animName)[0] ?? 0, animationOffsets?.get(animName)[1] ?? 0);

		super.playAnim(animName, force, reversed, frame);
	}

	public function applyGeneralOffsets() {
		if (metadata == null || metadata.generalOffsets == null) {
			offset.set(0, 0);
			return;
		}

		offset.set(metadata?.generalOffsets[0] ?? 0, metadata?.generalOffsets[1] ?? 0);
	}
}
