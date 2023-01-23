extends YSort

onready var dirt = $GeneratedTiles/DirtTiles
onready var plains = $GeneratedTiles/GreenGrassTiles
onready var forest = $GeneratedTiles/DarkGreenGrassTiles
onready var water = $GeneratedTiles/Water
onready var validTiles = $ValidTiles
onready var navTiles = $Navigation2D/NavTiles
onready var hoed = $FarmingTiles/HoedAutoTiles
onready var watered = $FarmingTiles/WateredAutoTiles
onready var snow = $GeneratedTiles/SnowTiles
onready var waves = $GeneratedTiles/WaveTiles
onready var wetSand = $GeneratedTiles/WetSandBeachBorder
onready var sand = $GeneratedTiles/DrySandTiles
onready var shallow_ocean = $GeneratedTiles/ShallowOcean
onready var deep_ocean = $GeneratedTiles/DeepOcean
onready var top_ocean = $GeneratedTiles/TopOcean
onready var Players = $Players

onready var Bear = load("res://World/Animals/Bear.tscn")
onready var Bunny = load("res://World/Animals/Bunny.tscn")
onready var Duck = load("res://World/Animals/Duck.tscn")
onready var Boar = load("res://World/Animals/Boar.tscn")
onready var Deer = load("res://World/Animals/Deer.tscn")
onready var Wolf = load("res://World/Animals/Wolf.tscn")
onready var CaveLadder = load("res://World/Caves/Objects/CaveLadder.tscn")

onready var GenerateWorldLoadingScreen = load("res://MainMenu/GenerateWorldLoadingScreen.tscn")

onready var Player = load("res://World/Player/Player/Player.tscn")
onready var _character = load("res://Global/Data/Characters.gd")

var rng = RandomNumberGenerator.new()

var spawn_loc

const MAX_DUCKS = 150
const MAX_BUNNIES = 150
const MAX_BEARS = 60
const MAX_BOARS = 50
const MAX_DEER = 90
const MAX_WOLVES = 50

var num_ducks = 0
var num_bunnies = 0
var num_deer = 0
var num_bears = 0
var num_boars = 0
var num_wolves = 0

var is_changing_scene: bool = false

var game_state: GameState

func _ready():
	Server.world = self
	create_or_load_world()

func create_or_load_world():
	if MapData.world["is_built"]: # Load world
		MapData.add_world_data_to_chunks()
		build_world()
	else: # Initial launch
		var loadingScreen = GenerateWorldLoadingScreen.instance()
		loadingScreen.name = "Loading"
		add_child(loadingScreen)
		GenerateNewWorld.build()

func build_world():
	buildMap(MapData.world)
	spawn_player()
	yield(get_tree(), "idle_frame")
	$WorldBuilder.initialize()
	$WorldBuilder/BuildTerrain.initialize()
	$WorldBuilder/BuildNature.initialize()
	#$WorldBuilder/SpawnAnimal.initialize()
	yield(get_tree(), "idle_frame")
	$WorldMap.buildMap()
	yield(get_tree(), "idle_frame")
	spawn_initial_animals()


func spawn_player():
	var player = Player.instance()
	player.is_building_world = true
	player.name = str("PLAYER")
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	$Players.add_child(player)
	if PlayerData.spawn_at_respawn_location:
		spawn_loc = PlayerData.player_data["respawn_location"]
	elif PlayerData.spawn_at_cave_exit:
		spawn_loc = MapData.world["cave_entrance_location"]
	elif PlayerData.spawn_at_last_saved_location:
		spawn_loc = PlayerData.player_data["current_save_location"]
	if spawn_loc == null: # initial random spawn
		var tiles = MapData.world["beach"]
		tiles.shuffle()
		spawn_loc = tiles[0]
		yield(get_tree(), "idle_frame")
		PlayerData.player_data["current_save_location"] =  spawn_loc
		PlayerData.player_data["current_save_scene"] = "res://World/World/World.tscn"
		PlayerData.player_data["respawn_scene"] = "res://World/World/World.tscn"
		PlayerData.player_data["respawn_location"] = spawn_loc
		var game_state = GameState.new()
		game_state.player_state = PlayerData.player_data
		game_state.world_state = MapData.world
		game_state.cave_state = MapData.caves
		game_state.save_state()
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

func spawn_initial_animals():
	for i in range(220):
		spawnRandomBunny()
	yield(get_tree(), "idle_frame")
	for i in range(220):
		spawnRandomDuck()
	yield(get_tree(), "idle_frame")
	for i in range(175):
		spawnRandomDeer()
	yield(get_tree(), "idle_frame")
	for i in range(25):
		spawnRandomBoar()
	yield(get_tree(), "idle_frame")
	for i in range(25):
		spawnRandomBear()
	yield(get_tree(), "idle_frame")
	for i in range(25):
		spawnRandomWolf()


func returnValidSpawnLocation():
	rng.randomize()
	var tempLoc = Vector2(rng.randi_range(100, 900), rng.randi_range(100, 900))
	if validTiles.get_cellv(tempLoc) != -1 and not MapData.world["ocean"].has(tempLoc):
		return tempLoc
	return null


func spawnRandomWolf():
	if num_wolves < MAX_WOLVES:
		var loc = returnValidSpawnLocation()
		if loc != null:
			var wolf = Wolf.instance()
			wolf.global_position = loc*32
			$Enemies.call_deferred("add_child",wolf)
			wolf.hide()
			num_wolves += 1
			yield(get_tree(), "idle_frame")

func spawnRandomBunny():
	if num_bunnies < MAX_BUNNIES:
		var loc = returnValidSpawnLocation()
		if loc != null:
			var bunny = Bunny.instance()
			bunny.variety = rng.randi_range(1,3)
			bunny.global_position = loc*32
			$Enemies.call_deferred("add_child",bunny)
			bunny.hide()
			num_bunnies += 1
			yield(get_tree(), "idle_frame")

func spawnRandomDuck():
	if num_ducks < MAX_DUCKS:
		var loc = returnValidSpawnLocation()
		if loc != null:
			var duck = Duck.instance()
			duck.variety = rng.randi_range(1,3)
			duck.global_position = loc*32
			$Enemies.call_deferred("add_child",duck)
			duck.hide()
			num_ducks += 1
			yield(get_tree(), "idle_frame")

func spawnRandomBear():
	if num_bears < MAX_BEARS:
		var loc = returnValidSpawnLocation()
		if loc != null:
			var bear = Bear.instance()
			$Enemies.call_deferred("add_child",bear)
			bear.global_position = loc*32
			num_bears += 1
			yield(get_tree(), "idle_frame")
		
func spawnRandomBoar():
	if num_boars < MAX_BOARS:
		var loc = returnValidSpawnLocation()
		if loc != null:
			var boar = Boar.instance()
			$Enemies.call_deferred("add_child", boar)
			boar.global_position = loc*32
			num_boars += 1
			boar.hide()
			yield(get_tree(), "idle_frame")

func spawnRandomDeer():
	if num_deer < MAX_DEER:
		var loc = returnValidSpawnLocation()
		if loc != null:
			var deer = Deer.instance()
			$Enemies.call_deferred("add_child", deer)
			deer.global_position = loc*32
			num_deer += 1
			deer.hide()
			yield(get_tree(), "idle_frame")

