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

		trace('Adding song(${song.id}) audioFiles');
		for (audioFile in song.audioFiles)
		{
			var a:FlxSound = new FlxSound().loadEmbedded(song.getPath('$audioFile${Constants.EXT_AUDIO}'));
			trace(' * $audioFile');
			audioFiles.push(a);
		}

		if (song.player != null)
		{
			player = new Character(song.player);
			add(player);
		}

		playAudio();
	}

	public function playAudio()
		for (a in audioFiles)
			a.play();

	public function pauseAudio()
		for (a in audioFiles)
			a.pause();

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
