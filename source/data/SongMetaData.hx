package data;

typedef SongMetaData =
{
	name:String,
	?artist:String,

	startingBPM:Null<Float>,

	audioFiles:Array<String>,

	?opponent:String,
	?player:String,
	?damsel:String,

	?stage:String,
}
