extends Node2D

export(bool) var redraw setget redraw
export(int) var map_width = 20
export(int) var map_height = 20

export(String) var world_seed = "Hello Godot!"
export(int) var noise_octaves = 3
export(int) var noise_period = 3
export(float) var noise_persistence = 0.7
export(float) var noise_lacunarity = 0.4
export(float) var tileId = 0
export(float) var threshold = -0.1

onready var ground_map = $Ground
onready var dirt_map = $Dirt
onready var wall_map = $Wall
onready var ore_map = $Ore

enum Tiles { GOLD, SILVER, STONE }

var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()

func _ready() -> void:
	redraw()

func is_cell_empty(x: int, y: int) -> bool:
	return ground_map.get_cell(x, y) == TileMap.INVALID_CELL
	
func redraw(value = null) -> void:
	if ground_map == null:
		return
	clear()
	generate()
	#generateTracks()
	
func clear() -> void:
	ground_map.clear()
	
func generate() -> void:
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.octaves = self.noise_octaves
	simplex_noise.period = self.noise_period
	simplex_noise.persistence = self.noise_persistence
	simplex_noise.lacunarity = self.noise_lacunarity
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
	removeWalls()
	removeWalls()
	addBorders()
	addOres()
	self.ground_map.update_dirty_quadrants()
	self.dirt_map.update_dirty_quadrants()
	self.wall_map.update_dirty_quadrants()
	
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
	var cells = self.ground_map.get_used_cells()
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
		if count >= 2:
			_set_autotileWall(cell.x,cell.y)
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
		
func addOres():
	var cells = self.ground_map.get_used_cells()
	for cell in cells:
		var wall = self.wall_map.get_cell(cell.x, cell.y) == TileMap.INVALID_CELL
		var ground = self.ground_map.get_cell(cell.x, cell.y) != TileMap.INVALID_CELL
		if wall && ground:
			var value = randi() % 10
			var chance = randi() % 3
			if chance == 1:
				if value > 7:
					ore_map.set_cell(cell.x, cell.y, Tiles.GOLD)
				if value > 4 && value < 7:
					ore_map.set_cell(cell.x, cell.y, Tiles.SILVER)
				if value < 4:
					ore_map.set_cell(cell.x, cell.y, Tiles.STONE)
