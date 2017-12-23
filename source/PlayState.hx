package;

import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		add(new FlxText(100, 50, 100, "Hello, World!", 24));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
