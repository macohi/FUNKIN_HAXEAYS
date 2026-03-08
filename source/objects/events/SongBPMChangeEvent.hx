package objects.events;

class SongBPMChangeEvent extends SongEvent {
	override public function new(time:Float, bpm:Float) {
		super(time, function() {
			Conductor.instance.bpm = bpm;
		});
	}
}
