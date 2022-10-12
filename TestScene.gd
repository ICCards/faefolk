extends YSort

onready var tileset = $Navigation2D/TestTiles
var tiles
#var polygon = $Navigation2D/NavPoly.get_navigation_polygon()

#func _ready():
#	yield(get_tree().create_timer(4.0), "timeout")
#	tileset.bake_navigation = true
	#set_navigation_tiles()


#func set_navigation_polygon():
#	tiles = tileset.get_used_cells()
#	for loc in tiles:
#		if tileset.get_cellv(loc+Vector2(1,0)) != -1:
#			tiles.erase(loc+Vector2(1,0))
#			make_nav_rect(loc, polygon)
#		else:
#			var pos = tileset.map_to_world(loc)
#			var outline = PoolVector2Array([pos+Vector2(1,1), pos+Vector2(31,1), pos+Vector2(31,31), pos+Vector2(1,31)])
#			polygon.add_outline(outline)
#	polygon.make_polygons_from_outlines()
#	$Navigation2D/NavPoly.navpoly = polygon

#func make_nav_rect(loc, polygon):
#	var count = 1
#	for i in range(100):
#		if tileset.get_cellv(loc+Vector2(1,0)+Vector2(i,0)) != -1:
#			tiles.erase(loc+Vector2(1,0)+Vector2(i,0))
#		else:
#			var pos = tileset.map_to_world(loc)
#			var outline = PoolVector2Array([(pos+Vector2(1,1))*(i+1), (pos+Vector2(31,1))*(i+1), (pos+Vector2(31,31))*(i+1), (pos+Vector2(1,31))*(i+1)])
#			polygon.add_outline(outline)
	
#func set_navigation_tiles():
#	var polygon = $Navigation2D/NavPoly.get_navigation_polygon()
#	var player_loc = tileset.world_to_map($Player.position)
#	for x in range(50):
#		for y in range(50):
#			var temp = player_loc + Vector2(x,y) + Vector2(-25,-25)
#			if tileset.get_cellv(temp) != -1:
#				var pos = tileset.map_to_world(temp)
#				var outline = PoolVector2Array([pos+Vector2(1,1), pos+Vector2(31,1), pos+Vector2(31,31), pos+Vector2(1,31)])
#				polygon.add_outline(outline)
#	polygon.make_polygons_from_outlines()
#	$Navigation2D/NavPoly.navpoly = polygon


func _on_Timer_timeout():
	pass
#	var polygon = $Navigation2D/NavPoly.get_navigation_polygon()
#	polygon.clear_outlines()
#	set_navigation_tiles()
