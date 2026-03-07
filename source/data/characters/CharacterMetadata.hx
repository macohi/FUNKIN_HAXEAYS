package data.characters;

import data.objects.*;

typedef CharacterMetadata = {
	type:CharacterType,
	imageName:String,

	?tags:Array<ObjectTagData>,

	?animations:Array<ObjectAnimationData>,

	?generalOffsets:Array<Float>,
}
