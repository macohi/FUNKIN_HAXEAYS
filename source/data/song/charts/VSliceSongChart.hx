package data.song.charts;

import scripting.ScriptManager;
import objects.SongChartNoteEvent;
import haxe.Json;
import debugging.DebugLogger;
import lime.utils.Assets;
import data.song.charts.VSliceSongData;
import states.PlayState;

class VSliceSongChart {
	public static function parseVSliceChart(difficulty:String, song:String) {
		trace('Loading VSlice song (difficulty: $difficulty)');

		var metadata:VSliceMetadata;
		var chart:VSliceChart;

		final chartPath = AssetPaths.path('songs/$song/chart/$song-chart${Constants.EXT_SONG_CHART}');
		final metadataPath = AssetPaths.path('songs/$song/chart/$song-metadata${Constants.EXT_SONG_CHART}');

		trace(' * chart: ${chartPath}');
		trace(' * metadata: ${metadataPath}');

		if (!Assets.exists(chartPath)) {
			DebugLogger.error('Non-existant VSlice song chart path: ${chartPath}');
			return null;
		}

		if (!Assets.exists(metadataPath)) {
			DebugLogger.error('Non-existant VSlice song metadata path: ${metadataPath}');
			return null;
		}

		try {
			metadata = Json.parse(Assets.getText(metadataPath));
		} catch (e) {
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): $e');
			return null;
		}

		if (metadata == null)
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): Null');

		try {
			chart = Json.parse(Assets.getText(chartPath));
		} catch (e) {
			DebugLogger.error('Error loading VSlice song chart (${chartPath}): $e');
			return null;
		}

		if (chart == null)
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): Null');

		if (chart.notes == null)
			DebugLogger.error('Error loading VSlice song metadata (${metadataPath}): Null notes field');

		var events:Array<VSliceChartEvent> = [];
		var notes:Array<VSliceChartNote> = [];

		for (event in chart.events)
			events.push(event);

		var difficultyNotes:Array<VSliceChartNote> = Reflect.field(chart.notes, difficulty);

		if (difficultyNotes == null) {
			DebugLogger.error('Missing VSlice song chart (${chartPath}) difficulty: $difficulty');
			return null;
		}

		for (note in difficultyNotes)
			notes.push(note);

		return {
			events: events,
			notes: notes,
		};
	}

	public static function loadVSliceChart(difficulty:String, song:String) {
		var parsedVSlice = parseVSliceChart(difficulty, song);

		if (parsedVSlice == null)
			return;

		var events:Array<VSliceChartEvent> = parsedVSlice.events;
		var notes:Array<VSliceChartNote> = parsedVSlice.notes;

		for (event in events)
			switch (event.e) {
				default:
					ScriptManager.generalScriptHolder?.scriptCall('vslice_addevent_${event.e}', [event.v, event.t]);
			}

		final holdOffset:Float = Constants.MS_PER_SEC / 10;
		for (note in notes) {
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

			if (note.l > 0) {
				var l = 0.0;

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
