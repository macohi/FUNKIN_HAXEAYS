package registries;

import haxe.PosInfos;
import haxe.io.Path;
import lime.app.Application;

using StringTools;

class BaseRegistry<T>
{
	public var id:String = 'base';

	public function new(id:String, ?fileExt:String)
	{
		this.id = id;

		loadRegistry();
	}

	public function loadRegistry()
	{
		trace('Initalizing registry: $id');

		for (asset in getRegistryAssets())
		{
			var f = loadAsset(asset);

			if (f)
				trace(' * loaded asset: ${getPath(asset)}');
		}
	}

	// TODO: add support for subdirectories
	public function getRegistryAssets():Array<String>
	{
		#if sys
		try
		{
			return sys.FileSystem.readDirectory(getPath('')) ?? [];
		}
		catch (e)
		{
			error(e, 'Registry($id) Error');
		}
		#end

		return [];
	}

	public function loadAsset(asset:String)
	{
		return false;
	}

	public var data:Map<String, T> = [];

	function error(e:Dynamic, t:String = null)
	{
		log(e);
		Application.current.window.alert(Std.string(e), t ?? 'Registry Error');
	}

	function log(e:Dynamic)
	{
		trace(e);
	}

	public function getPath(a:String):String
	{
		final path = 'assets/$id${(a.trim().length != 0 ? '/$a' : '')}';

		return path;
	}

	public function getEntry(entry:String):T
	{
		if (data.exists(entry))
			return data.get(entry);

		return null;
	}
}