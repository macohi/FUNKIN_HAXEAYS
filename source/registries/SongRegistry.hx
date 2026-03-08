package registries;

import sys.FileSystem;
import lime.utils.Assets;
import haxe.Json;
import haxe.io.Path;
import data.song.SongMetaData;

class SongRegistry extends BaseRegistry<SongMetaData> {
	public static var instance:SongRegistry = null;

	override public function new() {
		super('songs');
	}

	override function loadAsset(asset:String):Bool {
		if (!FileSystem.isDirectory(getPath(asset)))
			return false;
        
		try {
			var assetData:SongMetaData = Json.parse(Assets.getText(getPath(asset + '/meta${Constants.EXT_SONG_META}')));

			data.set(Path.withoutExtension(Path.withoutDirectory(asset)), assetData);

			return true;
		} catch (e) {
			error('Error loading "$asset" song metadata: $e');
		}

		return super.loadAsset(asset);
	}
}
