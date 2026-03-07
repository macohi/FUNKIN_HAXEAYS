package objects;

import scripting.BaseScript;

class ScriptHolder {
	public var scriptFiles:Array<BaseScript> = [];

	public function scriptCall(method:String, ?args:Array<Dynamic>)
		for (s in scriptFiles)
			s.call(method, args);

	public function scriptSet(variable:String, value:Dynamic)
		for (s in scriptFiles)
			s.set(variable, value);

	public function scriptGet(variable:String):Dynamic {
		var res = null;

		for (s in scriptFiles)
			if (res == null)
				res = s.get(variable);

		return res;
	}

	public function new() {}
}
