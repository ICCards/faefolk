extends Node2D

@export var map_width: int = 200
@export var map_height: int = 200
@export var redraw: bool : set = draw_elevation

@export var world_seed: String = "sd"
@export var noise_octaves: int = 1
@export var noise_frequency: float = 0.03
@export var noise_persistence: float = 0.7
@export var noise_lacunarity: float = 0.1
@export var noise_threshold: float = 0.1
@export var min_cave_size: int = 400 

var simplex_noise = FastNoiseLite.new()

@onready var elevation: TileMap = $Elevation

var elevation_data = {}

func _ready():
	draw_elevation()


func draw_elevation(value = null) -> void:
	elevation.clear()
	var walker = Vector2i(0,25)
	var locations = [walker]
	for i in range(8):
		for k in range(randi_range(3,10)):
			walker += Vector2i(1,0)
			locations.append(walker)
		if Util.chance(50):
			for h in range(4):#randi_range(1,4)):
				locations.append(walker+Vector2i(0,h+1))
				walker += Vector2i(0,h+1)
		else:
			locations.append(walker+Vector2i(0,-1))
			walker += Vector2i(1,-1)
		#locations.append(walker)
	for loc in locations:
		var autotile_id = Tiles.return_elevation_autotile_id(loc,locations)
		elevation.set_cell(0,loc,0,Vector2i(0,0)) #Tiles.return_elevation_atlas_tile(1,0))
	
	
#	var locs = elevation.get_used_cells(0)
#	var border_locs = []
#	for loc in locs:
#		if Tiles.return_autotile_id(loc,locs) != 0:
#			border_locs.append(loc)
#	elevation.clear()
#	for loc in border_locs:
#		elevation.set_cell(0,loc,0,Vector2i(0,0))
	
#	elevation.clear()
#	simplex_noise.seed = self.world_seed.hash()
#	simplex_noise.fractal_octaves = self.noise_octaves
#	simplex_noise.frequency = self.noise_frequency
#	for x in range(-self.map_width / 2, self.map_width / 2):
#		for y in range(-self.map_height / 2, self.map_height / 2):
#			if simplex_noise.get_noise_2d(x, y) < self.noise_threshold:
#				elevation.set_cell(0,Vector2i(x+map_width / 2, y+map_height / 2),0,Vector2(0,0))
