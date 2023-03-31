extends Node2D

@onready var CaveLadder = load("res://World/Caves/Objects/CaveLadder.tscn")
@onready var GenerateWorldLoadingScreen = load("res://MainMenu/GenerateWorldLoadingScreen.tscn")
@onready var Player = load("res://World/Player/Player/Player.tscn")

var rng := RandomNumberGenerator.new()
var thread := Thread.new()

var spawn_loc

var is_changing_scene: bool = false

var game_state: GameState

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

@export var world = {}


func _on_host_btn_pressed():
	$CanvasLayer.hide()
	if GameState.save_exists(): # Load world
		game_state = GameState.new()
		game_state.load_state()
		world = game_state.world_state
		build_world()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	spawn_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(spawn_player)


func _on_join_btn_pressed():
	$CanvasLayer.hide()
	enet_peer.create_client("localhost",PORT)
	multiplayer.multiplayer_peer = enet_peer
	build_world()

#func create_or_load_world():
#	if MapData.world["is_built"]: # Load world
#		MapData.add_world_data_to_chunks()
#		thread.start(Callable(self, "build_world"))
#		#build_world()
#	else: # Initial launch
#		var loadingScreen = GenerateWorldLoadingScreen.instantiate()
#		loadingScreen.name = "Loading"
#		add_child(loadingScreen)
#		GenerateNewWorld.build()

func build_world():
	Server.world = self
#	MapData.add_world_data_to_chunks()
	set_map_tiles()
#	set_valid_tiles()
#	$WorldBuilder.initialize()
#	$WorldBuilder/BuildTerrain.initialize()
#	$WorldBuilder/BuildNature.initialize()
#	$WorldBuilder/SpawnAnimal.initialize()
	$WorldMap.buildMap()


func set_valid_tiles():
	for x in range(1000):
		for y in range(1000):
			$TerrainTiles/ValidTiles.set_cell(0,Vector2(x,y),0,Constants.VALID_TILE_ATLAS_CORD,0)


func spawn_player(peer_id):
	var player = Player.instantiate()
	player.is_building_world = true
	player.name = str(peer_id)
	$Players.add_child(player)
#	if PlayerData.spawn_at_respawn_location:
#		spawn_loc = PlayerData.player_data["respawn_location"]
#	elif PlayerData.spawn_at_cave_exit:
#		spawn_loc = MapData.world["cave_entrance_location"]
#	elif PlayerData.spawn_at_last_saved_location:
#		spawn_loc = PlayerData.player_data["current_save_location"]
#	if spawn_loc == null: # initial random spawn
	var tiles = world["beach"]
	spawn_loc = tiles[0]
#	PlayerData.player_data["current_save_location"] =  spawn_loc
#	PlayerData.player_data["current_save_scene"] = "res://World/Overworld/Overworld.tscn"
#	PlayerData.player_data["respawn_scene"] = "res://World/Overworld/Overworld.tscn"
#	PlayerData.player_data["respawn_location"] = spawn_loc
#	var game_state = GameState.new()
#	game_state.player_state = PlayerData.player_data
#	game_state.world_state = MapData.world
#	game_state.cave_state = MapData.caves
#	game_state.save_state()
	player.position = spawn_loc*16
	PlayerData.spawn_at_respawn_location = false
	PlayerData.spawn_at_cave_exit = false
	PlayerData.spawn_at_last_saved_location = false


func advance_down_cave_level():
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, true)


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

