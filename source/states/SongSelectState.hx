package states;

import lime.utils.Assets;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import registries.SongRegistry;

using StringTools;

class SongSelectState extends MusicBeatState {
	public var songsList:Array<String> = [];

	public var textList:FlxTypedGroup<FlxText>;

	public var curSelect:Int = 0;

	public var camFollow:FlxObject;

	override function create() {
		super.create();

		textList = new FlxTypedGroup<FlxText>();
		add(textList);

		var i = 0;
		for (song in SongRegistry.instance.songList) {
			song = song.trim();
			var song_metadata = SongRegistry.instance.getEntry(song);

			if (song_metadata == null)
				return;

			songsList.push(song);

			var text:FlxText = new FlxText(10, 10, 0, song_metadata.name, 48);
			text.y = 10 + i * text.size * 2;

			text.font = FlxAssets.FONT_DEFAULT;
			text.ID = i;

			textList.add(text);

			i++;
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.4);
		FlxG.camera.focusOn(camFollow.getPosition());
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		for (text in textList.members) {
			text.color = FlxColor.WHITE;

			if (curSelect == text.ID) {
				camFollow.y = text.y;
				text.color = FlxColor.YELLOW;
			}
		}

		if (FlxG.keys.anyJustReleased([ENTER])) {
			FlxG.switchState(() -> new PlayState(songsList[curSelect]));
		}

		if (FlxG.keys.anyJustReleased([UP, W])) {
			curSelect--;
			FlxG.sound.play(Constants.SFX_SCROLLMENU);
		}
		if (FlxG.keys.anyJustReleased([DOWN, S])) {
			curSelect++;
			FlxG.sound.play(Constants.SFX_SCROLLMENU);
		}

		if (curSelect < 0)
			curSelect = songsList.length - 1;
		if (curSelect > songsList.length - 1)
			curSelect = 0;
	}
}
