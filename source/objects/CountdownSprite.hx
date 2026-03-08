package objects;

import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class CountdownSprite extends AYSSprite {
	override public function new() {
		super();

		frames = FlxAtlasFrames.fromSparrow('assets/ui/countdown.png', 'assets/ui/countdown.xml');

		addPrefixAnimation('ready glow', 'ready glow');
		addPrefixAnimation('ready regular', 'ready regular');
		addPrefixAnimation('3', '3');
		addPrefixAnimation('2', '2');
		addPrefixAnimation('1', '1');
		addPrefixAnimation('go', 'go');
	}

	public function display(phase:String) {
		playAnim(phase);
		alpha = 1;

        updateHitbox();
        screenCenter();

		if (!phase.startsWith('ready'))
			FlxG.sound.play('assets/ui/intro-$phase${Constants.EXT_AUDIO}');
	}
}
