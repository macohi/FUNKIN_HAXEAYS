package scripting;

import haxe.io.Path;
import lime.utils.Assets;
import crowplexus.iris.Iris;

class BaseScript extends Iris {
	override public function new(path:String) {
		if (Path.extension(path) == Constants.EXT_HSCRIPT.substr(1))
			path = Path.withoutExtension(path);

		final scriptPath:String = AssetPaths.hscript(path);

		super(Assets.getText(scriptPath), {
			name: scriptPath
		});

		setDefaultVariables();

		call('onLoaded');
	}

	override function call(fun:String, ?args:Array<Dynamic>):IrisCall {
		@:privateAccess
		if (!this.interp.variables.exists(fun))
			return null;

		return super.call(fun, args);
	}

	public function setDefaultVariables() {
		ScriptManager.setDefaultVariables(this);
	}
}
