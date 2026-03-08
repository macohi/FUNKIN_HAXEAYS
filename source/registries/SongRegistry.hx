package registries;

import modding.ModCore;
import sys.FileSystem;
import lime.utils.Assets;
import haxe.Json;
import haxe.io.Path;
import data.song.SongMetaData;

using StringTools;

class SongRegistry extends BaseRegistry<SongMetaData> {
	public static var instance:SongRegistry = null;

	override public function new() {
		super('songs');
	}

	override function loadAsset(asset:String):Bool {
		if (!FileSystem.isDirectory(asset))
			return false;

		try {
			var assetData:SongMetaData = Json.parse(Assets.getText(asset + '/meta${Constants.EXT_SONG_META}'));

			data.set(Path.withoutExtension(Path.withoutDirectory(asset)), assetData);

			return true;
		} catch (e) {
			error('Error loading "$asset" song metadata: $e');
		}

		return super.loadAsset(asset);
	}

	public var songList(get, never):Array<String>;

	function get_songList():Array<String> {
		var sl:Array<String> = [];

		final vanilla = Assets.getText('assets/songs/songList.txt').split('\n');

		for (song in vanilla)
			sl.push(song.trim());

		for (mod in ModCore.instance.enabledMods) {
			if (Assets.exists('mods/$mod/songs/songList.txt')) {
				final modList = Assets.getText('mods/$mod/songs/songList.txt').split('\n');
				for (song in modList)
					sl.push(song.trim());
			}
		}

		return sl;
	}
}
