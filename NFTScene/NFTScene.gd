extends Node2D

onready var valid_tiles = $WorldNavigation/ValidTiles

const MAP_SIZE = 100

func _ready():
	build_valid_tiles()

func build_valid_tiles():
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			valid_tiles.set_cellv(Vector2(x+1, y+1), 0)
