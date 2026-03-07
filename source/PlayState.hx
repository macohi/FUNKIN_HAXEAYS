package;

import debugging.DebugLogger;
import flixel.sound.FlxSound;
import objects.Song;
import ui.MusicBeatState;
import objects.Character;

class PlayState extends MusicBeatState {
	public static var instance:PlayState;

	public var song:Song;

	public var audioFiles(get, never):Array<FlxSound>;

	function get_audioFiles():Array<FlxSound>
		return song.audioFiles;

	public var player:Character;
	public var damsel:Character;
	public var opponent:Character;

	public var songLoaded:Bool = false;
	public var songStarted:Bool = false;

	override public function create() {
		super.create();

		if (instance != null)
			instance = null;
		instance = this;

		song = new Song('bopeebo');

		songLoaded = true;

		if (song.player != null) {
			player = new Character(song.player);
			add(player);

			player.screenCenter();
			player.x += player.width;
		}

		if (song.damsel != null) {
			damsel = new Character(song.damsel);
			add(damsel);

			damsel.screenCenter();
			damsel.y -= 100;
		}

		if (song.opponent != null) {
			opponent = new Character(song.opponent);
			add(opponent);

			opponent.screenCenter();
			opponent.x -= opponent.width;
		}

		conductor.bpm = song.startingBPM;

		scriptCall('onSongStart');
	}

	public function scriptCall(m:String, ?a:Array<Dynamic>) {
		song.scriptCall(m, a);

		player.scriptCall(m, a);
		damsel.scriptCall(m, a);
		opponent.scriptCall(m, a);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (songLoaded) {
			conductor.time += elapsed * Constants.MS_PER_SEC;
			conductor.update();

			if (conductor.time >= 0 && !songStarted)
				startSong();

			checkSongTime();
		}
	}

	public function startSong() {
		song.playAudio();
		songStarted = true;
	}

	public function checkSongTime() {
		if (audioFiles.length < 1)
			return;

		// End the song if the time has come...
		// Doing this normally has a problem unfortunately :(
		if (conductor.time >= audioFiles[0].length) {
			endSong();
			return;
		}
	}

	public function endSong() {}

	override function beatHit(beat:Int) {
		super.beatHit(beat);

		scriptCall('beatHit', [beat]);

		player.dance();
		damsel.dance();
		opponent.dance();
	}

	override function stepHit(step:Int) {
		super.stepHit(step);

		scriptCall('stepHit', [step]);
	}
}
