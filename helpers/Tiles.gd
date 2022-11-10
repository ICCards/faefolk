extends Node

var valid_tiles = null
var path_tiles = null
var hoed_tiles = null
var watered_tiles = null
var ocean_tiles = null
var deep_ocean_tiles: TileMap = null
var dirt_tiles = null
var wall_tiles = null
var selected_wall_tiles = null
var foundation_tiles = null
var selected_foundation_tiles = null
var object_tiles = null
var fence_tiles = null
var light_tiles = null
var wet_sand_tiles = null


func validate_tiles(location, dimensions):
	var active = false
	if not active:
		active = true
		for x in range(dimensions.x):
			for y in range(dimensions.y):
				if valid_tiles.get_cellv( Vector2(x, -y) + location) != 0: 
					return false
					break
		return true
		
		
func isValidNavigationTile(loc) -> bool:
	if wet_sand_tiles.get_cellv(loc) != -1 and deep_ocean_tiles.get_cellv(loc) == -1:
		return true
	elif valid_tiles.get_cellv(loc) == -1:
		return false
	elif valid_tiles.get_cellv(loc+Vector2(1,0)) == -1 and valid_tiles.get_cellv(loc+Vector2(0,1)) == -1:
		return false
	elif valid_tiles.get_cellv(loc+Vector2(1,0)) == -1 and valid_tiles.get_cellv(loc+Vector2(0,-1)) == -1:
		return false
	elif valid_tiles.get_cellv(loc+Vector2(-1,0)) == -1 and valid_tiles.get_cellv(loc+Vector2(0,1)) == -1:
		return false
	elif valid_tiles.get_cellv(loc+Vector2(-1,0)) == -1 and valid_tiles.get_cellv(loc+Vector2(0,-1)) == -1:
		return false
	elif valid_tiles.get_cellv(loc+Vector2(-1,0)) == -1 and valid_tiles.get_cellv(loc+Vector2(1,0)) == -1:
		return false
	elif valid_tiles.get_cellv(loc+Vector2(0,1)) == -1 and valid_tiles.get_cellv(loc+Vector2(0,-1)) == -1:
		return false
	
	return true


#func remove_nature_invalid_tiles(location, _name = ""):
#	if _name == "tree" or _name == "stump" or _name == "large ore":
#		valid_tiles.set_cellv(location, -1)
#		valid_tiles.set_cellv(location + Vector2(-1, -1), -1 )
#		valid_tiles.set_cellv(location + Vector2(-1, 0), -1 )
#		valid_tiles.set_cellv(location + Vector2(0, -1), -1)
#	elif _name == "tall grass" or _name == "flower":
#		valid_tiles.set_cellv(location, 1)
#	else:
#		valid_tiles.set_cellv(location, -1)


func remove_valid_tiles(location,var dimensions = Vector2(1,1)):
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cellv(location + Vector2(x, -y), -1)

func add_valid_tiles(location, var dimensions = Vector2(1,1)):
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cellv(location + Vector2(x, -y), 0)
			
func add_navigation_tiles(location, var dimensions = Vector2(1,1)):
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cellv(location + Vector2(x, -y), 1)


func isValidAutoTile(_pos, _map):
	var count = 0
	if _map.get_cellv(_pos + Vector2(0,1)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(0,-1)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(1,0)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(-1,0)) != -1:
		count += 1
	if count <= 1:
		return false
	else:
		if _map.get_cellv(_pos + Vector2(-1,-1)) != -1:
			count += 1
		if _map.get_cellv(_pos + Vector2(-1,1)) != -1:
			count += 1
		if _map.get_cellv(_pos + Vector2(1,-1)) != -1:
			count += 1
		if _map.get_cellv(_pos + Vector2(1,1)) != -1:
			count += 1
		if count == 6:
			if _map.get_cellv(_pos + Vector2(-1,-1)) == -1 and _map.get_cellv(_pos + Vector2(1,1)) == -1:
				return false
			elif _map.get_cellv(_pos + Vector2(1,-1)) == -1 and _map.get_cellv(_pos + Vector2(-1,1)) == -1:
				return false
			else:
				return true
		else:
			return true
			
	
func return_neighboring_cells(_pos, _map):
	var count = 0
	if _map.get_cellv(_pos + Vector2(0,1)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(0,-1)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(1,0)) != -1:
		count += 1
	if _map.get_cellv(_pos + Vector2(-1,0)) != -1:
		count += 1
	return count
	
func return_if_valid_wall_cell(_pos, _map):
	if _map.get_cellv(_pos + Vector2(0,1)) != -1 and _map.get_cellv(_pos + Vector2(1,1)) != -1 and _map.get_cellv(_pos + Vector2(1,0)) != -1:
		return false
	elif _map.get_cellv(_pos + Vector2(0,-1)) != -1 and _map.get_cellv(_pos + Vector2(1,-1)) != -1 and _map.get_cellv(_pos + Vector2(1,0)) != -1:
		return false 
	elif _map.get_cellv(_pos + Vector2(-1,-1)) != -1 and _map.get_cellv(_pos + Vector2(-1,0)) != -1 and _map.get_cellv(_pos + Vector2(0,-1)) != -1:
		return false 
	elif _map.get_cellv(_pos + Vector2(-1,0)) != -1 and _map.get_cellv(_pos + Vector2(-1,1)) != -1 and _map.get_cellv(_pos + Vector2(0,1)) != -1:
		return false 
	else:
		return true
	
	
func isCenterBitmaskTile(_pos, _map):
	if _map.get_cellv(_pos + Vector2(0,1)) != -1 and _map.get_cellv(_pos + Vector2(0,-1)) != -1 and \
	_map.get_cellv(_pos + Vector2(1,0)) != -1 and _map.get_cellv(_pos + Vector2(-1,0)) != -1 and \
	_map.get_cellv(_pos + Vector2(1,1)) != -1 and _map.get_cellv(_pos + Vector2(-1,1)) != -1 and \
	_map.get_cellv(_pos + Vector2(-1,-1)) != -1 and _map.get_cellv(_pos + Vector2(1,-1)) != -1:
		return true
	else:
		return false
	
func get_subtile_with_priority(id, tilemap: TileMap):
	var tiles = tilemap.tile_set
	var rect = tilemap.tile_set.tile_get_region(id)
	var size_x = rect.size.x / tiles.autotile_get_size(id).x
	var size_y = rect.size.y / tiles.autotile_get_size(id).y
	var tile_array = []
	for x in range(size_x):
		for y in range(size_y):
			var priority = tiles.autotile_get_subtile_priority(id, Vector2(x ,y))
			for p in priority:
				tile_array.append(Vector2(x,y))
	return tile_array[randi() % tile_array.size()]
	
func _set_cell(tilemap, x, y, id):
	tilemap.set_cell(x, y, id, false, false, false, Tiles.get_subtile_with_priority(id,tilemap))


func is_well_tile(loc, direction):
	match direction:
		"UP":
			if object_tiles.get_cellv(loc) == 75 or object_tiles.get_cellv(loc+Vector2(-1,0)) == 75 or object_tiles.get_cellv(loc+Vector2(-2,0)) == 75:
				return true
		"DOWN":
			if object_tiles.get_cellv(loc+Vector2(0,1)) == 75 or object_tiles.get_cellv(loc+Vector2(-1,1)) == 75 or object_tiles.get_cellv(loc+Vector2(-2,1)) == 75:
				return true
		"LEFT":
			if object_tiles.get_cellv(loc+Vector2(-2,0)) == 75 or object_tiles.get_cellv(loc+Vector2(-2,1)) == 75:
				return true
		"RIGHT":
			if object_tiles.get_cellv(loc) == 75 or object_tiles.get_cellv(loc+Vector2(0,1)) == 75:
				return true
	return false

