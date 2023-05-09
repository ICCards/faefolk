extends Node

signal refresh_crops

var game_state: GameState

var world_file_name = "res://JSONData/world.json"
var caves_file_name = "res://JSONData/caves.json"

var tile_types = ["beach", "ocean", "wet_sand", "deep_ocean1","deep_ocean2","deep_ocean3","deep_ocean4","plains", "forest", "dirt", "snow"]#, "desert", "beach", "ocean", "wet_sand", "deep_ocean"]
#var autotile_types = ["plains", "forest", "dirt", "snow",]
var nature_types = ["tree", "stump", "log", "ore_large", "ore", "tall_grass", "forage"]
var is_world_data_in_chunks = false

var world = {
	"is_built": false,
	"ocean": [],
	"deep_ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree": {},
	"stump": {},
	"log": {},
	"ore_large": {},
	"ore": {},
	"tall_grass": {},
	"forage": {},
	"animal": {},
	"crop": {},
	"tile": {},
	"placeable": {},
}


func set_hoed_tile(loc):
	Server.world.get_node("FarmingTiles").rpc_id(1,"set_hoed_tile",loc)
	#.world[MapData.get_chunk_from_location(data["l"])]["tile"][loc] = "h"

func set_watered_tile(loc):
	Server.world.get_node("FarmingTiles").rpc_id(1,"set_watered_tile",loc)
	#world["tile"][loc] = "w"

func remove_hoed_tile(loc):
	Server.world.get_node("FarmingTiles").rpc_id(1,"remove_hoed_tile",loc)
	#world["tile"].erase(loc)


func add_object(type,id,data):
	Server.world.world[MapData.get_chunk_from_location(data["l"])][type][id] = data
	PlaceObject.place(type,id,data)
	Server.world.get_node("PlaceableObjects").rpc_id(1,"player_place_object",Server.player_node.name,type,id,data)


func remove_object(type,id,location):
	Server.world.world[MapData.get_chunk_from_location(location)][type].erase(id)
	Server.world.get_node("PlaceableObjects").rpc_id(1,"player_remove_object",Server.player_node.name,type,id,location)


func move_placeable_object(player_id,id,prev_object_data,data):
	Server.world.world[MapData.get_chunk_from_location(prev_object_data["l"])]["placeable"].erase(id)
	Server.world.world[MapData.get_chunk_from_location(data["l"])]["placeable"][id] = data
	PlaceObject.place("placeable",id,data)
	Server.world.get_node("PlaceableObjects").rpc_id(1,"player_move_object",Server.player_node.name,id,prev_object_data,data)


func get_chunk_from_location(loc):
	var column
	var row
	var x = float(loc.x)
	var y = float(loc.y)
	if loc.x < 187.5:
		column = 1
	elif loc.x < 250:
		column = 2
	elif loc.x < 312.5:
		column = 3
	elif loc.x < 375:
		column = 4
	elif loc.x < 437.5:
		column = 5
	elif loc.x < 500:
		column = 6
	elif loc.x < 562.5:
		column = 7
	elif loc.x < 625:
		column = 8
	elif loc.x < 687.5:
		column = 9
	elif loc.x < 750:
		column = 10
	elif loc.x < 812.5:
		column = 11
	else:
		column = 12
	if loc.y < 187.5:
		row = "A"
	elif loc.y < 250:
		row = "B"
	elif loc.y < 312.5:
		row = "C"
	elif loc.y < 375:
		row = "D"
	elif loc.y < 437.5:
		row = "E"
	elif loc.y < 500:
		row = "F"
	elif loc.y < 562.5:
		row = "G"
	elif loc.y < 625:
		row = "H"
	elif loc.y < 687.5:
		row = "I"
	elif loc.y < 750:
		row = "J"
	elif loc.y < 812.5:
		row = "K"
	else:
		row = "L"
	return row+str(column)

