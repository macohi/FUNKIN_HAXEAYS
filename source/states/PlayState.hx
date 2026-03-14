package states;

import data.song.charts.PsychSongChart;
import substates.PauseSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.CountdownSprite;
import data.song.charts.VSliceSongChart;
import objects.events.SongEvent;
import flixel.FlxObject;
import flixel.util.FlxSort;
import flixel.FlxCamera;
import flixel.FlxG;
import objects.Stage;
import debugging.DebugLogger;
import flixel.sound.FlxSound;
import objects.Song;
import objects.Character;

class PlayState extends MusicBeatState {
	public static var instance:PlayState;

	public var song:Song;

	public var audioFiles(get, never):Array<FlxSound>;

	function get_audioFiles():Array<FlxSound>
		return song.audioFiles;

	public var stage:Stage;

	public var updateConductor:Bool = false;
	public var songStarted:Bool = false;

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

	public var camFollow:FlxObject;

	public var cameraZoom:Float = 1.00;

	public var events:Array<SongEvent> = [];

	private var songID:String = 'urmom';

	public var countdown:CountdownSprite;

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

			if (stage.opponent != null)
				camFollow.setPosition(stage.opponent.getGraphicMidpoint().x, stage.opponent.getGraphicMidpoint().y,);
		}

		camGame.follow(camFollow, LOCKON, 0.04);
		camGame.focusOn(camFollow.getPosition());

		conductor.reset(song.startingBPM);
		conductor.time = conductor.crotchet * -5;

		remakeCountdown();

		FlxG.sound.play(Constants.SFX_SCROLLMENU);

		refresh();

		if (song.metadata == null || audioFiles.length < 1) {
			endSong();
			return;
		}

		scriptCall('onSongLoaded');

		// persistentUpdate = true;
	}

	public function remakeCountdown() {
		try {
			countdown = new CountdownSprite();
			add(countdown);
			countdown.display('ready glow');
			countdown.cameras = [camHUD];
			countdown.screenCenter();
		} catch (e) {
			trace(e);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (updateConductor) {
			if (!paused) {
				conductor.time += elapsed * Constants.MS_PER_SEC;
				conductor.update();
			}

			if (!paused)
				if (conductor.time >= 0 && !songStarted)
					startSong();

			if (!paused)
				checkSongTime();

			if (FlxG.keys.justReleased.ENTER && songStarted)
				pause();
		} else {
			if (FlxG.keys.justReleased.ENTER)
				onSongLoading();
		}

		if (FlxG.keys.justReleased.ESCAPE && !songStarted)
			endSong();

		camGame.zoom = cameraZoom;

		scriptCall('onUpdate', [elapsed]);
	}

	public var focusLostPause:Bool = false;
	public var paused:Bool = false;

	var conductorTimeBeforePause:Float = 0;

	public function pause() {
		paused = !paused;

		if (paused) {
			scriptCall('onPause');

			if (!focusLostPause) {
				openSubState(new PauseSubState());
				camGame.followLerp = 0;
			}

			conductorTimeBeforePause = conductor.time;
			if (songStarted)
				song.pauseAudio();
		} else {
			scriptCall('onUnpause');

			camGame.followLerp = 0.04;

			conductor.time = conductorTimeBeforePause;
			if (songStarted) {
				for (a in audioFiles)
					a.time = conductorTimeBeforePause;

				song.playAudio();
			}
		}
	}

	public function startSong() {
		song.playAudio();
		songStarted = true;

		scriptCall('onSongStarted');
	}

	public function endSong() {
		scriptCall('onSongEnd');

		song.pauseAudio();

		FlxG.switchState(() -> new SongSelectState());
	}

	public function onSongLoading() {
		updateConductor = true;

		var countdownBeathit:Int->Void = null;

		countdownBeathit = function(beat) {
			if (beat < 1) {
				if (countdown.anim == null)
					remakeCountdown();

				switch (beat) {
					case 0:
						remove(countdown);
						countdown.destroy();

						conductor.beatHit.remove(countdownBeathit);

					case -1:
						countdown.display('go');
						scriptCall('countdownTick', [4]);
					case -2:
						countdown.display('1');
						scriptCall('countdownTick', [3]);
					case -3:
						countdown.display('2');
						scriptCall('countdownTick', [2]);
					case -4:
						countdown.display('3');
						scriptCall('countdownTick', [1]);
					case -5:
						countdown.display('ready regular');
						FlxG.sound.play(Constants.SFX_CONFIRMMENU);
						scriptCall('countdownTick', [0]);
				}

				if (beat < 0) {
					FlxTween.cancelTweensOf(countdown);
					FlxTween.tween(countdown, {alpha: 0}, Conductor.instance.crotchet / Constants.MS_PER_SEC, {
						ease: FlxEase.sineInOut
					});
				}
			}
		}

		conductor.beatHit.add(countdownBeathit);
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

		scriptCall('checkSongTime', [conductor.time]);
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

		scriptCall('refresh');
	}

	public function scriptCall(m:String, ?a:Array<Dynamic>) {
		song.scriptCall(m, a);

		stage?.player?.scriptCall(m, a);
		stage?.damsel?.scriptCall(m, a);
		stage?.opponent?.scriptCall(m, a);

		stage.scriptCall(m, a);
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

	public function parseVSliceChart(diff:String, song:String)
		return VSliceSongChart.parseVSliceChart(diff, song);

	public function loadVSliceChart(diff:String, song:String)
		VSliceSongChart.loadVSliceChart(diff, song);

	public function parsePsychChart(diff:String, song:String)
		PsychSongChart.parsePsychChart(diff, song);

	public function loadPsychChart(diff:String, song:String)
		PsychSongChart.loadPsychChart(diff, song);
}
