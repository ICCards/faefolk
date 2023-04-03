extends Node2D


const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

@export var world = {}

var connected_peer_ids = []
var is_changing_scene = false

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = load("res://World/Player/Player/Player.tscn").instantiate()
	player_character.name = str(peer_id)
	add_child(player_character)

@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)

@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)


func _on_join_btn_pressed():
	$CanvasLayer.hide()
	enet_peer.create_client("localhost",PORT)
	multiplayer.multiplayer_peer = enet_peer
	build_world()


func build_world():
	Server.world = self
#	MapData.add_world_data_to_chunks()
	set_map_tiles()
#	set_valid_tiles()
#	$WorldBuilder.initialize()
#	$WorldBuilder/BuildTerrain.initialize()
#	$WorldBuilder/BuildNature.initialize()
#	$WorldBuilder/SpawnAnimal.initialize()
#	$WorldMap.buildMap()


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
	#create_cave_entrance(map["cave_entrance_location"])


func create_cave_entrance(_loc):
	pass
#	var loc = Util.string_to_vector2(_loc)
#	Tiles.valid_tiles.set_cellv(loc, -1)
#	Tiles.valid_tiles.set_cellv(loc+Vector2(1,0), -1)
#	$GeneratedTiles/DownLadder.set_cellv(loc, 1)
#	var caveLadder = CaveLadder.instance()
#	caveLadder.is_down_ladder = true
#	caveLadder.position = loc*32 + Vector2(32,16)
#	add_child(caveLadder)
