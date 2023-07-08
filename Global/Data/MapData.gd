extends Node

signal refresh_crops

var game_state: GameState

var world = {}
var terrain = {} 
var caves = {}

func _ready() -> void:
	PlayerData.connect("season_changed",Callable(self,"reset_cave_data"))
	PlayerData.connect("set_day",Callable(self,"advance_crop"))

func advance_crop():
	for chunk in world:
		for id in world[chunk]["tree"]:
			if Util.isNonFruitTree(world[chunk]["tree"][id]["v"]): # if non-fruit tree
				if not str(world[chunk]["tree"][id]["p"]) == "5":
					world[chunk]["tree"][id]["p"] = Util.return_advanced_tree_phase(world[chunk]["tree"][id]["p"])
			else:
				if not world[chunk]["tree"][id]["p"] == "harvest" and not world[chunk]["tree"][id]["b"] == "snow":
					world[chunk]["tree"][id]["p"] = Util.return_advanced_fruit_tree_phase(world[chunk]["tree"][id]["p"])
		for id in world[chunk]["crop"]: 
			var loc = world[chunk]["crop"][id]["l"]
			if not JsonData.crop_data[world[chunk]["crop"][id]["n"]]["Seasons"].has(PlayerData.player_data["season"]): # wrong szn
				world[chunk]["crop"][id]["dww"] = 2 # set dead
			elif not world[chunk]["crop"][id]["dww"] == 2: # if crop isn't already dead
				if world[chunk]["tile"][loc] == "w": # if crop is watered, advance a day
					world[chunk]["crop"][id]["dww"] = 0
					world[chunk]["crop"][id]["dh"] -= 1 
					if world[chunk]["crop"][id]["dh"] < 0:
						world[chunk]["crop"][id]["dh"] = 0
				else: 
					world[chunk]["crop"][id]["dww"] += 1 # crop not watered
		for tile in world[chunk]["tile"]: # if tile is watered, set to not watered
			if world[chunk]["tile"][tile] == "w":
				world[chunk]["tile"][tile] = "h"
	if Server.world.name == "Overworld": # clear watered tiles if in world
		Tiles.watered_tiles.clear()
	emit_signal("refresh_crops")

func set_hoed_tile(loc):
	world[Util.return_chunk_from_location(loc)]["tile"][loc] = "h"
	
func set_watered_tile(loc):
	world[Util.return_chunk_from_location(loc)]["tile"][loc] = "w"
	
func remove_hoed_tile(loc):
	world[Util.return_chunk_from_location(loc)]["tile"].erase(loc)

func add_object(type,id,data):
	PlaceObject.place(type,id,data)
	world[Util.return_chunk_from_location(data["l"])][type][id] = data

func remove_object(type,id,location):
	world[Util.return_chunk_from_location(location)][type].erase(id)

func set_updated_animal_position(id,spawn_location,new_position,animal_data):
	var spawn_chunk = Util.return_chunk_from_location(spawn_location)
	var current_chunk = Util.return_chunk_from_location(new_position/16)
	if spawn_chunk == current_chunk:
		world[spawn_chunk]["animal"][id]["l"] = new_position/16
	else:
		world[spawn_chunk]["animal"].erase(id)
		world[current_chunk]["animal"][id] = animal_data

func update_object_health(type, id,new_health):
	pass

