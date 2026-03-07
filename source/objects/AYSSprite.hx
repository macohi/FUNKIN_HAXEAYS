package objects;

import flixel.FlxSprite;

class AYSSprite extends FlxSprite
{
	public function playAnim(anim:String, force:Bool = false, reversed:Bool = false, frame:Int = 0)
	{
		this.animation.play(anim, force, reversed, frame);
	}

	public function addPrefixAnimation(name:String, prefix:String, fps:Int = 24, looped:Bool = false)
	{
		this.animation.addByPrefix(name, prefix, fps, looped);
	}
}
