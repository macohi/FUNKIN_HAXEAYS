package states;

import data.song.charts.VSliceSongChart;
import objects.SongEvent;
import flixel.FlxObject;
import flixel.util.FlxSort;
import flixel.FlxCamera;
import flixel.FlxG;
import objects.Stage;
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

	public var stage:Stage;

	public var songLoaded:Bool = false;
	public var songStarted:Bool = false;

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

	public var camFollow:FlxObject;

	public var cameraZoom:Float = 1.00;

	public var events:Array<SongEvent> = [];

	private var songID:String = 'urmom';

	override public function new(?songID:String) {
		super();

		this.songID = songID;
	}

	override public function create() {
		super.create();

		if (instance != null)
			instance = null;
		instance = this;

		camHUD = new FlxCamera();
		camGame = new FlxCamera();
		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD);
		camHUD.bgColor.alpha = 0;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter();
		add(camFollow);

		@:privateAccess
		FlxCamera._defaultCameras = [camGame];

		song = new Song(songID);

		if (song.stage != null) {
			stage = new Stage(song.metadata);

			add(stage);
		}

		camGame.follow(camFollow, LOCKON, 0.04);
		camGame.focusOn(camFollow.getPosition());

		conductor.bpm = song.startingBPM;
		conductor.time -= (conductor.quaver * Constants.STEPS_PER_SECTION);

		songLoaded = true;
		refresh();
		scriptCall('onSongLoaded');

		if (song.metadata == null) {
			endSong();
			return;
		}
	}

	public var focusLostPause:Bool = false;
	public var paused:Bool = false;

	var conductorTimeBeforePause:Float = 0;

	public function pause() {
		paused = !paused;

		if (paused) {
			scriptCall('onPause');
			
			conductorTimeBeforePause = conductor.time;
			song.pauseAudio();
		} else {
			scriptCall('onUnpause');

			conductor.time = conductorTimeBeforePause;

			for (a in audioFiles)
				a.time = conductorTimeBeforePause;

			song.playAudio();
		}
	}

	public function startSong() {
		song.playAudio();
		songStarted = true;
		scriptCall('onSongStarted');
	}

	public function endSong() {
		scriptCall('onSongEnd');
		FlxG.switchState(() -> new SongSelectState());
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (songLoaded) {
			if (!paused) {
				conductor.time += elapsed * Constants.MS_PER_SEC;
				conductor.update();
			}

			if (conductor.time >= 0 && !songStarted)
				startSong();

			if (!paused)
				checkSongTime();
		}

		camGame.zoom = cameraZoom;
	}

	public function checkSongTime() {
		for (event in events) {
			final et = event.time / Constants.MS_PER_SEC;
			final wrs = Constants.SONG_EVENT_TIME_WIGGLEROOM_MS / Constants.MS_PER_SEC;

			final ct = conductor.time / Constants.MS_PER_SEC;

			if ((et - wrs) < (ct) && (et + wrs) < ct) {
				event.event();
				events.remove(event);
			}
		}

		if (audioFiles.length < 1)
			return;

		// End the song if the time has come...
		// Doing this normally has a problem unfortunately :(
		if (conductor.time >= audioFiles[0].length || audioFiles.length < 1) {
			endSong();
			return;
		}
	}

	public function addEvent(time:Float, event:Void->Void)
		addEventObject(new SongEvent(time * Constants.MS_PER_SEC, event));

	public function addEventObject(eventObj:SongEvent)
		events.push(eventObj);

	override function onFocusLost() {
		super.onFocusLost();

		if (!focusLostPause && !paused) {
			focusLostPause = true;
			pause();
		}
	}

	override function onFocus() {
		super.onFocus();

		if (focusLostPause && paused) {
			focusLostPause = false;
			pause();
		}
	}

	override function refresh() {
		super.refresh();

		stage.refresh();
	}

	public function scriptCall(m:String, ?a:Array<Dynamic>) {
		song.scriptCall(m, a);

		stage?.player?.scriptCall(m, a);
		stage?.damsel?.scriptCall(m, a);
		stage?.opponent?.scriptCall(m, a);
	}

	override function beatHit(beat:Int) {
		super.beatHit(beat);

		scriptCall('beatHit', [beat]);

		stage?.player?.dance();
		stage?.damsel?.dance();
		stage?.opponent?.dance();
	}

	override function stepHit(step:Int) {
		super.stepHit(step);

		scriptCall('stepHit', [step]);
	}

	override function sectionHit(section:Int) {
		super.sectionHit(section);

		scriptCall('sectionHit', [section]);
	}

	public function loadVSliceChart(diff:String, song:String) {
		VSliceSongChart.loadVSliceChart(diff, song);
	}
}
