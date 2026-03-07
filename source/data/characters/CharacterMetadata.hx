package data.characters;

import data.objects.*;

typedef CharacterMetadata = {
	type:ObjectAssetType,
	imageName:String,

	?tags:Array<ObjectTagData>,

	?animations:Array<ObjectAnimationData>,

	?generalOffsets:Array<Float>,
}
