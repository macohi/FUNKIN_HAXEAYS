package substates;

import states.SongSelectState;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import states.PlayState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import objects.AYSSprite;

class PauseSubState extends MusicBeatSubState {
	public var bg:AYSSprite;

	public var itemList:Array<String> = ['Resume', 'Restart', 'Exit'];

	public var textList:FlxTypedGroup<FlxText>;

	public var curSelect:Int = 0;

	public var pauseCam:FlxCamera;

	public var camFollow:FlxObject;

	override function create() {
		super.create();

		pauseCam = new FlxCamera();
		FlxG.cameras.add(pauseCam);
		pauseCam.bgColor.alpha = 0;

		bg = new AYSSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.0;
		add(bg);
		bg.scrollFactor.set();

		FlxTween.tween(bg, {alpha: 0.6}, conductor.quaver / Constants.MS_PER_SEC, {ease: FlxEase.sineInOut});

		textList = new FlxTypedGroup<FlxText>();
		add(textList);

		var i = 0;
		for (item in itemList) {
			var text:FlxText = new FlxText(10, 10, 0, item, 48);
			text.y = 10 + i * text.size * 2;

			text.font = FlxAssets.FONT_DEFAULT;
			text.ID = i;

			text.cameras = [pauseCam];

			textList.add(text);

			text.alpha = 0;
			FlxTween.tween(text, {alpha: 1}, ((conductor.quaver + ((i + 1) * 10)) / Constants.MS_PER_SEC), {ease: FlxEase.sineInOut});

			i++;
		}

		refresh();

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter();
		add(camFollow);

		pauseCam.follow(camFollow, LOCKON, 0.4);
		pauseCam.focusOn(camFollow.getPosition());

		

		var watermark:FlxText = new FlxText(0, 10, FlxG.width, '', 32);
		add(watermark);
		watermark.scrollFactor.set();
		watermark.alignment = RIGHT;
		watermark.alpha = 0;

		watermark.text = 'Song: ${PlayState.instance.song.name}\n';
		watermark.text += 'Artist: ${PlayState.instance.song.artist}\n';

			FlxTween.tween(watermark, {alpha: 1}, 0.6, {ease: FlxEase.sineInOut});
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
			process(itemList[curSelect].toLowerCase());
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

	public function process(item:String) {
		switch (item) {
			case 'resume':
				close();
				PlayState.instance.pause();
			case 'restart':
				FlxG.resetState();
			case 'exit':
				FlxG.switchState(() -> new SongSelectState());
		}
	}
}
