package scripting;

class StageScript extends BaseScript {
	override public function new(stage:String, script:String) {
		super('stages/$stage/scripts/$script');
	}
}
