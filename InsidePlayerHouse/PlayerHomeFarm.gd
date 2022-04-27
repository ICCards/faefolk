extends YSort

onready var TreeObject = preload("res://World/Objects/TreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/TallGrassObject.tscn")
onready var groundTilemap = $GroundTiles
onready var validTiles = $ValidTiles
onready var waterTilemap = $WaterTiles/WaterTilemap
onready var flowerTiles = $DecorationTiles/Flowers

var rng = RandomNumberGenerator.new()


onready var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
onready var tall_grass_types = ["dark green", "green", "red", "yellow"]
onready var treeTypes = ['A','B', 'C', 'D', 'E']
onready var oreTypes = ["Stone", "Cobblestone"]
onready var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var object_name
var pos
var object_variety

var NUM_FARM_OBJECTS = 550
var NUM_GRASS_BUNCHES = 150
var NUM_GRASS_TILES = 100
var NUM_FLOWER_TILES = 250
var MAX_GRASS_BUNCH_SIZE = 24

func _ready():
	if PlayerInventory.player_farm_objects.size() == 0:
		generate_farm()
	else:
		load_farm()
	generate_grass_bunches()
	generate_grass_tiles()
	generate_flower_tiles()


func load_farm():
	for i in range(PlayerInventory.player_farm_objects.size()):
		if PlayerInventory.player_farm_objects.has(i):
			validate_and_remove_tiles(PlayerInventory.player_farm_objects[i][0], groundTilemap.world_to_map(PlayerInventory.player_farm_objects[i][2]))
			place_object(PlayerInventory.player_farm_objects[i][0], PlayerInventory.player_farm_objects[i][1], PlayerInventory.player_farm_objects[i][2], PlayerInventory.player_farm_objects[i][3])


func generate_farm():
	for i in range(NUM_FARM_OBJECTS):
		rng.randomize()
		object_types.shuffle()
		object_name = object_types[0]
		object_variety = set_object_variety(object_name)
		pos = Vector2( rng.randi_range(-1600, 1850), rng.randi_range(250, 2650))
		var location = groundTilemap.world_to_map(pos)
		check_location_and_place_object(object_name, object_variety, i)

func check_location_and_place_object(name, variety, i):
	rng.randomize()
	pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
	var location = groundTilemap.world_to_map(pos)
	if validate_and_remove_tiles(name, location):
		place_object(name, variety, groundTilemap.map_to_world(location), true)
		PlayerInventory.player_farm_objects[i] = [name, variety, groundTilemap.map_to_world(location), true] 
	else:
		check_location_and_place_object(name, variety, i)

func generate_flower_tiles():
	for i in range(NUM_FLOWER_TILES):
		rng.randomize()
		pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(pos)
		if validate_and_remove_tiles("flower", location):
			flowerTiles.set_cellv(location, rng.randi_range(0, 19))


func generate_grass_bunches():
	for i in range(NUM_GRASS_BUNCHES):
		pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(pos)
		if validate_and_remove_tiles("tall grass", location):
			validTiles.set_cellv(location, -1)
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + pos + Vector2(16,24)
			create_grass_bunch(location, tall_grass_types[0])

func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for i in range(randomNum):
		randomBorderTiles.shuffle()
		loc += randomBorderTiles[0]
		if validate_and_remove_tiles("tall grass", loc):
			var tallGrassObject = TallGrassObject.instance()
			tallGrassObject.initialize(variety)
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + validTiles.map_to_world(loc) + Vector2(16,24)

func generate_grass_tiles():
	for i in range(NUM_GRASS_TILES):
		rng.randomize()
		pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(pos)
		if validate_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + pos + Vector2(16,24)


func set_object_variety(name):
	rng.randomize()
	if name == "tree" or name == "tree stump":
		treeTypes.shuffle()
		return treeTypes[0]
	elif name == "tree branch":
		return rng.randi_range(0, 11)
	else:
		oreTypes.shuffle()
		return oreTypes[0]


func validate_and_remove_tiles(name, loc):
	if name == "tree branch" or name == "ore small" or name == "tall grass" or name == "flower":
		if validTiles.get_cellv(loc) != -1:
			validTiles.set_cellv(loc, -1)
			return true
		else:
			return false
	else:
		if validTiles.get_cellv(loc) != -1 and validTiles.get_cellv(loc + Vector2(0,1)) != -1 and validTiles.get_cellv(loc + Vector2(-1,1)) != -1 and validTiles.get_cellv(loc + Vector2(-1,0)) != -1:
			validTiles.set_cellv(loc, -1)
			validTiles.set_cellv(loc + Vector2(0, 1), -1)
			validTiles.set_cellv(loc + Vector2(-1, 1), -1)
			validTiles.set_cellv(loc + Vector2(-1, 0), -1)
			return true
		else:
			return false


func place_object(name, variety, pos, isFullGrowth):
	if name == "tree":
		var treeObject = TreeObject.instance()
		treeObject.initialize(variety, pos, isFullGrowth)
		call_deferred("add_child", treeObject)
		treeObject.position = pos + Vector2(0, 24)
	elif name == "tree stump":
		var stumpObject = StumpObject.instance()
		stumpObject.initialize(variety, pos)
		call_deferred("add_child", stumpObject)
		stumpObject.position = pos + Vector2(4, 36)
	elif name == "tree branch":
		var branchObject = BranchObject.instance()
		branchObject.initialize(variety, pos)
		call_deferred("add_child", branchObject)
		branchObject.position = pos + Vector2(17, 16)
	elif name == "ore large":
		var oreObject = OreObject.instance()
		oreObject.initialize(variety, pos, isFullGrowth)
		call_deferred("add_child", oreObject)
		oreObject.position = pos + Vector2(0, 28)
	elif name == "ore small":
		var smallOreObject = SmallOreObject.instance()
		smallOreObject.initialize(variety, pos)
		call_deferred("add_child", smallOreObject)
		smallOreObject.position = pos + Vector2(16, 24)

