extends YSort

onready var TreeObject = preload("res://World/Objects/TreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/TallGrassObject.tscn")
onready var groundTilemap = $GroundTiles
onready var hiddenGroundTileMap = $HiddenGroundLayer

var rng = RandomNumberGenerator.new()

func _ready():
	if PlayerInventory.player_farm_objects.size() == 0:
		generate_farm()
	else:
		load_farm()
	initiate_grass_tiles()

onready var object_types = ["tree", "tree stump", "tree branch", "ore large", "ore small"]

var object_name
var pos
var object_variety

func initiate_grass_tiles():
	for i in range(2000):
		pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
		var location = groundTilemap.world_to_map(pos)
		if verify_tile("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = global_position + pos + Vector2(16,24)

func load_farm():
	for i in range(PlayerInventory.player_farm_objects.size()):
		if PlayerInventory.player_farm_objects.has(i):
			place_object(PlayerInventory.player_farm_objects[i][0], PlayerInventory.player_farm_objects[i][1], PlayerInventory.player_farm_objects[i][2], PlayerInventory.player_farm_objects[i][3])


func generate_farm():
	for i in range(650):
		rng.randomize()
		object_types.shuffle()
		object_name = object_types[0]
		object_variety = set_object_variety(object_name)
		pos = Vector2( rng.randi_range(-1600, 1850), rng.randi_range(250, 2650))
		var location = groundTilemap.world_to_map(pos)
		check_and_place_object(object_name, object_variety, i)
		
	
onready var treeTypes = ['A','B', 'C', 'D', 'E']
#onready var oreTypes = ['Red gem', 'Green gem', 'Dark blue gem', 'Cyan gem', 'Gold ore', 'Iron ore', 'Stone', 'Cobblestone']
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
		
func check_and_place_object(name, variety, i):
	rng.randomize()
	pos = Vector2( 32 * rng.randi_range(-50, 60), 32 * rng.randi_range(8, 82))
	var location = groundTilemap.world_to_map(pos)
	if verify_tile(name, location):
		change_tiles(name, location)
		place_object(name, variety, groundTilemap.map_to_world(location), true)
		PlayerInventory.player_farm_objects[i] = [name, variety, groundTilemap.map_to_world(location), true] 
	else:
		check_and_place_object(name, variety, i)

func verify_tile(name, loc):
	if name == "tree branch" or name == "ore small" or name == "tall grass":
		if groundTilemap.get_cellv(loc) != -1:
			return true
		else:
			return false
	else:
		if groundTilemap.get_cellv(loc) != -1 and groundTilemap.get_cellv(loc + Vector2(0,1)) != -1 and groundTilemap.get_cellv(loc + Vector2(-1,1)) != -1 and groundTilemap.get_cellv(loc + Vector2(-1,0)) != -1:
			return true
		else:
			return false

func change_tiles(name, loc):
	if name == "tree":
		groundTilemap.set_cellv(loc, -1)
		groundTilemap.set_cellv(loc + Vector2(0, 1), -1)
		groundTilemap.set_cellv(loc + Vector2(-1, 1), -1)
		groundTilemap.set_cellv(loc + Vector2(-1, 0), -1)
		hiddenGroundTileMap.set_cellv(loc, 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(0, 1), 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(-1, 1), 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(-1, 0), 2)
	elif name == "tree stump":
		groundTilemap.set_cellv(loc, -1)
		groundTilemap.set_cellv(loc + Vector2(0, 1), -1)
		groundTilemap.set_cellv(loc + Vector2(-1, 1), -1)
		groundTilemap.set_cellv(loc + Vector2(-1, 0), -1)
		hiddenGroundTileMap.set_cellv(loc, 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(0, 1), 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(-1, 1), 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(-1, 0), 2)
	elif name == "tree branch":
		groundTilemap.set_cellv(loc, -1)
		hiddenGroundTileMap.set_cellv(loc, 2)
	elif name == "ore large":
		groundTilemap.set_cellv(loc, -1)
		groundTilemap.set_cellv(loc + Vector2(0, 1), -1)
		groundTilemap.set_cellv(loc + Vector2(-1, 1), -1)
		groundTilemap.set_cellv(loc + Vector2(-1, 0), -1)
		hiddenGroundTileMap.set_cellv(loc, 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(0, 1), 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(-1, 1), 2)
		hiddenGroundTileMap.set_cellv(loc + Vector2(-1, 0), 2)
	elif name == "ore small":
		groundTilemap.set_cellv(loc, -1)
		hiddenGroundTileMap.set_cellv(loc, 2)
			
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
