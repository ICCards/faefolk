extends Node

func validate_tiles(location, dimensions):
	var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	var active = false
	if not active:
		active = true
		for x in range(dimensions.x):
			for y in range(dimensions.y):
				if valid_tiles.get_cellv( Vector2(x, -y) + location) != 0: 
					return false
					break
		return true
		
func remove_nature_invalid_tiles(location, _name = ""):
	var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	if _name == "tree" or _name == "stump" or _name == "large ore":
		valid_tiles.set_cellv(location, -1)
		valid_tiles.set_cellv(location + Vector2(-1, -1), -1 )
		valid_tiles.set_cellv(location + Vector2(-1, 0), -1 )
		valid_tiles.set_cellv(location + Vector2(0, -1), -1)
	elif _name == "tall grass" or _name == "flower":
		valid_tiles.set_cellv(location, 1)
	else:
		valid_tiles.set_cellv(location, -1)


func remove_invalid_tiles(location, dimensions):
	var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cellv(location + Vector2(x, -y), -1)

func reset_valid_tiles(location, item_name):
	var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	var object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
	var path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
	var fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
	valid_tiles.set_cellv(Vector2(location), 0)
	if item_name == "wood chest" or \
	item_name == "stone chest" or \
	item_name == "workbench" or \
	item_name == "grain mill" or \
	item_name == "stove":
		object_tiles.set_cellv(location, -1)
		valid_tiles.set_cellv(Vector2(location + Vector2(1,0)), 0)
	elif item_name == "wood fence":
		fence_tiles.set_cellv(location, -1)
		fence_tiles.update_bitmask_region()
	elif item_name == "wood path" or item_name == "stone path":
		path_tiles.set_cellv(location, -1)
	else:
		object_tiles.set_cellv(location, -1)

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
	elif count == 2:
		if _map.get_cellv(_pos + Vector2(0,1)) != -1 and _map.get_cellv(_pos + Vector2(0,-1)) != -1:
			return false
		elif _map.get_cellv(_pos + Vector2(1,0)) != -1 and _map.get_cellv(_pos + Vector2(-1,0)) != -1:
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


