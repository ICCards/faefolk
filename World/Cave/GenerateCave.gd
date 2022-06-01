extends Node2D

onready var Map = $CaveWallsMap
onready var GroundMap = $RedGroundMap
onready var GrassMap = $GrassMap

const Player = preload("res://World/Player/Player.tscn")

export(int)   var map_w         = 80
export(int)   var map_h         = 50
export(int)   var iterations    = 20000
export(int)   var neighbors     = 4
export(int)   var ground_chance = 48
export(int)   var min_cave_size = 80


var caves = []

func _input(event):
	if event.is_action_pressed("rotate"):
		generate()

func _ready():
	generate()

func generate():
	Map.clear()
	fill_with_walls()
	random_ground()
	dig_caves()
	get_caves()
	connect_caves()
	Map.update_bitmask_region()
	GroundMap.update_bitmask_region()
	#spawn_player()
	
func spawn_player():
	var player = Player.instance()
	player.initialize_camera_limits(Vector2(0, -64), Vector2(10000, 10000))
	add_child(player)
	player.position = Vector2(100, 100)


func random_ground():
	for x in range(1, map_w-1):
		for y in range(1, map_h-1):
			if Util.chance(ground_chance):
				Map.set_cell(x, y, -1)


func fill_with_walls():
	for x in range(0, map_w + 1):
		for y in range(-1, map_h + 1):
			Map.set_cell(x, y, 0)
			GroundMap.set_cell(x, y, 0)


func dig_caves():
	randomize()
	for i in range(iterations):
		# Pick a random point with a 1-tile buffer within the map
		var x = floor(rand_range(1, map_w-1))
		var y = floor(rand_range(1, map_h-1))

		# if nearby cells > neighbors, make it a roof tile
		if check_nearby(x,y) > neighbors:
			Map.set_cell(x, y, 0)

		# or make it the ground tile
		elif check_nearby(x,y) < neighbors:
			Map.set_cell(x, y, -1)

func check_nearby(x, y):
	var count = 0
	if Map.get_cell(x, y-1)   == 0:  count += 1
	if Map.get_cell(x, y+1)   == 0:  count += 1
	if Map.get_cell(x-1, y)   == 0:  count += 1
	if Map.get_cell(x+1, y)   == 0:  count += 1
	if Map.get_cell(x+1, y+1) == 0:  count += 1
	if Map.get_cell(x+1, y-1) == 0:  count += 1
	if Map.get_cell(x-1, y+1) == 0:  count += 1
	if Map.get_cell(x-1, y-1) == 0:  count += 1
	return count

func get_caves():
	caves = []

	for x in range (0, map_w):
		for y in range (0, map_h):
			if Map.get_cell(x, y) == -1:
				flood_fill(x,y)

	for cave in caves:
		for tile in cave:
			Map.set_cellv(tile, -1)


func flood_fill(tilex, tiley):
	var cave = []
	var to_fill = [Vector2(tilex, tiley)]
	while to_fill:
		var tile = to_fill.pop_back()

		if !cave.has(tile):
			cave.append(tile)
			Map.set_cellv(tile, 0)

			#check adjacent cells
			var north = Vector2(tile.x, tile.y-1)
			var south = Vector2(tile.x, tile.y+1)
			var east  = Vector2(tile.x+1, tile.y)
			var west  = Vector2(tile.x-1, tile.y)

			for dir in [north,south,east,west]:
				if Map.get_cellv(dir) == -1:
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
		if (2 < drunk_x + dx and drunk_x + dx < map_w-2) and \
			(2 < drunk_y + dy and drunk_y + dy < map_h-2):
			drunk_x += dx
			drunk_y += dy
			if Map.get_cell(drunk_x, drunk_y) == 0:
				Map.set_cell(drunk_x, drunk_y, -1)

				# optional: make tunnel wider
				Map.set_cell(drunk_x+1, drunk_y, -1)
				Map.set_cell(drunk_x+1, drunk_y+1, -1)


#### ROOM METHOD
#
#var Room = preload("res://World/Cave/CaveRoom.tscn")
#
#var font = preload("res://Assets/Fonts/RobotoBold120.tres")
#
#var rng = RandomNumberGenerator.new()
#
#var tile_size = 32  # size of a tile in the TileMap
#var num_rooms = 40  # number of rooms to generate
#var min_size = 6  # minimum room size (in tiles)
#var max_size = 15  # maximum room size (in tiles)
#var hspread = 400  # horizontal spread (in pixels)
#var cull = 0.5  # chance to cull room
#
#var path  # AStar pathfinding object
#var start_room = null
#var end_room = null
#var play_mode = false  
#var player = null
#
#export(Vector2) var mapSize = Vector2(280,220)
#export(String) var world_seed = "seed x"
#export(int) var noise_octaves = 1.0
#export(int) var noise_period = 12
#export(float) var noise_persistence = 0.5
#export(float) var noise_lacunarity = 2.0
#
#var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()
#
#func _ready() -> void:
##	simplex_noise.seed = self.world_seed.hash()
##	simplex_noise.octaves = self.noise_octaves
##	simplex_noise.period = self.noise_period
##	simplex_noise.persistence = self.noise_persistence
##	simplex_noise.lacunarity = self.noise_lacunarity
#	make_rooms()
##	for x in mapSize.x:
##		for y in mapSize.y:
##			GrassMap.set_cell(x,y,0)
#
#
#
#func make_rooms():
#	for i in range(num_rooms):
#		var pos = Vector2(rand_range(-hspread, hspread), 0)
#		var r = Room.instance()
#		var w = min_size + randi() % (max_size - min_size)
#		var h = min_size + randi() % (max_size - min_size)
#		r.make_room(pos, Vector2(w, h) * tile_size)
#		$Rooms.add_child(r)
#	# wait for movement to stop
#	yield(get_tree().create_timer(1.1), 'timeout')
#	# cull rooms
#	var room_positions = []
#	for room in $Rooms.get_children():
#		if randf() < cull:
#			room.queue_free()
#		else:
#			room.mode = RigidBody2D.MODE_STATIC
#			room_positions.append(Vector3(room.position.x,
#										  room.position.y, 0))
#	yield(get_tree(), 'idle_frame')
#	# generate a minimum spanning tree connecting the rooms
#	path = find_mst(room_positions)
#
#func _draw():
#	if start_room:
#		draw_string(font, start_room.position-Vector2(125,0), "start", Color(1,1,1))
#	if end_room:
#		draw_string(font, end_room.position-Vector2(125,0), "end", Color(1,1,1))
#	if play_mode:
#		return
#	for room in $Rooms.get_children():
#		draw_rect(Rect2(room.position - room.size, room.size * 2),
#				 Color(0, 1, 0), false)
#	if path:
#		for p in path.get_points():
#			for c in path.get_point_connections(p):
#				var pp = path.get_point_position(p)
#				var cp = path.get_point_position(c)
#				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y),
#						  Color(1, 1, 0), 15, true)
#
#func _process(delta):
#	update()
#
#func _input(event):
#	if event.is_action_pressed('ui_select'):
#		if play_mode:
#			player.queue_free()
#			play_mode = false
#		for n in $Rooms.get_children():
#			n.queue_free()
#		path = null
#		start_room = null
#		end_room = null
#		make_rooms()
#	if event.is_action_pressed('ui_focus_next'):
#		make_map()
#	if event.is_action_pressed('ui_cancel'):
#		player = Player.instance()
#		add_child(player)
#		player.position = start_room.position
#		play_mode = true
#	if event.is_action_pressed("mouse_click"):
#		adjust_rooms()
#
#func find_mst(nodes):
#	# Prim's algorithm
#	# Given an array of positions (nodes), generates a minimum
#	# spanning tree
#	# Returns an AStar object
#
#	# Initialize the AStar and add the first point
#	var path = AStar.new()
#	path.add_point(path.get_available_point_id(), nodes.pop_front())
#
#	# Repeat until no more nodes remain
#	while nodes:
#		var min_dist = INF  # Minimum distance so far
#		var min_p = null  # Position of that node
#		var p = null  # Current position
#		# Loop through points in path
#		for p1 in path.get_points():
#			p1 = path.get_point_position(p1)
#			# Loop through the remaining nodes
#			for p2 in nodes:
#				# If the node is closer, make it the closest
#				if p1.distance_to(p2) < min_dist:
#					min_dist = p1.distance_to(p2)
#					min_p = p2
#					p = p1
#		# Insert the resulting node into the path and add
#		# its connection
#		var n = path.get_available_point_id()
#		path.add_point(n, min_p)
#		path.connect_points(path.get_closest_point(p), n)
#		# Remove the node from the array so it isn't visited again
#		nodes.erase(min_p)
#	return path
#
#func make_map():
#	# Create a TileMap from the generated rooms and path
#	Map.clear()
#	find_start_room()
#	find_end_room()
#
#	# Fill TileMap with walls, then carve empty rooms
#	var full_rect = Rect2()
#	for room in $Rooms.get_children():
#		var r = Rect2(room.position-room.size,
#					room.get_node("CollisionShape2D").shape.extents*2)
#		full_rect = full_rect.merge(r)
#	var topleft = Map.world_to_map(full_rect.position)
#	var bottomright = Map.world_to_map(full_rect.end)
#	for x in range(topleft.x, bottomright.x):
#		for y in range(topleft.y, bottomright.y):
#			Map.set_cell(x, y, 0)	
#			GroundMap.set_cell(x, y, 0)
#
#	# Carve rooms
#	var corridors = []  # One corridor per connection
#	for room in $Rooms.get_children():
#		var s = (room.size / tile_size).floor()
#		var pos = Map.world_to_map(room.position)
#		var ul = (room.position / tile_size).floor() - s
#		for x in range(2, s.x * 2 - 1):
#			for y in range(2, s.y * 2 - 1):
#				Map.set_cell(ul.x + x, ul.y + y, -1)
#		# Carve connecting corridor
#		var p = path.get_closest_point(Vector3(room.position.x, 
#											room.position.y, 0))
#		for conn in path.get_point_connections(p):
#			if not conn in corridors:
#				var start = Map.world_to_map(Vector2(path.get_point_position(p).x,
#													path.get_point_position(p).y))
#				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x,
#													path.get_point_position(conn).y))									
#				carve_path(start, end)
#		corridors.append(p)
#	Map.update_bitmask_region()
#	GroundMap.update_bitmask_region()
#
#func carve_path(pos1, pos2):
#	# Carve a path between two points
#	var x_diff = sign(pos2.x - pos1.x)
#	var y_diff = sign(pos2.y - pos1.y)
#	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
#	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
#	# choose either x/y or y/x
#	var x_y = pos1
#	var y_x = pos2
#	if (randi() % 2) > 0:
#		x_y = pos2
#		y_x = pos1
#	for x in range(pos1.x, pos2.x, x_diff):
#		Map.set_cell(x, x_y.y, -1)
#		Map.set_cell(x, x_y.y + y_diff, -1)
#		Map.set_cell(x, x_y.y + y_diff +  y_diff, -1)  # widen the corridor
#	for y in range(pos1.y, pos2.y, y_diff):
#		Map.set_cell(y_x.x, y, -1)
#		Map.set_cell(y_x.x + x_diff, y, -1)
#		Map.set_cell(y_x.x + x_diff + x_diff, y, -1)
#
#func find_start_room():
#	var min_x = INF
#	for room in $Rooms.get_children():
#		if room.position.x < min_x:
#			start_room = room
#			min_x = room.position.x
#
#func find_end_room():
#	var max_x = -INF
#	for room in $Rooms.get_children():
#		if room.position.x > max_x:
#			end_room = room
#			max_x = room.position.x
#
#
#const CIRCLE_RADIUS = 10
#func adjust_rooms():
#	for room in $Rooms.get_children():
#		var s = (room.size / tile_size).floor()
#		var pos = Map.world_to_map(room.position)
#		if (randi() % 2) > 0:
#			make_tilemap_circle(pos, rng.randi_range(s.x, s.y))
##			make_tilemap_circle(pos / 2, rng.randi_range(s.x, s.y))
##			make_tilemap_circle(pos * 2, rng.randi_range(s.x, s.y))
##			for x in range(0, 10):
##				for y in range(0, 10):
##					var tile_coords = Vector2(x, y)
##					if tile_coords.length() <= CIRCLE_RADIUS:
##					# The tile is within the radius of the circle, so add a tile here
##					# (or whatever you need to do for tiles within the circle's radius)
##						Map.set_cellv(Vector2(x, y) + pos, -1)
##					else:
##						# The tile is not within the radius of the circle, so ignore the tile
##						pass
#	Map.update_bitmask_region()
#
#
#
#func make_tilemap_circle(center_position, radius, tile_id=-1):
##	radius += rng.randi_range(-5, 5)
#	# The right half of the circle:
#	for x in range(center_position.x, center_position.x + radius):
#		# The bottom right half of the circle:
#		for y in range(center_position.y, center_position.y + radius):
#			var relative_vector = Vector2(x, y) - center_position;
#			if (relative_vector.length() < radius):
#				Map.set_cell(x, y, tile_id);
#		# The top right half of the circle
#		for y in range(center_position.y - radius, center_position.y):
#			var relative_vector = center_position - Vector2(x, y);
#			if (relative_vector.length() < radius):
#				Map.set_cell(x, y, tile_id);
##	# The left half of the circle
#	for x in range(center_position.x - radius, center_position.x):
#		# The bottom left half of the circle:
##		radius += rng.randi_range(-5, 5)
#		for y in range(center_position.y, center_position.y + radius):
#			var relative_vector = Vector2(x, y) - center_position;
#			if (relative_vector.length() < radius):
#				Map.set_cell(x, y, tile_id);
##		# The top left half of the circle
#
#		for y in range(center_position.y - radius, center_position.y):
#			var relative_vector = center_position - Vector2(x, y);
#			if (relative_vector.length() < radius):
#				Map.set_cell(x, y, tile_id);
#
#
#
#
#
#
#
### WALKER METHOD
#
##func _ready():
##	randomize()
##	generate_level()
#
##var borders = Rect2(1, 1, 188, 105)
#
#
##func generate_level():
##	var walker = Walker.new(Vector2(1, 53), borders)
##	var map = walker.walk(500)
##
###	var player = Player.instance()
###	add_child(player)
###	player.position = map.front()*32
##
##	walker.queue_free()
##	for location in map:
##		WallMap.set_cellv(location, -1)
###		WallMap.set_cellv(location + Vector2(1, 0), -1)
###		WallMap.set_cellv(location + Vector2(1, 1), -1)
###		WallMap.set_cellv(location + Vector2(0, 1), -1)
##	WallMap.update_bitmask_region(borders.position, borders.end)
##
##func reload_level():
##	get_tree().reload_current_scene()
##
##func _input(event):
##	if event.is_action_pressed("rotate"):
##		reload_level()
