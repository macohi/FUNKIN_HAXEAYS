package data;

import data.ObjectAnimationType;

typedef ObjectAnimationData = {
	name:String,
	type:ObjectAnimationType,

	/** prefix **/
	?prefix:String,

	/** general **/
	?fps:Int,
	?looped:Bool,
}
