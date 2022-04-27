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
onready var hiddenGroundTileMap = $HiddenGroundLayer

var rng = RandomNumberGenerator.new()

func _ready():
	if PlayerInventory.player_farm_objects.size() == 0:
		generate_farm()
	else:
		load_farm()
	generate_grass_bunches()
	generate_grass_tiles()
	

onready var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]
onready var tall_grass_types = ["dark green", "green", "red", "yellow"]

var object_name
var pos
var object_variety

func generate_grass_bunches():
	for i in range(100):
		pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(pos)
		if verify_tile("tall grass", location):
			validTiles.set_cellv(location, -1)
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + pos + Vector2(16,24)
			create_grass_bunch(location, tall_grass_types[0])

onready var randomBorderTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]
func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(1, 20)
	for i in range(randomNum):
		randomBorderTiles.shuffle()
		loc += randomBorderTiles[0]
		if verify_tile("tall grass", loc):
			var tallGrassObject = TallGrassObject.instance()
			tallGrassObject.initialize(variety)
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + validTiles.map_to_world(loc) + Vector2(16,24)
		

func generate_grass_tiles():
	for i in range(500):
		rng.randomize()
		pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(pos)
		if verify_tile("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + pos + Vector2(16,24)

func load_farm():
	for i in range(PlayerInventory.player_farm_objects.size()):
		if PlayerInventory.player_farm_objects.has(i):
			replace_tiles(PlayerInventory.player_farm_objects[i][0], PlayerInventory.player_farm_objects[i][2])
			place_object(PlayerInventory.player_farm_objects[i][0], PlayerInventory.player_farm_objects[i][1], PlayerInventory.player_farm_objects[i][2], PlayerInventory.player_farm_objects[i][3])


func generate_farm():
	for i in range(500):
		rng.randomize()
		object_types.shuffle()
		object_name = object_types[0]
		object_variety = set_object_variety(object_name)
		pos = Vector2( rng.randi_range(-1600, 1850), rng.randi_range(250, 2650))
		var location = groundTilemap.world_to_map(pos)
		check_location_and_place_object(object_name, object_variety, i)
		
	
onready var treeTypes = ['A','B', 'C', 'D', 'E']
onready var oreTypes = ["Stone", "Cobblestone"]

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
		
func check_location_and_place_object(name, variety, i):
	rng.randomize()
	pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
	var location = groundTilemap.world_to_map(pos)
	if verify_tile(name, location):
		place_object(name, variety, groundTilemap.map_to_world(location), true)
		PlayerInventory.player_farm_objects[i] = [name, variety, groundTilemap.map_to_world(location), true] 
	else:
		check_location_and_place_object(name, variety, i)

func verify_tile(name, loc):
	if name == "tree branch" or name == "ore small" or name == "tall grass":
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

func replace_tiles(name, loc):
	loc = groundTilemap.world_to_map(loc)
	if name == "tree":
		validTiles.set_cellv(loc, -1)
		validTiles.set_cellv(loc + Vector2(0, 1), -1)
		validTiles.set_cellv(loc + Vector2(-1, 1), -1)
		validTiles.set_cellv(loc + Vector2(-1, 0), -1)
	elif name == "tree stump":
		validTiles.set_cellv(loc, -1)
		validTiles.set_cellv(loc + Vector2(0, 1), -1)
		validTiles.set_cellv(loc + Vector2(-1, 1), -1)
		validTiles.set_cellv(loc + Vector2(-1, 0), -1)
	elif name == "tree branch":
		validTiles.set_cellv(loc, -1)
	elif name == "ore large":
		validTiles.set_cellv(loc, -1)
		validTiles.set_cellv(loc + Vector2(0, 1), -1)
		validTiles.set_cellv(loc + Vector2(-1, 1), -1)
		validTiles.set_cellv(loc + Vector2(-1, 0), -1)
	elif name == "ore small":
		validTiles.set_cellv(loc, -1)

			
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

