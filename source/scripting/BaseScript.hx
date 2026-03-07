package scripting;

import haxe.io.Path;
import lime.utils.Assets;
import crowplexus.iris.Iris;

class BaseScript extends Iris
{
	override public function new(path:String)
	{
		if (Path.extension(path) == Constants.EXT_HSCRIPT.substr(1))
			path = Path.withoutExtension(path);

		final scriptPath:String = 'assets/$path${Constants.EXT_HSCRIPT}';

		super(Assets.getText(scriptPath), {
			name: scriptPath
		});

		setDefaultVariables();

		call('onLoaded');
	}

	public function setDefaultVariables()
	{
		ScriptManager.setDefaultVariables(this);
	}
}
