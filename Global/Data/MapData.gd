extends Node

signal refresh_crops

var game_state: GameState

var world_file_name = "res://JSONData/world.json"
var caves_file_name = "res://JSONData/caves.json"

var tile_types = ["beach", "ocean", "wet_sand", "deep_ocean1","deep_ocean2","deep_ocean3","deep_ocean4","plains", "forest", "dirt", "snow"]#, "desert", "beach", "ocean", "wet_sand", "deep_ocean"]
#var autotile_types = ["plains", "forest", "dirt", "snow",]
var nature_types = ["tree", "stump", "log", "ore_large", "ore", "tall_grass", "forage"]
var is_world_data_in_chunks = false

var world = {}
var caves = {} 

func _ready() -> void:
	PlayerData.connect("season_changed",Callable(self,"reset_cave_data"))
	PlayerData.connect("set_day",Callable(self,"advance_crop"))

#func reset_cave_data():
#	caves = starting_caves_data

func add_world_data_to_chunks():
	if not is_world_data_in_chunks:
		is_world_data_in_chunks = true
#		add_tiles_to_chunks()
#		add_nature_objects_to_chunks()
		#add_animals_to_chunks()

func advance_crop():
	for id in world["tree"]:
		if Util.isNonFruitTree(world["tree"][id]["v"]): # if non-fruit tree
			if not str(world["tree"][id]["p"]) == "5":
				world["tree"][id]["p"] = Util.return_advanced_tree_phase(world["tree"][id]["p"])
		else:
			if not world["tree"][id]["p"] == "harvest" and not world["tree"][id]["b"] == "snow":
				world["tree"][id]["p"] = Util.return_advanced_fruit_tree_phase(world["tree"][id]["p"])
	for id in world["crop"]: 
		var loc = world["crop"][id]["l"]
		if not world["crop"][id]["dww"] == 2: # if crop isn't already dead
			if world["tile"][loc] == "w": # if crop is watered, advance a day
				world["crop"][id]["dh"] -= 1 
				world["crop"][id]["dww"] = 0
			else: 
				world["crop"][id]["dww"] += 1 # crop not watered
	for tile in world["tile"]: # if tile is watered, set to not watered
		if world["tile"][tile] == "w":
			world["tile"][tile] = "h"
	if Server.world.name == "Overworld": # clear watered tiles if in world
		Tiles.watered_tiles.clear()
	emit_signal("refresh_crops")

func set_hoed_tile(loc):
	world["tile"][loc] = "h"
	
func set_watered_tile(loc):
	world["tile"][loc] = "w"
	
func remove_hoed_tile(loc):
	world["tile"].erase(loc)

func add_object(type,id,data):
	if Server.world.name == "Overworld":
		world[type][id] = data
	else:
		caves[Server.world.name][type][id] = data

func remove_object(type,id,location):
	if Server.world.name == "Overworld":
		world[Util.return_chunk_from_location(location)][type].erase(id)
	else:
		caves[Server.world.name][type].erase(id)
	
func update_object_health(type, id, new_health):
	if Server.world.name == "Overworld":
		if world[type].has(id):
			world[type][id]["h"] = new_health
	else:
		if caves[Server.world.name].has(id):
			caves[Server.world.name][id]["h"] = new_health

func return_cave_data(cave_name):
	match cave_name:
		"Overworld":
			return world
	return caves[cave_name]

#func add_nature_objects_to_chunks():
#	for type in nature_types:
#		for id in world[type]:
#			var loc = Util.string_to_vector2(world[type][id]["l"])
#			add_object_to_chunk(type, loc, id)
#
#func add_tiles_to_chunks():
#	for type in tile_types:
#		var tiles = world[type]
#		for tile in tiles:
#			add_tile_to_chunk(type, tile)
#
#
#func add_animals_to_chunks():
#	for id in world["animal"]:
#		var loc = Util.string_to_vector2(world["animal"][id]["l"])
#		add_object_to_chunk("animal", loc, id)

