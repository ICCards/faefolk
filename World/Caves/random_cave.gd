extends Node2D

var navTiles


func _ready():
	Server.world = self
	navTiles = $TerrainTiles/NavigationTiles
	Tiles.valid_tiles = $TerrainTiles/ValidTiles
	Tiles.cave_wall_tiles = $TerrainTiles/Walls


func set_nav():
#	pass
#	if Server.player_node:
#		var player_loc = Server.player_node.position/16
	for y in range($CaveGenerator.map_height):
		for x in range($CaveGenerator.map_width):
			var loc = Vector2i(x,y)
			if Tiles.valid_tiles.get_cell_atlas_coords(0,loc) != Vector2i(-1,-1):
				navTiles.set_cell(0,loc,0,Vector2i(0,0))



func _on_timer_timeout():
	set_nav()
