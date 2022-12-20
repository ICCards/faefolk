extends Node

var plains = []
var forest = []
var beach = []
var snow = []
var dirt = []
var tile_arrays = [plains, forest, snow, dirt, beach]

var decoration_locations = []
var occupied_terrain_tiles = []

const width := 1000
const height := 1000
const MAX_GRASS_BUNCH_SIZE = 150
const oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]
const treeTypes = ['A','B', 'C', 'D', 'E']
const randomAdjacentTiles = [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1), Vector2(0, -1), Vector2(-1, -1), Vector2(1, -1), Vector2(1, 0), Vector2(-1, 0)]

var openSimplexNoise := OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()
var _uuid = load("res://helpers/UUID.gd")
onready var uuid = _uuid.new()

var altittude = {}
var temperature = {}
var moisture = {}

var file_name = "res://JSONData/world.json"

#func _ready() -> void:
#	build()

func build():
	rng.randomize()
	randomize()
	temperature = generate_map(5,300)
	moisture = generate_map(5,300)
	altittude = generate_map(5,150)
	build_terrian()
	set_cave_entrance()
	generate_trees(MapData.world["snow"].values(),"snow")
	generate_trees(MapData.world["forest"].values(),"forest")
	generate_trees(MapData.world["desert"].values(),"desert")
	generate_grass_bunches(MapData.world["plains"].values(),"plains")
	generate_grass_bunches(MapData.world["snow"].values(),"snow")
	generate_ores(MapData.world["snow"].values(),"snow")
	generate_ores(MapData.world["desert"].values(),"desert")
	generate_ores(MapData.world["dirt"].values(),"dirt")
	generate_flowers(MapData.world["forest"].values(),"forest")
	generate_flowers(MapData.world["plains"].values(),"plains")
	save_world_data()
	
	
func set_cave_entrance():
	var loc = Vector2(rng.randi_range(490, 510), rng.randi_range(490, 510))
	MapData.world["cave_entrance_location"] = loc
	decoration_locations.append(loc)
	decoration_locations.append(loc+Vector2(1,0))

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
				MapData.world["ocean"][id] = Vector2(x,y)
			#Beach	
			elif between(alt,0.75,0.8):
				#MapData.world["beach"][id] = Vector2(x,y)
				beach.append(Vector2(x,y))
			#Biomes	
			elif between(alt,-1.4,0.8):
				#plains
				if between(moist,0,0.4) and between(temp,0.2,0.6):
					#MapData.world["plains"][id] = Vector2(x,y)
					plains.append(Vector2(x,y))
				#forest
				elif between(moist,0.5,0.85) and temp > 0.6:
					#MapData.world["forest"][id] = Vector2(x,y)
					forest.append(Vector2(x,y))
				#desert	
				elif temp > 0.6 and moist < 0.5:
					MapData.world["desert"][id] = Vector2(x,y)
					#desert.append(Vector2(x,y))
				#snow	
				elif temp < 0.2:
					#MapData.world["snow"][id] = Vector2(x,y)
					snow.append(Vector2(x,y))
				else:
					#dirt
					#MapData.world["dirt"][id] = Vector2(x,y)
					dirt.append(Vector2(x,y))
			else:
				#MapData.world["dirt"][id] = Vector2(x,y)
				dirt.append(Vector2(x,y))
	#save_world_data()
	fix_tiles()


func fix_tiles():
	print("FIXING")
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
	print("FOUND BORDER TILES")
	for loc in plains: 
		var id = uuid.v4()
		MapData.world["plains"][id] = loc
	for loc in forest: 
		var id = uuid.v4()
		MapData.world["forest"][id] = loc
	for loc in snow: 
		var id = uuid.v4()
		MapData.world["snow"][id] = loc
#	for loc in desert: 
#		var id = uuid.v4()
#		MapData.world["desert"][id] = loc
	for loc in beach: 
		var id = uuid.v4()
		MapData.world["beach"][id] = loc
	for loc in dirt: 
		var id = uuid.v4()
		MapData.world["dirt"][id] = loc
#	for loc in ocean: 
#		var id = uuid.v4()
#		MapData.world["ocean"][id] = loc
#	emit_signal("build_finished")
	print("BUILT TERRAIN FINAL")
	#save_world_data()

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


func save_world_data():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(MapData.world))
	file.close()
	print("saved")
	pass


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
		MapData.world["flower"][id] = {"l":loc,"h":5, "b":biome}
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

func create_ore_large(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		oreTypes.shuffle()
		MapData.world["ore_large"][id] = {"l":loc,"h":Stats.LARGE_ORE_HEALTH,"b":biome,"v":oreTypes.front()}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))

func create_ore(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		oreTypes.shuffle()
		MapData.world["ore"][id] = {"l":loc,"h":Stats.SMALL_ORE_HEALTH,"b":biome,"v":oreTypes.front()}
		decoration_locations.append(loc)

func generate_grass_bunches(locations,biome):
	var NUM_GRASS_BUNCHES = int(locations.size()/150)
	for _i in range(NUM_GRASS_BUNCHES):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_grass_bunch(location,biome)
	print("FISNIHED GRASS BUNCH " + biome)

func create_grass_bunch(loc,biome):
	rng.randomize()
	var randomNum = rng.randi_range(10, MAX_GRASS_BUNCH_SIZE)
	for _i in range(randomNum):
		randomAdjacentTiles.shuffle()
		loc += randomAdjacentTiles[0]
		if isValidPosition(loc) and not beach.has(loc):
			var id = uuid.v4()
			MapData.world["tall_grass"][id] = {"l":loc,"h":5,"b":biome}
			decoration_locations.append(loc)
		else:
			loc -= randomAdjacentTiles[0]


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
			var gradient_value = gradient_data.get_pixel(x,y).r * 1.5
			var value = openSimplexNoise.get_noise_2d(x,y)
			value += gradient_value
			grid[Vector2(x,y)] = value
	return grid

func check_64x64(loc):
	if not decoration_locations.has(loc) and not decoration_locations.has(loc+Vector2(1,0)) and \
	not decoration_locations.has(loc+Vector2(1,-1)) and not decoration_locations.has(loc+Vector2(0,-1)):
		return true
	return false
 

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
		treeTypes.shuffle()
		MapData.world["tree"][id] = {"l":loc,"h":Stats.TREE_HEALTH,"b":biome,"v":treeTypes.front()}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
		
func create_stump(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		treeTypes.shuffle()
		MapData.world["stump"][id] = {"l":loc,"h":Stats.STUMP_HEALTH,"b":biome,"v":treeTypes.front()}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2(1,0))
		decoration_locations.append(loc + Vector2(0,-1))
		decoration_locations.append(loc + Vector2(1,-1))
	
func create_log(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		MapData.world["log"][id] = {"l":loc,"h":1,"b":biome,"v":rng.randi_range(1,12)}
		decoration_locations.append(loc)

func isValidPosition(loc):
	if decoration_locations.has(loc):
		return false
	return true

func between(val, start, end):
	if start <= val and val < end:
		return true	
		
