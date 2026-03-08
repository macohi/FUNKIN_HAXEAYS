package registries;

import modding.ModCore;
import haxe.PosInfos;
import haxe.io.Path;
import lime.app.Application;

using StringTools;

class BaseRegistry<T> {
	public var id:String = 'base';

	public function new(id:String, ?fileExt:String) {
		this.id = id;

		loadRegistry();
	}

	public function loadRegistry() {
		trace('Initalizing registry: $id');

		for (asset in getRegistryAssets()) {
			var f = loadAsset(asset);

			if (f)
				trace(' * loaded asset: ${asset}');
			else
				trace(' * couldnt load asset: ${asset}');
		}
	}

	// TODO: add support for subdirectories
	public function getRegistryAssets():Array<String> {
		var assets:Array<String> = [];

		#if sys
		try {
			for (a in sys.FileSystem.readDirectory(getPath('')) ?? [])
				assets.push(getPath(a));

			for (mod in ModCore.instance.enabledMods)
				for (a in sys.FileSystem.readDirectory(getPath('').replace('assets/', 'mods/${mod}/')) ?? [])
					assets.push(getPath(a).replace('assets/', 'mods/${mod}/'));

		} catch (e) {
			error(e, 'Registry($id) Error');
		}
		#end

		return assets;
	}

	public function loadAsset(asset:String) {
		return false;
	}

	public var data:Map<String, T> = [];

	function error(e:Dynamic, t:String = null) {
		log(e);
		Application.current.window.alert(Std.string(e), t ?? 'Registry Error');
	}

	function log(e:Dynamic) {
		trace(e);
	}

	public function getPath(a:String):String {
		final path = 'assets/$id${(a.trim().length != 0 ? '/$a' : '')}';

		return path;
	}

	public function getEntry(entry:String):T {
		if (data.exists(entry))
			return data.get(entry);

		return null;
	}
}
