extends Node

#var _uuid = load("res://helpers/UUID.gd")
#var uuid
#
#
#export(int)   var map_w         = 100
#export(int)   var map_h         = 100
#export(int)   var iterations    = 45000
#export(int)   var neighbors     = 4
#export(int)   var ground_chance = 48
#export(bool) var redraw setget redraw
#
var caves = []
#
onready var walls = get_node("../Walls")
onready var ground1 = get_node("../Ground1")
#onready var ground2 = get_node("../Ground2")
#onready var grass1 = get_node("../Grass1")
#onready var grass2 = get_node("../Grass2")
#onready var upLadder = get_node("../UpLadder")
#
var reset_flag = false
#
#func _ready():
#	generate_walls()
#
#func generate_walls():
#	walls.clear()
#	upLadder.clear()
#	fill_roof()
#	random_ground()
#	dig_caves()
#	get_caves()
#	connect_caves()
#	add_boundary_tiles()
#	fix_tiles()
#	set_up_ladder()
#	#generate_floors()
#
#func set_up_ladder():
#	var starting_positions = ["top left", "top right"]
#	starting_positions.shuffle()
#	var starting_position = starting_positions.front()
##	if starting_position == "top left":
#	for x in range(map_w):
#		if isValidLadderPlacement(Vector2(x,1)):
#			upLadder.set_cellv(Vector2(x,1),0)
#			return
#		elif isValidLadderPlacement(Vector2(x,2)):
#			upLadder.set_cellv(Vector2(x,2),0)
#			return
#
#
##var walked_tiles = []
##func set_down_ladder():
##	var current_pos = upLadder.get_used_cells()[0]
##	walked_tiles.append(current_pos)
##	find_next_valid_tile()
#
##func find_next_valid_tile():
##	if Tiles.isCenterBitmaskTile(current_pos+Vector2(1,0), walls) and not walked_tiles.has(current_pos+Vector2(1,0)):
##		current_pos = current_pos+Vector2(1,0)
##		walked_tiles.append(current_pos)
##		set_down_ladder()
##		return
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



func fix_tiles():
	walls.update_bitmask_region()
	for tile in walls.get_used_cells():
		if walls.get_cell_autotile_coord(tile.x, tile.y) == Vector2(30,0):
			walls.set_cellv(tile,-1)
			walls.update_bitmask_area(tile)
			reset_flag = true
	if reset_flag:
		reset_flag = false
		fix_tiles()
		return




export(int) var map_width = 150
export(int) var map_height = 150
export(bool) var redraw setget redraw

export(String) var world_seed = "Hello Godot!"
export(int) var noise_octaves = 1
export(int) var noise_period = 13
export(float) var noise_persistence = 0.7
export(float) var noise_lacunarity = 0.1
export(float) var noise_threshold = 0.1
export(int)   var min_cave_size = 60 

var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()

func _ready() -> void:
	redraw()
	
func redraw(value = null) -> void:
	if walls == null:
		return
	clear()
	generate()
	add_boundary_tiles()
	get_caves()
	connect_caves()
	fix_tiles()
	
func clear() -> void:
	walls.clear()
	
func generate() -> void:
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.octaves = self.noise_octaves
	simplex_noise.period = self.noise_period
	simplex_noise.persistence = self.noise_persistence
	simplex_noise.lacunarity = self.noise_lacunarity
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
				#_set_autotile(x+map_width / 2, y+map_height / 2)
				walls.set_cell(x+map_width / 2, y+map_height / 2,0)
	#self.tile_map.update_dirty_quadrants()
	
#func _set_autotile(x : int, y : int) -> void:
#	self.tile_map.set_cell(
#		x, # map x coordinate
#		y, # map y coordinate
#		self.tile_map.get_tileset().get_tiles_ids()[0], # tile id
#		false, # flip x
#		false, # flip y
#		false, # transpose
#		self.tile_map.get_cell_autotile_coord(x, y) #autotile coordinate
#		)
#	self.tile_map.update_bitmask_area(Vector2(x, y))


func get_caves():
	caves = []

	for x in range (0, map_width):
		for y in range (0, map_height):
			if walls.get_cell(x, y) == -1:
				flood_fill(x,y)

	for cave in caves:
		for tile in cave:
			walls.set_cellv(tile, -1)


func flood_fill(tilex, tiley):
	var cave = []
	var to_fill = [Vector2(tilex, tiley)]
	while to_fill:
		var tile = to_fill.pop_back()

		if !cave.has(tile):
			cave.append(tile)
			walls.set_cellv(tile, 0)

			#check adjacent cells
			var north = Vector2(tile.x, tile.y-1)
			var south = Vector2(tile.x, tile.y+1)
			var east  = Vector2(tile.x+1, tile.y)
			var west  = Vector2(tile.x-1, tile.y)

			for dir in [north,south,east,west]:
				if walls.get_cellv(dir) == -1:
					if !to_fill.has(dir) and !cave.has(dir):
						to_fill.append(dir)

	if cave.size() >= min_cave_size:
		caves.append(cave)


func connect_caves():
	var prev_cave = null
	var tunnel_caves = caves.duplicate()

	for cave in tunnel_caves:
		if prev_cave:
			var new_point  = Util.choose(cave)
			var prev_point = Util.choose(prev_cave)

			# ensure not the same point
			if new_point != prev_point:
				create_tunnel(new_point, prev_point, cave)

		prev_cave = cave

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
			if walls.get_cell(drunk_x, drunk_y) == 0:
				walls.set_cell(drunk_x, drunk_y, -1)

				# optional: make tunnel wider
				walls.set_cell(drunk_x+1, drunk_y, -1)
				walls.set_cell(drunk_x+1, drunk_y+1, -1)
				walls.set_cell(drunk_x+2, drunk_y, -1)
				walls.set_cell(drunk_x+2, drunk_y+2, -1)
				walls.set_cell(drunk_x+1, drunk_y+3, -1)
				walls.set_cell(drunk_x+2, drunk_y+3, -1)
				walls.set_cell(drunk_x+1, drunk_y+4, -1)
				walls.set_cell(drunk_x+2, drunk_y+4, -1)
				walls.set_cell(drunk_x-1, drunk_y, -1)
				walls.set_cell(drunk_x-1, drunk_y-1, -1)


func add_boundary_tiles():
	for amt in range(10):
		for x in range(map_width+20):
			walls.set_cell(x-10,-amt,0)
			walls.set_cell(x-10,map_height+amt,0)
		for y in range(map_height):
			walls.set_cell(-amt-1,y,0)
			walls.set_cell(map_width+amt,y,0)
	for x in range(map_width):
		for y in range(map_height):
			ground1.set_cell(x,y,0)
	ground1.update_bitmask_region()
	walls.update_bitmask_region()

#var openSimplexNoise := OpenSimplexNoise.new()
#var rng = RandomNumberGenerator.new()
#
#var thread_world = Thread.new()
#var thread_world_update = Thread.new()
#var thread_temperature = Thread.new()
#var thread_moisture = Thread.new()
#var thread_altittude = Thread.new()
#
#var threads = [thread_world,thread_temperature,thread_moisture,thread_altittude,thread_world_update]
#
#var altittude = {}
#var temperature = {}
#var moisture = {}
#
#var mutex = Mutex.new()
#var semaphore = Semaphore.new()
#var thread_counter = 1
#var thread_tile_counter = 1
#
#
#func generate_floors():
#	build_temperature(5,300)
#	build_moisture(5,300)
#	build_altittude(5,150)
#
#
#func end_altittude():
#	altittude = thread_altittude.wait_to_finish()
#	print("finish building altittude")
#	mutex.lock()
#	if thread_counter == 3:
#		#call_deferred("build_world")
#		thread_world.start(self, "build_world")
#	else:	
#		thread_counter += 1
#	mutex.unlock()
#
#
#func end_temperature():
#	temperature = thread_temperature.wait_to_finish()
#	print("finish building temperature")
#	mutex.lock()
#	if thread_counter == 3:
#		#call_deferred("build_world")
#		thread_world.start(self, "build_world")
#	else:	
#		thread_counter += 1
#	mutex.unlock()
#
#func end_moisture():
#	moisture = thread_moisture.wait_to_finish()
#	print("finish building moisture")
#	mutex.lock()
#	if thread_counter == 3:
#		#call_deferred("build_world")
#		thread_world.start(self, "build_world")
#	else:	
#		thread_counter += 1
#	mutex.unlock()
#
#func build_altittude(octaves,period):
#	print("building altittude")
#	var data = {
#		"octaves":octaves,
#		"period":period,
#		"ending_function":"end_altittude"
#	};
#	thread_altittude.start(self, "generate_map", data)	
#
#func build_temperature(octaves,period):
#	print("building temperature")
#	var data = {
#		"octaves":octaves,
#		"period":period,
#		"ending_function":"end_temperature"
#	};
#	thread_temperature.start(self, "generate_map", data)
#
#func build_moisture(octaves,period):
#	print("building moisture")
#	var data = {
#		"octaves":octaves,
#		"period":period,
#		"ending_function":"end_moisture"
#	};
#	thread_moisture.start(self, "generate_map", data)
#
#func generate_map(data):
#	var grid = {}
#	openSimplexNoise.seed = randi()
#	openSimplexNoise.octaves = data.octaves
#	openSimplexNoise.period = data.period
#	var custom_gradient = CustomGradientTexture.new()
#	custom_gradient.gradient = Gradient.new()
#	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
#	custom_gradient.size = Vector2(map_w,map_h)
#	var gradient_data = custom_gradient.get_data()
#	gradient_data.lock()
#	for x in map_w:
#		for y in map_h:
#			var gradient_value = gradient_data.get_pixel(x,y).r * 1.5
#			var value = openSimplexNoise.get_noise_2d(x,y)
#			value += gradient_value
#			grid[Vector2(x,y)] = value
#	call_deferred(data.ending_function)
#	return grid
#
#func build_world():
#	print("BUILDING WORRLD")
#	for x in map_w:
#		for y in map_h:
#			var pos = Vector2(x,y)
#			ground1.set_cellv(pos,0)
#			var alt = altittude[pos]
#			var temp = temperature[pos]
#			var moist = moisture[pos]
#			#Ocean
#			if alt > 0.8:
#				pass
#				#ocean.append(Vector2(x,y))
#			#Beach	
#			elif between(alt,0.75,0.8):
#				#MapData.world["beach"][id] = Vector2(x,y)
#				#beach.append(Vector2(x,y))
#				pass
#			#Biomes	
#			elif between(alt,-1.4,0.8):
#				#plains
#				if between(moist,0,0.4) and between(temp,0.2,0.6):
#					#MapData.world["plains"][id] = Vector2(x,y)
#					#plains.append(Vector2(x,y))
#					ground2.set_cell(x,y,1)
#				#forest
#				elif between(moist,0.5,0.85) and temp > 0.6:
#					#MapData.world["forest"][id] = Vector2(x,y)
#					#forest.append(Vector2(x,y))
#					grass1.set_cell(x,y,2)
#				#desert	
#				elif temp > 0.6 and moist < 0.5:
#					#desert.append(Vector2(x,y))
#					grass2.set_cell(x,y,3)
#				#snow	
#				elif temp < 0.2:
#					#MapData.world["snow"][id] = Vector2(x,y)
#					#snow.append(Vector2(x,y))
#					grass2.set_cell(x,y,3)
#					pass
#				else:
#					#dirt
#					#MapData.world["dirt"][id] = Vector2(x,y)
#					#dirt.append(Vector2(x,y))
#					grass1.set_cell(x,y,2)
#			else:
#				#MapData.world["dirt"][id] = Vector2(x,y)
#				#dirt.append(Vector2(x,y))
#				ground2.set_cell(x,y,1)
#	ground1.update_bitmask_region()
#	ground2.update_bitmask_region()
#	grass1.update_bitmask_region()
#	grass2.update_bitmask_region()
##	#save_world_data()
#
#func between(val, start, end):
#	if start <= val and val < end:
#		return true
#	return false
