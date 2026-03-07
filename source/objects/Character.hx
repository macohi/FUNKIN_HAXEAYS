package objects;

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
	}

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
