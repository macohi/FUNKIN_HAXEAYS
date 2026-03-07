package debugging;

import haxe.PosInfos;
import lime.app.Application;

class DebugLogger
{
	public static function error(e:Dynamic, ?pos:PosInfos)
	{
		trace('ERROR: ' + Std.string(e));
		Application.current.window.alert(Std.string(e), '/!\\ ERROR /!\\');
	}
}
