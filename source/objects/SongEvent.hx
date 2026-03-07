package objects;

class SongEvent {
	public var time:Float;
	public var event:Void->Void;

	public function new(time:Float, event:Void->Void) {
		this.time = time;
		this.event = event;
	}
}
