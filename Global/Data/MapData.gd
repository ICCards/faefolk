extends Node

var openSimplexNoise := OpenSimplexNoise.new()

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

var world = {
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
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_2_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_3_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_4_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_5_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_6_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_7_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_8_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_9_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}
var cave_10_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}

export var width := 1000
export var height := 1000
export var MAX_GRASS_BUNCH_SIZE = 500


var rng = RandomNumberGenerator.new()
#onready var tile_maps = [_Tree,Stump,Log,Ore_Large,Ore,Flower]
var _uuid = preload("res://helpers/UUID.gd")
onready var uuid = _uuid.new()

var altittude = {}
var temperature = {}
var moisture = {}

var decoration_locations = []

const STUMP_HEALTH = 40
const TREE_HEALTH = 100
const SMALL_ORE_HEALTH = 40
const LARGE_ORE_HEALTH = 100
signal build_finished

func _ready() -> void:
	rng.randomize()
	randomize()
	temperature = generate_map(5,300)
	moisture = generate_map(5,300)
	altittude = generate_map(5,150)
	world = JsonData.world_data
	add_tiles_to_chunks()
	add_nature_objects_to_chunks()
	#build_terrian()
	#fix_tiles()
#	print("BUILT TERRAIN")
#	generate_trees(snow,"snow")
#	yield(get_tree(), "idle_frame")
#	generate_trees(forest,"forest")
#	yield(get_tree(), "idle_frame")
#	generate_trees(desert,"desert")
#	yield(get_tree(), "idle_frame")
#	generate_grass_bunches(plains,"plains")
#	yield(get_tree(), "idle_frame")
#	generate_grass_bunches(snow,"snow")
#	yield(get_tree(), "idle_frame")
#	generate_ores(snow,"snow")
#	yield(get_tree(), "idle_frame")
#	generate_ores(desert,"desert")
#	yield(get_tree(), "idle_frame")
#	generate_ores(dirt,"dirt")
#	yield(get_tree(), "idle_frame")
#	generate_flowers(forest,"forest")
#	yield(get_tree(), "idle_frame")
#	generate_flowers(plains,"plains")
#	print("NUM ORES " + str(num_ore))
#	print("NUM TREES " + str(num_trees))
#	world["cave_entrance_location"] = Vector2(rng.randi_range(490, 510), rng.randi_range(490, 510))
#	save_keys()
#	is_world_built = true
#	print("done")
var tile_types = ["plains", "forest", "dirt", "desert", "snow", "beach"]
var nature_types = ["tree", "stump", "log", "ore_large", "ore", "tall_grass", "flower"]


func add_nature_objects_to_chunks():
	for type in nature_types:
		for id in world[type]:
			var loc = Util.string_to_vector2(world[type][id]["l"])
			add_to_chunk(type, loc, world[type][id])

func add_tiles_to_chunks():
	for type in tile_types:
		for id in world[type]:
			var loc = Util.string_to_vector2(world[type][id])
			add_to_chunk(type, loc, loc)

#	for id in world["plains"]:
#		var loc = Util.string_to_vector2(world["plains"][id])
#		add_to_chunk("plains", loc, loc)
#	for id in world["forest"]:
#		var loc = Util.string_to_vector2(world["forest"][id])
#		add_to_chunk("forest", loc, loc)
#	for id in world["dirt"]:
#		var loc = Util.string_to_vector2(world["dirt"][id])
#		add_to_chunk("dirt", loc, loc)
#	for id in world["desert"]:
#		var loc = Util.string_to_vector2(world["desert"][id])
#		add_to_chunk("desert", loc, loc)
#	for id in world["snow"]:
#		var loc = Util.string_to_vector2(world["snow"][id])
#		add_to_chunk("snow", loc, loc)
#	for id in world["beach"]:
#		var loc = Util.string_to_vector2(world["beach"][id])
#		add_to_chunk("beach", loc, loc)


var file_name = "res://JSONData/world.json"

func save_keys():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(world))
	file.close()
	print("saved")
	pass
	

var plains = []
var forest = []
var desert = []
var beach = []
var snow = []
var dirt = []

var tile_arrays = [plains, forest, desert, beach, snow, dirt]

func generate_flowers(locations,biome):
	print("Building "+biome+" Flowers")
	var NUM_FLOWER = int(locations.size()/100)
	for _i in range(NUM_FLOWER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_flower(location,biome)
	

func create_flower(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		world["flower"][id] = {"l":loc,"h":5, "b":biome}
		#Flower.set_cellv(loc,0)
		decoration_locations.append(loc)

func generate_ores(locations,biome):
	var NUM_ORE_LARGE = int(locations.size()/100)
	var NUM_ORE = int(locations.size()/120)
	for _i in range(NUM_ORE_LARGE):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_ore_large(location,biome)
			
	for _i in range(NUM_ORE):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_ore(location,biome)

var num_ore = 0
func create_ore_large(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		world["ore_large"][id] = {"l":loc,"h":LARGE_ORE_HEALTH,"b":biome}
		#Ore_Large.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		num_ore += 1

func create_ore(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		world["ore"][id] = {"l":loc,"h":SMALL_ORE_HEALTH,"b":biome}
		#Ore.set_cellv(loc,0)
		decoration_locations.append(loc)
#		decoration_locations.append(loc + Vector2(1,0))
#		decoration_locations.append(loc + Vector2(0,-1))
#		decoration_locations.append(loc + Vector2(1,-1))

func generate_grass_bunches(locations,biome):
	var NUM_GRASS_BUNCHES = int(locations.size()/100)
	for _i in range(NUM_GRASS_BUNCHES):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_grass_bunch(location,biome)

func create_grass_bunch(loc,biome):
	rng.randomize()
	var randomNum = rng.randi_range(1, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		loc += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		if isValidPosition(loc):
			var id = uuid.v4()
			world["tall_grass"][id] = {"l":loc,"h":5,"b":biome}
			#Grass.set_cellv(loc,0)
			decoration_locations.append(loc)

func fix_tiles():
#	for id in world["plains"]:
#		plains.append(Util.string_to_vector2(world["plains"][id]))
#	for id in world["forest"]:
#		forest.append(Util.string_to_vector2(world["forest"][id]))
#	for id in world["snow"]:
#		snow.append(Util.string_to_vector2(world["snow"][id]))
#	for id in world["beach"]:
#		beach.append(Util.string_to_vector2(world["beach"][id]))
#	for id in world["dirt"]:
#		dirt.append(Util.string_to_vector2(world["dirt"][id]))
#	for id in world["desert"]:
#		desert.append(Util.string_to_vector2(world["desert"][id]))
	for tile_array in tile_arrays: 
		var border_tiles = []
		for loc in tile_array:
			if is_border_tile(loc, tile_array):
				border_tiles.append(loc)
		for loc in border_tiles:
			if not tile_array.has(loc+Vector2(1,0)):
				tile_array.append(loc+Vector2(1,0))
			if not tile_array.has(loc+Vector2(-1,0)):
				tile_array.append(loc+Vector2(-1,0))
			if not tile_array.has(loc+Vector2(0,1)):
				tile_array.append(loc+Vector2(0,1))
			if not tile_array.has(loc+Vector2(0,-1)):
				tile_array.append(loc+Vector2(0,-1))
			if not tile_array.has(loc+Vector2(1,1)):
				tile_array.append(loc+Vector2(1,1))
			if not tile_array.has(loc+Vector2(-1,1)):
				tile_array.append(loc+Vector2(-1,1))
			if not tile_array.has(loc+Vector2(1,-1)):
				tile_array.append(loc+Vector2(1,-1))
			if not tile_array.has(loc+Vector2(-1,-1)):
				tile_array.append(loc+Vector2(-1,-1))
		yield(get_tree(), "idle_frame")
	for loc in plains: 
		var id = uuid.v4()
		world["plains"][id] = loc
		add_to_chunk("plains", loc, loc)
	yield(get_tree(), "idle_frame")
	for loc in forest: 
		var id = uuid.v4()
		world["forest"][id] = loc
		add_to_chunk("forest", loc, loc)
	yield(get_tree(), "idle_frame")
	for loc in snow: 
		var id = uuid.v4()
		world["snow"][id] = loc
		add_to_chunk("snow", loc, loc)
	yield(get_tree(), "idle_frame")
	for loc in desert: 
		var id = uuid.v4()
		world["desert"][id] = loc
		add_to_chunk("desert", loc, loc)
	yield(get_tree(), "idle_frame")
	for loc in beach: 
		var id = uuid.v4()
		world["beach"][id] = loc
		add_to_chunk("beach", loc, loc)
	yield(get_tree(), "idle_frame")
	for loc in dirt: 
		var id = uuid.v4()
		world["dirt"][id] = loc
		add_to_chunk("dirt", loc, loc)

func is_border_tile(_pos, _tiles):
	if not _tiles.has(_pos+Vector2(1,0)):
		return true
	if not _tiles.has(_pos+Vector2(-1,0)):
		return true
	if not  _tiles.has(_pos+Vector2(0,1)):
		return true
	if not _tiles.has(_pos+Vector2(0,-1)):
		return true
	return false

func isInvalidAutoTile(_pos, _map):
	var count = 0
	if _map.has(_pos + Vector2(0,1)):
		count += 1
	if _map.has(_pos + Vector2(0,-1)):
		count += 1
	if _map.has(_pos + Vector2(1,0)):
		count += 1
	if _map.has(_pos + Vector2(-1,0)):
		count += 1
	if count <= 1:
		return true
	else:
		if _map.has(_pos + Vector2(-1,-1)):
			count += 1
		if _map.has(_pos + Vector2(-1,1)):
			count += 1
		if _map.has(_pos + Vector2(1,-1)):
			count += 1
		if _map.has(_pos + Vector2(1,1)):
			count += 1
		if count == 6:
			if _map.has(_pos + Vector2(-1,-1)) and _map.has(_pos + Vector2(1,1)):
				return true
			elif _map.has(_pos + Vector2(1,-1)) and _map.has(_pos + Vector2(-1,1)):
				return true
	return false


func generate_map(octaves,period):
	var grid = {}
	openSimplexNoise.seed = randi()
	openSimplexNoise.octaves = octaves
	openSimplexNoise.period = period
	var custom_gradient = CustomGradientTexture.new()
	custom_gradient.gradient = Gradient.new()
	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
	custom_gradient.size = Vector2(width,height)
	var gradient_data = custom_gradient.get_data()
	gradient_data.lock()
	for x in width:
		for y in height:
			#var rand := floor((abs(openSimplexNoise.get_noise_2d(x,y)))*11)
			var gradient_value = gradient_data.get_pixel(x,y).r * 1.5
			var value = openSimplexNoise.get_noise_2d(x,y)
			value += gradient_value
			grid[Vector2(x,y)] = value
	return grid

func build_terrian():
	print("BUILDING")
	for x in width:
		for y in height:
			var pos = Vector2(x,y)
			var alt = altittude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			var id = uuid.v4()
			#Ocean
			if alt > 0.8:
				pass
			#	Ground.set_cell(x,y, 3)
				#ocean.append(Vector2(x,y))
				#world["ocean"][id] = (Vector2(x,y))
			#Beach	
			elif between(alt,0.75,0.8):
				#Ground.set_cell(x,y, 5)
				#get_parent().spawnable_locations.append(Vector2(x,y))
				beach.append(Vector2(x,y))
				#world["beach"][id] = (Vector2(x,y))
			#Biomes	
			elif between(alt,-1.4,0.8):
				#plains
				if between(moist,0,0.4) and between(temp,0.2,0.6):
					#Ground.set_cell(x,y, 1)
					plains.append(Vector2(x,y))
					#world["plains"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["plains"].values())
				#forest
				elif between(moist,0.5,0.85) and temp > 0.6:
					#Ground.set_cell(x,y, 2)
					forest.append(Vector2(x,y))
					#world["forest"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["forest"].values())
				#desert	
				elif temp > 0.6 and moist < 0.5:
					#Ground.set_cell(x,y, 5)
					desert.append(Vector2(x,y))
					#world["desert"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["desert"].values())
				#snow	
				elif temp < 0.2:
					#Ground.set_cell(x,y, 6)
					snow.append(Vector2(x,y))
					#world["snow"][id] = (Vector2(x,y))
					#generate_trees(get_parent().map["snow"].values())
				else:
					#dirt
					#Ground.set_cell(x,y, 0)
					dirt.append(Vector2(x,y))
					#world["dirt"][id] = (Vector2(x,y))
			else:
				#Ground.set_cell(x,y, 0)
				dirt.append(Vector2(x,y))
				#world["dirt"][id] = (Vector2(x,y))
				#print(get_parent().map["dirt"])
	print("FINISHED BUILD")
	fix_tiles()

func check_64x64(loc):
	if not decoration_locations.has(loc) and not decoration_locations.has(loc+Vector2(1,0)) and \
	not decoration_locations.has(loc+Vector2(1,-1)) and not decoration_locations.has(loc+Vector2(0,-1)):
		return true
	return false
 
var num_trees = 0
func generate_trees(locations,biome):
	print("Building "+biome+" Trees")
	var NUM_TREES = int(locations.size()/100)
	var NUM_STUMPS = int(locations.size()/120)
	var NUM_LOGS = int(locations.size()/140)
	print(NUM_TREES)
	print(NUM_STUMPS)
	print(NUM_LOGS)
	for _i in range(NUM_TREES):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_tree(location,biome)
	for _i in range(NUM_STUMPS):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_stump(location,biome)
	for _i in range(NUM_LOGS):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_log(location,biome)

func create_tree(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		num_trees += 1
		world["tree"][id] = {"l":loc,"h":TREE_HEALTH,"b":biome}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		
func create_stump(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		num_trees += 1
		world["stump"][id] = {"l":loc,"h":STUMP_HEALTH,"b":biome}
		#Stump.set_cellv(loc,0)
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
	
func create_log(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		num_trees += 1
		world["log"][id] = {"l":loc,"h":1,"b":biome}
		#Log.set_cellv(loc,0)
		decoration_locations.append(loc)
#		decoration_locations.append(loc + Vector2(1,0))
#		decoration_locations.append(loc + Vector2(0,-1))
#		decoration_locations.append(loc + Vector2(1,-1))

func isValidPosition(loc):
	if decoration_locations.has(loc):
		return false
	return true

func between(val, start, end):
	if start <= val and val < end:
		return true	
		
func return_chunk(_row, _col):
	_col = int(_col)
	match _row:
		"A":
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

func add_to_chunk(type, loc, data):
	var column
	var row
	var id = uuid.v4()
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
	var chunk = row+str(column)
	match chunk:
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


