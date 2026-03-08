package states;

import lime.app.Application;
import flixel.FlxG;
import flixel.text.FlxText;
import registries.SongRegistry;

using StringTools;

class SongSelectState extends MenuState {
	public var songList:Array<String> = [];

	override function create() {
		var i = 0;
		for (song in SongRegistry.instance.songList) {
			song = song.trim();
			var song_metadata = SongRegistry.instance.getEntry(song);

			if (song_metadata == null)
				return;

			itemList.push(song_metadata.name);
			songList.push(song);

			i++;
		}

		super.create();

		var watermark:FlxText = new FlxText(0, 10, FlxG.width, '${Application.current.meta.get('version')}', 16);
		add(watermark);
		watermark.scrollFactor.set();
		watermark.alignment = RIGHT;
	}

	override function accept() {
		super.accept();

		FlxG.switchState(() -> new PlayState(songList[curSelect]));
	}
}
