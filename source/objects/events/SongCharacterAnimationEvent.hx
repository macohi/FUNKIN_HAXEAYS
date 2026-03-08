package objects.events;

import scripting.ScriptManager;
import states.PlayState;

class SongCharacterAnimationEvent extends SongEvent {
	override public function new(time:Float, anim:String, character:Int = 0) {
		super(time, function() {
			ScriptManager.generalScriptHolder.scriptCall('SongCharacterAnimationEvent', [time, anim, character]);

			switch (character) {
				case 1:
					PlayState.instance.stage.player.playAnim(anim);
				case 2:
					PlayState.instance.stage.damsel.playAnim(anim);
				default:
					PlayState.instance.stage.opponent.playAnim(anim);
			}
		});
	}
}
