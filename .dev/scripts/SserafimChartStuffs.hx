/** haxe -m SserafimChartStuffs --interp **/

import sys.io.File;
import haxe.Json;

class SserafimChartStuffs {
	static var baseSinging:Array<Bool> = [false, false, false, false, false, false];

	static function main() {
		var chart:Dynamic = Json.parse(File.getContent('../funkin/spaghetti-chart.json'));
		var metadata:Dynamic = Json.parse(File.getContent('../funkin/spaghetti-metadata.json'));

		var events:Array<Dynamic> = chart.events;
		var notes:Array<Dynamic> = chart.notes.hard;

		var newNotes:Map<String, Array<Dynamic>> = [];
		var newEvents:Array<Dynamic> = [];

		var yunjin:Array<Dynamic> = [];
		var kazuha:Array<Dynamic> = [];
		var chaewon:Array<Dynamic> = [];
		var eunchae:Array<Dynamic> = [];
		var sakura:Array<Dynamic> = [];
		var gf:Array<Dynamic> = [];

		var ranges:Array<Array<Dynamic>> = [];

		var pr = 0;

		for (event in events) {
			switch (event.e) {
				case 'sserafimSing':
					ranges.push([pr, event.t, event.v.singing]);
					pr = event.t;

				case 'FocusCamera':
					if (event.v.char >= 0)
						newEvents.push(event);

				default:
					newEvents.push(event);
			}
		}

		function addnote(note:Dynamic) {
			if (singing_yunjin == true) {
				yunjin.push(note);
			}
			if (singing_kazuha == true) {
				kazuha.push(note);
			}
			if (singing_chaewon == true) {
				chaewon.push(note);
			}
			if (singing_eunchae == true) {
				eunchae.push(note);
			}
			if (singing_sakura == true) {
				sakura.push(note);
			}
			if (singing_gf == true) {
				gf.push(note);
			}
		}

		setGirlsSinging(baseSinging);
		for (i => range in ranges) {
			for (note in notes) {
				if (note.t > range[0] && note.t < range[1]) {
					baseSinging = range[2];
					setGirlsSinging(baseSinging);
					addnote(note);
				}
			}
		}

		newNotes.set('yunjin', yunjin);
		newNotes.set('kazuha', kazuha);
		newNotes.set('chaewon', chaewon);
		newNotes.set('eunchae', eunchae);
		newNotes.set('sakura', sakura);
		newNotes.set('gf', gf);

		for (diff => notes in newNotes)
			trace('spaghetti-$diff (${notes.length} Notes)');

		File.saveContent('../../assets/songs/spaghetti/chart/spaghetti-chart.json', Json.stringify({
			version: chart.version,
			scrollSpeed: chart.scrollSpeed,
			generatedBy: 'FUNKIN_HAXEAYS SserafimChartStuffs',
			events: newEvents,
			notes: newNotes
		}, '\t'));
	}

	static var singing_yunjin:Bool = false;
	static var singing_kazuha:Bool = false;
	static var singing_chaewon:Bool = false;
	static var singing_eunchae:Bool = false;

	// bf too
	static var singing_sakura:Bool = false;

	static var singing_gf:Bool = false;

	static function setGirlsSinging(singingArray:Array<Bool>) {
		if (singingArray.length < 4)
			return;

		singing_yunjin = singingArray[0];

		singing_kazuha = singingArray[1];

		singing_chaewon = singingArray[2];
		singing_eunchae = singingArray[3];

		// bf too
		singing_sakura = singingArray[4];

		singing_gf = singingArray[5];

		// trace('Changed section: ${Json.stringify({
		// 	singing_yunjin: singing_yunjin,
		// 	singing_kazuha: singing_kazuha,
		// 	singing_chaewon: singing_chaewon,
		// 	singing_eunchae: singing_eunchae,
		// 	singing_sakura: singing_sakura,
		// 	singing_gf: singing_gf,
		// }, '\t')}');
	}
}
