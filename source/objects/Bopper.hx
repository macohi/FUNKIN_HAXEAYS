package objects;

class Bopper extends AYSSprite {
	public function dance() {
		playAnim('idle');
	}

	public var animationOffsets:Map<String, Array<Float>> = [];

	override function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		applyGeneralOffsets();
		if (animationOffsets.exists(animName))
			offset.add(animationOffsets?.get(animName)[0] ?? 0, animationOffsets?.get(animName)[1] ?? 0);

		super.playAnim(animName, force, reversed, frame);
	}

	public function applyGeneralOffsets() {
		offset.set(0, 0);
	}
}
