extends Node

@onready var Log = load("res://World/Objects/Nature/Trees/Log.tscn")
@onready var TallGrass = load("res://World/Objects/Nature/Grasses/TallGrass.tscn")
@onready var Weed = load("res://World/Objects/Nature/Grasses/Weed.tscn")
@onready var ForageItem = load("res://World/Objects/Nature/Forage/ForageItem.tscn")
@onready var TreeObject = load("res://World/Objects/Nature/Trees/TreeObject.tscn")
@onready var StumpObject = load("res://World/Objects/Nature/Trees/Stump.tscn")
@onready var PlantedCrop  = load("res://World/Objects/Farm/PlantedCrop.tscn")
@onready var TileObjectHurtBox = load("res://World/Building/Tiles/Hurtbox/TileObjectHurtBox.tscn")
@onready var BuildingTileObjectHurtBox = load("res://World/Building/Tiles/Hurtbox/BuildingTileObjectHurtBox.tscn")
@onready var LargeOre = load("res://World/Objects/Nature/Ores/LargeOre.tscn")
@onready var SmallOre = load("res://World/Objects/Nature/Ores/SmallOre.tscn")
@onready var Cactus = load("res://World/Objects/Nature/Cactus/cactus.tscn")

var rng = RandomNumberGenerator.new()


var PlaceableObjects 
var NatureObjects 
var ForageObjects
var GrassObjects


func place(type,id,data):
	if type == "forage":
		place_forage_in_world(id,data["n"],data["l"],data["f"])
#	elif type == "crop":
#		PlaceObject.place_seed_in_world(id,data["n"],data["l"],data["d"],0,false)
	elif type == "tree":
		place_tree_in_world(id,data["v"],data["l"],data["b"],data["h"],data["p"])
	elif type == "placeable":
		var item_name = data["n"]
		var location = Util.string_to_vector2(data["l"])
		var health = data["h"]
		if item_name == "wall" or item_name == "foundation":
			place_building_object_in_world(id,item_name,location,health,data["t"])
		elif item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
			place_door_in_world(id,item_name,data["d"],location,health,data["v"],data["o"])
		else:
			place_object_in_world(id,item_name,data["d"],location,data["v"],data["o"])


func place_building_object_in_world(id,item_name,location,health,tier):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	var object = BuildingTileObjectHurtBox.instantiate()
	object.name = id
	object.health = health
	object.location = location
	object.item_name = item_name
	object.tier = tier
	PlaceableObjects.call_deferred("add_child", object, true)
	object.global_position = Tiles.wall_tiles.map_to_local(location)


func place_door_in_world(id,item_name,direction,location,health,variety,door_opened):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	var object = BuildingTileObjectHurtBox.instantiate()
	object.name = id
	object.variety = int(variety)
	object.direction = direction
	object.health = health
	object.location = Vector2i(location)
	object.item_name = item_name
	object.door_opened = door_opened
	PlaceableObjects.call_deferred("add_child", object, true)
	object.global_position = Tiles.wall_tiles.map_to_local(location)
	Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_rotatable_object_atlas_tiles[item_name][int(variety)][direction])



func place_tall_grass_in_world(id,biome,location,front_health,back_health):
	GrassObjects = Server.world.get_node("GrassObjects")
	var object = TallGrass.instantiate()
	object.name = id
	object.front_health = front_health
	object.back_health = back_health
	object.biome = biome
	object.location = location 
	object.position = Tiles.valid_tiles.map_to_local(location) + Vector2(-8,8)
	GrassObjects.call_deferred("add_child",object,true)

func place_weed_in_world(id,variety,location):
	GrassObjects = Server.world.get_node("GrassObjects")
	var object = Weed.instantiate()
	object.name = id
	object.variety = variety
	object.location = location
	object.position = Tiles.valid_tiles.map_to_local(location) + Vector2(-8,8)
	GrassObjects.call_deferred("add_child",object,true)

func place_log_in_world(id,variety,location):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = Log.instantiate()
	object.name = id
	object.variety = variety
	object.location = location
	object.position = Tiles.valid_tiles.map_to_local(location) #+ Vector2(8,-8)
	NatureObjects.call_deferred("add_child",object,true)

func place_cactus_in_world(id,variety,location):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = Cactus.instantiate()
	object.name = id
	object.variety = variety
	#object.location = location
	object.position = Tiles.valid_tiles.map_to_local(location) #+ Vector2(8,-8)
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
	object.position = pos + Vector2(-8,-8)
	object.name = id
	NatureObjects.call_deferred("add_child",object,true)
	
func place_stump_in_world(id,variety,location,health):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = StumpObject.instantiate()
	var pos = Tiles.valid_tiles.map_to_local(location)
	object.health = health
	object.variety = variety
	object.location = location
	object.position = pos + Vector2(-8,-8)
	object.name = id
	NatureObjects.call_deferred("add_child",object,true)


func place_seed_in_world(id, item_name, location, days_until_harvest, days_without_water, in_regrowth_phase):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	var plantedCrop = PlantedCrop.instantiate()
	plantedCrop.name = str(id)
	plantedCrop.crop_name = item_name
	plantedCrop.location = location
	plantedCrop.days_until_harvest = days_until_harvest
	plantedCrop.days_without_water = days_without_water
	plantedCrop.in_regrowth_phase = in_regrowth_phase
	PlaceableObjects.call_deferred("add_child", plantedCrop, true)
	plantedCrop.global_position = Tiles.valid_tiles.map_to_local(location)


func place_small_ore_in_world(id,variety,location,health):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = SmallOre.instantiate()
	object.name = id
	object.variety = variety
	object.health = health
	object.location = location
	object.position = Tiles.valid_tiles.map_to_local(location)
	NatureObjects.call_deferred("add_child",object,true)
	
func place_large_ore_in_world(id,variety,location,health):
	NatureObjects = Server.world.get_node("NatureObjects")
	var object = LargeOre.instantiate()
	object.name = id
	object.variety = variety
	object.health = health
	object.location = location
	object.position = Tiles.valid_tiles.map_to_local(location) + Vector2(-8,0)
	NatureObjects.call_deferred("add_child",object,true)
	


#func remove_valid_tiles(item_name,direction, location):
#	item_name = Util.return_adjusted_item_name(item_name)
#	if direction == "left" or direction == "right":
#		Tiles.remove_valid_tiles(location, Vector2(Constants.dimensions_dict[item_name].y, Constants.dimensions_dict[item_name].x))
#	else:
#		Tiles.remove_valid_tiles(location, Constants.dimensions_dict[item_name])
		
func place_object_in_world(id, item_name, direction, location, variety, opened_or_light_toggled):
	PlaceableObjects = Server.world.get_node("PlaceableObjects")
	var tileObjectHurtBox = TileObjectHurtBox.instantiate()
	tileObjectHurtBox.variety = variety
	tileObjectHurtBox.name = id
	tileObjectHurtBox.item_name = item_name
	tileObjectHurtBox.location = Vector2i(location)
	tileObjectHurtBox.direction = direction
	tileObjectHurtBox.opened_or_light_toggled = opened_or_light_toggled
	PlaceableObjects.call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = Tiles.valid_tiles.map_to_local(location)
