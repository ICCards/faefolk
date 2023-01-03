extends Node

signal refresh_crops

var game_state: GameState

var world_file_name = "res://JSONData/world.json"
var caves_file_name = "res://JSONData/caves.json"

var tile_types = ["plains", "forest", "dirt", "desert", "snow", "beach", "ocean"]
var nature_types = ["tree", "stump", "log", "ore_large", "ore", "tall_grass", "flower"]
var is_world_built = false

var world = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree": {},
	"stump": {},
	"log": {},
	"ore_large": {},
	"ore": {},
	"flower": {},
	"tall_grass": {},
	"forage": {},
	"crops": {},
	"tiles": {},
	"placables": {}
}
var caves = {"Cave 1-1":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-2":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-3":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-4":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-5":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-6":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-7":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-Boss":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 1-Fishing":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-1":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-2":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-3":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-4":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-5":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-6":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-7":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}},
"Cave 2-Boss":{"is_built":false,"mushroom":{},"ore":{},"ore_large":{},"placables":{},"tall_grass":{}}}

func _ready() -> void:
	var file = File.new()
	if GameState.save_exists():
		add_world_data_to_chunks()
	PlayerData.connect("set_day", self, "advance_crops")

func add_world_data_to_chunks():
	game_state = GameState.new()
	game_state.load_state()
	caves = game_state.cave_state
	world = game_state.world_state
	add_tiles_to_chunks()
	add_nature_objects_to_chunks()

func advance_crops():
	for id in world["crops"]: # if crop is watered, advance a day
		var loc_string = world["crops"][id]["l"]
		if world["tiles"][loc_string] == "w":
			world["crops"][id]["d"] -= 1
	for tile in world["tiles"]: # if tile is watered, set to not watered
		if world["tiles"][tile] == "w":
			world["tiles"][tile] = "h"
	if Server.world.name == "World": # clear watered tiles if in world
		Tiles.watered_tiles.clear()
	emit_signal("refresh_crops")

func save_map_data():
	pass
#	var world_file = File.new()
#	world_file.open(world_file_name,File.WRITE)
#	world_file.store_string(to_json(world))
#	world_file.close()
#	var caves_file = File.new()
#	caves_file.open(caves_file_name,File.WRITE)
#	caves_file.store_string(to_json(caves))
#	caves_file.close()
#	print("saved map data")

#func load_world_data():
#	var file = File.new()
#	if(file.file_exists(world_file_name)):
#		file.open(world_file_name,File.READ)
#		var data = parse_json(file.get_as_text())
#		file.close()
#		if(typeof(data) == TYPE_DICTIONARY):
#			print("loaded world data")
#			world = data
#		else:
#			printerr("corrupted world data")
#	else:
#		printerr("world data not found")
#
#func load_caves_data():
#	var file = File.new()
#	if(file.file_exists(caves_file_name)):
#		file.open(caves_file_name,File.READ)
#		var data = parse_json(file.get_as_text())
#		file.close()
#		if(typeof(data) == TYPE_DICTIONARY):
#			print("loaded caves data")
#			caves = data
#		else:
#			printerr("corrupted caves data")
#	else:
#		var caves_file = File.new()
#		caves_file.open(caves_file_name,File.WRITE)
#		caves_file.store_string(to_json(caves))
#		caves_file.close()
	
func set_hoed_tile(loc):
	world["tiles"][str(loc)] = "h"
	
func set_watered_tile(loc):
	world["tiles"][str(loc)] = "w"
	
func remove_hoed_tile(loc):
	world["tiles"].erase(str(loc))

func add_crop(id,data):
	world["crops"][id] = data
	
func remove_crop(id):
	world["crops"].erase(id)

func add_placable(id, data):
	if Server.world.name == "World":
		world["placables"][id] = data
	else:
		caves[Server.world.name]["placables"][id] = data

func remove_placable(id):
	if Server.world.name == "World":
		world["placables"].erase(id)
	else:
		caves[Server.world.name]["placables"].erase(id)

func remove_object(type, id):
	if Server.world.name == "World":
		world[type].erase(id)
	else:
		caves[Server.world.name][type].erase(id)
	
func update_object_health(type, id, new_health):
	if Server.world.name == "World":
		if world[type].has(id):
			world[type][id]["h"] = new_health
	else:
		if caves[Server.world.name].has(id):
			caves[Server.world.name][id]["h"] = new_health

func return_cave_data(cave_name):
	match cave_name:
		"World":
			return world
	return caves[cave_name]

func add_nature_objects_to_chunks():
	for type in nature_types:
		for id in world[type]:
			var loc = Util.string_to_vector2(world[type][id]["l"])
			add_nature_object_to_chunk(type, loc, id)

func add_tiles_to_chunks():
	for type in tile_types:
		var loc_array = world[type]
		for loc_string in loc_array:
			var loc = Util.string_to_vector2(loc_string)
			add_tile_to_chunk(type, loc)

func return_chunk(_row, _col):
	_col = int(_col)
	match _row:
		"A":
			match _col:
				1:
					return a1
				2:
					return a2
				3:
					return a3
				4:
					return a4
				5:
					return a5
				6:
					return a6
				7:
					return a7
				8:
					return a8
				9:
					return a9
				10:
					return a10
				11:
					return a11
				12:
					return a12
		"B":
			match _col:
				1:
					return b1
				2:
					return b2
				3:
					return b3
				4:
					return b4
				5:
					return b5
				6:
					return b6
				7:
					return b7
				8:
					return b8
				9:
					return b9
				10:
					return b10
				11:
					return b11
				12:
					return b12
		"C":
			match _col:
				1:
					return c1
				2:
					return c2
				3:
					return c3
				4:
					return c4
				5:
					return c5
				6:
					return c6
				7:
					return c7
				8:
					return c8
				9:
					return c9
				10:
					return c10
				11:
					return c11
				12:
					return c12
		"D":
			match _col:
				1:
					return d1
				2:
					return d2
				3:
					return d3
				4:
					return d4
				5:
					return d5
				6:
					return d6
				7:
					return d7
				8:
					return d8
				9:
					return d9
				10:
					return d10
				11:
					return d11
				12:
					return d12
		"E":
			match _col:
				1:
					return e1
				2:
					return e2
				3:
					return e3
				4:
					return e4
				5:
					return e5
				6:
					return e6
				7:
					return e7
				8:
					return e8
				9:
					return e9
				10:
					return e10
				11:
					return e11
				12:
					return e12
		"F":
			match _col:
				1:
					return f1
				2:
					return f2
				3:
					return f3
				4:
					return f4
				5:
					return f5
				6:
					return f6
				7:
					return f7
				8:
					return f8
				9:
					return f9
				10:
					return f10
				11:
					return f11
				12:
					return f12
		"G":
			match _col:
				1:
					return g1
				2:
					return g2
				3:
					return g3
				4:
					return g4
				5:
					return g5
				6:
					return g6
				7:
					return g7
				8:
					return g8
				9:
					return g9
				10:
					return g10
				11:
					return g11
				12:
					return g12
		"H":
			match _col:
				1:
					return h1
				2:
					return h2
				3:
					return h3
				4:
					return h4
				5:
					return h5
				6:
					return h6
				7:
					return h7
				8:
					return h8
				9:
					return h9
				10:
					return h10
				11:
					return h11
				12:
					return h12
		"I":
			match _col:
				1:
					return i1
				2:
					return i2
				3:
					return i3
				4:
					return i4
				5:
					return i5
				6:
					return i6
				7:
					return i7
				8:
					return i8
				9:
					return i9
				10:
					return i10
				11:
					return i11
				12:
					return i12
		"J":
			match _col:
				1:
					return j1
				2:
					return j2
				3:
					return j3
				4:
					return j4
				5:
					return j5
				6:
					return j6
				7:
					return j7
				8:
					return j8
				9:
					return j9
				10:
					return j10
				11:
					return j11
				12:
					return j12
		"K":
			match _col:
				1:
					return k1
				2:
					return k2
				3:
					return k3
				4:
					return k4
				5:
					return k5
				6:
					return k6
				7:
					return k7
				8:
					return k8
				9:
					return k9
				10:
					return k10
				11:
					return k11
				12:
					return k12
		"L":
			match _col:
				1:
					return l1
				2:
					return l2
				3:
					return l3
				4:
					return l4
				5:
					return l5
				6:
					return l6
				7:
					return l7
				8:
					return l8
				9:
					return l9
				10:
					return l10
				11:
					return l11
				12:
					return l12

var a1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var a12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var b12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var c12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var d12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var e12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var f12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var g12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var h12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var i12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var j12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var k12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l1 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l2 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l3 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l4 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l5 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l6 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l7 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l8 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l9 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l10 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l11 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
var l12 = {
	"ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"forage": {}
}
func add_tile_to_chunk(type, loc):
	var column
	var row
	var chunk_name = get_chunk_from_location(loc)
	match chunk_name:
		"A1":
			a1[type].append(loc)
		"A2":
			a2[type].append(loc)
		"A3":
			a3[type].append(loc)
		"A4":
			a4[type].append(loc)
		"A5":
			a5[type].append(loc)
		"A6":
			a6[type].append(loc)
		"A7":
			a7[type].append(loc)
		"A8":
			a8[type].append(loc)
		"A9":
			a9[type].append(loc)
		"A10":
			a10[type].append(loc)
		"A11":
			a11[type].append(loc)
		"A12":
			a12[type].append(loc)
		"B1":
			b1[type].append(loc)
		"B2":
			b2[type].append(loc)
		"B3":
			b3[type].append(loc)
		"B4":
			b4[type].append(loc)
		"B5":
			b5[type].append(loc)
		"B6":
			b6[type].append(loc)
		"B7":
			b7[type].append(loc)
		"B8":
			b8[type].append(loc)
		"B9":
			b9[type].append(loc)
		"B10":
			b10[type].append(loc)
		"B11":
			b11[type].append(loc)
		"B12":
			b12[type].append(loc)
		"C1":
			c1[type].append(loc)
		"C2":
			c2[type].append(loc)
		"C3":
			c3[type].append(loc)
		"C4":
			c4[type].append(loc)
		"C5":
			c5[type].append(loc)
		"C6":
			c6[type].append(loc)
		"C7":
			c7[type].append(loc)
		"C8":
			c8[type].append(loc)
		"C9":
			c9[type].append(loc)
		"C10":
			c10[type].append(loc)
		"C11":
			c11[type].append(loc)
		"C12":
			c12[type].append(loc)
		"D1":
			d1[type].append(loc)
		"D2":
			d2[type].append(loc)
		"D3":
			d3[type].append(loc)
		"D4":
			d4[type].append(loc)
		"D5":
			d5[type].append(loc)
		"D6":
			d6[type].append(loc)
		"D7":
			d7[type].append(loc)
		"D8":
			d8[type].append(loc)
		"D9":
			d9[type].append(loc)
		"D10":
			d10[type].append(loc)
		"D11":
			d11[type].append(loc)
		"D12":
			d12[type].append(loc)
		"E1":
			e1[type].append(loc)
		"E2":
			e2[type].append(loc)
		"E3":
			e3[type].append(loc)
		"E4":
			e4[type].append(loc)
		"E5":
			e5[type].append(loc)
		"E6":
			e6[type].append(loc)
		"E7":
			e7[type].append(loc)
		"E8":
			e8[type].append(loc)
		"E9":
			e9[type].append(loc)
		"E10":
			e10[type].append(loc)
		"E11":
			e11[type].append(loc)
		"E12":
			e12[type].append(loc)
		"F1":
			f1[type].append(loc)
		"F2":
			f2[type].append(loc)
		"F3":
			f3[type].append(loc)
		"F4":
			f4[type].append(loc)
		"F5":
			f5[type].append(loc)
		"F6":
			f6[type].append(loc)
		"F7":
			f7[type].append(loc)
		"F8":
			f8[type].append(loc)
		"F9":
			f9[type].append(loc)
		"F10":
			f10[type].append(loc)
		"F11":
			f11[type].append(loc)
		"F12":
			f12[type].append(loc)
		"G1":
			g1[type].append(loc)
		"G2":
			g2[type].append(loc)
		"G3":
			g3[type].append(loc)
		"G4":
			g4[type].append(loc)
		"G5":
			g5[type].append(loc)
		"G6":
			g6[type].append(loc)
		"G7":
			g7[type].append(loc)
		"G8":
			g8[type].append(loc)
		"G9":
			g9[type].append(loc)
		"G10":
			g10[type].append(loc)
		"G11":
			g11[type].append(loc)
		"G12":
			g12[type].append(loc)
		"H1":
			h1[type].append(loc)
		"H2":
			h2[type].append(loc)
		"H3":
			h3[type].append(loc)
		"H4":
			h4[type].append(loc)
		"H5":
			h5[type].append(loc)
		"H6":
			h6[type].append(loc)
		"H7":
			h7[type].append(loc)
		"H8":
			h8[type].append(loc)
		"H9":
			h9[type].append(loc)
		"H10":
			h10[type].append(loc)
		"H11":
			h11[type].append(loc)
		"H12":
			h12[type].append(loc)
		"I1":
			i1[type].append(loc)
		"I2":
			i2[type].append(loc)
		"I3":
			i3[type].append(loc)
		"I4":
			i4[type].append(loc)
		"I5":
			i5[type].append(loc)
		"I6":
			i6[type].append(loc)
		"I7":
			i7[type].append(loc)
		"I8":
			i8[type].append(loc)
		"I9":
			i9[type].append(loc)
		"I10":
			i10[type].append(loc)
		"I11":
			i11[type].append(loc)
		"I12":
			i12[type].append(loc)
		"J1":
			j1[type].append(loc)
		"J2":
			j2[type].append(loc)
		"J3":
			j3[type].append(loc)
		"J4":
			j4[type].append(loc)
		"J5":
			j5[type].append(loc)
		"J6":
			j6[type].append(loc)
		"J7":
			j7[type].append(loc)
		"J8":
			j8[type].append(loc)
		"J9":
			j9[type].append(loc)
		"J10":
			j10[type].append(loc)
		"J11":
			j11[type].append(loc)
		"J12":
			j12[type].append(loc)
		"K1":
			k1[type].append(loc)
		"K2":
			k2[type].append(loc)
		"K3":
			k3[type].append(loc)
		"K4":
			k4[type].append(loc)
		"K5":
			k5[type].append(loc)
		"K6":
			k6[type].append(loc)
		"K7":
			k7[type].append(loc)
		"K8":
			k8[type].append(loc)
		"K9":
			k9[type].append(loc)
		"K10":
			k10[type].append(loc)
		"K11":
			k11[type].append(loc)
		"K12":
			k12[type].append(loc)
		"L1":
			l1[type].append(loc)
		"L2":
			l2[type].append(loc)
		"L3":
			l3[type].append(loc)
		"L4":
			l4[type].append(loc)
		"L5":
			l5[type].append(loc)
		"L6":
			l6[type].append(loc)
		"L7":
			l7[type].append(loc)
		"L8":
			l8[type].append(loc)
		"L9":
			l9[type].append(loc)
		"L10":
			l10[type].append(loc)
		"L11":
			l11[type].append(loc)
		"L12":
			l12[type].append(loc)



func get_chunk_from_location(loc):
	var column
	var row
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

func add_nature_object_to_chunk(type, loc, id):
	var column
	var row
	var data = world[type][id]
	var chunk_name = get_chunk_from_location(loc)
	match chunk_name:
		"A1":
			a1[type][id] = data
		"A2":
			a2[type][id] = data
		"A3":
			a3[type][id] = data
		"A4":
			a4[type][id] = data
		"A5":
			a5[type][id] = data
		"A6":
			a6[type][id] = data
		"A7":
			a7[type][id] = data
		"A8":
			a8[type][id] = data
		"A9":
			a9[type][id] = data
		"A10":
			a10[type][id] = data
		"A11":
			a11[type][id] = data
		"A12":
			a12[type][id] = data
		"B1":
			b1[type][id] = data
		"B2":
			b2[type][id] = data
		"B3":
			b3[type][id] = data
		"B4":
			b4[type][id] = data
		"B5":
			b5[type][id] = data
		"B6":
			b6[type][id] = data
		"B7":
			b7[type][id] = data
		"B8":
			b8[type][id] = data
		"B9":
			b9[type][id] = data
		"B10":
			b10[type][id] = data
		"B11":
			b11[type][id] = data
		"B12":
			b12[type][id] = data
		"C1":
			c1[type][id] = data
		"C2":
			c2[type][id] = data
		"C3":
			c3[type][id] = data
		"C4":
			c4[type][id] = data
		"C5":
			c5[type][id] = data
		"C6":
			c6[type][id] = data
		"C7":
			c7[type][id] = data
		"C8":
			c8[type][id] = data
		"C9":
			c9[type][id] = data
		"C10":
			c10[type][id] = data
		"C11":
			c11[type][id] = data
		"C12":
			c12[type][id] = data
		"D1":
			d1[type][id] = data
		"D2":
			d2[type][id] = data
		"D3":
			d3[type][id] = data
		"D4":
			d4[type][id] = data
		"D5":
			d5[type][id] = data
		"D6":
			d6[type][id] = data
		"D7":
			d7[type][id] = data
		"D8":
			d8[type][id] = data
		"D9":
			d9[type][id] = data
		"D10":
			d10[type][id] = data
		"D11":
			d11[type][id] = data
		"D12":
			d12[type][id] = data
		"E1":
			e1[type][id] = data
		"E2":
			e2[type][id] = data
		"E3":
			e3[type][id] = data
		"E4":
			e4[type][id] = data
		"E5":
			e5[type][id] = data
		"E6":
			e6[type][id] = data
		"E7":
			e7[type][id] = data
		"E8":
			e8[type][id] = data
		"E9":
			e9[type][id] = data
		"E10":
			e10[type][id] = data
		"E11":
			e11[type][id] = data
		"E12":
			e12[type][id] = data
		"F1":
			f1[type][id] = data
		"F2":
			f2[type][id] = data
		"F3":
			f3[type][id] = data
		"F4":
			f4[type][id] = data
		"F5":
			f5[type][id] = data
		"F6":
			f6[type][id] = data
		"F7":
			f7[type][id] = data
		"F8":
			f8[type][id] = data
		"F9":
			f9[type][id] = data
		"F10":
			f10[type][id] = data
		"F11":
			f11[type][id] = data
		"F12":
			f12[type][id] = data
		"G1":
			g1[type][id] = data
		"G2":
			g2[type][id] = data
		"G3":
			g3[type][id] = data
		"G4":
			g4[type][id] = data
		"G5":
			g5[type][id] = data
		"G6":
			g6[type][id] = data
		"G7":
			g7[type][id] = data
		"G8":
			g8[type][id] = data
		"G9":
			g9[type][id] = data
		"G10":
			g10[type][id] = data
		"G11":
			g11[type][id] = data
		"G12":
			g12[type][id] = data
		"H1":
			h1[type][id] = data
		"H2":
			h2[type][id] = data
		"H3":
			h3[type][id] = data
		"H4":
			h4[type][id] = data
		"H5":
			h5[type][id] = data
		"H6":
			h6[type][id] = data
		"H7":
			h7[type][id] = data
		"H8":
			h8[type][id] = data
		"H9":
			h9[type][id] = data
		"H10":
			h10[type][id] = data
		"H11":
			h11[type][id] = data
		"H12":
			h12[type][id] = data
		"I1":
			i1[type][id] = data
		"I2":
			i2[type][id] = data
		"I3":
			i3[type][id] = data
		"I4":
			i4[type][id] = data
		"I5":
			i5[type][id] = data
		"I6":
			i6[type][id] = data
		"I7":
			i7[type][id] = data
		"I8":
			i8[type][id] = data
		"I9":
			i9[type][id] = data
		"I10":
			i10[type][id] = data
		"I11":
			i11[type][id] = data
		"I12":
			i12[type][id] = data
		"J1":
			j1[type][id] = data
		"J2":
			j2[type][id] = data
		"J3":
			j3[type][id] = data
		"J4":
			j4[type][id] = data
		"J5":
			j5[type][id] = data
		"J6":
			j6[type][id] = data
		"J7":
			j7[type][id] = data
		"J8":
			j8[type][id] = data
		"J9":
			j9[type][id] = data
		"J10":
			j10[type][id] = data
		"J11":
			j11[type][id] = data
		"J12":
			j12[type][id] = data
		"K1":
			k1[type][id] = data
		"K2":
			k2[type][id] = data
		"K3":
			k3[type][id] = data
		"K4":
			k4[type][id] = data
		"K5":
			k5[type][id] = data
		"K6":
			k6[type][id] = data
		"K7":
			k7[type][id] = data
		"K8":
			k8[type][id] = data
		"K9":
			k9[type][id] = data
		"K10":
			k10[type][id] = data
		"K11":
			k11[type][id] = data
		"K12":
			k12[type][id] = data
		"L1":
			l1[type][id] = data
		"L2":
			l2[type][id] = data
		"L3":
			l3[type][id] = data
		"L4":
			l4[type][id] = data
		"L5":
			l5[type][id] = data
		"L6":
			l6[type][id] = data
		"L7":
			l7[type][id] = data
		"L8":
			l8[type][id] = data
		"L9":
			l9[type][id] = data
		"L10":
			l10[type][id] = data
		"L11":
			l11[type][id] = data
		"L12":
			l12[type][id] = data
