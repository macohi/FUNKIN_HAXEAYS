import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import modding.ModCore;

class AssetPaths {
	public static function path(p:String) {
		for (mod in ModCore.instance.allMods) {
			final modPath = 'mods/$mod/$p';

			if (Assets.exists(modPath))
				return modPath;
		}

		return 'assets/$p';
	}

	public static function fromSparrow(p:String):FlxAtlasFrames
		return FlxAtlasFrames.fromSparrow(png(p), xml(p));

	public static function hscript(p:String):String
		return path(p + Constants.EXT_HSCRIPT);

	public static function png(p:String):String
		return path(p + Constants.EXT_PNG);

	public static function xml(p:String):String
		return path(p + Constants.EXT_XML);

	public static function audio(p:String):String
		return path(p + Constants.EXT_AUDIO);

	public static function json(p:String):String
		return path(p + Constants.EXT_JSON);
}
