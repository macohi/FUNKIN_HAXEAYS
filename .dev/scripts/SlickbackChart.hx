/** haxe -m SlickbackChart --interp **/

import sys.io.File;
import haxe.Json;

class SlickbackChart {
	static function main() {
		var newNotes:Map<String, Array<Dynamic>> = [];
		var newEvents:Array<Dynamic> = [];
		var notes:Array<Dynamic> = [];

		var animates:Dynamic = {};

		newNotes.set('easy', notes);
		newNotes.set('normal', notes);
		newNotes.set('hard', notes);
		newNotes.set('erect', notes);
		newNotes.set('nightmare', notes);

		File.saveContent('../../assets/songs/a-pimp-named-slickback/chart/a-pimp-named-slickback-chart.json', Json.stringify({
			version: '0.0.0',
			scrollSpeed: 1.0,
			generatedBy: 'FUNKIN_HAXEAYS SlickbackChart',
			events: [],
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
