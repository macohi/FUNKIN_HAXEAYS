package data.song.charts;

import objects.events.SongBPMChangeEvent;
import states.PlayState;
import data.song.charts.PsychSongData.SwagSection;
import scripting.ScriptManager;
import data.song.charts.PsychSongData.SwagSong;
import lime.utils.Assets;
import haxe.Json;
import debugging.DebugLogger;

class PsychSongChart {
	public static function parsePsychChart(difficulty:String, song:String):Dynamic {
		trace('Parsing Psych Chart: $song (difficulty: $difficulty)');

		var chart:SwagSong;

		final chartPath = AssetPaths.path('songs/$song/chart/$song$difficulty${Constants.EXT_SONG_CHART}');

		trace(' * chart: ${chartPath}');

		if (!Assets.exists(chartPath)) {
			DebugLogger.error('Non-existant Psych chart path: ${chartPath}');
			return null;
		}

		try {
			chart = Json.parse(Assets.getText(chartPath)).song;
		} catch (e) {
			DebugLogger.error('Error loading Psych chart (${chartPath}): $e');
			return null;
		}

		var noteSections:Array<Dynamic> = [];
		var events:Array<Dynamic> = [];

		if (chart.notes != null)
			for (note in chart.notes)
				noteSections.push(note);

		if (chart.events != null)
			for (event in chart.events)
				events.push(event);

		return {
			noteSections: noteSections,
			events: events,
		};
	}

	public static function loadPsychChart(difficulty:String, song:String) {
		final chartData:Dynamic = parsePsychChart(difficulty, song);

		if (chartData == null)
			return;

		final events:Array<Dynamic> = chartData.events;
		final noteSections:Array<SwagSection> = chartData.noteSections;

		if (noteSections == null)
			return;

		for (i => section in noteSections) {
			final section_time = (Conductor.instance.quaver * Constants.STEPS_PER_SECTION) * i;

			if (section.changeBPM)
				PlayState.instance.addEventObject(new SongBPMChangeEvent(section_time, section.bpm));

			if (section.mustHitSection)
				ScriptManager.generalScriptHolder?.scriptCall('vslice_addevent_FocusCamera', [1, section_time]);
			else
				ScriptManager.generalScriptHolder?.scriptCall('vslice_addevent_FocusCamera', [0, section_time]);

			for (note in section.sectionNotes) {
				if (note == null)
					continue;

				Constants.addNoteEvent(note[1], note[2], note[0], note[3]);
			}
		}

		if (events == null)
			return;

		for (event in events) {
			if (event == null)
				continue;

			final thefuckingevents:Array<Dynamic> = event[1][0];

			if (thefuckingevents == null)
				continue;

			for (even in thefuckingevents) {
				switch (even[0]) {
					default:
						ScriptManager.generalScriptHolder?.scriptCall('psych_addevent_${even[0]}', [even[1], even[2], event[0]]);
				}
			}
		}
	}
}
