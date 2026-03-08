package states;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuState extends MusicBeatState {
	public var itemList:Array<String> = [];

	public var textList:FlxTypedGroup<FlxText>;

	public var curSelect:Int = 0;

	public var camFollow:FlxObject;

	override function create() {
		super.create();

		textList = new FlxTypedGroup<FlxText>();
		add(textList);

		var i = 0;
		for (item in itemList) {
			var text:FlxText = new FlxText(10, 10, 0, item, 48);
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
			FlxG.sound.play(Constants.SFX_CONFIRMMENU);
			accept();
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
			curSelect = itemList.length - 1;
		if (curSelect > itemList.length - 1)
			curSelect = 0;
	}

	public function accept() {}
}
