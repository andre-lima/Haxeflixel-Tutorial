package;

import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _map:TiledLevel;
	
	override public function create():Void {
		_player = new Player(20, 20);
    add(_player);

		// Load the level's tilemaps
		_map = new TiledLevel("assets/data/maps/map.tmx", this);
		// Add tilemaps
		
	  //add(_map.background);

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
