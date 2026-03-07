package objects;

import debugging.DebugLogger;
import lime.utils.Assets;
import haxe.Json;
import data.SongMetaData;

class Song
{
	public var id:String = '';

	public function getPath(path:String):String
	{
		return 'assets/songs/${this.id}/$path';
	}

	public var metadata:SongMetaData;

	public function new(id:String = 'bopeebo')
	{
		this.id = id;

		try
		{
			metadata = Json.parse(Assets.getText(getPath('meta${Constants.EXT_SONG_META}')));
		}
		catch (e)
		{
			DebugLogger.error('Song "${this.id}" had issues loading the metadata file: ${e}');
			metadata = null;
		}

		if (audioFiles.length == 0)
			DebugLogger.error('Song "${this.id}" has no audio files. Why?');
	}

	public var name(get, never):Null<String>;

	function get_name():Null<String>
		return metadata.name ?? 'Unknown';

	public var artist(get, never):Null<String>;

	function get_artist():Null<String>
		return metadata.artist ?? 'Unknown';

	public var audioFiles(get, never):Null<Array<String>>;

	function get_audioFiles():Null<Array<String>>
		return metadata.audioFiles ?? [];

	public var startingBPM(get, never):Null<Float>;

	function get_startingBPM():Null<Float>
		return metadata.startingBPM ?? null;

	public var stage(get, never):Null<String>;

	function get_stage():Null<String>
		return metadata.stage ?? null;

	public var player(get, never):Null<String>;

	function get_player():Null<String>
		return metadata.player ?? null;

	public var damsel(get, never):Null<String>;

	function get_damsel():Null<String>
		return metadata.damsel ?? null;

	public var opponent(get, never):Null<String>;

	function get_opponent():Null<String>
		return metadata.opponent ?? null;
}
