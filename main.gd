extends Node2D


const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var world = {}
var server_data = {}

var connected_peer_ids = []
var is_changing_scene = false


func _on_join_btn_pressed():
	$CanvasLayer.hide()
	enet_peer.create_client("localhost",PORT)
	multiplayer.multiplayer_peer = enet_peer
	build_world()



@rpc
func send_world_data(data):
	print("GOT WORLD DATA")
	world = data["world"]
	server_data = data["server_data"]
#	MapData.world = _world
	$WorldMap.buildMap()
#	await get_tree().create_timer(2).timeout
#	MapData.add_world_data_to_chunks()
	$WorldAmbience.initialize()
	$WorldBuilder.initialize()
	$WorldBuilder/BuildTerrain.initialize()
	$WorldBuilder/BuildNature.initialize()
#	$WorldBuilder/SpawnAnimal.initialize()


func build_world():
	print("BUILD WORLD")
	Server.world = self
#	MapData.add_world_data_to_chunks()
	set_map_tiles()
	set_valid_tiles()
#	$WorldBuilder.initialize()
#	$WorldBuilder/BuildTerrain.initialize()
#	$WorldBuilder/BuildNature.initialize()
#	$WorldBuilder/SpawnAnimal.initialize()
	#$WorldMap.buildMap()


func set_valid_tiles():
	for x in range(1000):
		for y in range(1000):
			$TerrainTiles/ValidTiles.set_cell(0,Vector2(x,y),0,Constants.VALID_TILE_ATLAS_CORD,0)


func set_map_tiles():
	Tiles.valid_tiles = $TerrainTiles/ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedTiles
	Tiles.watered_tiles = $FarmingTiles/WateredTiles
	Tiles.ocean_tiles = $TerrainTiles/ShallowOcean
	Tiles.deep_ocean_tiles = $TerrainTiles/DeepOcean
	Tiles.dirt_tiles = $TerrainTiles/Dirt
	Tiles.wall_tiles = $BuildingTiles/WallTiles
	Tiles.foundation_tiles = $BuildingTiles/FoundationTiles
	Tiles.object_tiles = $BuildingTiles/ObjectTiles
	Tiles.wet_sand_tiles = $TerrainTiles/WetSand
	Tiles.forest_tiles = $TerrainTiles/Forest


