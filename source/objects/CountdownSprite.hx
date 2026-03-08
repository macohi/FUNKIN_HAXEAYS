package objects;

import flixel.FlxG;

using StringTools;

class CountdownSprite extends AYSSprite {
	override public function new() {
		super();

		frames = AssetPaths.fromSparrow('ui/countdown');

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
			FlxG.sound.play(AssetPaths.audio('ui/intro-$phase'));
	}
}
