package objects;

import flixel.math.FlxPoint;
import scripting.ScriptManager;
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

class Character extends Bopper {
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

		cameraFollowPoint = new FlxPoint();

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

		scriptFiles = ScriptManager.readScriptFolder(getPath('scripts'), function(s) {
			return new CharacterScript(this.id, s);
		});
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

	public var cameraFollowPoint:FlxPoint = new FlxPoint(0, 0);

	public function loadCharacter() {
		trace('Loading character: ${this.id}');

		switch (metadata.type) {
			case sparrow:
				loadSparrowCharacter();

			case textureatlas:
				loadTextureAtlasCharacter();

			default:
				DebugLogger.error('Character "${this.id}" has an unknown or unsupported asset type: ${metadata.type}');
		}

		cameraFollowPoint.set(this.getGraphicMidpoint().x, this.getGraphicMidpoint().y);

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

	override public function dance() {
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
			super.dance();
	}

	override public function applyGeneralOffsets() {
		if (metadata == null || metadata.generalOffsets == null) {
			super.applyGeneralOffsets();
			return;
		}

		offset.set(metadata?.generalOffsets[0] ?? 0, metadata?.generalOffsets[1] ?? 0);
	}
}
