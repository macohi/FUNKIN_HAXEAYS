package data.song.charts;

typedef VSliceMetadataPlayDataCharacters = {
	player:String,
	girlfriend:String,
	opponent:String,

	// altInstrumentals:Array<String>,
	opponentVocals:Array<String>,
	playerVocals:Array<String>
}

typedef VSliceMetadataPlayData = {
	// songVariations:Array<String>,
	// difficulties:Array<String>,
	characters:VSliceMetadataPlayDataCharacters,
	stage:String,
	// noteStyle:String,
	// ratings:Map<String, Int>,
	// album:String
}

typedef VSliceMetadataTimeChange = {
	// timeStamp
	t:Float,

	// beatTime
	b:Float,

	bpm:Float,

	// beatTuplets (what?)
	bt:Array<Int>
}

typedef VSliceMetadata = {
	// version:String,
	songName:String,
	artist:String,

	// charter:String,
	// offsets:{},
	playData:VSliceMetadataPlayData,
	// generatedBy:String,
	timeChanges:Array<VSliceMetadataTimeChange>
}

typedef VSliceChart = {
	// version:String,
	// scrollSpeed:Map<String, Float>,
	events:Array<VSliceChartEvent>,
	notes:Map<String, Array<VSliceChartNote>>,
	// generatedBy:String
}

typedef VSliceChartNote = {
    // time
	t:Float,
    
    // direction
	d:Int,

    // sustain
	l:Float
}

typedef VSliceChartEvent = {
    // time
	t:Float,
    
    // event name
	e:String,

    // value
	v:Dynamic
}
