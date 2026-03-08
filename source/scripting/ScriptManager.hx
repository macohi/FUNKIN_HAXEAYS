package scripting;

import data.song.charts.VSliceSongChart;
import sys.FileSystem;
import data.*;
import debugging.*;
import objects.*;
import states.*;
import substates.*;

class ScriptManager {
	// alot yoinked from mobmod hehehehehaw
	public static var defaultVariables:Map<String, Dynamic> = [
		// Haxe related stuff
		'Std' => Std,
		'Math' => Math,
		'Reflect' => Reflect,
		'StringTools' => StringTools,
		'Json' => haxe.Json,
		// OpenFL & Lime related stuff
		'Assets' => openfl.utils.Assets,
		'Application' => lime.app.Application,
		'Main' => Main,
		// Flixel related stuff
		'FlxG' => flixel.FlxG,
		'FlxSprite' => flixel.FlxSprite,
		'FlxBasic' => flixel.FlxBasic,
		'FlxCamera' => flixel.FlxCamera,
		'FlxEase' => flixel.tweens.FlxEase,
		'FlxTween' => flixel.tweens.FlxTween,
		'FlxSound' => flixel.sound.FlxSound,
		'FlxAssets' => flixel.system.FlxAssets,
		'FlxMath' => flixel.math.FlxMath,
		'FlxGroup' => flixel.group.FlxGroup,
		'FlxTypedGroup' => flixel.group.FlxGroup.FlxTypedGroup,
		'FlxSpriteGroup' => flixel.group.FlxSpriteGroup,
		// 'FlxTypeText' => flixel.addons.text.FlxTypeText,
		'FlxText' => flixel.text.FlxText,
		'FlxTimer' => flixel.util.FlxTimer,
		'FlxPoint' => getMacroAbstractClass('flixel.math.FlxPoint'),
		'FlxAxes' => getMacroAbstractClass('flixel.util.FlxAxes'),
		'FlxColor' => getMacroAbstractClass('flixel.util.FlxColor'),
		// HAXEAYS related stuff
		'VSliceSongChart' => VSliceSongChart,
		'DebugLogger' => DebugLogger,
		'AYSSprite' => AYSSprite,
		'Bopper' => Bopper,
		'Character' => Character,
		'ScriptHolder' => ScriptHolder,
		'Song' => Song,
		'SongCharacterAnimationEvent' => SongCharacterAnimationEvent,
		'SongChartNoteEvent' => SongChartNoteEvent,
		'SongEvent' => SongEvent,
		'Stage' => Stage,
		'BaseScript' => BaseScript,
		'CharacterScript' => CharacterScript,
		'ScriptManager' => ScriptManager,
		'SongScript' => SongScript,
		'MusicBeatState' => MusicBeatSubState,
		'Conductor' => Conductor,
		'Constants' => Constants,
		'PlayState' => PlayState,
		'SongSelectState' => SongSelectState,
	];

	public static inline function getMacroAbstractClass(className:String) {
		return Type.resolveClass('${className}_HSC');
	}

	public static function setDefaultVariables(script:BaseScript) {
		for (variable => value in defaultVariables)
			script.set(variable, value, false);
	}

	public static function readScriptFolder(baseFolder:String, makeScript:String->BaseScript):Array<BaseScript> {
		var scripts:Array<BaseScript> = [];

		trace('Reading script folder: ${baseFolder}');
		try {
			final scriptsFolder:Array<String> = FileSystem.readDirectory(baseFolder);

			for (script in scriptsFolder) {
				final getScriptPath = function(s) {
					return '$baseFolder/$s';
				}

				if (FileSystem.isDirectory(getScriptPath(script))) {
					trace(' * subdirectory (unsupported): ${getScriptPath(script)}');
					continue;
				}

				trace(' * file: ${getScriptPath(script)}');

				var baseScript = makeScript(script);
				scripts.push(baseScript);
			}
		} catch (e) {

			trace(' * Error reading script folder : $e');
			scripts = [];
		}

		return scripts;
	}

	public static var generalScriptHolder:ScriptHolder;
}
