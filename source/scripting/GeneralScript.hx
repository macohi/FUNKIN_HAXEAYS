package scripting;

class GeneralScript extends BaseScript {
	override public function new(script:String) {
		super('scripts/$script');
	}
}

