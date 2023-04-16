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
#var starting_caves_data = {
#"Cave 1-1":{"is_built":false,"forage":{},"ore":{},"ore_large":{},"placable":{},"tall_grass":{}},

var caves = {} #= starting_caves_data

func _ready() -> void:
	PlayerData.connect("season_changed",Callable(self,"reset_cave_data"))
	PlayerData.connect("set_day",Callable(self,"advance_crop"))


func advance_crop():
	pass
#	for id in world["tree"]:
#		if Util.isNonFruitTree(world["tree"][id]["v"]): # if non-fruit tree
#			if not str(world["tree"][id]["p"]) == "5":
#				world["tree"][id]["p"] = Util.return_advanced_tree_phase(world["tree"][id]["p"])
#		else:
#			if not world["tree"][id]["p"] == "harvest" and not world["tree"][id]["b"] == "snow":
#				world["tree"][id]["p"] = Util.return_advanced_fruit_tree_phase(world["tree"][id]["p"])
#	for id in world["crop"]: 
#		var loc = world["crop"][id]["l"]
#		if not world["crop"][id]["dww"] == 2: # if crop isn't already dead
#			if world["tile"][loc] == "w": # if crop is watered, advance a day
#				world["crop"][id]["dh"] -= 1 
#				world["crop"][id]["dww"] = 0
#			else: 
#				world["crop"][id]["dww"] += 1 # crop not watered
#	for tile in world["tile"]: # if tile is watered, set to not watered
#		if world["tile"][tile] == "w":
#			world["tile"][tile] = "h"
#	if Server.world.name == "Overworld": # clear watered tiles if in world
#		Tiles.watered_tiles.clear()
#	emit_signal("refresh_crops")

#func set_hoed_tile(loc):
#	world["tile"][loc] = "h"
#
#func set_watered_tile(loc):
#	world["tile"][loc] = "w"
#
#func remove_hoed_tile(loc):
#	world["tile"].erase(loc)


func add_object(type,id,data):
#	if Server.world.name == "Overworld":
	world[type][id] = data
#	else:
#		Server.caves[Server.world.name][type][id] = data

func remove_object(type,id):
	#if Server.world.name == "Overworld":
	world[type].erase(id)
#	else:
#		caves[Server.world.name][type].erase(id)
	
func update_object_health(type, id, new_health):
	if Server.world.name == "Overworld":
		if Server.world[type].has(id):
			Server.world[type][id]["h"] = new_health
#	else:
#		if caves[Server.world.name].has(id):
#			caves[Server.world.name][id]["h"] = new_health

#func return_cave_data(cave_name):
#	match cave_name:
#		"Overworld":
#			return Server.world
#	return caves[cave_name]

func add_nature_objects_to_chunks():
	for type in nature_types:
		for id in Server.world.world[type]:
			var loc = Util.string_to_vector2(Server.world.world[type][id]["l"])
			add_object_to_chunk(type, loc, id)

func add_tiles_to_chunks():
	for type in tile_types:
		var tiles = Server.world.world[type]
		for tile in tiles:
			add_tile_to_chunk(type, tile)
		
			
func add_animals_to_chunks():
	pass
#	for id in Server.world["animal"]:
#		var loc = Util.string_to_vector2(world["animal"][id]["l"])
#		add_object_to_chunk("animal", loc, id)

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
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var a12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var b12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var c12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var d12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var e12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var f12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var g12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var h12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var i12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var j12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var k12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l1 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l2 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l3 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l4 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l5 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l6 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l7 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l8 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l9 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l10 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l11 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
var l12 = {
	"ocean": [],
	"deep_ocean1": [],
	"deep_ocean2": [],
	"plains": [],"deep_ocean3": [],
	"deep_ocean4": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"forage": {},
	"animal": {}
}
func add_tile_to_chunk(type, tile):
	var loc
	if type == "plains" or type == "forest" or type == "snow" or type == "dirt":
		loc = tile[0]
	else:
		loc = tile
	var column
	var row
	var chunk_name = get_chunk_from_location(loc)
	match chunk_name:
		"A1":
			a1[type].append(tile)
		"A2":
			a2[type].append(tile)
		"A3":
			a3[type].append(tile)
		"A4":
			a4[type].append(tile)
		"A5":
			a5[type].append(tile)
		"A6":
			a6[type].append(tile)
		"A7":
			a7[type].append(tile)
		"A8":
			a8[type].append(tile)
		"A9":
			a9[type].append(tile)
		"A10":
			a10[type].append(tile)
		"A11":
			a11[type].append(tile)
		"A12":
			a12[type].append(tile)
		"B1":
			b1[type].append(tile)
		"B2":
			b2[type].append(tile)
		"B3":
			b3[type].append(tile)
		"B4":
			b4[type].append(tile)
		"B5":
			b5[type].append(tile)
		"B6":
			b6[type].append(tile)
		"B7":
			b7[type].append(tile)
		"B8":
			b8[type].append(tile)
		"B9":
			b9[type].append(tile)
		"B10":
			b10[type].append(tile)
		"B11":
			b11[type].append(tile)
		"B12":
			b12[type].append(tile)
		"C1":
			c1[type].append(tile)
		"C2":
			c2[type].append(tile)
		"C3":
			c3[type].append(tile)
		"C4":
			c4[type].append(tile)
		"C5":
			c5[type].append(tile)
		"C6":
			c6[type].append(tile)
		"C7":
			c7[type].append(tile)
		"C8":
			c8[type].append(tile)
		"C9":
			c9[type].append(tile)
		"C10":
			c10[type].append(tile)
		"C11":
			c11[type].append(tile)
		"C12":
			c12[type].append(tile)
		"D1":
			d1[type].append(tile)
		"D2":
			d2[type].append(tile)
		"D3":
			d3[type].append(tile)
		"D4":
			d4[type].append(tile)
		"D5":
			d5[type].append(tile)
		"D6":
			d6[type].append(tile)
		"D7":
			d7[type].append(tile)
		"D8":
			d8[type].append(tile)
		"D9":
			d9[type].append(tile)
		"D10":
			d10[type].append(tile)
		"D11":
			d11[type].append(tile)
		"D12":
			d12[type].append(tile)
		"E1":
			e1[type].append(tile)
		"E2":
			e2[type].append(tile)
		"E3":
			e3[type].append(tile)
		"E4":
			e4[type].append(tile)
		"E5":
			e5[type].append(tile)
		"E6":
			e6[type].append(tile)
		"E7":
			e7[type].append(tile)
		"E8":
			e8[type].append(tile)
		"E9":
			e9[type].append(tile)
		"E10":
			e10[type].append(tile)
		"E11":
			e11[type].append(tile)
		"E12":
			e12[type].append(tile)
		"F1":
			f1[type].append(tile)
		"F2":
			f2[type].append(tile)
		"F3":
			f3[type].append(tile)
		"F4":
			f4[type].append(tile)
		"F5":
			f5[type].append(tile)
		"F6":
			f6[type].append(tile)
		"F7":
			f7[type].append(tile)
		"F8":
			f8[type].append(tile)
		"F9":
			f9[type].append(tile)
		"F10":
			f10[type].append(tile)
		"F11":
			f11[type].append(tile)
		"F12":
			f12[type].append(tile)
		"G1":
			g1[type].append(tile)
		"G2":
			g2[type].append(tile)
		"G3":
			g3[type].append(tile)
		"G4":
			g4[type].append(tile)
		"G5":
			g5[type].append(tile)
		"G6":
			g6[type].append(tile)
		"G7":
			g7[type].append(tile)
		"G8":
			g8[type].append(tile)
		"G9":
			g9[type].append(tile)
		"G10":
			g10[type].append(tile)
		"G11":
			g11[type].append(tile)
		"G12":
			g12[type].append(tile)
		"H1":
			h1[type].append(tile)
		"H2":
			h2[type].append(tile)
		"H3":
			h3[type].append(tile)
		"H4":
			h4[type].append(tile)
		"H5":
			h5[type].append(tile)
		"H6":
			h6[type].append(tile)
		"H7":
			h7[type].append(tile)
		"H8":
			h8[type].append(tile)
		"H9":
			h9[type].append(tile)
		"H10":
			h10[type].append(tile)
		"H11":
			h11[type].append(tile)
		"H12":
			h12[type].append(tile)
		"I1":
			i1[type].append(tile)
		"I2":
			i2[type].append(tile)
		"I3":
			i3[type].append(tile)
		"I4":
			i4[type].append(tile)
		"I5":
			i5[type].append(tile)
		"I6":
			i6[type].append(tile)
		"I7":
			i7[type].append(tile)
		"I8":
			i8[type].append(tile)
		"I9":
			i9[type].append(tile)
		"I10":
			i10[type].append(tile)
		"I11":
			i11[type].append(tile)
		"I12":
			i12[type].append(tile)
		"J1":
			j1[type].append(tile)
		"J2":
			j2[type].append(tile)
		"J3":
			j3[type].append(tile)
		"J4":
			j4[type].append(tile)
		"J5":
			j5[type].append(tile)
		"J6":
			j6[type].append(tile)
		"J7":
			j7[type].append(tile)
		"J8":
			j8[type].append(tile)
		"J9":
			j9[type].append(tile)
		"J10":
			j10[type].append(tile)
		"J11":
			j11[type].append(tile)
		"J12":
			j12[type].append(tile)
		"K1":
			k1[type].append(tile)
		"K2":
			k2[type].append(tile)
		"K3":
			k3[type].append(tile)
		"K4":
			k4[type].append(tile)
		"K5":
			k5[type].append(tile)
		"K6":
			k6[type].append(tile)
		"K7":
			k7[type].append(tile)
		"K8":
			k8[type].append(tile)
		"K9":
			k9[type].append(tile)
		"K10":
			k10[type].append(tile)
		"K11":
			k11[type].append(tile)
		"K12":
			k12[type].append(tile)
		"L1":
			l1[type].append(tile)
		"L2":
			l2[type].append(tile)
		"L3":
			l3[type].append(tile)
		"L4":
			l4[type].append(tile)
		"L5":
			l5[type].append(tile)
		"L6":
			l6[type].append(tile)
		"L7":
			l7[type].append(tile)
		"L8":
			l8[type].append(tile)
		"L9":
			l9[type].append(tile)
		"L10":
			l10[type].append(tile)
		"L11":
			l11[type].append(tile)
		"L12":
			l12[type].append(tile)


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

func add_object_to_chunk(type, loc, id):
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
