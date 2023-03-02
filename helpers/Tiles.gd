extends Node

var valid_tiles: TileMap = null
var path_tiles: TileMap = null
var hoed_tiles: TileMap = null
var watered_tiles: TileMap = null
var ocean_tiles: TileMap = null
var deep_ocean_tiles: TileMap = null
var dirt_tiles: TileMap = null
var forest_tiles: TileMap = null
var wall_tiles: TileMap = null
var selected_wall_tiles: TileMap = null
var foundation_tiles: TileMap = null
var selected_foundation_tiles: TileMap = null
var object_tiles: TileMap = null
var fence_tiles: TileMap = null
var light_tiles: TileMap = null
var wet_sand_tiles: TileMap = null
var cave_wall_tiles: TileMap = null


func validate_forest_tiles(location):
	var active = false
	if not active:
		active = true
		for x in range(2):
			for y in range(2):
				if valid_tiles.get_cellv(Vector2(x,-y)+location) == -1 or valid_tiles.get_cellv(Vector2(x,-y) + location) == 1 or valid_tiles.local_to_map(Server.player_node.position) == Vector2(x,-y) + location or forest_tiles.get_cellv(Vector2(x,-y) + location) == -1 or not foundation_tiles.get_cellv(Vector2(x,-y) + location) == -1: 
					return false
					break
		return true

func validate_tiles(location, dimensions):
	var active = false
	if Server.world.name == "Overworld":
		if not active:
			active = true
			for x in range(dimensions.x):
				for y in range(dimensions.y):
					if not valid_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Constants.VALID_TILE_ATLAS_CORD or \
					hoed_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) != Vector2i(-1,-1) or \
					valid_tiles.local_to_map(Server.player_node.position) == Vector2i(x,-y)+location or \
					Server.player_node.position.distance_to((location+Vector2i(1,1))*16) > Constants.MIN_PLACE_OBJECT_DISTANCE:
						return false
						break
			return true
#	else:
#		if not active:
#			active = true
#			for x in range(dimensions.x):
#				for y in range(dimensions.y):
#					if valid_tiles.get_cellv(Vector2(x,-y)+location) == -1 or valid_tiles.get_cellv(Vector2(x,-y) + location) == 1 or valid_tiles.local_to_map(Server.player_node.position) == Vector2(x,-y) + location: 
#						return false
#						break
#			return true


func validate_foundation_tiles(location, dimensions):
	var active = false
	if not active:
		active = true
		for x in range(dimensions.x):
			for y in range(dimensions.y):
				if foundation_tiles.get_cell_atlas_coords(0,location)==Vector2i(-1,-1) or not valid_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Constants.VALID_TILE_ATLAS_CORD: 
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

func remove_valid_tiles(location, dimensions = Vector2i(1,1)):
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.erase_cell(0,location+Vector2i(x,-y))

func add_valid_tiles(location, dimensions = Vector2i(1,1)):
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cell(0,location+Vector2i(x,-y),0,Constants.VALID_TILE_ATLAS_CORD,0)

func add_navigation_tiles(location, dimensions = Vector2(1,1)):
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cell(0,location+Vector2i(x,-y),0,Constants.NAVIGATION_TILE_ATLAS_CORD,0)


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
			elif count == 2:
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
	if _map.get_cell_atlas_coords(0,_pos+Vector2i(0,1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(1,1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(1,0)) != Vector2i(-1,-1):
		return false
	elif _map.get_cell_atlas_coords(0,_pos+Vector2i(0,-1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(1,-1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(1,0)) != Vector2i(-1,-1):
		return false 
	elif _map.get_cell_atlas_coords(0,_pos+Vector2i(-1,-1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(-1,0)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(0,-1)) != Vector2i(-1,-1):
		return false 
	elif _map.get_cell_atlas_coords(0,_pos+Vector2i(-1,0)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(-1,1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(0,1)) != Vector2i(-1,-1):
		return false 
	return true
	
	
func isCenterBitmaskTile(_pos, _map):
	if _map.get_cell_atlas_coords(0,_pos+Vector2i(0,1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(0,-1)) != Vector2i(-1,-1) and \
	_map.get_cell_atlas_coords(0,_pos+Vector2i(1,0)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(-1,0)) != Vector2i(-1,-1) and \
	_map.get_cell_atlas_coords(0,_pos+Vector2i(1,1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(-1,1)) != Vector2i(-1,-1) and \
	_map.get_cell_atlas_coords(0,_pos+Vector2i(-1,-1)) != Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos+Vector2i(1,-1)) != Vector2i(-1,-1):
		return true
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
#	match direction:
#		"UP":
#			if object_tiles.get_cellv(loc) == 75 or object_tiles.get_cellv(loc+Vector2(-1,0)) == 75 or object_tiles.get_cellv(loc+Vector2(-2,0)) == 75:
#				return true
#		"DOWN":
#			if object_tiles.get_cellv(loc+Vector2(0,1)) == 75 or object_tiles.get_cellv(loc+Vector2(-1,1)) == 75 or object_tiles.get_cellv(loc+Vector2(-2,1)) == 75:
#				return true
#		"LEFT":
#			if object_tiles.get_cellv(loc+Vector2(-2,0)) == 75 or object_tiles.get_cellv(loc+Vector2(-2,1)) == 75:
#				return true
#		"RIGHT":
#			if object_tiles.get_cellv(loc) == 75 or object_tiles.get_cellv(loc+Vector2(0,1)) == 75:
#				return true
	return false

