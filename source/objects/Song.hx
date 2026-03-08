package objects;

import modding.ModCore;
import registries.SongRegistry;
import scripting.ScriptManager;
import sys.FileSystem;
import scripting.SongScript;
import flixel.sound.FlxSound;
import debugging.DebugLogger;
import lime.utils.Assets;
import haxe.Json;
import data.song.SongMetaData;

using StringTools;

class Song extends ScriptHolder {
	public var id:String = '';

	public function getPath(path:String):String {
		return AssetPaths.path('songs/${this.id}/$path');
	}

	public var metadata:SongMetaData;

	override public function new(id:String = 'bopeebo') {
		super();

		this.id = id;

		if (!SongRegistry.instance.data.exists(this.id)) {
			DebugLogger.error('Song ${this.id} is missing it\'s metadata file');
			return;
		}

		metadata = SongRegistry.instance.getEntry(this.id);

		if (songFiles.length == 0)
			DebugLogger.error('Song "${this.id}" has no audio files. Why?');
		else {
			trace('Adding audio files for song: ${this.id}');
			for (audioFile in songFiles) {

				var a:FlxSound = new FlxSound().loadEmbedded(getPath('audio/' + audioFile + Constants.EXT_AUDIO));
				trace(' * $audioFile');
				audioFiles.push(a);
			}
		}

		scriptFiles = ScriptManager.readScriptFolder(getPath('scripts'), function(s) {
			return new SongScript(this.id, s);
		});
	}

	public var audioFiles:Array<FlxSound> = [];

	public function playAudio()
		for (a in audioFiles)
			a.play();

	public function pauseAudio()
		for (a in audioFiles)
			a.pause();

	public var name(get, never):Null<String>;

	function get_name():Null<String>
		return metadata.name ?? 'Unknown';

	public var artist(get, never):Null<String>;

	function get_artist():Null<String>
		return metadata.artist ?? 'Unknown';

	public var songFiles(get, never):Null<Array<String>>;

	function get_songFiles():Null<Array<String>>
		return metadata.songFiles ?? [];

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
