extends Node

var game_state: GameState

var deep_ocean1: Array = []
var deep_ocean2: Array = []
var deep_ocean3: Array = []
var deep_ocean4: Array = []
var plains: Array = []
var forest: Array = []
var beach: Array = []
var snow: Array = []
var dirt: Array = []
var ocean: Array = []
var desert: Array = []
var wet_sand: Array = []
var tile_array_names: Array = ["plains","forest","snow","dirt"]#"deep_ocean1","deep_ocean2","deep_ocean3","deep_ocean4","ocean"]
var tile_arrays_to_fix: Array = [plains, forest, snow, dirt] #deep_ocean1, deep_ocean2, deep_ocean3, deep_ocean4]
#var tile_arrays: Array = [plains, forest, snow, dirt, deep_ocean]

var decoration_locations = []
var occupied_terrain_tiles = []

const width := 1000
const height := 1000
const MAX_GRASS_BUNCH_SIZE = 150
var oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]
var treeTypes = ['oak','spruce','birch','evergreen','pine','apple','plum','cherry','pear']
var weedTypes = ["A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","D1","D2","D3","D4"]
var flowerTypes = ["poppy flower","sunflower","tulip","lily of the nile","dandelion"]
var clamTypes = ["blue clam","pink clam","red clam"]
var starfishTypes = ["starfish", "baby starfish"]
var randomAdjacentTiles = [Vector2i(0, 1), Vector2i(1, 1), Vector2i(-1, 1), Vector2i(0, -1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(1, 0), Vector2i(-1, 0)]

var fastNoiseLite := FastNoiseLite.new()
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

#func _ready() -> void:
#	build()

func build():
	rng.randomize()
	randomize()
	#await get_tree().create_timer(1.0).timeout
	build_temperature(5,0.06)
	#await get_tree().create_timer(1.0).timeoutg
	build_moisture(5,0.006)
	#await get_tree().create_timer(2.0).timeout
	build_altittude(5,0.003)

func end_altittude():
	altittude = thread_altittude.wait_to_finish()
	print("finish building altittude")
	mutex.lock()
	if thread_counter == 3:
		#call_deferred("build_world")
		thread_world.start(Callable(self,"build_world"))
	else:	
		thread_counter += 1
	mutex.unlock()


func end_temperature():
	temperature = thread_temperature.wait_to_finish()
	print("finish building temperature")
	mutex.lock()
	if thread_counter == 3:
		#call_deferred("build_world")
		thread_world.start(Callable(self,"build_world"))
	else:	
		thread_counter += 1
	mutex.unlock()

func end_moisture():
	moisture = thread_moisture.wait_to_finish()
	print("finish building moisture")
	mutex.lock()
	if thread_counter == 3:
		#call_deferred("build_world")
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
	get_node("/root/Overworld/Loading").call_deferred("set_phase","Building terrain")
	build_terrian()
	#await get_tree().create_timer(1.0).timeout
	#set_cave_entrance()
	get_node("/root/Overworld/Loading").call_deferred("set_phase","Building nature")
	#await get_tree().create_timer(1.0).timeout
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
	await get_tree().create_timer(1.0).timeout
	#await get_tree().create_timer(1.0).timeout
	get_node("/root/Overworld/Loading").call_deferred("set_phase","Saving data")
	#await get_tree().create_timer(1.0).timeout
	## make faster
	fix_tiles()
	##################

func build_map():
	Server.world.create_or_load_world()
	

func set_cave_entrance():
	var loc = Vector2i(rng.randi_range(490, 510), rng.randi_range(490, 510))
	MapData.world["cave_entrance_location"] = loc
	decoration_locations.append(loc)
	decoration_locations.append(loc+Vector2i(1,0))

func build_terrian():
	print("BUILDING")
	for x in width:
		for y in height:
			var pos = Vector2i(x,y)
			var alt = altittude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			var id = uuid.v4()
			#Ocean
			if alt > 0.975:
				if x <= 500 and y <= 500:
					deep_ocean1.append(Vector2i(x,y))
				elif x >= 500 and y <= 500:
					deep_ocean2.append(Vector2i(x,y))
				elif x <= 500:
					deep_ocean3.append(Vector2i(x,y))
				else:
					deep_ocean4.append(Vector2i(x,y))
			if alt > 0.8:
				ocean.append(Vector2i(x,y))
			#Beach	
			elif between(alt,0.75,0.8):
				#MapData.world["beach"][id] = Vector2i(x,y)
				beach.append(Vector2i(x,y))
			#Biomes	
			elif between(alt,-1.4,0.8):
				#plains
				if between(moist,0,0.4) and between(temp,0.2,0.6):
					#MapData.world["plains"][id] = Vector2i(x,y)
					plains.append(Vector2i(x,y))
				#forest
				elif between(moist,0.5,0.85) and temp > 0.6:
					#MapData.world["forest"][id] = Vector2i(x,y)
					forest.append(Vector2i(x,y))
				#desert	
				elif temp > 0.6 and moist < 0.5:
					desert.append(Vector2i(x,y))
				#snow	
				elif temp < 0.2:
					#MapData.world["snow"][id] = Vector2i(x,y)
					snow.append(Vector2i(x,y))
				else:
					#dirt
					#MapData.world["dirt"][id] = Vector2i(x,y)
					dirt.append(Vector2i(x,y))
			else:
				#MapData.world["dirt"][id] = Vector2i(x,y)
				dirt.append(Vector2i(x,y))
	#save_world_data()

	
func add_ocean_tiles():
	var border_tiles = []
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
	for loc in beach:
		if ocean.has(loc):
			ocean.erase(loc)
	for loc in ocean:
		wet_sand.append(loc)
	assign_autotiles()


func assign_autotiles():
	print("ASSIGN AUTOTILES")
	for tile_array_name in tile_array_names: 
		var tileThread = Thread.new()
		threads.append(tileThread)
		tileThread.start(Callable(self,"assign_autotile_id").bind(tile_array_name))


func assign_autotile_id(tile_array_name):
	print("assigning autotiles")
	var locations = return_tile_array(tile_array_name)
#	var locations = tiles
	for loc in locations:
		MapData.world[tile_array_name].append([loc,Tiles.return_autotile_id(loc,locations)])
		await get_tree().process_frame
#		tiles[tiles.find(loc)] = [loc,return_tile_id(loc,locations)]
	if thread_tile_counter == tile_array_names.size():
		print("assigned all")
		#call_deferred("build_world")
		thread_tile_counter = 1
		update_fixed_map()
	else:	
		thread_tile_counter += 1
		print("assigned: "+str(thread_tile_counter) + tile_array_name)


func return_tile_array(tile_array_name):
	match tile_array_name:
		"plains":
			return plains
		"forest":
			return forest 
		"snow":
			return snow
		"desert":
			return desert 
		"beach":
			return beach 
		"dirt":
			return dirt 
		"ocean":
			return ocean 
		"wet_sand":
			return wet_sand  
		"deep_ocean1":
			return deep_ocean1
		"deep_ocean2":
			return deep_ocean2
		"deep_ocean3":
			return deep_ocean3
		"deep_ocean4":
			return deep_ocean4
		

func update_fixed_map():
#	print("FOUND BORDER TILES")
	MapData.world["deep_ocean1"] = deep_ocean1
	MapData.world["deep_ocean2"] = deep_ocean2
	MapData.world["deep_ocean3"] = deep_ocean3
	MapData.world["deep_ocean4"] = deep_ocean4
	MapData.world["wet_sand"] = wet_sand
#	MapData.world["plains"] = plains
#	MapData.world["forest"] = forest
#	MapData.world["desert"] = desert
#	MapData.world["snow"] = snow
	MapData.world["ocean"] = ocean
#	MapData.world["dirt"] = dirt
	MapData.world["beach"] = beach
	print("BUILT TERRAIN FINAL")
	save_starting_world_data()
	MapData.add_world_data_to_chunks()
	get_node("/root/Overworld/Loading").call_deferred("queue_free")
	call_deferred("build_map")

func fix_tiles():
	print("FIXING")
	for tile_array in tile_arrays_to_fix: 
		var tileThread = Thread.new()
		threads.append(tileThread)
		tileThread.start(Callable(self,"_fix_tiles").bind(tile_array))
		
func _fix_tiles(value):
	print("start fixing")
	var border_tiles = []
#	for i in range(2):
#	border_tiles = []
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
		#call_deferred("build_world")
		thread_tile_counter = 1
		thread_world_update.start(Callable(self,"add_ocean_tiles"))
	else:	
		thread_tile_counter += 1
		print("fixing: "+str(thread_tile_counter))



func save_starting_world_data():
	MapData.world["is_built"] = true
	game_state = GameState.new()
	game_state.world_state = MapData.world
	game_state.cave_state = MapData.caves
	game_state.player_state = PlayerData.starting_player_data
	game_state.save_state()

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
			MapData.world["animal"][id] = {"l":location,"n":"bunny","v":rng.randi_range(1,3),"h":Stats.BUNNY_HEALTH}
			decoration_locations.append(location)
	for _i in range(NUM_BUNNY):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			MapData.world["animal"][id] = {"l":location,"n":"duck","v":rng.randi_range(1,3),"h":Stats.DUCK_HEALTH}
			decoration_locations.append(location)
	var NUM_BEAR = (locations.size() / 4000)
	print("NUM BEARS " + str(NUM_BEAR))
	for _i in range(NUM_BEAR):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			MapData.world["animal"][id] = {"l":location,"n":"bear","h":Stats.BEAR_HEALTH}
			decoration_locations.append(location)
	var NUM_BOAR = (locations.size() / 4000)
	print("NUM BEARS " + str(NUM_BOAR))
	for _i in range(NUM_BOAR):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			MapData.world["animal"][id] = {"l":location,"n":"boar","h":Stats.BOAR_HEALTH}
			decoration_locations.append(location)
	var NUM_DEER = (locations.size() / 3000)
	print("NUM DEER " + str(NUM_DEER))
	for _i in range(NUM_DEER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			MapData.world["animal"][id] = {"l":location,"n":"deer","h":Stats.DEER_HEALTH}
			decoration_locations.append(location)
	var NUM_WOLF = (locations.size() / 4000)
	print("NUM WOLF " + str(NUM_WOLF))
	for _i in range(NUM_WOLF):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			MapData.world["animal"][id] = {"l":location,"n":"wolf","h":Stats.WOLF_HEALTH}
			decoration_locations.append(location)
	

func generate_beach_forage(locations):
	print("Building beach forage")
	var NUM_FORAGE = int(locations.size()/150)
	for _i in range(NUM_FORAGE):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		if isValidPosition(location):
			var id = uuid.v4()
			if Util.chance(50):
				clamTypes.shuffle()
				MapData.world["forage"][id] = {"l":location,"n":clamTypes.front(),"f":true}
			else:
				starfishTypes.shuffle()
				MapData.world["forage"][id] = {"l":location,"n":starfishTypes.front(),"f":true}

func generate_weeds(locations,biome):
	print("Building "+biome+" weeds")
	var NUM_FLOWER = int(locations.size()/200)
	for _i in range(NUM_FLOWER):
		var index = rng.randi_range(0, locations.size() - 1)
		var location = locations[index]
		create_weed(location,biome)
		
func create_weed(loc,biome):
	var id = uuid.v4()
	if isValidPosition(loc):
		weedTypes.shuffle()
		MapData.world["tall_grass"][id] = {"l":loc,"n":"weed","v":weedTypes.front()}
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
	if isValidPosition(loc):
		flowerTypes.shuffle()
		MapData.world["forage"][id] = {"l":loc,"n":flowerTypes.front(),"f":true}
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
		decoration_locations.append(loc + Vector2i(1,0))
		decoration_locations.append(loc + Vector2i(0,-1))
		decoration_locations.append(loc + Vector2i(1,-1))

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
			MapData.world["tall_grass"][id] = {"l":loc,"b":biome,"n":"grass"}
			decoration_locations.append(loc)
		else:
			loc -= randomAdjacentTiles[0]

func generate_map(data):
	print("GENERATE MAP " + str(data))
	var grid = {}
	fastNoiseLite.noise_type = FastNoiseLite.TYPE_SIMPLEX
	fastNoiseLite.fractal_type = FastNoiseLite.FRACTAL_FBM
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
		if Util.isNonFruitTree(variety):
			MapData.world["tree"][id] = {"l":loc,"h":Stats.TREE_HEALTH,"b":biome,"v":variety,"p":"5"}
		else:
			MapData.world["tree"][id] = {"l":loc,"h":Stats.TREE_HEALTH,"b":biome,"v":variety,"p":"empty"}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2i(1,0))
		decoration_locations.append(loc + Vector2i(0,-1))
		decoration_locations.append(loc + Vector2i(1,-1))

func create_stump(loc,biome):
	var id = uuid.v4()
	if check_64x64(loc) and isValidPosition(loc):
		treeTypes.shuffle()
		MapData.world["stump"][id] = {"l":loc,"h":Stats.STUMP_HEALTH,"b":biome,"v":treeTypes.front()}
		decoration_locations.append(loc)
		decoration_locations.append(loc + Vector2i(1,0))
		decoration_locations.append(loc + Vector2i(0,-1))
		decoration_locations.append(loc + Vector2i(1,-1))

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

#func _exit_tree():
#	for thread in threads:
#		thread.wait_to_finish()
