package scripting;

class CharacterScript extends BaseScript {
	override public function new(character:String, script:String) {
		super('characters/$character/scripts/$script');
	}
}
