extends Node2D

onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
onready var DesertTreeObject = preload("res://World/Objects/Nature/Trees/DesertTreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/Nature/Trees/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/Nature/Trees/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/Nature/Ores/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/Nature/Ores/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/Nature/Grasses/TallGrassObject.tscn")
onready var FlowerObject = preload("res://World/Objects/Nature/Grasses/FlowerObject.tscn")
onready var Bunny = preload("res://World/Animals/Bunny.tscn")
onready var Duck = preload("res://World/Animals/Duck.tscn")

onready var valid_tiles = $WorldNavigation/ValidTiles
onready var dirt_tiles = $GeneratedTiles/DirtTiles
onready var forest_tiles = $GeneratedTiles/DarkGreenGrassTiles
onready var snow_tiles = $GeneratedTiles/SnowTiles
onready var Player = preload("res://NFTScene/PlayerNftScene.tscn")
const _character = preload("res://Global/Data/Characters.gd")

var rng = RandomNumberGenerator.new()

onready var biomes = ["dirt", "forest", "snow"]
onready var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
onready var tall_grass_types = ["dark green", "green", "red", "yellow"]
onready var treeTypes = ['A','B', 'C', 'D', 'E']
onready var oreTypes = ["Stone", "Cobblestone"]
onready var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

const NUM_BUNNIES = 40
const NUM_DUCKS = 40
const MAP_SIZE = 100
const NUM_FARM_OBJECTS = 550
const NUM_GRASS_BUNCHES = 150
const NUM_GRASS_TILES = 75
const NUM_FLOWER_TILES = 250
const MAX_GRASS_BUNCH_SIZE = 24
var biome 

func _ready():
	Server.world = self
	PlayerInventory.current = false
	build_valid_tiles()
	generate_random_biome()
	spawn_bunnies()
	spawn_ducks()
	spawn_player()
	play_random_weather()
	generate_grass_bunches()
	generate_flower_tiles()
	Server.isLoaded = true
	

func play_random_weather():
	rng.randomize()
	var randomNum = rng.randi_range(0, 100)
	if randomNum < 25:
		$Weather/Snow.visible = true
	elif randomNum < 50:
		$Weather/FallingLeaf.visible = true
	elif randomNum < 75:
		$Weather/Rain.visible = true


func spawn_player():
	var player = Player.instance()
	player.name = Server.player_id
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	$Players.add_child(player)
	player.position = Vector2(50*32,50*32)


func build_valid_tiles():
	Tiles.valid_tiles = $WorldNavigation/ValidTiles
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			valid_tiles.set_cellv(Vector2(x, y), 0)

func generate_random_biome():
	rng.randomize()
	biomes.shuffle()
	biome = biomes[0]
	match biome:
		"dirt":
			generate_biome(dirt_tiles)
		"forest":
			generate_biome(forest_tiles)
		"snow":
			generate_biome(snow_tiles)
	build_random_nature_objects()
	
	
func build_random_nature_objects():
	for i in range(NUM_FARM_OBJECTS):
		rng.randomize()
		object_types.shuffle()
		var object_name = object_types[0]
		find_random_location_and_place_object(object_name)


func find_random_location_and_place_object(object_name):
	rng.randomize()
	var location = Vector2(rng.randi_range(0, 100), rng.randi_range(0, 100))
	if validate_location_and_remove_tiles(object_name, location):
		place_object(object_name, null, location)

func validate_location_and_remove_tiles(item_name, loc):
	if item_name == "tree branch" or item_name == "ore small" or item_name == "tall grass" or item_name == "flower":
		if valid_tiles.get_cellv(loc) != -1:
			valid_tiles.set_cellv(loc, -1)
			return true
		else:
			return false
	else:
		if valid_tiles.get_cellv(loc) != -1 \
		and valid_tiles.get_cellv(loc + Vector2(0,1)) != -1 \
		and valid_tiles.get_cellv(loc + Vector2(-1,1)) != -1 \
		and valid_tiles.get_cellv(loc + Vector2(-1,0)) != -1:
				valid_tiles.set_cellv(loc, -1)
				valid_tiles.set_cellv(loc + Vector2(0, 1), -1)
				valid_tiles.set_cellv(loc + Vector2(-1, 1), -1)
				valid_tiles.set_cellv(loc + Vector2(-1, 0), -1)
				return true
		else:
			return false
			
			
func generate_flower_tiles():
	for _i in range(NUM_FLOWER_TILES):
		var location = Vector2(rng.randi_range(0, 100), rng.randi_range(0, 100))
		if validate_location_and_remove_tiles("tall grass", location):
			var flowerObject = FlowerObject.instance()
			$NatureObjects.call_deferred("add_child", flowerObject)
			flowerObject.position = valid_tiles.map_to_world(location) + Vector2(16, 32)


func generate_grass_bunches():
	for _i in range(NUM_GRASS_BUNCHES):
		var location = Vector2(rng.randi_range(0, 100), rng.randi_range(0, 100))
		if validate_location_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.biome = biome
			tallGrassObject.variety = tall_grass_types[0]
			$NatureObjects.call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = valid_tiles.map_to_world(location) + Vector2(8, 32)
			create_grass_bunch(location, tall_grass_types[0])

func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		randomBorderTiles.shuffle()
		loc += randomBorderTiles[0]
		if validate_location_and_remove_tiles("tall grass", loc):
			var tallGrassObject = TallGrassObject.instance()
			tallGrassObject.biome = biome
			tallGrassObject.variety = variety
			$NatureObjects.call_deferred("add_child", tallGrassObject)
			tallGrassObject.position =  valid_tiles.map_to_world(loc) + Vector2(8, 32)
		else:
			loc -= randomBorderTiles[0]

func place_object(item_name, variety, loc):
	if item_name == "tree":
		treeTypes.shuffle()
		var treeObject = TreeObject.instance()
		treeObject.health = 8
		treeObject.biome = biome
		treeObject.initialize(treeTypes[0], loc)
		$NatureObjects.call_deferred("add_child", treeObject)
		treeObject.position = valid_tiles.map_to_world(loc) + Vector2(0, 24)
	elif item_name == "tree stump":
		treeTypes.shuffle()
		var stumpObject = StumpObject.instance()
		stumpObject.health = 5
		stumpObject.initialize(treeTypes[0], loc)
		$NatureObjects.call_deferred("add_child", stumpObject)
		stumpObject.position = valid_tiles.map_to_world(loc) + Vector2(4, 36)
	elif item_name == "tree branch":
		var branchObject = BranchObject.instance()
		branchObject.initialize(rng.randi_range(0, 11), loc)
		$NatureObjects.call_deferred("add_child", branchObject)
		branchObject.position = valid_tiles.map_to_world(loc) + Vector2(17, 16)
	elif item_name == "ore large":
		oreTypes.shuffle()
		var oreObject = OreObject.instance()
		oreObject.health = 5
		oreObject.initialize(oreTypes[0], loc)
		$NatureObjects.call_deferred("add_child", oreObject)
		oreObject.position = valid_tiles.map_to_world(loc) + Vector2(0, 28)
	elif item_name == "ore small":
		oreTypes.shuffle()
		var smallOreObject = SmallOreObject.instance()
		smallOreObject.health = 3
		smallOreObject.initialize(oreTypes[0], loc)
		$NatureObjects.call_deferred("add_child", smallOreObject)
		smallOreObject.position = valid_tiles.map_to_world(loc) + Vector2(16, 24)


func generate_biome(map):
	for x in range(MAP_SIZE+2):
		for y in range(MAP_SIZE+2):
			map.set_cellv(Vector2(x-1, y-1), 0)
	map.update_bitmask_region()
	

func is_valid_position(_pos, _name):
	if _pos.x > 1 and _pos.x < 99 and _pos.y > 1 and _pos.y < 99:
		if valid_tiles.get_cellv(_pos) != -1 and _name != "tree" and _name != "stump":
			valid_tiles.set_cellv(_pos, -1)
			return true
		elif (_name == "tree" or _name == "stump" or name == "ore_large") and \
				valid_tiles.get_cellv(_pos) != -1 and \
				valid_tiles.get_cellv(_pos + Vector2(-1, -1)) != -1 and \
				valid_tiles.get_cellv(_pos + Vector2(-1, 0)) != -1 and \
				valid_tiles.get_cellv(_pos + Vector2(0, -1)) != -1:
					valid_tiles.set_cellv(_pos, -1)
					valid_tiles.set_cellv(_pos + Vector2(-1, -1), -1 )
					valid_tiles.set_cellv(_pos + Vector2(-1, 0), -1 )
					valid_tiles.set_cellv(_pos + Vector2(0, -1), -1)
					return true
		else: 
			return false
	else: 
		return false
		
		
func returnValidSpawnLocation():
	rng.randomize()
	var tempLoc = Vector2(rng.randi_range(0, 3200), rng.randi_range(0, 3200))
	if valid_tiles.get_cellv(valid_tiles.world_to_map(tempLoc)) != -1:
		return tempLoc
	else:
		return null

func spawn_bunnies():
	for i in range(NUM_BUNNIES):
		spawnRandomBunny()
		
func spawn_ducks():
	for i in range(NUM_DUCKS):
		spawnRandomDuck()


func spawnRandomBunny():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var bunny = Bunny.instance()
		bunny.global_position = loc
		$Animals.add_child(bunny)

func spawnRandomDuck():
	var loc = returnValidSpawnLocation()
	if loc != null:
		var duck = Duck.instance()
		duck.global_position = loc
		$Animals.add_child(duck)
