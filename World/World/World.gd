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

onready var Bear = preload("res://World/Animals/Bear.tscn")
onready var Bunny = preload("res://World/Animals/Bunny.tscn")
onready var Duck = preload("res://World/Animals/Duck.tscn")
onready var Boar = preload("res://World/Animals/Boar.tscn")
onready var Deer = preload("res://World/Animals/Deer.tscn")
onready var Wolf = preload("res://World/Animals/Wolf.tscn")
onready var Clam = preload("res://World/Objects/Nature/Forage/Clam.tscn")
onready var Starfish = preload("res://World/Objects/Nature/Forage/Starfish.tscn")
onready var CaveLadder = preload("res://World/Caves/Objects/CaveLadder.tscn")

var rng = RandomNumberGenerator.new()

const NUM_DUCKS = 200
const NUM_BUNNIES = 200
const NUM_BEARS = 70
const NUM_BOARS = 70
const NUM_DEER = 120
const NUM_WOLVES = 70

var is_changing_scene: bool = false

func _ready():
	Server.world = self
	buildMap(MapData.world)
	
func advance_down_cave_level():
	if not is_changing_scene:
		is_changing_scene = true
		get_node("BuildWorld/BuildNature").is_destroyed = true
		yield(get_tree(), "idle_frame")
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		for node in $Projectiles.get_children():
			node.destroy()
		for node in $Enemies.get_children():
			node.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 1-1/Cave 1-1.tscn")


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
	Server.isLoaded = true
	spawn_animals()
	create_cave_entrance(map["cave_entrance_location"])
	set_random_beach_forage()

func create_cave_entrance(_loc):
	var loc = Util.string_to_vector2(_loc)
	Tiles.valid_tiles.set_cellv(loc, -1)
	Tiles.valid_tiles.set_cellv(loc+Vector2(1,0), -1)
	$GeneratedTiles/DownLadder.set_cellv(loc, 1)
	var caveLadder = CaveLadder.instance()
	caveLadder.is_down_ladder = true
	caveLadder.position = loc*32 + Vector2(32,16)
	add_child(caveLadder)

func spawn_animals():
	for i in range(NUM_BUNNIES):
		spawnRandomBunny()
	for i in range(NUM_DUCKS):
		spawnRandomDuck()
	for i in range(NUM_BEARS):
		spawnRandomBear()
	for i in range(NUM_BOARS):
		spawnRandomBoar()
	for i in range(NUM_DEER):
		spawnRandomDeer()
	for i in range(NUM_WOLVES):
		spawnRandomWolf()
	
func set_random_beach_forage():
	for id in MapData.world["beach"]:
		if Util.chance(3):
			var loc = Util.string_to_vector2(MapData.world["beach"][id])
			if dirt.get_cellv(loc) == -1 and forest.get_cellv(loc) == -1 and snow.get_cellv(loc) == -1 and plains.get_cellv(loc) == -1:
				if Util.chance(50):
					Tiles.remove_valid_tiles(loc)
					var clam = Clam.instance()
					clam.location = loc
					clam.global_position = Tiles.valid_tiles.map_to_world(loc)
					$ForageObjects.add_child(clam)
				else:
					Tiles.add_navigation_tiles(loc)
					var starfish = Starfish.instance()
					starfish.location = loc
					starfish.global_position = Tiles.valid_tiles.map_to_world(loc)
					$ForageObjects.add_child(starfish)

	
func set_water_tiles():
	#var count = 0
	for x in range(1000): # fill ocean
		for y in range(1000):
			if dirt.get_cell(x, y) == -1 and plains.get_cell(x, y) == -1 and forest.get_cell(x, y) == -1 and snow.get_cell(x, y) == -1 and sand.get_cell(x,y) == -1:
				wetSand.set_cell(x, y, 0)
				waves.set_cell(x, y, 5)
				shallow_ocean.set_cell(x,y,0)
				top_ocean.set_cell(x,y,0)
				deep_ocean.set_cell(x,y,0)
				validTiles.set_cell(x, y, -1)
	for loc in waves.get_used_cells(): # remove outer layer to show wet sand
		if sand.get_cellv(loc+Vector2(1,0)) != -1 or sand.get_cellv(loc+Vector2(-1,0)) != -1 or sand.get_cellv(loc+Vector2(0,1)) != -1 or sand.get_cellv(loc+Vector2(0,-1)) != -1:
			waves.set_cellv(loc, -1)
			shallow_ocean.set_cellv(loc,-1)
			deep_ocean.set_cellv(loc,-1)
			top_ocean.set_cellv(loc,-1)
	for loc in wetSand.get_used_cells(): # add outer layer to show wet sand
		if wetSand.get_cellv(loc+Vector2(1,0)) != -1 or wetSand.get_cellv(loc+Vector2(-1,0)) != -1 or wetSand.get_cellv(loc+Vector2(0,1)) != -1 or wetSand.get_cellv(loc+Vector2(0,-1)) != -1:
			wetSand.set_cellv(loc+Vector2(1,0), 0)
			wetSand.set_cellv(loc+Vector2(-1,0), 0)
			wetSand.set_cellv(loc+Vector2(0,1), 0)
			wetSand.set_cellv(loc+Vector2(0,-1), 0)
	for loc in waves.get_used_cells(): # remove outer layer to show wet sand
		if wetSand.get_cellv(loc+Vector2(1,0)) != -1 or wetSand.get_cellv(loc+Vector2(-1,0)) != -1 or wetSand.get_cellv(loc+Vector2(0,1)) != -1 or wetSand.get_cellv(loc+Vector2(0,-1)) != -1:
			wetSand.set_cellv(loc+Vector2(1,0), 0)
			wetSand.set_cellv(loc+Vector2(-1,0), 0)
			wetSand.set_cellv(loc+Vector2(0,1), 0)
			wetSand.set_cellv(loc+Vector2(0,-1), 0)
	for loc in shallow_ocean.get_used_cells():
		for i in range(6): # shallow depth length
			if shallow_ocean.get_cellv(loc+Vector2(i,0)) == -1 or shallow_ocean.get_cellv(loc+Vector2(-i,0)) == -1 or shallow_ocean.get_cellv(loc+Vector2(0,i)) == -1 or shallow_ocean.get_cellv(loc+Vector2(0,-i)) == -1:
				deep_ocean.set_cellv(loc+Vector2(1,0), -1)
				deep_ocean.set_cellv(loc+Vector2(-1,0), -1)
				deep_ocean.set_cellv(loc+Vector2(0,1), -1)
				deep_ocean.set_cellv(loc+Vector2(0,-1), -1)


func returnValidSpawnLocation():
	rng.randomize()
	var tempLoc = Vector2(rng.randi_range(8000, 24000), rng.randi_range(8000, 24000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	tempLoc = Vector2(rng.randi_range(8000, 24000), rng.randi_range(8000, 24000))
	if validTiles.get_cellv(validTiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	return null


func spawnRandomWolf():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var wolf = Wolf.instance()
		wolf.global_position = loc
		$Enemies.add_child(wolf)

func spawnRandomBunny():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bunny = Bunny.instance()
		bunny.global_position = loc
		$Enemies.add_child(bunny)

func spawnRandomDuck():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var duck = Duck.instance()
		duck.global_position = loc
		$Enemies.add_child(duck)

func spawnRandomBear():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bear = Bear.instance()
		$Enemies.add_child(bear)
		bear.global_position = loc
		
func spawnRandomBoar():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var boar = Boar.instance()
		$Enemies.add_child(boar)
		boar.global_position = loc

func spawnRandomDeer():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var deer = Deer.instance()
		$Enemies.add_child(deer)
		deer.global_position = loc


