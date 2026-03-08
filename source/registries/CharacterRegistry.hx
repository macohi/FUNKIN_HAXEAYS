package registries;

import sys.FileSystem;
import data.characters.CharacterMetadata;
import lime.utils.Assets;
import haxe.Json;
import haxe.io.Path;

class CharacterRegistry extends BaseRegistry<CharacterMetadata> {
	public static var instance:CharacterRegistry = null;

	override public function new() {
		super('characters');
	}

	override function loadAsset(asset:String):Bool {
		if (!FileSystem.isDirectory(getPath(asset)))
			return false;

		try {
			var assetData:CharacterMetadata = Json.parse(Assets.getText(getPath(asset + '/meta${Constants.EXT_CHARACTER_META}')));

			data.set(Path.withoutExtension(Path.withoutDirectory(asset)), assetData);

			return true;
		} catch (e) {
			error('Error loading "$asset" character metadata: $e');
		}

		return super.loadAsset(asset);
	}
}
