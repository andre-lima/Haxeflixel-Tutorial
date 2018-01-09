package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;

import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.system.FlxSound;
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	private var _ending:Bool;
	private var _won:Bool;

	private var _player:Player;
	private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpEnemies:FlxTypedGroup<Enemy>;

	private var _hud:HUD;
	private var _money:Int = 0;
	private var _health:Int = 5;
	
	private var _map:TiledMap;
 	private var _mWalls:FlxTilemap;

	private var _inCombat:Bool = false;
 	private var _combatHud:CombatHUD;

	private var _sndCoin:FlxSound;
	
	override public function create():Void {
		_map = new TiledMap(AssetPaths.map__tmx);
		_mWalls = new FlxTilemap();
		_mWalls.loadMapFromArray(cast(_map.getLayer("walls"), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png, _map.tileWidth, _map.tileHeight, OFF, 1, 1, 3);
		_mWalls.follow();
		_mWalls.setTileProperties(2, FlxObject.NONE);
		_mWalls.setTileProperties(3, FlxObject.ANY);
		add(_mWalls);

		_grpCoins = new FlxTypedGroup<Coin>();
 		add(_grpCoins);

		_grpEnemies = new FlxTypedGroup<Enemy>();
 		add(_grpEnemies);

		_player = new Player();
    add(_player);

	  var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		for (e in tmpMap.objects)	{
				placeEntities(e.type, e.xmlData.x, e.properties);
		}

		FlxG.camera.follow(_player, TOPDOWN, 1);

		_hud = new HUD();
 		add(_hud);

		_combatHud = new CombatHUD();
 		add(_combatHud);

		_sndCoin = FlxG.sound.load(AssetPaths.coin__wav);

		#if !FLX_NO_MOUSE
			FlxG.mouse.visible = false;
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	  if (_ending)
		{
				return;
		}
		
		if (!_inCombat)
		{
				FlxG.collide(_player, _mWalls);
				FlxG.overlap(_player, _grpCoins, playerTouchCoin);
				FlxG.collide(_grpEnemies, _mWalls);
				_grpEnemies.forEachAlive(checkEnemyVision);
				FlxG.overlap(_player, _grpEnemies, playerTouchEnemy);
		}
		else
		{
				if (!_combatHud.visible)
				{
						_health = _combatHud.playerHealth;
						_hud.updateHUD(_health, _money);
						if (_combatHud.outcome == DEFEAT)
						{
								_ending = true;
								FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
						}
						else
						{
								if (_combatHud.outcome == VICTORY)
								{
										_combatHud.e.kill();
										if (_combatHud.e.etype == 1)
										{
												_won = true;
												_ending = true;
												FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
										}
								}
								else
								{
										_combatHud.e.flicker();
								}
								_inCombat = false;
								_player.active = true;
								_grpEnemies.active = true;
						}
				}
		}
	}

	private function doneFadeOut():Void
	{
			FlxG.switchState(new GameOverState(_won, _money));
	}

	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
			if (P.alive && P.exists && E.alive && E.exists && !E.isFlickering())
			{
					startCombat(E);
			}
	}

	private function startCombat(E:Enemy):Void
	{
			_inCombat = true;
			_player.active = false;
			_grpEnemies.active = false;
			_combatHud.initCombat(_health, E);
	}

	private function placeEntities(entityName:String, entityData:Xml, entityProperties:Dynamic):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		} else if (entityName == "coin") {
			_grpCoins.add(new Coin(x + 4, y + 4));
		}  else if (entityName == "enemy") {
			trace(entityProperties);
			_grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityProperties.get("etype"))));
		}
	}

	private function playerTouchCoin(P:Player, C:Coin):Void	{
		if (P.alive && P.exists && C.alive && C.exists)	{
			_sndCoin.play(true);
			C.kill();
			_money++;
 			_hud.updateHUD(_health, _money);
		}
	}

	private function checkEnemyVision(e:Enemy):Void {
    if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint())) {
      e.seesPlayer = true;
      e.playerPos.copyFrom(_player.getMidpoint());
    }
    else
      e.seesPlayer = false;
 	}
}
