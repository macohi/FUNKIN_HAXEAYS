package modding;

import sys.FileSystem;
import lime.utils.Assets;
import lime.app.Application;
import haxe.Json;

class ModCore {
	public function new() {}

	public static var instance:ModCore = null;

	public var MOD_MIN_API_VERSION:Float = 0.1;

	public var MOD_DIRECTORY:String = 'mods';
	public var MOD_METADATA_FILE:String = 'meta.json';

	public var allMods:Array<String> = [];

	public var enabledMods(get, never):Array<String>;

	function get_enabledMods():Array<String> {
		return allMods;
	}

	public var modMetadatas:Map<String, ModMetadata> = [];

	public function getModName(mod:String) {
		return modMetadatas.get(mod)?.title ?? mod;
	}

	public function init() {
		reloadMods();
	}

	public function reloadMods() {
		reloadModList();
	}

	public function reloadModList() {
		allMods = [];
		modMetadatas.clear();

		for (mod in FileSystem.readDirectory(MOD_DIRECTORY)) {
			var path:String = '$MOD_DIRECTORY/$mod';

			if (Assets.exists('$path/$MOD_METADATA_FILE')) {
				try {
					var modMeta:ModMetadata = Json.parse(Assets.getText('$path/$MOD_METADATA_FILE'));

					if (modMeta.api_version < MOD_MIN_API_VERSION) {
						alert('"$mod" running on unsupported version',
							'The mod "$mod" is running on an unsupported version : ${modMeta.api_version}\n\n' +
							'Minimum supported version ${MOD_MIN_API_VERSION}\n' + 'The mod will still be added but if things go wrong don\'t be surprised');
					}

					modMeta.authors ??= [];
					modMeta.description ??= 'N / A';

					modMetadatas.set(mod, modMeta);
				} catch (e) {
					alert('"$mod" metadata JSON Parsing Error', 'Could not parse mod metajson file:\n\n' + 'Error Message: ${e.message}');
					continue;
				}

				allMods.push(mod);
			}
		}

		trace(' Reloaded with ${allMods.length} mod(s) found');
		for (mod in allMods) {
			var meta = modMetadatas.get(mod);

			var name = getModName(mod);
			var version = (meta.mod_version != null) ? ' ${meta.mod_version}' : '';

			trace('  * $name$version for api : ${meta.api_version}');
		}

		for (mod in enabledMods)
			if (!allMods.contains(mod))
				enabledMods.remove(mod);
	}

	public function alert(title:String, msg:String) {
		Application.current.window.alert(msg, title);
	}
}
