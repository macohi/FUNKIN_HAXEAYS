package data.song.charts;

import scripting.ScriptManager;
import objects.ScriptHolder;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.SongChartNoteEvent;
import haxe.Json;
import debugging.DebugLogger;
import lime.utils.Assets;
import data.song.charts.VSliceSongData;
import states.PlayState;

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
				default:
					ScriptManager.generalScriptHolder?.scriptCall('vslice_addevent_${event.e}', [event.v, event.t]);
			}
		}

		var difficultyNotes:Array<VSliceChartNote> = Reflect.field(chart.notes, difficulty);

		if (difficultyNotes == null) {
			DebugLogger.error('Missing VSlice song chart (${chartPath}) difficulty: $difficulty');
			return;
		}

		final holdOffset:Float = Constants.MS_PER_SEC / 10;
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
}
