extends Node

@onready var Log = load("res://World/Objects/Nature/Trees/Log.tscn")
@onready var TallGrass = load("res://World/Objects/Nature/Grasses/TallGrass.tscn")
@onready var ForageItem = load("res://World/Objects/Nature/Forage/ForageItem.tscn")
@onready var TreeObject = load("res://World/Objects/Nature/Trees/TreeObject.tscn")
@onready var StumpObject = load("res://World/Objects/Nature/Trees/Stump.tscn")
@onready var PlantedCrop  = load("res://World/Objects/Farm/PlantedCrop.tscn")
@onready var TileObjectHurtBox = load("res://World/Building/Tiles/Hurtbox/TileObjectHurtBox.tscn")
@onready var BuildingTileObjectHurtBox = load("res://World/Building/Tiles/Hurtbox/BuildingTileObjectHurtBox.tscn")
@onready var DoorFront #= load("res://World/Objects/Tiles/DoorFront.tscn")
@onready var DoorSide #= load("res://World/Objects/Tiles/DoubleDoorSide.tscn")
@onready var GateFront #= load("res://World/Objects/Tiles/GateFront.tscn")

var rng = RandomNumberGenerator.new()


var PlaceableObjects 
var NatureObjects 
var ForageObjects


func place_log_in_world(id,variety,location):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = Log.instantiate()
	object.name = id
	object.variety = variety #rng.randi_range(1,12) #MapData.world["log"][id]["v"]
	object.location = location
	object.position = Tiles.valid_tiles.map_to_local(location) + Vector2(-8,8)
	NatureObjects.call_deferred("add_child",object,true)

func place_forage_in_world(id,item_name,location,first_placement):
	ForageObjects = Server.world.get_node("ForageObjects")
	var forageItem = ForageItem.instantiate()
	forageItem.name = id
	forageItem.item_name = item_name
	forageItem.location = location
	forageItem.first_placement = first_placement
	forageItem.position = Tiles.valid_tiles.map_to_local(location)
	ForageObjects.call_deferred("add_child",forageItem,true)

func place_tree_in_world(id, variety, location, biome ,health, phase):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = TreeObject.instantiate()
	var pos = Tiles.valid_tiles.map_to_local(location)
	object.phase = phase
	object.biome = biome
	object.health = health
	object.variety = variety
	object.location = location
	object.position = pos + Vector2(-6,-4)
	object.name = id
	NatureObjects.call_deferred("add_child",object,true)
	
func place_stump_in_world(id,variety,location,health):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = StumpObject.instantiate()
	var pos = Tiles.valid_tiles.map_to_local(location)
	object.health = health
	object.variety = variety
	object.location = location
	object.position = pos + Vector2(-6,-4)
	object.name = id
	NatureObjects.call_deferred("add_child",object,true)


func place_seed_in_world(id, item_name, location, days_until_harvest, days_without_water, in_regrowth_phase):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	Tiles.remove_valid_tiles(location)
	var plantedCrop = PlantedCrop.instantiate()
	plantedCrop.name = str(id)
	plantedCrop.crop_name = item_name
	plantedCrop.location = location
	plantedCrop.days_until_harvest = days_until_harvest
	plantedCrop.days_without_water = days_without_water
	plantedCrop.in_regrowth_phase = in_regrowth_phase
	PlaceableObjects.call_deferred("add_child", plantedCrop, true)
	plantedCrop.global_position = Tiles.valid_tiles.map_to_local(location) #+ Vector2(16, 16)


func place_building_object_in_world(id, item_name, variety , location, health):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	rng.randomize()
	match item_name:
		"wall":
			var object = BuildingTileObjectHurtBox.instantiate()
			object.name = str(id)
			object.health = health
			object.location = location
			object.item_name = item_name
			object.tier = variety
			object.id = str(id)
			PlaceableObjects.call_deferred("add_child", object)
			object.global_position = Tiles.wall_tiles.map_to_local(location)
			Tiles.remove_valid_tiles(location, Vector2(1,1))
		"foundation":
			var object = BuildingTileObjectHurtBox.instantiate()
			object.name = str(id)
			object.health = health
			object.location = location
			object.item_name = item_name
			object.id = str(id)
			object.tier = variety
			PlaceableObjects.call_deferred("add_child", object)
			object.global_position = Tiles.wall_tiles.map_to_local(location)


func remove_valid_tiles(item_name,direction, location):
	item_name = Util.return_adjusted_item_name(item_name)
	if direction == "left" or direction == "right":
		Tiles.remove_valid_tiles(location, Vector2(Constants.dimensions_dict[item_name].y, Constants.dimensions_dict[item_name].x))
	else:
		Tiles.remove_valid_tiles(location, Constants.dimensions_dict[item_name])
		
func place_object_in_world(id, item_name, direction, location, variety = null):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	var tileObjectHurtBox = TileObjectHurtBox.instantiate()
	tileObjectHurtBox.variety = variety
	tileObjectHurtBox.name = id
	tileObjectHurtBox.item_name = item_name
	tileObjectHurtBox.location = location
	tileObjectHurtBox.direction = direction
	tileObjectHurtBox.id = id
	PlaceableObjects.call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = Tiles.valid_tiles.map_to_local(location)
	remove_valid_tiles(item_name, direction, location)
	if Constants.autotile_object_atlas_tiles.keys().has(item_name):
		Tiles.object_tiles.set_cells_terrain_connect(0,[location],0,Constants.autotile_object_atlas_tiles[item_name])
	elif Constants.object_atlas_tiles.keys().has(item_name):
		if not Util.isStorageItem(item_name):
			Tiles.object_tiles.set_cell(0,location,0,Constants.object_atlas_tiles[item_name])
	elif Constants.customizable_rotatable_object_atlas_tiles.keys().has(item_name):
		if not Util.isStorageItem(item_name):
			Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_rotatable_object_atlas_tiles[item_name][variety][direction])
	elif Constants.customizable_object_atlas_tiles.keys().has(item_name):
		if not Util.isStorageItem(item_name):
			Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety])
	else:
		if not Util.isStorageItem(item_name):
			Tiles.object_tiles.set_cell(0,location,0,Constants.rotatable_object_atlas_tiles[item_name][direction])
