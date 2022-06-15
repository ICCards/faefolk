extends YSort


onready var Map = $CaveWallsMap
onready var GroundMap = $RedGroundMap
onready var GrassMap = $GrassMap
onready var CaveDoorsMap = $CaveDoorsMap

const Player = preload("res://World/Player/Player.tscn")

export(int)   var map_w         = 120
export(int)   var map_h         = 75
export(int)   var iterations    = 20000
export(int)   var neighbors     = 4
export(int)   var ground_chance = 38
export(int)   var min_cave_size = 80


var caves = []

func _input(event):
	if event.is_action_pressed("rotate"):
		generate()
	elif event.is_action_pressed("ui_focus_next"):
		SceneChanger.change_scene("res://World/PlayerFarm/PlayerFarm.tscn")

func _ready():
	generate()

func generate():
	Map.clear()
	fill_with_walls()
	random_ground()
	create_entrance_cave()
	dig_caves()
	get_caves()
	connect_caves()
	Map.update_bitmask_region()
	Map.fix_invalid_tiles()
	Map.update_bitmask_region()
	GroundMap.update_bitmask_region()
#	spawn_player()
	
	
func create_entrance_cave():
	for i in range(9):
		for j in range(9):
			Map.set_cell(i + 1, j + 1, -1)
	CaveDoorsMap.set_cell(4, 0, 0)
	
	
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
	for x in range(-10, map_w + 10):
		for y in range(-10, map_h + 10):
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
		elif check_nearby(x,y) <= neighbors:
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
#				Map.set_cell(drunk_x, drunk_y+1, -1)
#				Map.set_cell(drunk_x+2, drunk_y+2, -1)
