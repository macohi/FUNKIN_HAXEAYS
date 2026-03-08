package data.objects;

enum abstract ObjectAssetType(String) from String to String {
	var solid:String = 'solid';
	var image:String = 'image';

	var sparrow:String = 'sparrow';
	var textureatlas:String = 'textureatlas';
}
