package objects.events;

import scripting.ScriptManager;

class SongChartNoteEvent extends SongCharacterAnimationEvent {
	override public function new(time:Float, direction:String, character:Int = 0, kind:Dynamic = '') {
		var v:Dynamic = '';

		if (kind != null) {
			ScriptManager.generalScriptHolder.scriptSet('v', null);
			ScriptManager.generalScriptHolder.scriptCall('ChartNoteEventKind', [kind, character]);
			v = ScriptManager.generalScriptHolder.scriptGet('v');
		}

		super(time, 'sing${direction.toUpperCase()}${v ?? ''}', character);
	}
}
