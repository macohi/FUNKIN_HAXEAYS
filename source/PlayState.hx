package;

import ui.MusicBeatState;
import objects.Character;

class PlayState extends MusicBeatState
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

	override function beatHit(beat:Int)
	{
		super.beatHit(beat);

		player.dance();
	}
}
