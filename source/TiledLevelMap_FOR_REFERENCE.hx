package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
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
import haxe.io.Path;


class TiledLevelMap {


	// Array of tilemaps used for collision
	public var wallsLayer:FlxGroup = new FlxGroup();
	public var objectsLayer:FlxGroup = new FlxGroup();
	private var collidableTileLayers:Array<FlxTilemap>;
	
	public var backgroundLayer:FlxGroup = new FlxGroup();

  private var playerInitialPosition:Array<Int> = [0,0]; 

  public function new(mapPath: String, tiledMapFile:String, state:PlayState) {
		mapPath = Path.addTrailingSlash(mapPath);

    setupEnvironment(mapPath, tiledMapFile, state);
  }

  private function setupEnvironment(mapPath: String, tiledMapFile:String, state:PlayState){
    var _tiled = new TiledLayers(mapPath, tiledMapFile, state);

    setCameraBounds(_tiled);
    loadObjects(_tiled, state);
    loadImages(_tiled, state);
    loadLayers(_tiled, mapPath, state);
  }

  private function setCameraBounds(tiled:TiledLayers){
    FlxG.camera.setScrollBoundsRect(0, 0, tiled.fullWidth, tiled.fullHeight, true);
  }

  private function loadObjects(tiled:TiledLayers, state:PlayState){
    for (objLayer in tiled.objectsLayerArray) {
      for(o in objLayer.objects) {
        switch (o.type.toLowerCase())
        {
          case "player_start":
            playerInitialPosition = [o.x, o.y];
            
          case "floor":
            trace("floor");
            
          case "coin":
            trace("coin");

          case "enemy":
            trace("enemy");
            
          case "exit":
            trace("exit");

          default:
            trace("default");
        }
      }
    }
  }

  private function loadImages(tiled:TiledLayers, state:PlayState){
    trace('LOADING IMAGES');
  }

  private function loadLayers(tiled:TiledLayers, mapPath:String, state:PlayState){
    trace('LOADING LAYERS');
    for (tileLayer in tiled.tilesLayerArray) {

      //Only allows for 1 tileset per layer
      var tileSet:TiledTileSet = tileLayer.map.tilesetArray[0];

			var imageFile = tileSet.imageSource;
			var processedPath	= mapPath + imageFile;


      // could be a regular FlxTilemap if there are no animated tiles
			var tilemap = new FlxTilemapExt();
			tilemap.loadMapFromArray(tileLayer.tileArray, tiled.width, tiled.height, 
        processedPath, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

      if (collidableTileLayers == null)
				collidableTileLayers = new Array<FlxTilemap>();

			switch (tileLayer.name)	{
				case "background":
          backgroundLayer.add(tilemap);
        case "walls":
          wallsLayer.add(tilemap);
          collidableTileLayers.push(tilemap);
        case "floor":
          backgroundLayer.add(tilemap);

				default: 
				  throw "Unknown layer name found!";
			}

    }
  }

  public function getPlayerInitialPosition(){
    trace('GETTING PLAYER POSITION');
    return playerInitialPosition;
  }

}