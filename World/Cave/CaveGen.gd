extends Node

#export(bool) var redraw setget redraw
export(Vector2) var mapSize = Vector2(280,220)
export(String) var world_seed = "seed that makes the map noise"
export(int) var noise_octaves = 1.0
export(int) var noise_period = 12
export(float) var noise_persistence = 0.5
export(float) var noise_lacunarity = 2.0
export(float) var tileId = 0
export(float) var threshold = -0.1

export(float) var wallCap = 1
#export(Vector2) var grassCap = Vector2(1,0.3)
export(Vector2) var roadCap = Vector2(0.4,0.05)
export(Vector2) var decorationCap = Vector2(0.4,0.05)

onready var grass_map = $GrassGround
onready var road_map = $DirtGround
onready var wall_map = $CaveWalls
onready var ore_map = $Ores
onready var stones_decoration = $stones_decoration
onready var lanterns = $lanterns

onready var player = $Player
onready var playerColloision = $Player/CollisionShape2D 
onready var lanternLight = $LightNode

onready var RedLantern = preload("res://World/Cave/objects/red_lantern.tscn")
onready var GreenLantern = preload("res://World/Cave/objects/green_lantern.tscn")
onready var BlueLantern = preload("res://World/Cave/objects/blue_lantern.tscn")

enum Tiles { GOLD, SILVER, STONE }

var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()

func _ready() -> void:
	
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.octaves = self.noise_octaves
	simplex_noise.period = self.noise_period
	simplex_noise.persistence = self.noise_persistence
	simplex_noise.lacunarity = self.noise_lacunarity
	makeWallMap()
	makeRoadMap()
	addDecorations()
	spawnPlayer()

	
func makeWallMap():
	for x in mapSize.x:
		for y in mapSize.y:
			grass_map.set_cell(x,y,0)
			wall_map.set_cell(x,y,0)
	grass_map.update_bitmask_region(Vector2(0.0, 0.0), Vector2(mapSize.x, mapSize.y))
	wall_map.update_bitmask_region(Vector2(0.0, 0.0), Vector2(mapSize.x, mapSize.y))
	
func spawnPlayer():
	var cell = self.road_map.get_used_cells()[1]
	playerColloision.disabled = true
	player.move_and_slide(Vector2(cell.x * 52, cell.y * 52), Vector2(0, 0))
	playerColloision.disabled = false
	print("spawned to cell", cell.x, cell.y)

func makeRoadMap():
	for x in mapSize.x:
		for y in mapSize.y:
			var a = simplex_noise.get_noise_2d(x,y)
			if x > 2.0 and x < mapSize.x - 2.0 and y > 2.0 and y < mapSize.y - 2.0:
				if a < roadCap.x and a > roadCap.y:
					wall_map.set_cell(x, y, -1)
					road_map.set_cell(x, y, 1)
	wall_map.update_bitmask_region(Vector2(0.0, 0.0), Vector2(mapSize.x, mapSize.y))
	road_map.update_bitmask_region(Vector2(0.0, 0.0), Vector2(mapSize.x, mapSize.y))

func addDecorations():
	for x in mapSize.x:
		for y in mapSize.y:
			var a = simplex_noise.get_noise_2d(x,y)
			if x > 2.0 and x < mapSize.x - 2.0 and y > 2.0 and y < mapSize.y - 2.0:
				if a < decorationCap.x and a > decorationCap.y:
					var chance = randi() % 100
					if chance < 7 and chance > 3:
						var randTile = randi() % 90
						stones_decoration.set_cell(x, y, randTile)
					if chance < 2:
						var randLantern = randi() % 3
						if(randLantern == 0):
							var redLantern = RedLantern.instance()
							redLantern.initialize(Vector2(x* 32,y* 32))
							redLantern.position = Vector2(x* 32,y* 32)
							add_child(redLantern)
						if(randLantern ==1):
							var greenLantern = GreenLantern.instance()
							greenLantern.initialize(Vector2(x* 32,y* 32))
							greenLantern.position = Vector2(x* 32,y* 32)
							add_child(greenLantern)
						if(randLantern ==2):
							var blueLantern = BlueLantern.instance()
							blueLantern.initialize(Vector2(x* 32,y* 32))
							blueLantern.position = Vector2(x* 32,y* 32)
							add_child(blueLantern)
						
	stones_decoration.update_bitmask_region(Vector2(0.0, 0.0), Vector2(mapSize.x, mapSize.y))

	
func generate() -> void:
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			var value = generate_threshold(simplex_noise.get_noise_2d(x, y))
			_set_autotile(x, y)
			if value != 0:
				pass
				#_set_autotileWall(x, y)	
				#_set_autotile(x, y)
				#self.wall_map.set_cell(x, y, -1)
				#_set_autotile(x, y)
			else:
				_set_autotileWall(x, y)
				#_set_autotile(x, y)
				#_set_autotileDirt(x, y)
				#_set_autotile(x, y)
				#_set_autotileWall(x, y)	
	#addWall()
	#removeWalls()
	#removeWalls()
	#addBorders()
	#addOres()
	#self.ground_map.update_dirty_quadrants()
	#self.dirt_map.update_dirty_quadrants()
	#self.wall_map.update_dirty_quadrants()
	
func _set_autotile(x : int, y : int) -> void:
	self.ground_map.set_cell(
		x, # map x coordinate
		y, # map y coordinate
		self.ground_map.get_tileset().get_tiles_ids()[0], # tile id
		false, # flip x
		false, # flip y
		false, # transpose
		self.ground_map.get_cell_autotile_coord(x, y) #autotile coordinate
		)
	self.ground_map.update_bitmask_area(Vector2(x, y))

func _set_autotileWall(x : int, y : int) -> void:
	self.wall_map.set_cell(
		x, # map x coordinate
		y, # map y coordinate
		self.wall_map.get_tileset().get_tiles_ids()[0], # tile id
		false, # flip x
		false, # flip y
		false, # transpose
		self.wall_map.get_cell_autotile_coord(x, y) #autotile coordinate
		)
	self.wall_map.update_bitmask_area(Vector2(x, y))

func generate_threshold(noise_level: float):
	if(noise_level <= -threshold):
		return -1
	else:
		return 0

func addWall():
	var cells = self.wall_map.get_used_cells()
	for cell in cells:

		var top = self.wall_map.get_cell(cell.x, cell.y-1) == TileMap.INVALID_CELL
		var bottom = self.wall_map.get_cell(cell.x, cell.y+1) == TileMap.INVALID_CELL
		var left = self.wall_map.get_cell(cell.x-1, cell.y) == TileMap.INVALID_CELL
		var right = self.wall_map.get_cell(cell.x+1, cell.y) == TileMap.INVALID_CELL
		
		var topLeft = self.wall_map.get_cell(cell.x-1, cell.y+1) == TileMap.INVALID_CELL
		var bottomLeft = self.wall_map.get_cell(cell.x-1, cell.y-1) == TileMap.INVALID_CELL
		var topRight = self.wall_map.get_cell(cell.x+1, cell.y+1) == TileMap.INVALID_CELL
		var bottomRight = self.wall_map.get_cell(cell.x+1, cell.y-1) == TileMap.INVALID_CELL

		if topLeft:
			if top == true and bottom == true and right == true and left == true:
				_set_autotileWall(cell.x-1, cell.y+1)
		if bottomLeft:
			if top == true and bottom == true and right == true and left == true:
				_set_autotileWall(cell.x-1, cell.y-1)
		if topRight:
			if top == true and bottom == true and right == true and left == true:
				_set_autotileWall(cell.x+1, cell.y+1)
		if bottomRight:
			if top == true and bottom == true and right == true and left == true:
				_set_autotileWall(cell.x+1, cell.y-1)
	self.wall_map.update_dirty_quadrants()

func removeWalls():
	var cells = self.wall_map.get_used_cells()
	for cell in cells:
		var count = 0
		var left = self.wall_map.get_cell(cell.x-1, cell.y) == TileMap.INVALID_CELL
		var right = self.wall_map.get_cell(cell.x+1, cell.y) == TileMap.INVALID_CELL
		var top = self.wall_map.get_cell(cell.x, cell.y-1) == TileMap.INVALID_CELL
		var bottom = self.wall_map.get_cell(cell.x, cell.y+1) == TileMap.INVALID_CELL
		if left == false:
			count = count + 1
		if right == false:
			count = count + 1
		if top == false:
			count = count + 1
		if bottom == false:
			count = count + 1
		if count < 2 :
			self.wall_map.set_cell(cell.x, cell.y, -1)
			#_set_autotileWall2(cell.x,cell.y)
	self.wall_map.update_dirty_quadrants()

func addBorders():
	var cells = self.ground_map.get_used_cells()
	for cell in cells:
		var left = self.ground_map.get_cell(cell.x-1, cell.y) == TileMap.INVALID_CELL
		var right = self.ground_map.get_cell(cell.x+1, cell.y) == TileMap.INVALID_CELL
		var top = self.ground_map.get_cell(cell.x, cell.y-1) == TileMap.INVALID_CELL
		var bottom = self.ground_map.get_cell(cell.x, cell.y+1) == TileMap.INVALID_CELL
		if left:
			_set_autotileWall(cell.x,cell.y)
			_set_autotileWall(cell.x-1,cell.y)
		if right:
			_set_autotileWall(cell.x,cell.y)
			_set_autotileWall(cell.x+1,cell.y)
		if top:	
			_set_autotileWall(cell.x,cell.y)
			_set_autotileWall(cell.x,cell.y-1)
		if bottom:
			_set_autotileWall(cell.x,cell.y)
			_set_autotileWall(cell.x,cell.y+1)
	self.wall_map.update_dirty_quadrants()
