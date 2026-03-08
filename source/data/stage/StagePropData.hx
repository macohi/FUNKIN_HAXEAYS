package data.stage;

import data.objects.ObjectAssetType;
import data.objects.ObjectAnimationData;

typedef StagePropData = {
	> StageBasePropBasicData,
	> StageBasePropAssetData,

	id:String,
}

typedef StageBasePropBasicData = {
	?zIndex:Int,

	?scale:Array<Float>,
	?position:Array<Float>,
	?scroll:Array<Float>,

	?alpha:Float,
}

typedef StageBasePropAssetData = {
	?color:String,

	?assetType:ObjectAssetType,

	?assetPath:String,

	?startingAnimation:String,
	?animations:Array<ObjectAnimationData>,
}
