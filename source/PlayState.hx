package;

import objects.Character;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static var instance:PlayState;

	public var player:Character;

	override public function create()
	{
		super.create();

		if (instance != null)
			instance = null;
		instance = this;

		player = new Character('bf');
		add(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
