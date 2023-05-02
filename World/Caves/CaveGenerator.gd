extends Node

@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")

@onready var Slime = load("res://World/Enemies/Slime/Slime.tscn")
@onready var Spider = load("res://World/Enemies/Spider.tscn")
@onready var FireMageSkeleton = load("res://World/Enemies/Skeleton.tscn")

var caves = []

@export var map_width: int = 150
@export var map_height: int = 150
@export var redraw: bool : set = redraw_walls

@export var world_seed: String = "Hgfdddsdssdel"
@export var noise_octaves: int = 1
@export var noise_frequency: float = 0.03
@export var noise_persistence: float = 0.7
@export var noise_lacunarity: float = 0.1
@export var noise_threshold: float = 0.1
@export var min_cave_size: int = 400 
@export var loc: Vector2i = Vector2i(100,100)

var simplex_noise = FastNoiseLite.new()
var wall_type
var path
var reset_flag = false
var counter = 0
var valid_light_or_ladder_tiles = []

var oreTypesLevel1 = ["stone1", "stone2", "stone1", "stone2", "bronze ore", "bronze ore", "bronze ore", "iron ore"]
var oreTypesLevel2 = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "bronze ore", "bronze ore", "iron ore", "iron ore", "gold ore"]
var mushroomTypes = ["common mushroom", "healing mushroom", "purple mushroom", "chanterelle"]
var randomAdjacentTiles = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
const NUM_MUSHROOMS = 40
const NUM_SMALL_ORE = 70
const NUM_LARGE_ORE = 30
const MAX_TALL_GRASS_SIZE = 140

var NUM_BATS = 12
var NUM_SLIMES = 16
var NUM_SPIDERS = 16
var NUM_SKELETONS = 16

@onready var valid_tiles: TileMap = get_node("../TerrainTiles/ValidTiles")
@onready var walls: TileMap = get_node("../TerrainTiles/Walls")
@onready var ground1: TileMap = get_node("../TerrainTiles/Ground1")
@onready var ground2: TileMap = get_node("../TerrainTiles/Ground2")
@onready var ground3: TileMap = get_node("../TerrainTiles/Ground3")
@onready var decoration: TileMap = get_node("../TerrainTiles/Decoration")

var _uuid = load("res://helpers/UUID.gd")
var uuid = _uuid.new()

func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	randomize()
	redraw_walls()


func fix_tiles_and_set_ladders_and_lights():
	valid_light_or_ladder_tiles = []
	for loc in walls.get_used_cells(0): # fix tiles and get light/ladder locs
		var autotile_id = Tiles.return_autotile_id(loc,walls.get_used_cells(0))
		if autotile_id == 13:
			walls.set_cell(0,loc,0,Vector2i(-1,-1))
			reset_flag = true
		elif autotile_id == 7 or autotile_id == 11 or autotile_id == 12:
			valid_light_or_ladder_tiles.append(loc)
	if reset_flag:
		reset_flag = false
		fix_tiles_and_set_ladders_and_lights()
		counter += 1
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
	decoration.set_cell(0,valid_ladder_location+Vector2i(0,1),0,Vector2i(60,9))

	var ladder2 = room_positions[1] # set down ladder location
	decoration.set_cell(0,room_positions[1]+Vector2i(0,-1),0,Vector2i(61,11))
	
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
	walls.set_cells_terrain_connect(0,walls.get_used_cells(0),0,wall_type)
	print("NUM TIMES RAN " + str(counter))

func place_cave_light(loc):
	var rand_light = randi_range(52,55)
	decoration.set_cell(0,loc+Vector2i(0,-2),0,Vector2i(rand_light,26))
	var type
	if rand_light == 52:
		type = null
	elif rand_light == 53:
		type = "red"
	elif rand_light == 54:
		type = "yellow"
	elif rand_light == 55:
		type = "blue"
	if type:
		var caveLight = CaveLight.instantiate()
		caveLight.type = type
		caveLight.position = loc*16
		get_parent().call_deferred("add_child",caveLight)
	

func redraw_walls(value = null) -> void:
	print(Util.return_chunk_from_location(loc))
#	wall_type = 1 #randi_range(0,3)
#	if walls == null:
#		return
#	clear()
#	generate()
#	add_boundary_tiles()
#	get_caves()
#	connect_caves()
#	fix_tiles_and_set_ladders_and_lights()
#	set_valid_tiles()
#	set_decorations()
#	set_resources()
#	set_mobs()
	
func set_mobs():
	var locs = valid_tiles.get_used_cells(0)
	locs.shuffle()
	for i in range(NUM_SLIMES):
		var slime = Slime.instantiate()
		Server.world.get_node("Enemies").add_child(slime)
		slime.position = locs[i]*16 + Vector2i(8,8)
		await get_tree().process_frame
	locs.shuffle()
	for i in range(NUM_SPIDERS):
		var spider = Spider.instantiate()
		Server.world.get_node("Enemies").add_child(spider)
		spider.position = locs[i]*16 + Vector2i(8,8)
		await get_tree().process_frame
	locs.shuffle()
	for i in range(NUM_SKELETONS):
		var skele = FireMageSkeleton.instantiate()
		Server.world.get_node("Enemies").add_child(skele)
		skele.position = locs[i]*16 + Vector2i(8,8)
		await get_tree().process_frame

	
func set_resources():
	generate_ore()
	generate_mushroom_forage()
	generate_tall_grass()
	
func set_valid_tiles():
	for x in range(map_width):
		for y in range(map_height):
			if walls.get_cell_atlas_coords(0,Vector2i(x,y)) == Vector2i(-1,-1):
				valid_tiles.set_cell(0,Vector2i(x,y),0,Constants.VALID_TILE_ATLAS_CORD)

func set_decorations():
	print("SET DECOR")
	set_random_rail_decoration()
	print("SET SHRUBS")
	set_random_shrubs()
	
func set_random_shrubs():
	var shrub_locs = [Vector2i(57,15),Vector2i(59,15)]
	for loc in walls.get_used_cells(0):
		var autotile_id = Tiles.return_autotile_id(loc,walls.get_used_cells(0))
		if autotile_id != 0:
			if Util.chance(5):
				shrub_locs.shuffle()
				if autotile_id == 7 or autotile_id == 11 or autotile_id == 12:
					decoration.set_cell(0,loc,0,shrub_locs.front())
				else:
					decoration.set_cell(0,loc+Vector2i(0,2),0,shrub_locs.front())
			await get_tree().process_frame
	
func set_random_rail_decoration():
	var rail_location
	var locations = []
	if Util.chance(50):
		rail_location = Vector2i(randi_range(0,map_width),0)
		while rail_location.y != map_height:
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
		while rail_location.x != map_width:
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
	for loc in locations:
		if Util.chance(2) or valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
			locations.erase(loc)
	decoration.set_cells_terrain_connect(0,locations,0,0)
	for loc in locations:
		valid_tiles.set_cell(0,loc,0,Constants.NAVIGATION_TILE_ATLAS_CORD)

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
		if !cave.has(tile):
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

func clear() -> void:
	decoration.clear()
	walls.clear()


func generate() -> void:
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = self.noise_frequency
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				walls.set_cell(0,Vector2i(x+map_width / 2, y+map_height / 2),0,Vector2(0,0))
	var groundTiles2 = []
	simplex_noise.seed = randi()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = 0.03
	for x in range(-self.map_width / 2 , self.map_width / 2 ):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				groundTiles2.append(Vector2i(x+map_width / 2, y+map_height / 2))
	var groundTiles3 = []
	simplex_noise.seed = randi()
	simplex_noise.fractal_octaves = self.noise_octaves
	simplex_noise.frequency = 0.03
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				groundTiles3.append(Vector2i(x+map_width / 2, y+map_height / 2))
	for x in range(map_width+4):
		for y in range(map_height+4):
			if wall_type == 3:
				ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(56,58),randi_range(40,42)))
			else:
				ground1.set_cell(0,Vector2i(x-2,y-2),0,Vector2i(randi_range(26,28),randi_range(40,42)))
	if wall_type == 3:
		ground2.set_cells_terrain_connect(0,groundTiles2,0,1)
		ground3.set_cells_terrain_connect(0,groundTiles3,0,4)
	else:
		ground2.set_cells_terrain_connect(0,groundTiles2,0,1)
		ground3.set_cells_terrain_connect(0,groundTiles3,0,2)

func get_caves():
	caves = []
	for x in range (0, map_width):
		for y in range (0, map_height):
			if walls.get_cell_atlas_coords(0,Vector2i(x, y)) == Vector2i(-1,-1):
				flood_fill(x,y)

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
	for amt in range(10):
		for x in range(map_width+20):
			walls.set_cell(0,Vector2i(x-10,-amt),0,Vector2i(0,0))
			walls.set_cell(0,Vector2i(x-10,map_height+amt),0,Vector2i(0,0))
		for y in range(map_height):
			walls.set_cell(0,Vector2i(-amt+1,y),0,Vector2i(0,0))
			walls.set_cell(0,Vector2i(map_width+amt-1,y),0,Vector2i(0,0))

func generate_mushroom_forage():
	for i in range(NUM_MUSHROOMS):
		var locs = valid_tiles.get_used_cells(0)
		locs.shuffle()
		var location = locs[0]
		if valid_tiles.get_cell_atlas_coords(0,location) == Constants.VALID_TILE_ATLAS_CORD:
			mushroomTypes.shuffle()
			var id = uuid.v4()
			PlaceObject.place_forage_in_world(id,mushroomTypes.front(),location,true)
			await get_tree().process_frame
#			map["forage"][id] = {"l": str(loc), "v": mushroomTypes.front()}
	
func generate_tall_grass():
	for z in range(2):
		for i in range(4):
			var locs = valid_tiles.get_used_cells(0)
			locs.shuffle()
			var start_loc = locs[0]
			generate_grass_bunch(start_loc, i+1)
		
func generate_grass_bunch(loc, variety):
	var randomNum = randi_range(60, MAX_TALL_GRASS_SIZE)
	for _i in range(randomNum):
		randomAdjacentTiles.shuffle()
		loc += randomAdjacentTiles[0]
		if valid_tiles.get_cell_atlas_coords(0,loc) == Constants.VALID_TILE_ATLAS_CORD:
			var id = uuid.v4()
			PlaceObject.place_tall_grass_in_world(id,"cave"+str(variety),loc)
#			map["tall_grass"][id] = {"l": str(loc), "v": variety}
		else:
			loc -= randomAdjacentTiles[0]
		await get_tree().process_frame
	
var count = 0
func generate_ore():
	for i in range(NUM_SMALL_ORE):
		var locs = valid_tiles.get_used_cells(0)
		locs.shuffle()
		var loc = locs[0]
		if valid_tiles.get_cell_atlas_coords(0,loc) == Constants.VALID_TILE_ATLAS_CORD:
			var id = uuid.v4()
			oreTypesLevel2.shuffle()
			PlaceObject.place_small_ore_in_world(id,oreTypesLevel2.front(),loc,Stats.SMALL_ORE_HEALTH)
			await get_tree().process_frame
			#map["ore"][id] = {"l": str(loc), "v": variety, "h": Stats.SMALL_ORE_HEALTH}
	while count < NUM_LARGE_ORE:
		var locs = valid_tiles.get_used_cells(0)
		locs.shuffle()
		var loc = locs[0]
		if valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Constants.VALID_TILE_ATLAS_CORD and \
		valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,0)) == Constants.VALID_TILE_ATLAS_CORD and \
		valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Constants.VALID_TILE_ATLAS_CORD and \
		valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,-1)) == Constants.VALID_TILE_ATLAS_CORD:
		#if Tiles.validate_tiles(loc+Vector2(-1,0), Vector2(2,2)):
			var id = uuid.v4()
			count += 1
			oreTypesLevel2.shuffle()
			PlaceObject.place_large_ore_in_world(id,oreTypesLevel2.front(),loc,Stats.LARGE_ORE_HEALTH)
			await get_tree().process_frame
			#map["ore_large"][id] = {"l": str(loc), "v": variety, "h": Stats.LARGE_ORE_HEALTH}


#
#func isValidLadderPlacement(_pos):
#	if walls.get_cellv(_pos) == -1 and \
#	walls.get_cellv(_pos+Vector2(0,1)) == -1 and \
#	walls.get_cellv(_pos+Vector2(0,2)) == -1 and \
#	walls.get_cellv(_pos+Vector2(1,0)) == -1 and \
#	walls.get_cellv(_pos+Vector2(-1,0)) == -1:
#		return true
#	return false
#
#
