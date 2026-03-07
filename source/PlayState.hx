package;

import debugging.DebugLogger;
import flixel.sound.FlxSound;
import objects.Song;
import ui.MusicBeatState;
import objects.Character;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;

	public var song:Song;

	public var audioFiles:Array<FlxSound> = [];

	public var player:Character;

	override public function create()
	{
		super.create();

		if (instance != null)
			instance = null;
		instance = this;

		song = new Song('bopeebo');

		if (song.player != null)
		{
			player = new Character(song.player);
			add(player);
		}

		song.playAudio();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (audioFiles.length > 0)
			conductor.time = audioFiles[0].time;
	}

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		player.dance();
	}
}
