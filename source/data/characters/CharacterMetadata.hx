package data.characters;

import data.objects.*;

typedef CharacterMetadata = {
	type:ObjectAssetType,
	imageName:String,

	?tags:Array<ObjectTagData>,

	?animations:Array<ObjectAnimationData>,

	?cameraOffsets:Array<Float>,
	?generalOffsets:Array<Float>,
}
