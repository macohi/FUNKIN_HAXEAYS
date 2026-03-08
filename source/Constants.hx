import flixel.util.FlxSort;
import flixel.FlxBasic;

class Constants {
	public static final MS_PER_SEC:Int = 1000;
	public static final SECS_PER_MIN:Int = 60;

	public static final STEPS_PER_BEAT:Int = 4;
	public static final STEPS_PER_SECTION:Int = 16;

	public static final RESYNC_THRESHOLD:Float = 40;

	public static final EXT_AUDIO:String = '.ogg';
	public static final EXT_JSON:String = '.json';
	public static final EXT_XML:String = '.xml';
	public static final EXT_PNG:String = '.png';
	public static final EXT_HSCRIPT:String = '.hxs';

	public static final EXT_SONG_META:String = EXT_JSON;
	public static final EXT_SONG_CHART:String = EXT_JSON;

	public static final EXT_CHARACTER_META:String = EXT_JSON;
	public static final EXT_STAGE_META:String = EXT_JSON;

	public static inline function sortByZIndex(order:Int, b1:FlxBasic, b2:FlxBasic):Int {
		return FlxSort.byValues(order, b1?.zIndex ?? 0, b2?.zIndex ?? 0);
	}

	public static final SONG_EVENT_TIME_WIGGLEROOM_MS:Float = 20;
}
