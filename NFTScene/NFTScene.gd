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
onready var PlayerInventoryNftScene = preload("res://NFTScene/PlayerInventoryNftScene.tscn")

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

func _ready():
	Constants.PlayerInventoryNftScene = PlayerInventoryNftScene.instance()
	Server.world = self
	Server.isLoaded = true
	PlayerInventory.current = false
	build_world()
	spawn_animals()
	spawn_weather()
	spawn_player()
	
	
func spawn_animals():
	if Constants.Spawn_bunnies:
		spawn_bunnies()
	if Constants.Spawn_ducks:
		spawn_ducks()
		

func spawn_weather():
	if Constants.Snowing:
		$Weather/Snow.visible = true
	if Constants.Leaves_falling:
		$Weather/FallingLeaf.visible = true
	if Constants.Raining:
		$Weather/Rain.visible = true
	if Constants.Cloudy:
		$Weather/Clouds.visible = true
	if Constants.Lightning:
		start_lightning_effect()


func start_lightning_effect():
	pass

func spawn_player():
	var player = Player.instance()
	player.name = Server.player_id
	player.character = _character.new()
	player.character.LoadPlayerCharacter(Constants.Character)
	$Players.add_child(player)
	player.position = Vector2(50*32,50*32)


func build_valid_tiles():
	Tiles.valid_tiles = $WorldNavigation/ValidTiles
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			valid_tiles.set_cellv(Vector2(x, y), 0)

func build_world():
	match Constants.Biome:
		"dirt":
			generate_biome(dirt_tiles)
		"forest":
			generate_biome(forest_tiles)
		"snow":
			generate_biome(snow_tiles)
	build_valid_tiles()
	build_random_nature_objects()
	generate_grass_bunches()
	generate_flower_tiles()


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
			tallGrassObject.biome = Constants.Biome
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
			tallGrassObject.biome = Constants.Biome
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
		treeObject.biome = Constants.Biome
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
