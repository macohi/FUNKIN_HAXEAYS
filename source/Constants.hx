import objects.events.SongChartNoteEvent;
import states.PlayState;
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
	public static final EXT_FRAG:String = '.frag';

	public static final EXT_SONG_META:String = EXT_JSON;
	public static final EXT_SONG_CHART:String = EXT_JSON;

	public static final EXT_CHARACTER_META:String = EXT_JSON;
	public static final EXT_STAGE_META:String = EXT_JSON;

	public static inline function sortByZIndex(order:Int, b1:FlxBasic, b2:FlxBasic):Int {
		return FlxSort.byValues(order, b1?.zIndex ?? 0, b2?.zIndex ?? 0);
	}

	public static final SONG_EVENT_TIME_WIGGLEROOM_MS:Float = 20;

	public static var SFX_CANCELMENU(get, never):String;
	public static var SFX_CONFIRMMENU(get, never):String;
	public static var SFX_SCROLLMENU(get, never):String;

	static function get_SFX_CANCELMENU():String
		return AssetPaths.audio('ui/cancelMenu');

	static function get_SFX_CONFIRMMENU():String
		return AssetPaths.audio('ui/confirmMenu');

	static function get_SFX_SCROLLMENU():String
		return AssetPaths.audio('ui/scrollMenu');

	public static final CHART_PARSE_NOTE_HOLD_OFFSET:Float = Constants.MS_PER_SEC / 10;

	public static function getNoteDirectionName(d:Int) {
		switch (d % 4) {
			case 0:
				return 'left';
			case 1:
				return 'down';
			case 2:
				return 'up';
			case 3:
				return 'right';
		}

		return '';
	}

	public static function getCharacterOnDirection(d:Int) {
		return (Math.floor(d / 4) < 1) ? 1 : 0;
	}

	public static function addNoteEvent(d:Int, l:Float, t:Float, k:Dynamic) {
		var direction = Constants.getNoteDirectionName(d);
		var char = Constants.getCharacterOnDirection(d);

		// Duo Character Sing

		if (l > 0) {
			var l = 0.0;

			while (l > 0) {
				PlayState.instance.addEventObject(new SongChartNoteEvent(t + l, direction, char, k));

				l -= CHART_PARSE_NOTE_HOLD_OFFSET;
				l += CHART_PARSE_NOTE_HOLD_OFFSET;
			}
		} else
			PlayState.instance.addEventObject(new SongChartNoteEvent(t, direction, char, k));
	}
}
