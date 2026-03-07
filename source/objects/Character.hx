package objects;

import scripting.BaseScript;
import scripting.CharacterScript;
import sys.FileSystem;
import debugging.DebugLogger;
import data.ObjectAnimationType;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import haxe.Json;
import data.CharacterMetadata;
import objects.AYSSprite;

class Character extends AYSSprite
{
	public var id:String = '';

	public var metadata:CharacterMetadata;

	private var scriptHolder:ScriptHolder;

	public function getPath(path:String):String
	{
		return 'assets/characters/${this.id}/$path';
	}

	override public function new(id:String)
	{
		super();

		this.id = id;

		try
		{
			metadata = Json.parse(Assets.getText(getPath('meta${Constants.EXT_CHARACTER_META}')));
		}
		catch (e)
		{
			DebugLogger.error('Character ${this.id} had issues loading the metadata file: ${e}');
			metadata = null;
		}

		if (metadata != null)
			loadCharacter();

		scriptHolder = new ScriptHolder();
		trace('Reading script folder for character: ${this.id}');
		try
		{
			final scriptsFolder:Array<String> = FileSystem.readDirectory(getPath('scripts'));

			for (script in scriptsFolder)
			{
				final getScriptPath = function(s)
				{
					return getPath('scripts/$s');
				}

				if (FileSystem.isDirectory(getScriptPath(script)))
				{
					trace(' * subdirectory (unsupported): ${getScriptPath(script)}');
					continue;
				}

				trace(' * file: ${getScriptPath(script)}');

				var characterScript = new CharacterScript(this.id, script);
				scriptHolder.scriptFiles.push(characterScript);
			}
		}
		catch (e)
		{
			trace(' * Error reading script folder for character "${this.id}": $e');
		}
	}

	public var scriptFiles(get, set):Array<BaseScript>;

	function get_scriptFiles():Array<BaseScript>
	{
		return scriptHolder.scriptFiles;
	}

	function set_scriptFiles(scriptFiles:Array<BaseScript>):Array<BaseScript>
	{
		return scriptHolder.scriptFiles = scriptFiles;
	}

	public function scriptCall(method:String, ?args:Array<Dynamic>)
		scriptHolder.scriptCall(method, args);

	public function scriptSet(variable:String, value:Dynamic)
		scriptHolder.scriptCall(variable, value);

	public function scriptGet(variable:String):Dynamic
		return scriptHolder.scriptGet(variable);

	public function loadCharacter()
	{
		trace('Loading character: ${this.id}');

		switch (metadata.type)
		{
			case sparrow:
				loadSparrowCharacter();

			default:
				DebugLogger.error('Character "${this.id}" has an unknown type: ${metadata.type}');
		}

		dance();
	}

	public function loadSparrowCharacter()
	{
		final imageName = metadata.imageName ?? 'atlas';

		this.frames = FlxAtlasFrames.fromSparrow(getPath('$imageName${Constants.EXT_PNG}'), getPath('$imageName${Constants.EXT_XML}'));

		if (metadata.animations == null)
		{
			DebugLogger.error('Character "${this.id}" is missing the metadata "animations" field.');
			return;
		}

		for (anim in metadata.animations)
		{
			if (anim.name == null)
				continue;

			if (![ObjectAnimationType.prefix].contains(anim.type))
			{
				trace(' * Unsupported animation (${anim.name}) OAT: ${anim.type}');
				continue;
			}

			trace(' * Adding ${anim.type} animation: ${anim.name}');
			if (anim.type == prefix)
				addPrefixAnimation(anim.name, anim.prefix, anim.fps ?? 24, anim.looped ?? false);
		}
	}

	public function dance()
	{
		playAnim('idle');
	}
}
