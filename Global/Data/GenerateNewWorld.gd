extends Node

var world = {}
var caves = {}

var terrain = {
	"ocean": [],
	"deep_ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
}

var game_state: GameState

#var server_data = {
#	"season": "spring",
#	"day_week": "Mon.",
#	"day_number": 1,
#	"time_minutes": 0,
#	"time_hours": 6,
#	"ui_slots": {},
#}


var plains: Array = []
var deep_ocean: Array = []
var forest: Array = []
var beach: Array = []
var snow: Array = []
var dirt: Array = []
var ocean: Array = []
var desert: Array = []
var wet_sand: Array = []
var tile_array_names: Array = ["plains","forest","snow","dirt","wet_sand","deep_ocean","ocean"]
var tile_arrays_to_fix: Array = [plains, forest, snow, dirt] #deep_ocean1, deep_ocean2, deep_ocean3, deep_ocean4]
#var tile_arrays: Array = [plains, forest, snow, dirt, deep_ocean]

var decoration_locations = []
var occupied_terrain_tiles = []

const width := 1000
const height := 1000
const MAX_GRASS_BUNCH_SIZE = 50
var oreTypes = ["stone1", "stone2"]
var treeTypes = ['oak','spruce','birch','evergreen','pine','apple','plum','cherry','pear']
var weedTypes = ["A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","D1","D2","D3","D4"]
var flowerTypes = ["poppy flower","sunflower","tulip","lily of the nile","dandelion"]
var clamTypes = ["blue clam","pink clam","red clam"]
var starfishTypes = ["starfish", "baby starfish"]
var randomAdjacentTiles = [Vector2i(0, 1), Vector2i(1, 1), Vector2i(-1, 1), Vector2i(0, -1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(1, 0), Vector2i(-1, 0)]

var rng = RandomNumberGenerator.new()
var _uuid = load("res://helpers/UUID.gd")
var uuid

var mutex = Mutex.new()
var semaphore = Semaphore.new()
var thread_counter = 1
var thread_tile_counter = 1

var thread_world = Thread.new()
var thread_world_update = Thread.new()
var thread_temperature = Thread.new()
var thread_moisture = Thread.new()
var thread_altittude = Thread.new()

var threads = [thread_world,thread_temperature,thread_moisture,thread_altittude,thread_world_update]

var altittude = {}
var temperature = {}
var moisture = {}

var file_name = "res://JSONData/world.json"



func build():
	for column in range(12):
		for row in ["A","B","C","D","E","F","G","H","I","J","K","L"]:
			world[row+str(column+1)] = {
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
				"placeable": {}}
	rng.randomize()
	randomize()
	build_temperature(5,0.003)
	build_moisture(5,0.003)
	build_altittude(5,0.0025)

func end_altittude():
	altittude = thread_altittude.wait_to_finish()
	print("finish building altittude")
	mutex.lock()
	if thread_counter == 3:
		thread_world.start(Callable(self,"build_world"))
	else:	
		thread_counter += 1
	mutex.unlock()


func end_temperature():
	temperature = thread_temperature.wait_to_finish()
	print("finish building temperature")
	mutex.lock()
	if thread_counter == 3:
		thread_world.start(Callable(self,"build_world"))
	else:	
		thread_counter += 1
	mutex.unlock()

func end_moisture():
	moisture = thread_moisture.wait_to_finish()
	print("finish building moisture")
	mutex.lock()
	if thread_counter == 3:
		thread_world.start(Callable(self,"build_world"))
	else:	
		thread_counter += 1
	mutex.unlock()
	
func build_altittude(octaves,frequency):
	print("building altittude")
	var data = {
		"octaves":octaves,
		"frequency":frequency,
		"ending_function":"end_altittude"
	};
	thread_altittude.start(Callable(self,"generate_map").bind(data))	
	
func build_temperature(octaves,frequency):
	print("building temperature")
	var data = {
		"octaves":octaves,
		"frequency":frequency,
		"ending_function":"end_temperature"
	};
	thread_temperature.start(Callable(self,"generate_map").bind(data))
	
func build_moisture(octaves,frequency):
	print("building moisture")
	var data = {
		"octaves":octaves,
		"frequency":frequency,
		"ending_function":"end_moisture"
	};
	thread_moisture.start(Callable(self,"generate_map").bind(data))

func build_world():
	print("building world")
	uuid = _uuid.new()
	build_terrian()
	generate_trees(snow,"snow")
	generate_trees(forest,"forest")
	generate_trees(desert,"desert")
	generate_grass_bunches(plains,"plains")
	generate_grass_bunches(snow,"snow")
	generate_ores(snow,"snow")
	generate_ores(desert,"desert")
	generate_ores(dirt,"dirt")
	generate_flowers(forest,"forest")
	generate_flowers(plains,"plains")
	generate_weeds(forest,"forest")
	generate_weeds(plains,"plains")
	generate_beach_forage(beach)
	generate_animals()
	fix_tiles()
	##################


func build_terrian():
	print("BUILDING")
	for x in width:
		for y in height:
			var pos = Vector2i(x,y)
			var alt = altittude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			if alt > 0.975:
				deep_ocean.append(Vector2i(x,y))
			elif alt > 0.8:
				ocean.append(Vector2i(x,y))
			#Beach	
			elif between(alt,0.75,0.8):
				beach.append(Vector2i(x,y))
			#Biomes	
			elif between(alt,-1.4,0.8):
				#plains
				if between(moist,0,0.4) and between(temp,0.2,0.6):
					plains.append(Vector2i(x,y))
				#forest
				elif between(moist,0.5,0.85) and temp > 0.6:
					forest.append(Vector2i(x,y))
				#desert	
				elif temp > 0.6 and moist < 0.5:
					desert.append(Vector2i(x,y))
				#snow	
				elif temp < 0.2:
					snow.append(Vector2i(x,y))
				else:
					#dirt
					dirt.append(Vector2i(x,y))
			else:
				dirt.append(Vector2i(x,y))
	print("BUILT")

func add_ocean_tiles():
	var border_tiles = []
	for i in range(2):
		border_tiles = []
		print("EXTENDING BEACH")
		for loc in beach:
			if Util.is_border_tile(loc, beach) and not forest.has(loc) and not plains.has(loc) and not dirt.has(loc):
				border_tiles.append(loc)
		for loc in border_tiles: # extend beach
			if not beach.has(loc+Vector2i(1,0)):
				beach.append(loc+Vector2i(1,0))
			if not beach.has(loc+Vector2i(-1,0)):
				beach.append(loc+Vector2i(-1,0))
			if not beach.has(loc+Vector2i(0,1)):
				beach.append(loc+Vector2i(0,1))
			if not beach.has(loc+Vector2i(0,-1)):
				beach.append(loc+Vector2i(0,-1))
			if not beach.has(loc+Vector2i(1,1)):
				beach.append(loc+Vector2i(1,1))
			if not beach.has(loc+Vector2i(-1,1)):
				beach.append(loc+Vector2i(-1,1))
			if not beach.has(loc+Vector2i(1,-1)):
				beach.append(loc+Vector2i(1,-1))
			if not beach.has(loc+Vector2i(-1,-1)):
				beach.append(loc+Vector2i(-1,-1))
	print("ADD WET SAND LAYER")
	border_tiles = []
	for loc in beach:
		if Util.is_border_tile(loc, beach) and not forest.has(loc) and not plains.has(loc) and not dirt.has(loc):
			border_tiles.append(loc)
	for loc in border_tiles: # set wet sand layer
		if not beach.has(loc+Vector2i(1,0)):
			wet_sand.append(loc+Vector2i(1,0))
		if not beach.has(loc+Vector2i(-1,0)):
			wet_sand.append(loc+Vector2i(-1,0))
		if not beach.has(loc+Vector2i(0,1)):
			wet_sand.append(loc+Vector2i(0,1))
		if not beach.has(loc+Vector2i(0,-1)):
			wet_sand.append(loc+Vector2i(0,-1))
		if not beach.has(loc+Vector2i(1,1)):
			wet_sand.append(loc+Vector2i(1,1))
		if not beach.has(loc+Vector2i(-1,1)):
			wet_sand.append(loc+Vector2i(-1,1))
		if not beach.has(loc+Vector2i(1,-1)):
			wet_sand.append(loc+Vector2i(1,-1))
		if not beach.has(loc+Vector2i(-1,-1)):
			wet_sand.append(loc+Vector2i(-1,-1))
	print("REMOVE OCEAN TILES")
	for loc in wet_sand: # remove ocean tiles
		if ocean.has(loc):
			ocean.erase(loc)
	print("HERE")
	for loc in beach:
		if ocean.has(loc):
			ocean.erase(loc)
	print("HERE1")
	for loc in ocean:
		wet_sand.append(loc)
	print("HERE2")
	save_tiles()



func save_tiles():
	print("SAVING TILES")
	terrain["beach"] = beach
	terrain["ocean"] = ocean
	terrain["deep_ocean"] = deep_ocean
	terrain["forest"] = forest
	terrain["plains"] = plains
	terrain["desert"] = desert
	terrain["snow"] = snow
	terrain["wet_sand"] = wet_sand
	terrain["dirt"] = dirt
	print("NEW TERRAIN")
	save_starting_world_data()


func fix_tiles():
	print("FIXING")
	for tile_array in tile_arrays_to_fix: 
		var tileThread = Thread.new()
		threads.append(tileThread)
		tileThread.start(Callable(self,"_fix_tiles").bind(tile_array))
		
func _fix_tiles(value):
	print("start fixing")
	var border_tiles = []
	border_tiles = []
	for loc in value:
		if Util.is_border_tile(loc, value):
			border_tiles.append(loc)
	for loc in border_tiles:
		if not value.has(loc+Vector2i(1,0)):
			value.append(loc+Vector2i(1,0))
		if not value.has(loc+Vector2i(-1,0)):
			value.append(loc+Vector2i(-1,0))
		if not value.has(loc+Vector2i(0,1)):
			value.append(loc+Vector2i(0,1))
		if not value.has(loc+Vector2i(0,-1)):
			value.append(loc+Vector2i(0,-1))
		if not value.has(loc+Vector2i(1,1)):
			value.append(loc+Vector2i(1,1))
		if not value.has(loc+Vector2i(-1,1)):
			value.append(loc+Vector2i(-1,1))
		if not value.has(loc+Vector2i(1,-1)):
			value.append(loc+Vector2i(1,-1))
		if not value.has(loc+Vector2i(-1,-1)):
			value.append(loc+Vector2i(-1,-1))
	if thread_tile_counter == tile_arrays_to_fix.size():
		print("fixed")
		thread_tile_counter = 1
		thread_world_update.start(Callable(self,"add_ocean_tiles"))
	else:
		thread_tile_counter += 1
		print("fixing: "+str(thread_tile_counter))

func save_starting_world_data():
	print("SAVING")
	game_state = GameState.new()
	game_state.terrain = terrain
	game_state.world = world
	game_state.caves = caves
	game_state.player_state = PlayerData.player_data
	game_state.save_state()
	MapData.world = world
	MapData.terrain = terrain
	MapData.caves = caves
	print("here")
	Server.world.build_world()
	print("SAVED")

func generate_animals():
	print("Building animals")
	var locations = plains + forest + snow + dirt + desert
	var NUM_BUNNY = int(locations.size() / 1200)
	print("NUM BUNNIES " + str(NUM_BUNNY))
	for _i in range(NUM_BUNNY):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			world[Util.return_chunk_from_location(location)]["animal"][id] = {"l":location,"n":"bunny","v":rng.randi_range(1,3),"h":Stats.BUNNY_HEALTH}
			decoration_locations.append(location)
	for _i in range(NUM_BUNNY):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			world[Util.return_chunk_from_location(location)]["animal"][id] = {"l":location,"n":"duck","v":rng.randi_range(1,3),"h":Stats.DUCK_HEALTH}
			decoration_locations.append(location)
	var NUM_BEAR = (locations.size() / 4000)
	print("NUM BEARS " + str(NUM_BEAR))
	for _i in range(NUM_BEAR):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			world[Util.return_chunk_from_location(location)]["animal"][id] = {"l":location,"n":"bear","h":Stats.BEAR_HEALTH}
			decoration_locations.append(location)
	var NUM_BOAR = (locations.size() / 4000)
	print("NUM BEARS " + str(NUM_BOAR))
	for _i in range(NUM_BOAR):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			world[Util.return_chunk_from_location(location)]["animal"][id] = {"l":location,"n":"boar","h":Stats.BOAR_HEALTH}
			decoration_locations.append(location)
	var NUM_DEER = (locations.size() / 3000)
	print("NUM DEER " + str(NUM_DEER))
	for _i in range(NUM_DEER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			world[Util.return_chunk_from_location(location)]["animal"][id] = {"l":location,"n":"deer","h":Stats.DEER_HEALTH}
			decoration_locations.append(location)
	var NUM_WOLF = (locations.size() / 4000)
	print("NUM WOLF " + str(NUM_WOLF))
	for _i in range(NUM_WOLF):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			world[Util.return_chunk_from_location(location)]["animal"][id] = {"l":location,"n":"wolf","h":Stats.WOLF_HEALTH}
			decoration_locations.append(location)
#

func generate_beach_forage(locations):
	print("Building beach forage")
	var NUM_FORAGE = int(locations.size()/150)
	for _i in range(NUM_FORAGE):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			var chunk = Util.return_chunk_from_location(location)
			if Util.chance(50):
				clamTypes.shuffle()
				world[chunk]["forage"][id] = {"l":location,"n":clamTypes.front(),"f":true}
			else:
				starfishTypes.shuffle()
				world[chunk]["forage"][id] = {"l":location,"n":starfishTypes.front(),"f":true}

func generate_weeds(locations,biome):
	print("Building "+biome+" weeds")
	var NUM_FLOWER = int(locations.size()/200)
	for _i in range(NUM_FLOWER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_weed(location,biome)
		
func create_weed(loc,biome):
	var id = uuid.v4()
	var chunk = Util.return_chunk_from_location(loc)
	if isValidPosition(loc):
		weedTypes.shuffle()
		world[chunk]["tall_grass"][id] = {"l":loc,"n":"weed","v":weedTypes.front()}
		decoration_locations.append(loc)

func generate_flowers(locations,biome):
	print("Building "+biome+" Flowers")
	var NUM_FLOWER = int(locations.size()/200)
	for _i in range(NUM_FLOWER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_flower(location,biome)

func create_flower(loc,biome):
	var id = uuid.v4()
	var chunk = Util.return_chunk_from_location(loc)
	if isValidPosition(loc):
		flowerTypes.shuffle()
		world[chunk]["forage"][id] = {"l":loc,"n":flowerTypes.front(),"f":true}
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
		world[Util.return_chunk_from_location(loc+Vector2i(1,0))]["ore_large"][id] = {"l":loc+Vector2i(1,0),"h":Stats.LARGE_ORE_HEALTH,"b":biome,"v":oreTypes.front()}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2i(1,0))
		decoration_locations.append(loc + Vector2i(0,-1))
		decoration_locations.append(loc + Vector2i(1,-1))

func create_ore(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		oreTypes.shuffle()
		world[Util.return_chunk_from_location(loc)]["ore"][id] = {"l":loc,"h":Stats.SMALL_ORE_HEALTH,"b":biome,"v":oreTypes.front()}
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
			world[Util.return_chunk_from_location(loc)]["tall_grass"][id] = {"l":loc,"b":biome,"n":"grass", "fh":rng.randi_range(1,3), "bh":rng.randi_range(1,3)}
			decoration_locations.append(loc)
		else:
			loc -= randomAdjacentTiles[0]

func generate_map(data):
	var grid = {}
	var fastNoiseLite := FastNoiseLite.new()
	fastNoiseLite.seed = randi()
	fastNoiseLite.fractal_octaves = data.octaves
	fastNoiseLite.frequency = data.frequency
	var custom_gradient = CustomGradientTexture.new()
	custom_gradient.gradient = Gradient.new()
	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
	custom_gradient.size = Vector2i(width,height)
	var gradient_data = custom_gradient.get_image()
	for x in width:
		for y in height:
			var gradient_value = gradient_data.get_pixel(x,y).r * 1.5
			var value = fastNoiseLite.get_noise_2d(x,y)
			value += gradient_value
			grid[Vector2i(x,y)] = value
	call_deferred(data.ending_function)
	return grid

func check_64x64(loc):
	if not decoration_locations.has(loc) and not decoration_locations.has(loc+Vector2i(1,0)) and \
	not decoration_locations.has(loc+Vector2i(1,-1)) and not decoration_locations.has(loc+Vector2i(0,-1)):
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
	if not biome == "desert":
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
		var variety = treeTypes.front()
		var chunk = Util.return_chunk_from_location(loc+Vector2i(1,0))
		if Util.isNonFruitTree(variety):
			world[chunk]["tree"][id] = {"l":loc+Vector2i(1,0),"h":Stats.TREE_HEALTH,"b":biome,"v":variety,"p":"5"}
		else:
			world[chunk]["tree"][id] = {"l":loc+Vector2i(1,0),"h":Stats.TREE_HEALTH,"b":biome,"v":variety,"p":"empty"}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2i(1,0))
		decoration_locations.append(loc + Vector2i(0,-1))
		decoration_locations.append(loc + Vector2i(1,-1))

func create_stump(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		treeTypes.shuffle()
		world[Util.return_chunk_from_location(loc+Vector2i(1,0))]["stump"][id] = {"l":loc+Vector2i(1,0),"h":Stats.STUMP_HEALTH,"b":biome,"v":treeTypes.front()}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2i(1,0))
		decoration_locations.append(loc + Vector2i(0,-1))
		decoration_locations.append(loc + Vector2i(1,-1))

func create_log(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		if biome == "desert":
			world[Util.return_chunk_from_location(loc)]["log"][id] = {"l":loc,"h":1,"b":biome,"v":rng.randi_range(1,5)}
		else:
			world[Util.return_chunk_from_location(loc)]["log"][id] = {"l":loc,"h":1,"b":biome,"v":rng.randi_range(1,12)}
		decoration_locations.append(loc)

func isValidPosition(loc):
	if decoration_locations.has(loc):
		return false
	return true

func between(val, start, end):
	if start <= val and val < end:
		return true

