extends Node2D

@onready var Player = load("res://World/Player/Player/Player.tscn")

var rng := RandomNumberGenerator.new()

var spawn_loc

var is_changing_scene: bool = false

var game_state: GameState


func _ready():
	Server.world = self
	create_or_load_world()
#	set_valid_tiles()


func set_valid_tiles():
	for x in range(1000):
		for y in range(1000):
			$TerrainTiles/ValidTiles.set_cell(0,Vector2(x,y),0,Constants.VALID_TILE_ATLAS_CORD,0)


func create_or_load_world():
	if not MapData.world == {}: # Load world
		build_world()
	else: # Initial launch
		GenerateNewWorld.build()


func build_world():
	$WorldBuilder/BuildTerrain.build()

func initialize():
	$InitLoadingScreen.queue_free()
	$WorldBuilder.initialize()
	$WorldMap.buildMap()
	buildMap()
	set_valid_tiles()
	spawn_player()


func spawn_player():
	var player = Player.instantiate()
	player.is_building_world = true
	player.name = str("PLAYER")
	$Players.add_child(player)
	spawn_loc = Vector2i(500,500)
	if PlayerData.spawn_at_respawn_location:
		spawn_loc = PlayerData.player_data["respawn_location"]
	elif PlayerData.spawn_at_cave_exit:
		spawn_loc = MapData.world["cave_entrance_location"]
	elif PlayerData.spawn_at_last_saved_location:
		spawn_loc = PlayerData.player_data["current_save_location"]
	if spawn_loc == null: # initial random spawn
		var tiles = MapData.terrain["beach"]
		tiles.shuffle()
		spawn_loc = tiles[0]
		PlayerData.player_data["current_save_location"] =  spawn_loc
		PlayerData.player_data["respawn_location"] = spawn_loc
		var game_state = GameState.new()
		game_state.player_state = PlayerData.player_data
		game_state.world = MapData.world
		game_state.terrain = MapData.terrain
		game_state.save_state()
	player.position = spawn_loc*16
	PlayerData.spawn_at_respawn_location = false
	PlayerData.spawn_at_cave_exit = false
	PlayerData.spawn_at_last_saved_location = false


func buildMap():
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

