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
	public var damsel:Character;
	public var opponent:Character;

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

		if (song.damsel != null)
		{
			damsel = new Character(song.damsel);
			add(damsel);
		}

		if (song.opponent != null)
		{
			opponent = new Character(song.opponent);
			add(opponent);
		}

		scriptCall('onSongStart');
		song.playAudio();
	}

	public function scriptCall(m:String, ?a:Array<Dynamic>)
	{
		song.scriptCall(m, a);
		player.scriptCall(m, a);
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
