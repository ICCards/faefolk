extends YSort

onready var TreeObject = preload("res://World/Objects/TreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/TallGrassObject.tscn")
onready var FlowerObject = preload("res://World/Objects/FlowerObject.tscn")
onready var TorchObject = preload("res://World/Objects/TorchObject.tscn")
onready var groundTilemap = $GroundTiles/GroundTiles
onready var validTiles = $GroundTiles/ValidTiles
onready var waterTilemap = $WaterTiles/WaterTilemap
onready var flowerTiles = $DecorationTiles/Flowers
onready var validWaterTiles = $GroundTiles/WaterValidTiles
onready var waterAnimationTiles = $WaterTiles/WaterAnimated
onready var timer = $Timer

var rng = RandomNumberGenerator.new()


onready var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
onready var tall_grass_types = ["dark green", "green", "red", "yellow"]
onready var treeTypes = ['A','B', 'C', 'D', 'E']
onready var oreTypes = ["Stone", "Cobblestone"]
onready var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var object_name
var position_of_object
var object_variety

const NUM_FARM_OBJECTS = 550
const NUM_GRASS_BUNCHES = 150
const NUM_GRASS_TILES = 100
const NUM_FLOWER_TILES = 250
const MAX_GRASS_BUNCH_SIZE = 24


func _ready():
	if PlayerInventory.player_farm_objects.size() == 0:
		generate_farm()
	else:
		pass
		load_farm()
	generate_grass_bunches()
	generate_grass_tiles()
	generate_flower_tiles()
	play_water_animation()
	
func play_water_animation():
	var tiles = validWaterTiles.get_used_cells()
	tiles.shuffle()
	for i in range(10):
		waterAnimationTiles.set_cellv(tiles[i], rng.randi_range(0, 7))
	var randomDelay = rng.randi_range(1,2)
	timer.wait_time = randomDelay
	timer.start()
	yield(timer, "timeout")
	waterAnimationTiles.clear()
	play_water_animation()

var amount_of_farm_objects = PlayerInventory.player_farm_objects.size()
func load_farm():
	for i in range(amount_of_farm_objects):
		if PlayerInventory.player_farm_objects.has(i):
			validate_and_remove_tiles(PlayerInventory.player_farm_objects[i][0], groundTilemap.world_to_map(PlayerInventory.player_farm_objects[i][2]))
			place_object(PlayerInventory.player_farm_objects[i][0], PlayerInventory.player_farm_objects[i][1], PlayerInventory.player_farm_objects[i][2], PlayerInventory.player_farm_objects[i][3])
		else:
			amount_of_farm_objects += 1


func generate_farm():
	for i in range(NUM_FARM_OBJECTS):
		rng.randomize()
		object_types.shuffle()
		object_name = object_types[0]
		object_variety = set_object_variety(object_name)
		find_valid_location_and_place_object(object_name, object_variety, i)

func find_valid_location_and_place_object(name, variety, i):
	rng.randomize()
	position_of_object = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
	var location = groundTilemap.world_to_map(position_of_object)
	if validate_and_remove_tiles(name, location):
		place_object(name, variety, groundTilemap.map_to_world(location), true)
		PlayerInventory.player_farm_objects[i] = [name, variety, groundTilemap.map_to_world(location), true] 
	else:
		find_valid_location_and_place_object(name, variety, i)

func generate_flower_tiles():
	for _i in range(NUM_FLOWER_TILES):
		rng.randomize()
		position_of_object = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(position_of_object)
		if validate_and_remove_tiles("flower", location):
			var flowerObject = FlowerObject.instance()
			call_deferred("add_child", flowerObject)
			flowerObject.position = global_position + position_of_object + Vector2(16, 32)


func generate_grass_bunches():
	for _i in range(NUM_GRASS_BUNCHES):
		position_of_object = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(position_of_object)
		if validate_and_remove_tiles("tall grass", location):
			validTiles.set_cellv(location, -1)
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + position_of_object + Vector2(16,32)
			create_grass_bunch(location, tall_grass_types[0])

func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		randomBorderTiles.shuffle()
		loc += randomBorderTiles[0]
		if validate_and_remove_tiles("tall grass", loc):
			var tallGrassObject = TallGrassObject.instance()
			tallGrassObject.initialize(variety)
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + validTiles.map_to_world(loc) + Vector2(16,32)
		else:
			loc -= randomBorderTiles[0]

func generate_grass_tiles():
	for _i in range(NUM_GRASS_TILES):
		rng.randomize()
		position_of_object = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(position_of_object)
		if validate_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + position_of_object + Vector2(16,32)


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
	if name == "tree branch" or name == "ore small" or name == "tall grass" or name == "flower" or name == "Torch":
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
	elif name == "Torch":
		var torchObject = TorchObject.instance()
		call_deferred("add_child", torchObject)
		torchObject.global_position = pos