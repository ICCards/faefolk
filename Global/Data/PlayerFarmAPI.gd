extends Node

onready var valid_object_tiles 
onready var valid_path_tiles

func reset_cells(name, location): 
	valid_object_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForObjectPlacement")
	valid_path_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForPathPlacement")
	if name == "tree" or name == "tree stump" or name == "ore large":
		valid_object_tiles.set_cellv(location, 0)
		valid_object_tiles.set_cellv(location + Vector2(0, 1), 0)
		valid_object_tiles.set_cellv(location + Vector2(-1, 1), 0)
		valid_object_tiles.set_cellv(location + Vector2(-1, 0), 0)
	elif name == "large wood chest":
		valid_object_tiles.set_cellv(location, 0)
		valid_object_tiles.set_cellv(location + Vector2(1, 0), 0)
	elif name == "wood path" or name == "stone path":
		valid_object_tiles.set_cellv(location, 0)
		valid_path_tiles.set_cellv(location, 0)
	else: 
		valid_object_tiles.set_cellv(location, 0)


### Nature
# Name // Variety // Location // If grown tree or large ore
var player_farm_objects = []
func remove_farm_object(pos):
	for i in range(player_farm_objects.size()):
		if player_farm_objects[i][2] == pos:
			reset_cells(player_farm_objects[i][0], player_farm_objects[i][2])
			player_farm_objects.remove(i)
			return
	
# For large ore or trees
func set_farm_object_break(pos):
	for i in range(player_farm_objects.size() - 1):
		if player_farm_objects[i][2] == pos:
			player_farm_objects[i][3] = false

### Planted crops
# Name // Location // IsWatered // DaysUntilHarvest // IsInRegrowthPhase // IsDead
var planted_crops = []
func advance_day():
	for i in range(planted_crops.size()):
		if planted_crops[i][2]:
			planted_crops[i][2] = false
			if planted_crops[i][3] != 0:
				planted_crops[i][3] -= 1
			
func add_watered_tile(location):
	for i in range(planted_crops.size()):
		if planted_crops[i][1] == location:
			planted_crops[i][2] = true
			return
			
func remove_crop(location):
	for i in range(planted_crops.size()):
		if planted_crops[i][1] == location:
			print('remove')
			planted_crops.remove(i)
			return

func set_crop_regrowth_phase(name, location):
	for i in range(planted_crops.size()):
		if planted_crops[i][1] == location:
			planted_crops[i][3] = JsonData.crop_data[name]["Regrowth"]
			planted_crops[i][4] = true
			return

func set_crop_dead(location):
	for i in range(planted_crops.size()):
		if planted_crops[i][1] == location:
			planted_crops[i][5] = true
			return


### Placable paths
# Name // Variety // Location
var player_placable_paths = []

func remove_path_object(pos):
	for i in range(player_placable_paths.size()):
		if player_placable_paths[i][2] == pos:
			reset_cells(player_placable_paths[i][0], player_placable_paths[i][2])
			player_placable_paths.remove(i)
			return

### Placable objects	
# Name // Location 
var player_placable_objects = [
	["wood barrel", Vector2(27, 14)],
	["wood box", Vector2(31, 14)],
	["wood box", Vector2(32, 14)],
	["wood fence", Vector2(29, 16)],
	["wood fence", Vector2(28, 16)],
	["wood fence", Vector2(27, 16)],
	["wood fence", Vector2(26, 16)],
	["wood fence", Vector2(25, 16)],
	["wood fence", Vector2(24, 16)],
	["wood fence", Vector2(23, 16)],
	["wood fence", Vector2(22, 16)],
	["wood fence", Vector2(21, 16)],
	["wood fence", Vector2(21, 15)],
	["wood fence", Vector2(21, 14)],
	["wood fence", Vector2(21, 13)],
	["wood fence", Vector2(21, 12)],
	["wood fence", Vector2(21, 11)],
	["wood fence", Vector2(21, 10)],
	["wood fence", Vector2(21, 9)],
	["wood fence", Vector2(22, 9)],
	["wood fence", Vector2(23, 9)],
	["wood fence", Vector2(24, 9)],
	["wood fence", Vector2(25, 9)],
	["wood fence", Vector2(26, 9)],
	["wood fence", Vector2(27, 9)],
	["wood fence", Vector2(28, 9)],
	["wood fence", Vector2(29, 9)],
	["wood fence", Vector2(30, 9)],
	["wood fence", Vector2(31, 9)],
	["wood fence", Vector2(32, 9)],
	["wood fence", Vector2(33, 9)],
	["wood fence", Vector2(34, 9)],
	["wood fence", Vector2(34, 10)],
	["wood fence", Vector2(34, 11)],
	["wood fence", Vector2(34, 12)],
	["wood fence", Vector2(34, 13)],
	["wood fence", Vector2(34, 14)],
	["wood fence", Vector2(34, 15)],
	["wood fence", Vector2(34, 16)],
]

func remove_placable_object(pos):
	for i in range(player_placable_objects.size()):
		if player_placable_objects[i][1] == pos:
			reset_cells(player_placable_objects[i][0], player_placable_objects[i][1])
			player_placable_objects.remove(i)
			return



