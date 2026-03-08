package registries;

import data.stage.StageMetaData;
import sys.FileSystem;
import lime.utils.Assets;
import haxe.Json;
import haxe.io.Path;

class StageRegistry extends BaseRegistry<StageMetaData> {
	public static var instance:StageRegistry = null;

	override public function new() {
		super('stages');
	}

	override function loadAsset(asset:String):Bool {
		if (!FileSystem.isDirectory(getPath(asset)))
			return false;

		try {
			var assetData:StageMetaData = Json.parse(Assets.getText(getPath(asset + '/meta${Constants.EXT_STAGE_META}')));

			data.set(Path.withoutExtension(Path.withoutDirectory(asset)), assetData);

			return true;
		} catch (e) {
			error('Error loading "$asset" stage metadata: $e');
		}

		return super.loadAsset(asset);
	}
}
