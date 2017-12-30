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

class TiledLayers extends TiledMap {
  // Initializing arrays of types of tiles
  public var tilesLayerArray:Array<TiledTileLayer> = [];
	public var objectsLayerArray:Array<TiledObjectLayer> = [];
	public var imagesLayerArray:Array<TiledImageLayer> = [];

	public function new(mapPath: String, tiledMapFile:String, state:PlayState) {
		mapPath = Path.addTrailingSlash(mapPath);
    var tiledLevel = mapPath + tiledMapFile;
		super(tiledLevel);

		// Load Tile Maps
		for (layer in layers)
		{

			switch (layer.type)
			{
				case TiledLayerType.TILE:
					tilesLayerArray.push(cast layer);
				case TiledLayerType.OBJECT:
					objectsLayerArray.push(cast layer);
				case TiledLayerType.IMAGE:
					imagesLayerArray.push(cast layer);
				default: 
				  throw "Unknown Tile type found!";
			}
    }

  }

}