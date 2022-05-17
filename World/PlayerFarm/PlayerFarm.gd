extends YSort

onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/Nature/Trees/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/Nature/Trees/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/Nature/Ores/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/Nature/Ores/OreObjectSmall.tscn")
onready var TallGrassObject = preload("res://World/Objects/Nature/Grasses/TallGrassObject.tscn")
onready var FlowerObject = preload("res://World/Objects/Nature/Grasses/FlowerObject.tscn")
onready var TorchObject = preload("res://World/Objects/Placables/TorchObject.tscn")
onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/PlayerFarm/TileObjectHurtBox.tscn")

onready var hoed_grass_tiles = $GroundTiles/HoedAutoTiles
onready var watered_grass_tiles = $GroundTiles/WateredAutoTiles
onready var invalid_tiles_for_nature_placement = $GroundTiles/InvalidTileForNaturePlacement
onready var valid_tiles_for_object_placement = $GroundTiles/ValidTilesForObjectPlacement
onready var invisible_planted_crop_cells = $GroundTiles/InvisiblePlantedCropCells
onready var fence_tiles = $DecorationTiles/FenceAutoTile
onready var placable_object_tiles = $DecorationTiles/PlacableObjectTiles

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
const NUM_GRASS_TILES = 75
const NUM_FLOWER_TILES = 250
const MAX_GRASS_BUNCH_SIZE = 24


func _ready():
	if PlayerFarmApi.player_farm_objects.size() == 0:
		generate_farm()
	else:
		load_farm()
	load_player_crops()
	load_player_placables()
	generate_grass_bunches()
	generate_grass_tiles()
	generate_flower_tiles()
	DayNightTimer.connect("advance_day", self, "advance_crop_day")


func load_player_placables():
	for i in range(PlayerFarmApi.player_placable_objects.size()):
		place_object(PlayerFarmApi.player_placable_objects[i][0], null, PlayerFarmApi.player_placable_objects[i][1], null)

func load_farm():
	for i in range( PlayerFarmApi.player_farm_objects.size()):
		validate_location_and_remove_tiles(PlayerFarmApi.player_farm_objects[i][0], PlayerFarmApi.player_farm_objects[i][2])
		place_object(PlayerFarmApi.player_farm_objects[i][0], PlayerFarmApi.player_farm_objects[i][1], PlayerFarmApi.player_farm_objects[i][2], PlayerFarmApi.player_farm_objects[i][3])
		
		
func load_player_crops():
	for i in range(PlayerFarmApi.planted_crops.size()):
		invisible_planted_crop_cells.set_cellv(PlayerFarmApi.planted_crops[i][1], 0)
		hoed_grass_tiles.set_cellv(PlayerFarmApi.planted_crops[i][1], 0)
		valid_tiles_for_object_placement.set_cellv(PlayerFarmApi.planted_crops[i][1], -1)
		var plantedCrop = PlantedCrop.instance()
		plantedCrop.initialize(PlayerFarmApi.planted_crops[i][0], PlayerFarmApi.planted_crops[i][1], PlayerFarmApi.planted_crops[i][3], PlayerFarmApi.planted_crops[i][4],  PlayerFarmApi.planted_crops[i][5])
		add_child(plantedCrop)
		plantedCrop.global_position = valid_tiles_for_object_placement.map_to_world(PlayerFarmApi.planted_crops[i][1]) + Vector2(0, 16)
		if PlayerFarmApi.planted_crops[i][2]:
			watered_grass_tiles.set_cellv(PlayerFarmApi.planted_crops[i][1], 0)
	hoed_grass_tiles.update_bitmask_region()
	watered_grass_tiles.update_bitmask_region()

func generate_farm():
	for i in range(NUM_FARM_OBJECTS):
		rng.randomize()
		object_types.shuffle()
		object_name = object_types[0]
		object_variety = set_object_variety(object_name)
		find_random_location_and_place_object(object_name, object_variety, i)


func find_random_location_and_place_object(name, variety, i):
	rng.randomize()
	var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
	if validate_location_and_remove_tiles(name, location):
		place_object(name, variety, location, true)
		PlayerFarmApi.player_farm_objects.append([name, variety, location, true])
	else:
		find_random_location_and_place_object(name, variety, i)

func generate_flower_tiles():
	for _i in range(NUM_FLOWER_TILES):
		rng.randomize()
		var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
		if validate_location_and_remove_tiles("flower", location):
			var flowerObject = FlowerObject.instance()
			call_deferred("add_child", flowerObject)
			flowerObject.position = valid_tiles_for_object_placement.map_to_world(location) + Vector2(16, 32)


func generate_grass_bunches():
	for _i in range(NUM_GRASS_BUNCHES):
		var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
		if validate_location_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position = valid_tiles_for_object_placement.map_to_world(location) + Vector2(16,32)
			create_grass_bunch(location, tall_grass_types[0])

func create_grass_bunch(loc, variety):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		randomBorderTiles.shuffle()
		loc += randomBorderTiles[0]
		if validate_location_and_remove_tiles("tall grass", loc):
			var tallGrassObject = TallGrassObject.instance()
			tallGrassObject.initialize(variety)
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position =  valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16,32)
		else:
			loc -= randomBorderTiles[0]


func generate_grass_tiles():
	for _i in range(NUM_GRASS_TILES):
		rng.randomize()
		var location = Vector2(rng.randi_range(-50, 60), rng.randi_range(8, 82))
		if validate_location_and_remove_tiles("tall grass", location):
			var tallGrassObject = TallGrassObject.instance()
			tall_grass_types.shuffle()
			tallGrassObject.initialize(tall_grass_types[0])
			call_deferred("add_child", tallGrassObject)
			tallGrassObject.position =  valid_tiles_for_object_placement.map_to_world(location) + Vector2(16,32)


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


func validate_location_and_remove_tiles(name, loc):
	if name == "tree branch" or name == "ore small" or name == "tall grass" or name == "flower" or name == "Torch":
		if valid_tiles_for_object_placement.get_cellv(loc) != -1 and invalid_tiles_for_nature_placement.get_cellv(loc) != 0:
			valid_tiles_for_object_placement.set_cellv(loc, -1)
			return true
		else:
			return false
	else:
		if valid_tiles_for_object_placement.get_cellv(loc) != -1 \
		and valid_tiles_for_object_placement.get_cellv(loc + Vector2(0,1)) != -1 \
		and valid_tiles_for_object_placement.get_cellv(loc + Vector2(-1,1)) != -1 \
		and valid_tiles_for_object_placement.get_cellv(loc + Vector2(-1,0)) != -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc) == -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc + Vector2(0,1)) == -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc + Vector2(-1,1)) == -1 \
		and invalid_tiles_for_nature_placement.get_cellv(loc + Vector2(-1,0)) == -1:
				valid_tiles_for_object_placement.set_cellv(loc, -1)
				valid_tiles_for_object_placement.set_cellv(loc + Vector2(0, 1), -1)
				valid_tiles_for_object_placement.set_cellv(loc + Vector2(-1, 1), -1)
				valid_tiles_for_object_placement.set_cellv(loc + Vector2(-1, 0), -1)
				return true
		else:
			return false


func place_object(name, variety, loc, isFullGrowth):
	if name == "tree":
		var treeObject = TreeObject.instance()
		treeObject.initialize(variety, loc, isFullGrowth)
		call_deferred("add_child", treeObject)
		treeObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(0, 24)
	elif name == "tree stump":
		var stumpObject = StumpObject.instance()
		stumpObject.initialize(variety, loc)
		call_deferred("add_child", stumpObject)
		stumpObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(4, 36)
	elif name == "tree branch":
		var branchObject = BranchObject.instance()
		branchObject.initialize(variety, loc)
		call_deferred("add_child", branchObject)
		branchObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(17, 16)
	elif name == "ore large":
		var oreObject = OreObject.instance()
		oreObject.initialize(variety, loc, isFullGrowth)
		call_deferred("add_child", oreObject)
		oreObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(0, 28)
	elif name == "ore small":
		var smallOreObject = SmallOreObject.instance()
		smallOreObject.initialize(variety, loc)
		call_deferred("add_child", smallOreObject)
		smallOreObject.position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 24)
	elif name == "torch":
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var torchObject = TorchObject.instance()
		torchObject.initialize(loc)
		call_deferred("add_child", torchObject)
		torchObject.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 22)
	elif name == "wood fence":
		fence_tiles.set_cellv(loc, 0)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	elif name == "wood barrel":
		placable_object_tiles.set_cellv(loc, 0)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	elif name == "wood box":
		placable_object_tiles.set_cellv(loc, 1)
		valid_tiles_for_object_placement.set_cellv(loc, -1)
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, loc)
		call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = valid_tiles_for_object_placement.map_to_world(loc) + Vector2(16, 16)
	fence_tiles.update_bitmask_region()

func advance_crop_day():
	PlayerFarmApi.advance_day()
	get_tree().call_group("active_crops", "delete_crop")
	watered_grass_tiles.clear()
	load_player_crops()
