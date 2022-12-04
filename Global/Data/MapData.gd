extends Node


var tile_types = ["plains", "forest", "dirt", "desert", "snow", "beach", "ocean"]
var nature_types = ["tree", "stump", "log", "ore_large", "ore", "tall_grass", "flower"]

var is_world_built: bool = true
var is_cave_1_built: bool = false
var is_cave_2_built: bool = false
var is_cave_3_built: bool = false
var is_cave_4_built: bool = false
var is_cave_5_built: bool = false
var is_cave_6_built: bool = false
var is_cave_7_built: bool = false
var is_cave_8_built: bool = false
var is_cave_9_built: bool = false
var is_cave_10_built: bool = false
var is_cave_11_built: bool = false
var is_cave_12_built: bool = false
var is_cave_13_built: bool = false
var is_cave_14_built: bool = false
var is_cave_15_built: bool = false
var is_cave_16_built: bool = false
var is_cave_17_built: bool = false
var is_cave_18_built: bool = false
var is_cave_19_built: bool = false
var is_cave_20_built: bool = false

func return_if_cave_built(cave_name):
	match cave_name:
		"Cave 1":
			return is_cave_1_built
		"Cave 2":
			return is_cave_2_built
		"Cave 3":
			return is_cave_3_built
		"Cave 4":
			return is_cave_4_built
		"Cave 5":
			return is_cave_5_built
		"Cave 6":
			return is_cave_6_built
		"Cave 7":
			return is_cave_7_built
		"Cave 8":
			return is_cave_8_built
		"Cave 9":
			return is_cave_9_built
		"Cave 10":
			return is_cave_10_built
		"Cave 11":
			return is_cave_11_built
		"Cave 12":
			return is_cave_12_built
		"Cave 13":
			return is_cave_13_built
		"Cave 14":
			return is_cave_14_built
		"Cave 15":
			return is_cave_15_built
		"Cave 16":
			return is_cave_16_built
		"Cave 17":
			return is_cave_17_built
		"Cave 18":
			return is_cave_18_built
		"Cave 19":
			return is_cave_19_built
		"Cave 20":
			return is_cave_20_built

func set_cave_built(cave_name):
	match cave_name:
		"Cave 1":
			is_cave_1_built = true
		"Cave 2":
			is_cave_2_built = true
		"Cave 3":
			is_cave_3_built = true
		"Cave 4":
			is_cave_4_built = true
		"Cave 5":
			is_cave_5_built = true
		"Cave 6":
			is_cave_6_built = true
		"Cave 7":
			is_cave_7_built = true
		"Cave 8":
			is_cave_8_built = true
		"Cave 9":
			is_cave_9_built = true
		"Cave 10":
			is_cave_10_built = true
		"Cave 11":
			is_cave_11_built = true
		"Cave 12":
			is_cave_12_built = true
		"Cave 13":
			is_cave_13_built = true
		"Cave 14":
			is_cave_14_built = true
		"Cave 15":
			is_cave_15_built = true
		"Cave 16":
			is_cave_16_built = true
		"Cave 17":
			is_cave_17_built = true
		"Cave 18":
			is_cave_18_built = true
		"Cave 19":
			is_cave_19_built = true
		"Cave 20":
			is_cave_20_built = true

var world = {
	"placables":{},
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
	"tile": {},
	"cave_entrance_location": null
}
var cave_1_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_2_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_3_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_4_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_5_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_6_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_7_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_8_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_9_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_10_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_11_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_12_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_13_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_14_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_15_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_16_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_17_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_18_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_19_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_20_data = {
	"placables":{},
	"ore": {},
	"ore_large": {},
	"tall_grass": {},
	"mushroom": {}
}

func _ready() -> void:
	world = JsonData.world_data
#	add_tiles_to_chunks()
#	add_nature_objects_to_chunks()

func add_placable(id, data):
	var map = return_cave_data(Server.world.name)
	map["placables"][id] = data
	
func remove_placable(id):
	var map = return_cave_data(Server.world.name)
	map["placables"].erase(id)
	print(map["placables"])

func remove_object(type, id):
	var map = return_cave_data(Server.world.name)
	map[type].erase(id)
	
func update_object_health(type, id, new_health):
	var map = return_cave_data(Server.world.name)
	if map[type].has(id):
		map[type][id]["h"] = new_health

func return_cave_data(cave_name):
	match cave_name:
		"World":
			return world
		"Cave 1":
			return cave_1_data
		"Cave 2":
			return cave_2_data
		"Cave 3":
			return cave_3_data
		"Cave 4":
			return cave_4_data
		"Cave 5":
			return cave_5_data
		"Cave 6":
			return cave_6_data
		"Cave 7":
			return cave_7_data
		"Cave 8":
			return cave_8_data
		"Cave 9":
			return cave_9_data
		"Cave 10":
			return cave_10_data
		"Cave 11":
			return cave_11_data
		"Cave 12":
			return cave_12_data
		"Cave 13":
			return cave_13_data
		"Cave 14":
			return cave_14_data
		"Cave 15":
			return cave_15_data
		"Cave 16":
			return cave_16_data
		"Cave 17":
			return cave_17_data
		"Cave 18":
			return cave_18_data
		"Cave 19":
			return cave_19_data
		"Cave 20":
			return cave_20_data

func add_nature_objects_to_chunks():
	for type in nature_types:
		for id in world[type]:
			var loc = Util.string_to_vector2(world[type][id]["l"])
			add_to_chunk(type, loc, id)

func add_tiles_to_chunks():
	for type in tile_types:
		for id in world[type]:
			var loc = Util.string_to_vector2(world[type][id])
			add_to_chunk(type, loc, id)

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
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var a12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var b12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var c12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var d12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var e12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var f12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var g12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var h12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var i12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var j12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var k12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l1 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l2 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l3 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l4 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l5 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l6 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l7 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l8 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l9 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l10 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l11 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}
var l12 = {
	"dirt":{},
	"ocean":{},
	"beach":{},
	"plains":{},
	"forest":{},
	"desert":{},
	"snow":{},
	"tree":{},
	"tall_grass":{},
	"ore_large":{},
	"ore":{},
	"log":{},
	"stump":{},
	"flower":{},
}

func add_to_chunk(type, loc, id):
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

