extends Node

@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")

@onready var Slime = load("res://World/Enemies/Slime/Slime.tscn")
@onready var Spider = load("res://World/Enemies/Spider.tscn")
@onready var FireMageSkeleton = load("res://World/Enemies/Skeleton.tscn")

var game_state: GameState

var caves = [] 
var decoration_locations = []
var groundTiles1 = []
var groundTiles2 = []
var cave_dict = {}

var map_width: int = 100
var map_height: int = 100

var world_seed: String
var noise_octaves: int = 1
var noise_frequency: float = 0.03
var noise_persistence: float = 0.7
var noise_lacunarity: float = 0.1
var noise_threshold: float = 0.1
var min_cave_size: int = 400 

var simplex_noise = FastNoiseLite.new()
var path
var reset_flag = false
var valid_light_or_ladder_tiles = []

var oreTypesLevel1 = ["stone1", "stone2", "stone1", "stone2", "bronze ore", "bronze ore", "bronze ore", "iron ore"]
var oreTypesLevel2 = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "bronze ore", "bronze ore", "iron ore", "iron ore", "gold ore"]
var mushroomTypes = ["common mushroom", "healing mushroom", "purple mushroom", "chanterelle"]
var randomAdjacentTiles = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
var NUM_MUSHROOMS #= 40
var NUM_SMALL_ORE #= 70
var NUM_LARGE_ORE #= 30

var NUM_BATS = 12
var NUM_SLIMES = 16
var NUM_SPIDERS = 16
var NUM_SKELETONS = 16


@onready var walls: TileMap = get_node("../TerrainTiles/Walls")
#@onready var ground1: TileMap = get_node("../TerrainTiles/Ground1")
#@onready var ground2: TileMap = get_node("../TerrainTiles/Ground2")
#@onready var ground3: TileMap = get_node("../TerrainTiles/Ground3")
#@onready var lights: TileMap = get_node("../TerrainTiles/Decoration")
#@onready var upLadder: TileMap = get_node("../TerrainTiles/UpLadder")
#@onready var downLadder: TileMap = get_node("../TerrainTiles/DownLadder")

var _uuid = load("res://helpers/UUID.gd")
var uuid = _uuid.new()

var decorations = {}

func generate_caves():
	match get_parent().tier:
		"wind":
			map_width = 100
			map_height = 100
		"fire":
			map_width = 125
			map_height = 125
		"ice":
			map_width = 150
			map_height = 150
	randomize()
	cave_dict[get_parent().tier+str(get_parent().level)] = {"wall":[],"ground1":[],"ground2":[],"rail":[],"light":{},"ladder":{},"chest":null}
	build_walls(get_parent().level)


func build_walls(level):
	walls.clear()
	world_seed = str(randi())
	print("BUILDING WALLS")
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = self.noise_frequency
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				walls.set_cell(0,Vector2i(x+map_width / 2, y+map_height / 2),0,Vector2(0,0))
	add_boundary_tiles()
	get_caves(level)
	connect_caves()
	set_valid_tiles()
	fix_tiles_and_set_ladders_and_lights()


func save_cave_data():
	print("SAVING")
	var temp_array = []
	for loc in walls.get_used_cells(0):
		temp_array.append(str(loc))
	cave_dict[get_parent().tier+str(get_parent().level)]["wall"] = temp_array
	temp_array = []
	for loc in groundTiles1:
		temp_array.append(str(loc))
	cave_dict[get_parent().tier+str(get_parent().level)]["ground1"] = temp_array
	temp_array = []
	for loc in groundTiles2:
		temp_array.append(str(loc))
	cave_dict[get_parent().tier+str(get_parent().level)]["ground2"] = temp_array
#	cave_dict[get_parent().tier+str(1)]["wall"] = walls.get_used_cells(0)
#	cave_dict[get_parent().tier+str(1)]["ground1"] = groundTiles1
#	cave_dict[get_parent().tier+str(1)]["ground2"] = groundTiles2
	walls.clear()
	MapData.caves = cave_dict
	game_state = GameState.new()
	game_state.terrain = MapData.terrain
	game_state.world = MapData.world
	game_state.player_state = PlayerData.player_data
	game_state.caves = MapData.caves
	game_state.save_state()
	get_parent().load_cave()


func fix_tiles_and_set_ladders_and_lights():
	print("FIXING TILES")
	walls.set_cells_terrain_connect(0,walls.get_used_cells(0),0,1)
	await get_tree().create_timer(1.0).timeout
	valid_light_or_ladder_tiles = []
	for loc in walls.get_used_cells(0): # fix tiles and get light/ladder locs
		var autotile_id = Tiles.return_autotile_id(loc,walls.get_used_cells(0))
		if autotile_id == null:
			walls.set_cell(0,loc,0,Vector2i(-1,-1))
			reset_flag = true
		elif autotile_id == 7 or autotile_id == 11 or autotile_id == 12:
			valid_light_or_ladder_tiles.append(loc)
	if reset_flag:
		reset_flag = false
		fix_tiles_and_set_ladders_and_lights()
		return
	
	var room_positions = []
	for cave in caves: # get two farthest points in cave
		room_positions.append(Util.choose(cave))
	var two_fatherest_points = return_two_farthest_points(room_positions)
	
	var ladder1 = room_positions[0]
	var distance_to_valid_ladder_placement = 100000
	var valid_ladder_location
	for loc in valid_light_or_ladder_tiles: # set up ladder location
		var distToLadder = Vector2(loc.x,loc.y).distance_to(Vector2(ladder1.x,ladder1.y))
		if distToLadder < distance_to_valid_ladder_placement:
			distance_to_valid_ladder_placement = distToLadder
			valid_ladder_location = loc
	valid_light_or_ladder_tiles.erase(valid_ladder_location)
	for loc in valid_light_or_ladder_tiles:
		if Util.chance(14):
			place_cave_light(loc)
			if valid_light_or_ladder_tiles.has(loc+Vector2i(1,0)):
				valid_light_or_ladder_tiles.erase(loc+Vector2i(1,0))
			if valid_light_or_ladder_tiles.has(loc+Vector2i(-1,0)):
				valid_light_or_ladder_tiles.erase(loc+Vector2i(-1,0))
			if valid_light_or_ladder_tiles.has(loc+Vector2i(2,0)):
				valid_light_or_ladder_tiles.erase(loc+Vector2i(2,0))
			if valid_light_or_ladder_tiles.has(loc+Vector2i(-2,0)):
				valid_light_or_ladder_tiles.erase(loc+Vector2i(-2,0))
	print("FIXED TILES")
	decoration_locations.append(valid_ladder_location+Vector2i(0,1))
	cave_dict[get_parent().tier+str(get_parent().level)]["ladder"]["up"] = str(valid_ladder_location+Vector2i(0,1))
#	upLadder.set_cell(0,valid_ladder_location+Vector2i(0,1),0,Vector2i(60,9))
#	valid_tiles.set_cell(0,valid_ladder_location+Vector2i(0,1),0,Vector2i(-1,-1))
	print("UP LADDER LOC " + str(valid_ladder_location))
	place_down_ladder(room_positions[1])
	place_chest(room_positions[2])
	set_decorations()
	build_ground()
	

func place_down_ladder(loc):
	print("DOWN LADDER LOC " + str(loc))
#	if walls.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1) and walls.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1):
	decoration_locations.append(loc)
	decoration_locations.append(loc+Vector2i(1,0))
	cave_dict[get_parent().tier+str(get_parent().level)]["ladder"]["down"] = str(loc)
#	else:
#		var new_loc = loc
#		if loc.x < map_width/2:
#			new_loc.x += 1
#		else:
#			new_loc.x -= 1
#		if loc.y < map_height/2:
#			new_loc.y += 1
#		else:
#			new_loc.y -= 1
#		place_down_ladder(loc)
#		return
	
func place_chest(loc): 
	print("CHEST LOC " + str(loc))
	decoration_locations.append(loc)
	decoration_locations.append(loc+Vector2i(1,0))
	cave_dict[get_parent().tier+str(get_parent().level)]["chest"] = str(loc)
	


func build_ground():
	simplex_noise.seed = randi()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = 0.03
	for x in range(-self.map_width / 2 , self.map_width / 2 ):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				groundTiles1.append(Vector2i(x+map_width / 2, y+map_height / 2))
	simplex_noise.seed = randi()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = 0.03
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				groundTiles2.append(Vector2i(x+map_width / 2, y+map_height / 2))
	save_cave_data()


func place_cave_light(loc):
	var rand_light = randi_range(53,55)
	cave_dict[get_parent().tier+str(get_parent().level)]["light"][str(loc+Vector2i(0,-2))] = str(Vector2i(rand_light,26))
#	lights.set_cell(0,loc+Vector2i(0,-2),0,Vector2i(rand_light,26))
	#decorati on["lights"][loc] = rand_light
#	var type
#	if rand_light == 53:
#		type = "red"
#	elif rand_light == 54:
#		type = "yellow"
#	elif rand_light == 55:
#		type = "blue"
#	if type:
#		var caveLight = CaveLight.instantiate()
#		caveLight.type = type
#		caveLight.position = loc*16
#		get_parent().call_deferred("add_child",caveLight)



func set_resources():
	print("SETTING RESOURCES")
	generate_ore()
	generate_mushroom_forage()
	generate_tall_grass()
	print("SET RESOURCES")
	
func set_valid_tiles():
	for x in range(map_width):
		for y in range(map_height):
			if not walls.get_cell_atlas_coords(0,Vector2i(x,y)) == Vector2i(-1,-1):
				decoration_locations.append(Vector2i(x,y))
#				valid_tiles.set_cell(0,Vector2i(x,y),0,Constants.VALID_TILE_ATLAS_CORD)

func set_decorations():
	print("SET DECOR")
	set_random_rail_decoration()


func set_random_rail_decoration():
	var rail_location
	var locations = []
	if Util.chance(50):
		rail_location = Vector2i(randi_range(0,map_width),0)
		while rail_location.y <= map_height:
			locations.append(rail_location)
			if Util.chance(60):
				rail_location+=Vector2i(0,1)
			elif Util.chance(20):
				locations.append(rail_location+Vector2i(1,0))
				locations.append(rail_location+Vector2i(1,1))
				rail_location+=Vector2i(1,2)
			elif Util.chance(20):
				locations.append(rail_location+Vector2i(-1,0))
				locations.append(rail_location+Vector2i(-1,1))
				rail_location+=Vector2i(-1,2)
			if rail_location.x == map_width:
				rail_location.x -= 1
			if rail_location.x == 0:
				rail_location.x += 1
	else:
		rail_location = Vector2i(0,randi_range(map_height,0))
		while rail_location.x <= map_width:
			locations.append(rail_location)
			if Util.chance(60):
				rail_location+=Vector2i(1,0)
			elif Util.chance(20):
				locations.append(rail_location+Vector2i(1,1))
				locations.append(rail_location+Vector2i(0,1))
				rail_location+=Vector2i(2,1)
			elif Util.chance(20):
				locations.append(rail_location+Vector2i(1,-1))
				locations.append(rail_location+Vector2i(0,-1))
				rail_location+=Vector2i(2,-1)
			if rail_location.y == map_height:
				rail_location.y -= 1
			if rail_location.y == 0:
				rail_location.y += 1
	print("HERE")
	for loc in locations:
		if Util.chance(2) or decoration_locations.has(loc): #valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
			locations.erase(loc)
	#rail.set_cells_terrain_connect(0,locations,0,0)
	for loc in locations:
		decoration_locations.append(loc)
	var temp_array = []
	for loc in locations:
		temp_array.append(str(loc))
	cave_dict[get_parent().tier+str(get_parent().level)]["rail"] = temp_array
		#valid_tiles.set_cell(0,loc,0,Constants.NAVIGATION_TILE_ATLAS_CORD)
	print("PLACED RAILS")

func return_two_farthest_points(room_positions):
	var longest_path_points = []
	var checked_locations = []
	var longest_distance = 10
	for loc in room_positions:
		for location_to_check in room_positions:
			if loc != location_to_check:
				var distance_between_points = return_distance_between_points(loc,location_to_check)
				if distance_between_points > longest_distance:
					longest_distance = distance_between_points
					longest_path_points = [loc,location_to_check]
	return longest_path_points
	
func return_distance_between_points(start_pt,end_pt):
	var cave = []
	var to_fill = [start_pt]
	var counter = 0
	while not to_fill.has(end_pt):
		var tile = to_fill.pop_back()
		counter+=1
		if !cave.has(tile) and tile != null:
			cave.append(tile)
			
			#check adjacent cells
			var north = Vector2i(tile.x, tile.y-1)
			var south = Vector2i(tile.x, tile.y+1)
			var east  = Vector2i(tile.x+1, tile.y)
			var west  = Vector2i(tile.x-1, tile.y)

			for dir in [north,south,east,west]:
				if walls.get_cell_atlas_coords(0,dir) == Vector2i(-1,-1): #if not wall_tiles.has(dir):
					if !to_fill.has(dir) and !cave.has(dir):
						to_fill.append(dir)
	return counter



func generate() -> void:
	print("BUILDING NOISE")
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = self.noise_frequency
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				walls.set_cell(0,Vector2i(x+map_width / 2, y+map_height / 2),0,Vector2(0,0))
#	var groundTiles2 = []
#	simplex_noise.seed = randi()
#	simplex_noise.fractal_octaves = self.noise_octaves
#	simplex_noise.frequency = 0.03
#	for x in range(-self.map_width / 2 , self.map_width / 2 ):
#		for y in range(-self.map_height / 2, self.map_height / 2):
#			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
#				ground1Tiles.append(Vector2i(x+map_width / 2, y+map_height / 2))
##	var groundTiles3 = []
#	simplex_noise.seed = randi()
#	simplex_noise.fractal_octaves = self.noise_octaves
#	simplex_noise.frequency = 0.03
#	for x in range(-self.map_width / 2, self.map_width / 2):
#		for y in range(-self.map_height / 2, self.map_height / 2):
#			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
#				ground2Tiles.append(Vector2i(x+map_width / 2, y+map_height / 2))
#	for x in range(map_width+4):
#		for y in range(map_height+4):
##			if wall_type == 3:
##				ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(56,58),randi_range(40,42)))
##			else:
#			ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(26,28),randi_range(40,42)))
#	if wall_type == 3:
#		ground2.set_cells_terrain_connect(0,groundTiles2,0,1)
#		ground3.set_cells_terrain_connect(0,groundTiles3,0,4)
#	else:
#	ground2.set_cells_terrain_connect(0,groundTiles2,0,1)
#	ground3.set_cells_terrain_connect(0,groundTiles3,0,2)
	print("BUILT NOISE")

func get_caves(cave_level):
	caves = []
	for x in range (0, map_width):
		for y in range (0, map_height):
			if walls.get_cell_atlas_coords(0,Vector2i(x, y)) == Vector2i(-1,-1):
				flood_fill(x,y)
	print("NUM CAVE ROOMS " + str(caves.size()))
	if caves.size() <= 2:
		print("INVAID NOISE SO RESTART")
		build_walls(cave_level)
		return
	for cave in caves:
		for tile in cave:
			walls.set_cell(0, tile, 0, Vector2i(-1,-1))
			#walls.set_cells_terrain_connect(0,[tile],0,-1)


func flood_fill(tilex, tiley):
	var cave = []
	var to_fill = [Vector2i(tilex, tiley)]
	while to_fill:
		var tile = to_fill.pop_back()

		if !cave.has(tile):
			cave.append(tile)
			walls.set_cell(0, tile, 0, Vector2i(0,0))

			#check adjacent cells
			var north = Vector2i(tile.x, tile.y-1)
			var south = Vector2i(tile.x, tile.y+1)
			var east  = Vector2i(tile.x+1, tile.y)
			var west  = Vector2i(tile.x-1, tile.y)

			for dir in [north,south,east,west]:
				if walls.get_cell_atlas_coords(0,dir) == Vector2i(-1,-1): #if not wall_tiles.has(dir):
					if !to_fill.has(dir) and !cave.has(dir):
						to_fill.append(dir)
	if cave.size() >= min_cave_size:
		caves.append(cave)


func connect_caves():
	var prev_cave = null
	var tunnel_caves = caves.duplicate()
	
	for cave in tunnel_caves:
		var starting_pt = return_point_closest_to_center(cave)
		var end_pt = return_nearest_point_to_connect(starting_pt,cave,tunnel_caves)

		if starting_pt != end_pt:
			create_tunnel(starting_pt, end_pt, cave)

		prev_cave = cave
	print("CONNECTED CAVES")


func return_nearest_point_to_connect(start_pt,current_cave,all_caves):
	var current_dist = 10000
	var current_tile = Vector2(0,0)
	for cave in all_caves:
		if cave != current_cave:
			for tile in cave:
				tile = Vector2(tile.x,tile.y)
				var new_dist = tile.distance_to(start_pt)
				if new_dist < current_dist:
					current_dist = new_dist
					current_tile = tile
	return Vector2i(int(current_tile.x),int(current_tile.y))


func return_point_closest_to_center(cave):
	var current_dist = 10000
	var current_tile = Vector2(0,0)
	for tile in cave:
		tile = Vector2(tile.x,tile.y)
		var new_dist = tile.distance_to(Vector2(75,75))
		if new_dist < current_dist:
			current_dist = new_dist
			current_tile = tile
	return Vector2i(int(current_tile.x),int(current_tile.y))


# do a drunken walk from point1 to point2
func create_tunnel(point1, point2, cave):
	randomize()          # for randf
	var max_steps = 500  # so editor won't hang if walk fails
	var steps = 0
	var drunk_x = point2[0]
	var drunk_y = point2[1]

	while steps < max_steps and !cave.has(Vector2(drunk_x, drunk_y)):
		steps += 1

		# set initial dir weights
		var n       = 1.0
		var s       = 1.0
		var e       = 1.0
		var w       = 1.0
		var weight  = 1

		# weight the random walk against edges
		if drunk_x < point1.x: # drunkard is left of point1
			e += weight
		elif drunk_x > point1.x: # drunkard is right of point1
			w += weight
		if drunk_y < point1.y: # drunkard is above point1
			s += weight
		elif drunk_y > point1.y: # drunkard is below point1
			n += weight

		# normalize probabilities so they form a range from 0 to 1
		var total = n + s + e + w
		n /= total
		s /= total
		e /= total
		w /= total

		var dx
		var dy

		# choose the direction
		var choice = randf()

		if 0 <= choice and choice < n:
			dx = 0
			dy = -1
		elif n <= choice and choice < (n+s):
			dx = 0
			dy = 1
		elif (n+s) <= choice and choice < (n+s+e):
			dx = 1
			dy = 0
		else:
			dx = -1
			dy = 0

		# ensure not to walk past edge of map
		if (2 < drunk_x + dx and drunk_x + dx < map_width-2) and \
			(2 < drunk_y + dy and drunk_y + dy < map_height-2):
			drunk_x += dx
			drunk_y += dy
#			if walls.get_cell_atlas_coords(0,Vector2i(drunk_x, drunk_y)) == Vector2i(0,0):
			walls.set_cell(0,Vector2i(drunk_x,drunk_y),0,Vector2i(-1,-1))
			# optional: make tunnel wider
			walls.set_cell(0,Vector2i(drunk_x, drunk_y+1),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x, drunk_y-1),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x+1, drunk_y),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x+1, drunk_y+1),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x+1, drunk_y-1),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x-1, drunk_y),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x-1, drunk_y+1),0,Vector2i(-1,-1))
			walls.set_cell(0,Vector2i(drunk_x-1, drunk_y+-1),0,Vector2i(-1,-1))


func add_boundary_tiles():
	for amt in range(20):
		for x in range(map_width+40):
			walls.set_cell(0,Vector2i(x-20,-amt),0,Vector2i(0,0))
			walls.set_cell(0,Vector2i(x-20,map_height+amt-1),0,Vector2i(0,0))
		for y in range(map_height):
			walls.set_cell(0,Vector2i(-amt+1,y),0,Vector2i(0,0))
			walls.set_cell(0,Vector2i(map_width+amt-1,y),0,Vector2i(0,0))


func generate_mushroom_forage():
	NUM_MUSHROOMS = map_width / 5
	for i in range(NUM_MUSHROOMS):
		var loc = Vector2i(randi_range(1,map_width), randi_range(1,map_height))
		if not decoration_locations.has(loc):
			mushroomTypes.shuffle()
			var id = uuid.v4()
#			PlaceObject.place_forage_in_world(id,mushroomTypes.front(),location,true)
#			await get_tree().process_frame
			decoration_locations.append(loc)
			cave_dict[get_parent().tier+str(1)]["forage"][id] = {"l": loc, "v": mushroomTypes.front()}


func generate_tall_grass():
	for z in range(2):
		for i in range(4):
			var start_loc = Vector2i(randi_range(1,map_width), randi_range(1,map_height))
			if not decoration_locations.has(start_loc):
				generate_grass_bunch(start_loc, i+1)


func generate_grass_bunch(loc, variety):
	var randomNum = randi_range(40, 100)
	for _i in range(randomNum):
		randomAdjacentTiles.shuffle()
		loc += randomAdjacentTiles[0]
		if not decoration_locations.has(loc):
			var id = uuid.v4()
			decoration_locations.append(loc)
#			PlaceObject.place_tall_grass_in_world(id,"cave"+str(variety),loc,3,3)
			cave_dict[get_parent().tier+str(1)]["tall_grass"][id] = {"l": loc, "v": variety, "fh":randi_range(1,3), "bh":randi_range(1,3)}
		else:
			loc -= randomAdjacentTiles[0]


var count = 0
func generate_ore():
	NUM_SMALL_ORE = map_width / 2
	for i in range(NUM_SMALL_ORE):
		var loc = Vector2i(randi_range(1,map_width), randi_range(1,map_height))
		if not decoration_locations.has(loc):
			var id = uuid.v4()
			oreTypesLevel2.shuffle()
#			PlaceObject.place_small_ore_in_world(id,oreTypesLevel2.front(),loc,Stats.SMALL_ORE_HEALTH)
#			await get_tree().process_frame
			decoration_locations.append(loc)
			cave_dict[get_parent().tier+str(1)]["ore"][id] = {"l": loc, "v": oreTypesLevel2.front(), "h": Stats.SMALL_ORE_HEALTH}
	NUM_LARGE_ORE = map_width / 4
	while count < NUM_LARGE_ORE:
		var loc = Vector2i(randi_range(1,map_width), randi_range(1,map_height))
		if not decoration_locations.has(loc) and not decoration_locations.has(loc+Vector2i(-1,0)) and not decoration_locations.has(loc+Vector2i(0,-1)) and not decoration_locations.has(loc+Vector2i(-1,-1)):
			var id = uuid.v4()
			count += 1
			oreTypesLevel2.shuffle()
#			PlaceObject.place_large_ore_in_world(id,oreTypesLevel2.front(),loc,Stats.LARGE_ORE_HEALTH)
#			await get_tree().process_frame
			decoration_locations.append(loc)
			decoration_locations.append(loc+Vector2i(-1,0))
			decoration_locations.append(loc+Vector2i(0,-1))
			decoration_locations.append(loc+Vector2i(-1,-1))
			cave_dict[get_parent().tier+str(1)]["ore_large"][id] = {"l": loc, "v": oreTypesLevel2.front(), "h": Stats.LARGE_ORE_HEALTH}

