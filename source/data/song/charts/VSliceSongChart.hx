package data.song.charts;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.SongChartNoteEvent;
import haxe.Json;
import debugging.DebugLogger;
import lime.utils.Assets;
import data.song.charts.VSliceSongData;

class VSliceSongChart {
	public static function loadVSliceChart(difficulty:String, song:String) {
		trace('Loading VSlice song');

		var metadata:VSliceMetadata;
		var chart:VSliceChart;

		final chartPath = 'assets/songs/$song/chart/$song-chart${Constants.EXT_SONG_CHART}';
		final metadataPath = 'assets/songs/$song/chart/$song-metadata${Constants.EXT_SONG_CHART}';

		trace(' * chart: ${chartPath}');
		trace(' * metadata: ${metadataPath}');

		if (!Assets.exists(chartPath)) {
			DebugLogger.error('Non-existant VSlice song chart path: ${chartPath}');
			return;
		}

		if (!Assets.exists(metadataPath)) {
			DebugLogger.error('Non-existant VSlice song metadata path: ${metadataPath}');
			return;
		}

		try {
			metadata = Json.parse(Assets.getText(metadataPath));
		} catch (e) {
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): $e');
			return;
		}

		if (metadata == null)
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): Null');

		try {
			chart = Json.parse(Assets.getText(chartPath));
		} catch (e) {
			DebugLogger.error('Error loading VSlice song chart (${chartPath}): $e');
			return;
		}

		if (chart == null)
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): Null');

		if (chart.notes == null)
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): Null notes field');

		for (event in chart.events) {
			switch (event.e) {
				case 'FocusCamera':
					event_FocusCamera(event.v, event.t);
				default:
					PlayState.instance.scriptCall('vslice_addevent_${event.e}', [event.v, event.t]);
			}
		}

		var difficultyNotes:Array<VSliceChartNote> = Reflect.field(chart.notes, difficulty);

		if (difficultyNotes == null) {
			DebugLogger.error('Missing VSlice song chart (${chartPath}) difficulty: $difficulty');
			return;
		}

		final holdOffset:Float = Constants.MS_PER_SEC / 4;
		for (note in difficultyNotes) {
			var direction = '';

			switch (note.d % 4) {
				case 0:
					direction = 'left';
				case 1:
					direction = 'down';
				case 2:
					direction = 'up';
				case 3:
					direction = 'right';
			}

			var l = 0.0;

			if (note.l > 0) {
				while (note.l > 0) {
					PlayState.instance.addEventObject(new SongChartNoteEvent(note.t + l, direction, (Math.floor(note.d / 4) < 1 ? 1 : 0)));

					note.l -= holdOffset;
					l += holdOffset;
				}
			} else
				PlayState.instance.addEventObject(new SongChartNoteEvent(note.t, direction, (Math.floor(note.d / 4) < 1 ? 1 : 0)));
		}
	}

	static function event_FocusCamera(v:Dynamic, t:Float) {
		if (v == null)
			return;

		switch (v) {
			case -1:
				return;

			case 0:
				PlayState.instance.addEvent(t / Constants.MS_PER_SEC, function() {
					if (PlayState.instance.stage.player != null)
						PlayState.instance.camFollow.setPosition(PlayState.instance.stage.player.getGraphicMidpoint().x,
							PlayState.instance.stage.player.getGraphicMidpoint().y);
				});
				return;
			case 1:
				PlayState.instance.addEvent(t / Constants.MS_PER_SEC, function() {
					if (PlayState.instance.stage.opponent != null)
						PlayState.instance.camFollow.setPosition(PlayState.instance.stage.opponent.getGraphicMidpoint().x,
							PlayState.instance.stage.opponent.getGraphicMidpoint().y);
				});
				return;
			case 2:
				PlayState.instance.addEvent(t / Constants.MS_PER_SEC, function() {
					if (PlayState.instance.stage.damsel != null)
						PlayState.instance.camFollow.setPosition(PlayState.instance.stage.damsel.getGraphicMidpoint().x,
							PlayState.instance.stage.damsel.getGraphicMidpoint().y);
				});
				return;
		}

		var char:Int = v.char;

		var xOffset:Float = v.x;
		var yOffset:Float = v.y;

		var duration:Float = v.duration;

		var ease:String = v.ease;
		var easeDir:String = v.easeDir;

		var targetX = xOffset;
		var targetY = yOffset;

		switch (char) {
			case -1:
				PlayState.instance.camFollow.setPosition(xOffset, yOffset);

			case 0:
				if (PlayState.instance.stage.player != null) {
					targetX += PlayState.instance.stage.player.cameraFollowPoint.x;
					targetY += PlayState.instance.stage.player.cameraFollowPoint.y;
				}

			case 1:
				if (PlayState.instance.stage.opponent != null) {
					targetX += PlayState.instance.stage.opponent.cameraFollowPoint.x;
					targetY += PlayState.instance.stage.opponent.cameraFollowPoint.y;
				}

			case 2:
				if (PlayState.instance.stage.damsel != null) {
					targetX += PlayState.instance.stage.damsel.cameraFollowPoint.x;
					targetY += PlayState.instance.stage.damsel.cameraFollowPoint.y;
				}
		}

		switch (ease) {
			case 'CLASSIC':
				PlayState.instance.addEvent(t / Constants.MS_PER_SEC, function() {
					PlayState.instance.camFollow.setPosition(targetX, targetY);
				});
			case 'INSTANT':
				PlayState.instance.addEvent(t / Constants.MS_PER_SEC, function() {
					PlayState.instance.camFollow.setPosition(targetX, targetY);
					PlayState.instance.camGame.focusOn(PlayState.instance.camFollow.getPosition());
				});
			default:
				var easeFunctionName = '$ease$easeDir';

				var easeFunction:Null<Float->Float> = Reflect.field(FlxEase, easeFunctionName);
				if (easeFunction == null) {
					trace('Invalid ease function: $easeFunctionName');
					return;
				}

				PlayState.instance.addEvent(t / Constants.MS_PER_SEC, function() {
					FlxTween.tween(PlayState.instance.camFollow, {
						x: targetX,
						y: targetY,
					}, duration, {
						ease: easeFunction
					});
				});
		}
	}
}
