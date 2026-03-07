package objects;

import animate.FlxAnimate;

class AYSSprite extends FlxAnimate {
	public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		this.anim.play(animName, force, reversed, frame);
	}

	public function addPrefixAnimation(name:String, prefix:String, fps:Int = 24, looped:Bool = false) {
		this.anim.addByPrefix(name, prefix, fps, looped);
	}

	public function addFrameLabel(name:String, frameLabel:String, fps:Int = 24, looped:Bool = false) {
		this.anim.addByFrameLabel(name, frameLabel, fps, looped);
	}
}
