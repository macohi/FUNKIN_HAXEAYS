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
	?assetType:ObjectAssetType,

	?assetPath:String,

	?animations:ObjectAnimationData,
}
