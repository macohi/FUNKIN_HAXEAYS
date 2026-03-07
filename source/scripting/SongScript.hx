package scripting;

class SongScript extends BaseScript
{

    override public function new(song:String, script:String) {
        super('songs/$song/scripts/$script');
    }
    
}