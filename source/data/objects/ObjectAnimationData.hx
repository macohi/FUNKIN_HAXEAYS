package data.objects;

typedef ObjectAnimationData = {
	name:String,
	type:ObjectAnimationType,

	/** prefix **/
	?prefix:String,

	/** framelabel **/
	?framelabel:String,

	/** general **/
	?fps:Int,
	?looped:Bool,
}
