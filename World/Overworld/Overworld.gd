extends Node2D

@onready var CaveLadder = load("res://World/Caves/Objects/CaveLadder.tscn")
@onready var GenerateWorldLoadingScreen = load("res://MainMenu/GenerateWorldLoadingScreen.tscn")
@onready var Player = load("res://World/Player/Player/Player.tscn")

var rng := RandomNumberGenerator.new()
var thread := Thread.new()

var spawn_loc

var is_changing_scene: bool = false

var game_state: GameState


func _ready():
	Server.world = self
	#create_or_load_world()
	spawn_player()
	set_valid_tiles()


func set_valid_tiles():
	for x in range(1000):
		for y in range(1000):
			$TerrainTiles/ValidTiles.set_cell(0,Vector2(x,y),0,Constants.VALID_TILE_ATLAS_CORD,0)
#	print($TerrainTiles/ValidTiles.get_cell_atlas_coords(0,Vector2(0,0)))
#	print($TerrainTiles/ValidTiles.get_cell_atlas_coords(0,Vector2(-1,0)))
	Tiles.valid_tiles = $TerrainTiles/ValidTiles
	Tiles.wall_tiles = $BuildingTiles/WallTiles
	Tiles.foundation_tiles = $BuildingTiles/FoundationTiles
	Tiles.dirt_tiles = $TerrainTiles/Dirt
	Tiles.hoed_tiles = $FarmingTiles/HoedTiles
	Tiles.watered_tiles = $FarmingTiles/WateredTiles
	Tiles.ocean_tiles = $TerrainTiles/Ocean
#	Tiles.deep_ocean_tiles = $GeneratedTiles/DeepOcean
#	Tiles.wall_tiles = $PlacableTiles/WallTiles
#	Tiles.selected_wall_tiles = $PlacableTiles/SelectedWallTiles
#	Tiles.foundation_tiles = $PlacableTiles/FoundationTiles
#	Tiles.selected_foundation_tiles = $PlacableTiles/SelectedFoundationTiles
#	Tiles.object_tiles = $PlacableTiles/ObjectTiles
#	Tiles.fence_tiles = $PlacableTiles/FenceTiles
#	Tiles.wet_sand_tiles = $GeneratedTiles/WetSandBeachBorder
#	Tiles.forest_tiles = $GeneratedTiles/DarkGreenGrassTiles


func create_or_load_world():
	if MapData.world["is_built"]: # Load world
		MapData.add_world_data_to_chunks()
		thread.start(Callable(self, "build_world"))
		#build_world()
	else: # Initial launch
		var loadingScreen = GenerateWorldLoadingScreen.instantiate()
		loadingScreen.name = "Loading"
		add_child(loadingScreen)
		GenerateNewWorld.build()

func build_world():
	call_deferred("build_world_deferred")
	
func build_world_deferred():
	buildMap(MapData.world)
	spawn_player()
	$WorldBuilder.initialize()
	$WorldBuilder/BuildTerrain.initialize()
	$WorldBuilder/BuildNature.initialize()
	$WorldBuilder/SpawnAnimal.initialize()
	$WorldMap.buildMap()
	thread.wait_to_finish()


func spawn_player():
	var player = Player.instantiate()
	player.is_building_world = true
	player.name = str("PLAYER")
	$Players.add_child(player)
#	if PlayerData.spawn_at_respawn_location:
#		spawn_loc = PlayerData.player_data["respawn_location"]
#	elif PlayerData.spawn_at_cave_exit:
#		spawn_loc = MapData.world["cave_entrance_location"]
#	elif PlayerData.spawn_at_last_saved_location:
#		spawn_loc = PlayerData.player_data["current_save_location"]
#	if spawn_loc == null: # initial random spawn
#		var tiles = MapData.world["beach"]
#		tiles.shuffle()
#		spawn_loc = tiles[0]
#		PlayerData.player_data["current_save_location"] =  spawn_loc
#		PlayerData.player_data["current_save_scene"] = "res://World/World/World.tscn"
#		PlayerData.player_data["respawn_scene"] = "res://World/World/World.tscn"
#		PlayerData.player_data["respawn_location"] = spawn_loc
#		var game_state = GameState.new()
#		game_state.player_state = PlayerData.player_data
#		game_state.world_state = MapData.world
#		game_state.cave_state = MapData.caves
#		game_state.save_state()
	spawn_loc = Vector2.ZERO
	player.position = Util.string_to_vector2(spawn_loc)*32
	PlayerData.spawn_at_respawn_location = false
	PlayerData.spawn_at_cave_exit = false
	PlayerData.spawn_at_last_saved_location = false


func advance_down_cave_level():
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, true)


func buildMap(map):
	Tiles.valid_tiles = $ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedAutoTiles
	Tiles.watered_tiles = $FarmingTiles/WateredAutoTiles
	Tiles.ocean_tiles = $GeneratedTiles/ShallowOcean
	Tiles.deep_ocean_tiles = $GeneratedTiles/DeepOcean
	Tiles.dirt_tiles = $GeneratedTiles/DirtTiles
	Tiles.wall_tiles = $PlacableTiles/WallTiles
	Tiles.selected_wall_tiles = $PlacableTiles/SelectedWallTiles
	Tiles.foundation_tiles = $PlacableTiles/FoundationTiles
	Tiles.selected_foundation_tiles = $PlacableTiles/SelectedFoundationTiles
	Tiles.object_tiles = $PlacableTiles/ObjectTiles
	Tiles.fence_tiles = $PlacableTiles/FenceTiles
	Tiles.wet_sand_tiles = $GeneratedTiles/WetSandBeachBorder
	Tiles.forest_tiles = $GeneratedTiles/DarkGreenGrassTiles
	create_cave_entrance(map["cave_entrance_location"])


func create_cave_entrance(_loc):
	var loc = Util.string_to_vector2(_loc)
	Tiles.valid_tiles.set_cellv(loc, -1)
	Tiles.valid_tiles.set_cellv(loc+Vector2(1,0), -1)
	$GeneratedTiles/DownLadder.set_cellv(loc, 1)
	var caveLadder = CaveLadder.instance()
	caveLadder.is_down_ladder = true
	caveLadder.position = loc*32 + Vector2(32,16)
	add_child(caveLadder)
