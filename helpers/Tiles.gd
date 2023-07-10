extends Node

var valid_tiles: TileMap = null
var nav_tiles: TileMap = null
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
var cave_grass_tiles: TileMap = null
var cave_water_tiles: TileMap = null

var rng = RandomNumberGenerator.new()



func return_atlas_tile_cord(tile_name,id):
	match tile_name:
		"beach":
			return Vector2i(rng.randi_range(50,52),rng.randi_range(24,26))
		"desert":
			if Util.chance(50):
				return Vector2i(rng.randi_range(50,52),rng.randi_range(24,26))
			else:
				return Vector2i(rng.randi_range(48,55),rng.randi_range(37,43))
		"plains":
			match id:
				0:
					if Util.chance(50):
						return Vector2i(rng.randi_range(30,32),rng.randi_range(17,19))
					else:
						return Vector2i(rng.randi_range(38,47),rng.randi_range(28,35))
				1:
					return Vector2i(24,14)
				2:
					return Vector2i(25,14)
				3:
					return Vector2i(25,15)
				4:
					return Vector2i(24,15)
				5:
					return Vector2i(rng.randi_range(30,32),16)
				6:
					return Vector2i(33,rng.randi_range(17,19))
				7:
					return Vector2i(rng.randi_range(30,32),20)
				8:
					return Vector2i(29,rng.randi_range(17,19))
				9:
					return Vector2i(29,16)
				10:
					return Vector2i(33,16)
				11:
					return Vector2i(33,20)
				12:
					return Vector2i(29,20)
		"forest":
			match id:
				0:
					if Util.chance(50):
						return Vector2i(rng.randi_range(30,32),rng.randi_range(24,26))
					else:
						return Vector2i(rng.randi_range(38,47),rng.randi_range(37,43))
				1:
					return Vector2i(28,21)
				2:
					return Vector2i(29,21)
				3:
					return Vector2i(29,22)
				4:
					return Vector2i(28,22)
				5:
					return Vector2i(rng.randi_range(30,32),23)
				6:
					return Vector2i(33,rng.randi_range(24,26))
				7:
					return Vector2i(rng.randi_range(30,32),27)
				8:
					return Vector2i(29,rng.randi_range(24,26))
				9:
					return Vector2i(29,23)
				10:
					return Vector2i(33,23)
				11:
					return Vector2i(33,27)
				12:
					return Vector2i(29,27)
		"dirt":
			match id:
				0:
					if Util.chance(2):
						return Vector2i(rng.randi_range(40,43),rng.randi_range(0,1))
					if Util.chance(50):
						return Vector2i(rng.randi_range(40,42),rng.randi_range(17,19))
					else:
						return Vector2i(rng.randi_range(48,55),rng.randi_range(28,35))
				1:
					return Vector2i(34,14)
				2:
					return Vector2i(35,14)
				3:
					return Vector2i(35,15)
				4:
					return Vector2i(34,15)
				5:
					return Vector2i(rng.randi_range(40,42),23)
				6:
					return Vector2i(43,rng.randi_range(17,19))
				7:
					return Vector2i(rng.randi_range(40,42),20)
				8:
					return Vector2i(39,rng.randi_range(17,19))
				9:
					return Vector2i(39,16)
				10:
					return Vector2i(43,16)
				11:
					return Vector2i(43,20)
				12:
					return Vector2i(39,20)
		"snow":
			match id:
				0:
					if Util.chance(2):
						return Vector2i(rng.randi_range(40,43),rng.randi_range(0,1))
					if Util.chance(50):
						return Vector2i(rng.randi_range(40,42),rng.randi_range(17,19))
					else:
						return Vector2i(rng.randi_range(48,55),rng.randi_range(28,35))
				1:
					return Vector2i(34,14)
				2:
					return Vector2i(35,14)
				3:
					return Vector2i(35,15)
				4:
					return Vector2i(34,15)
				5:
					return Vector2i(rng.randi_range(40,42),23)
				6:
					return Vector2i(43,rng.randi_range(17,19))
				7:
					return Vector2i(rng.randi_range(40,42),20)
				8:
					return Vector2i(39,rng.randi_range(17,19))
				9:
					return Vector2i(39,16)
				10:
					return Vector2i(43,16)
				11:
					return Vector2i(43,20)
				12:
					return Vector2i(39,20)
		"wet_sand":
			match id:
				0:
					return Vector2i(rng.randi_range(59,60),rng.randi_range(25,26))
				1:
					return Vector2i(54,22)
				2:
					return Vector2i(55,22)
				3:
					return Vector2i(55,23)
				4:
					return Vector2i(54,23)
				5:
					return Vector2i(rng.randi_range(59,60),24)
				6:
					return Vector2i(61,rng.randi_range(25,26))
				7:
					return Vector2i(rng.randi_range(59,60),27)
				8:
					return Vector2i(58,rng.randi_range(25,26))
				9:
					return Vector2i(58,24)
				10:
					return Vector2i(61,24)
				11:
					return Vector2i(61,27)
				12:
					return Vector2i(58,27)
				null:
					return Vector2i(rng.randi_range(50,52),rng.randi_range(24,26))
		"ocean":
			match id:
				0:
					return Vector2i(-1,-1)
				1:
					return Vector2i(25,63)
				2:
					return Vector2i(26,63)
				3:
					return Vector2i(26,64)
				4:
					return Vector2i(25,64)
				5:
					return Vector2i(26,60)
				6:
					return Vector2i(27,61)
				7:
					return Vector2i(26,62)
				8:
					return Vector2i(25,61)
				9:
					return Vector2i(25,60)
				10:
					return Vector2i(27,60)
				11:
					return Vector2i(27,62)
				12:
					return Vector2i(25,62)
		"deep_ocean":
			match id:
				0:
					return Vector2i(26,56)
				1:
					return Vector2i(25,58)
				2:
					return Vector2i(25,56)
				3:
					return Vector2i(27,56)
				4:
					return Vector2i(25,56)
				5:
					return Vector2i(rng.randi_range(26,27),57)
				6:
					return Vector2i(25,57)
				7:
					return Vector2i(rng.randi_range(25,26),59)
				8:
					return Vector2i(27,rng.randi_range(58,59))
			return Vector2i(26,58)
	return Vector2i(-1,-1)
#				9:
#					return Vector2i(25,60)
#				10:
#					return Vector2i(27,60)
#				11:
#					return Vector2i(27,62)
#				12:
#					return Vector2i(25,62)
			
	


func validate_forest_tiles(location):
	var active = false
	if not active:
		active = true
		for x in range(2):
			for y in range(2):
				if not valid_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Constants.VALID_TILE_ATLAS_CORD or valid_tiles.local_to_map(Server.player_node.position) == Vector2i(x,-y) + location or forest_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Vector2i(-1,-1) or not foundation_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Vector2i(-1,-1): 
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
#					if not valid_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Constants.VALID_TILE_ATLAS_CORD or \
#					valid_tiles.local_to_map(Server.player_node.position) == Vector2i(x,-y)+location or \
#					Server.player_node.position.distance_to((location+Vector2i(1,1))*16) > Constants.MIN_PLACE_OBJECT_DISTANCE:
#			return true


func validate_foundation_tiles(location, dimensions):
	var active = false
	if not active:
		active = true
		for x in range(dimensions.x):
			for y in range(dimensions.y):
				if foundation_tiles.get_cell_atlas_coords(0,location+Vector2i(x,-y))==Vector2i(-1,-1): #or not valid_tiles.get_cell_atlas_coords(0,Vector2i(x,-y)+location) == Constants.VALID_TILE_ATLAS_CORD: 
					return false
					break
		return true


func isValidNavigationTile(loc) -> bool:
#	if Server.world.name == "Overworld":
#		if wet_sand_tiles.get_cell_atlas_coords(0,loc) != Vector2i(-1,-1) and deep_ocean_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
#			return true
	if valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
		return false
	return true
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,1)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1):
#			return false
#		return true
#	else:
#		if valid_tiles.get_cell_atlas_coords(0,loc) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(-1,0)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(1,0)) == Vector2i(-1,-1):
#			return false
#		elif valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,1)) == Vector2i(-1,-1) and valid_tiles.get_cell_atlas_coords(0,loc+Vector2i(0,-1)) == Vector2i(-1,-1):
#			return false
#		return true

func remove_valid_tiles(location, dimensions = Vector2i(1,1)):
	location = Vector2i(location.x,location.y)
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.erase_cell(0,location+Vector2i(x,-y))
			nav_tiles.erase_cell(0,location+Vector2i(x,-y))

func add_valid_tiles(location, dimensions = Vector2i(1,1)):
	location = Vector2i(location.x,location.y)
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cell(0,location+Vector2i(x,-y),0,Constants.VALID_TILE_ATLAS_CORD,0)
			nav_tiles.set_cell(0,location+Vector2i(x,-y),0,Constants.VALID_TILE_ATLAS_CORD,0)

func add_navigation_tiles(location, dimensions = Vector2i(1,1)):
	location = Vector2i(location.x,location.y)
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			valid_tiles.set_cell(0,location+Vector2i(x,-y),0,Constants.NAVIGATION_TILE_ATLAS_CORD,0)


func isValidAutoTile(_pos, _map):
	var count = 0
	if _map.get_cell_atlas_coords(0,_pos + Vector2i(0,1)) != Vector2i(-1,-1):
		count += 1
	if _map.get_cell_atlas_coords(0,_pos + Vector2i(0,-1)) != Vector2i(-1,-1):
		count += 1
	if _map.get_cell_atlas_coords(0,_pos + Vector2i(1,0)) != Vector2i(-1,-1):
		count += 1
	if _map.get_cell_atlas_coords(0,_pos + Vector2i(-1,0)) != Vector2i(-1,-1):
		count += 1
	if count <= 1:
		return false
	else:
		if _map.get_cell_atlas_coords(0,_pos + Vector2i(-1,-1)) != Vector2i(-1,-1):
			count += 1
		if _map.get_cell_atlas_coords(0,_pos + Vector2i(-1,1)) != Vector2i(-1,-1):
			count += 1
		if _map.get_cell_atlas_coords(0,_pos + Vector2i(1,-1)) != Vector2i(-1,-1):
			count += 1
		if _map.get_cell_atlas_coords(0,_pos + Vector2i(1,1)) != Vector2i(-1,-1):
			count += 1
		if count == 6:
			if _map.get_cell_atlas_coords(0,_pos + Vector2i(-1,-1)) == Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos + Vector2i(1,1)) == Vector2i(-1,-1):
				return false
			elif _map.get_cell_atlas_coords(0,_pos + Vector2i(1,-1)) == Vector2i(-1,-1) and _map.get_cell_atlas_coords(0,_pos + Vector2i(-1,1)) == Vector2i(-1,-1):
				return false
			elif count == 2:
				return false
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
	
#var array
func return_autotile_id(loc,tiles):
	var array = [0,0,0,0,0,0,0,0]
	if tiles.has(loc+Vector2i(-1,-1)):
		array[0] = 1
	if tiles.has(loc+Vector2i(1,-1)):
		array[1] = 1
	if tiles.has(loc+Vector2i(1,1)):
		array[2] = 1
	if tiles.has(loc+Vector2i(-1,1)):
		array[3] = 1
	if tiles.has(loc+Vector2i(0,-1)):
		array[4] = 1
	if tiles.has(loc+Vector2i(1,0)):
		array[5] = 1
	if tiles.has(loc+Vector2i(0,1)):
		array[6] = 1
	if tiles.has(loc+Vector2i(-1,0)):
		array[7] = 1
	if array == [1,1,1,1,1,1,1,1]:
		return 0 
	elif array == [1,1,0,1,1,1,1,1]: # corners
		return 1
	elif array == [1,1,1,0,1,1,1,1]:
		return 2 
	elif array == [0,1,1,1,1,1,1,1]:
		return 3  
	elif array == [1,0,1,1,1,1,1,1]:
		return 4 
	elif array[2] == 1 and array[3] == 1 and array[5] == 1 and array[6] == 1 and array[7] == 1: # top side
		return 5
	elif array[0] == 1 and array[3] == 1 and array[4] == 1 and array[7] == 1 and array[6] == 1: # right side
		return 6
	elif array[0] == 1 and array[1] == 1 and array[4] == 1 and array[5] == 1 and array[7] == 1: # bottom side
		return 7
	elif array[1] == 1 and array[2] == 1 and array[4] == 1 and array[5] == 1 and array[6] == 1: # left side
		return 8
	elif array[2] == 1 and array[5] == 1 and array[6] == 1: # top left
		return 9
	elif array[3] == 1 and array[6] == 1 and array[7] == 1: # top right
		return 10 
	elif array[0] == 1 and array[4] == 1 and array[7] == 1: # bottom right
		return 11
	elif array[1] == 1 and array[4] == 1 and array[5] == 1: # bottom right
		return 12
	return null #INVALID


func return_elevation_autotile_id(loc,locations):
	if locations.has(loc+Vector2i(1,0)) and locations.has(loc+Vector2i(0,1)): # bottom left
		return 0 
	elif locations.has(loc+Vector2i(1,0)) and locations.has(loc+Vector2i(-1,0)): # bottom middle
		return 1
	elif locations.has(loc+Vector2i(-1,0)) and locations.has(loc+Vector2i(0,1)): # bottom right
		return 2
	elif locations.has(loc+Vector2i(-1,0)) and locations.has(loc+Vector2i(0,-1)): # top left
		return 3
	elif locations.has(loc+Vector2i(1,0)) and locations.has(loc+Vector2i(0,-1)): # top right
		return 4
	elif locations.has(loc+Vector2i(1,0)): # start left
		return 5
	elif locations.has(loc+Vector2i(-1,0)): # start right
		return 6
	
func return_elevation_atlas_tile(elevation,id):
	if id == 5:
		return Vector2i(3,22)
	elif id == 6:
		return Vector2i(2,22)
	match elevation:
		1:
			match id:
				0:
					return Vector2i(0,15)
				1:
					return Vector2i(5,15)
				2:
					return Vector2i(randi_range(1,4),15)
				3:
					return Vector2i(15,15)
				4:
					return Vector2i(16,15)
	return Vector2i(0,0)
