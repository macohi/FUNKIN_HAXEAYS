package objects;

class SongChartNoteEvent extends SongCharacterAnimationEvent {
	override public function new(time:Float, direction:String, character:Int = 0) {
		super(time, 'sing${direction.toUpperCase()}', character);
	}
}
