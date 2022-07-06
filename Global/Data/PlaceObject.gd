extends Node

onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouse.tscn")

onready var valid_tiles
onready var fence_tiles 
onready var object_tiles
onready var path_tiles 
var rng = RandomNumberGenerator.new()

enum Placables { 
	BARREL, 
	BOX, 
	WOOD_CHEST, 
	STONE_CHEST, 
	WORKBENCH1, WORKBENCH2, WORKBENCH3,
	GRAIN_MILL1, GRAIN_MILL2, GRAIN_MILL3,
	STOVE1, STOVE2, STOVE3,
	TORCH,
	CAMPFIRE,
	FIRE_PEDESTAL_TALL,
	FIRE_PEDESTAL
}

enum Paths {
	WOOD_PATH1,
	WOOD_PATH2,
	STONE_PATH1,
	STONE_PATH2,
	STONE_PATH3,
	STONE_PATH4
}

func place_seed_in_world(id, item_name, location, days):
	valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")
	valid_tiles.set_cellv(location, -1)
	var plantedCrop = PlantedCrop.instance()
	plantedCrop.name = str(id)
	plantedCrop.initialize(item_name, location, days, false, false)
	Server.world.add_child(plantedCrop, true)
	plantedCrop.global_position = valid_tiles.map_to_world(location) + Vector2(0, 16)

func place_object_in_world(id, item_name, location):
	valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")
	fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
	object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
	path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
	
	var tileObjectHurtBox = TileObjectHurtBox.instance()
	tileObjectHurtBox.name = str(id)
	tileObjectHurtBox.initialize(item_name, location)
	Server.world.call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = valid_tiles.map_to_world(location) + Vector2(16, 16)
	match item_name:
		"torch":
			valid_tiles.set_cellv(location, -1)
			object_tiles.set_cellv(location, Placables.TORCH)
		"campfire":
			valid_tiles.set_cellv(location, -1)
			object_tiles.set_cellv(location, Placables.CAMPFIRE)
		"fire pedestal":
			valid_tiles.set_cellv(location, -1)
			object_tiles.set_cellv(location, Placables.FIRE_PEDESTAL)
		"tall fire pedestal":
			valid_tiles.set_cellv(location, -1)
			object_tiles.set_cellv(location, Placables.FIRE_PEDESTAL_TALL)
		"wood fence":
			fence_tiles.set_cellv(location, 0)
			fence_tiles.update_bitmask_region()
			valid_tiles.set_cellv(location, -1)
		"wood barrel":
			object_tiles.set_cellv(location, Placables.BARREL)
			valid_tiles.set_cellv(location, -1)
		"wood box":
			object_tiles.set_cellv(location, Placables.BOX)
			valid_tiles.set_cellv(location, -1)
		"wood chest":
			object_tiles.set_cellv(location, Placables.WOOD_CHEST)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"stone chest":
			object_tiles.set_cellv(location, Placables.STONE_CHEST)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"house":
			var playerHouseObject = PlayerHouseObject.instance()
			playerHouseObject.name = str(id)
			Server.player_house_position = location
			Server.world.call_deferred("add_child", playerHouseObject, true)
			playerHouseObject.global_position = fence_tiles.map_to_world(location) + Vector2(6,6)
			set_player_house_invalid_tiles(location)
		"workbench":
			print(location)
			object_tiles.set_cellv(location, Placables.WORKBENCH1)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"workbench2":
			object_tiles.set_cellv(location, Placables.WORKBENCH2)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"workbench3":
			object_tiles.set_cellv(location, Placables.WORKBENCH3)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"grain mill":
			object_tiles.set_cellv(location, Placables.GRAIN_MILL1)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"stove":
			object_tiles.set_cellv(location, Placables.STOVE1)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"wood path1":
			path_tiles.set_cellv(location, Paths.WOOD_PATH1)
		"wood path2":
			path_tiles.set_cellv(location, Paths.WOOD_PATH2)
		"stone path1":
			path_tiles.set_cellv(location, Paths.STONE_PATH1)
		"stone path2":
			path_tiles.set_cellv(location, Paths.STONE_PATH2)
		"stone path3":
			path_tiles.set_cellv(location, Paths.STONE_PATH3)
		"stone path4":
			path_tiles.set_cellv(location, Paths.STONE_PATH4)

func upgrade_workbench(player_pos):
	if object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32))) == Placables.WORKBENCH1:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32)), Placables.WORKBENCH2)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32))) == Placables.WORKBENCH1:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32)), Placables.WORKBENCH2)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32))) == Placables.WORKBENCH2:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32)), Placables.WORKBENCH3)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32))) == Placables.WORKBENCH2:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32)), Placables.WORKBENCH3)
		
func upgrade_stove(player_pos):
	if object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32))) == Placables.STOVE1:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32)), Placables.STOVE2)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32))) == Placables.STOVE1:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32)), Placables.STOVE2)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32))) == Placables.STOVE2:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32)), Placables.STOVE3)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32))) == Placables.STOVE2:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32)), Placables.STOVE3)
		
func upgrade_grain_mill(player_pos):
	if object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32))) == Placables.GRAIN_MILL1:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32)), Placables.GRAIN_MILL2)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32))) == Placables.GRAIN_MILL1:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32)), Placables.GRAIN_MILL2)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32))) == Placables.GRAIN_MILL2:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(0, -32)), Placables.GRAIN_MILL3)
	elif object_tiles.get_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32))) == Placables.GRAIN_MILL2:
		object_tiles.set_cellv(valid_tiles.world_to_map(player_pos + Vector2(-32, -32)), Placables.GRAIN_MILL3)

func set_player_house_invalid_tiles(location):
	for x in range(8):
		for y in range(4):
			valid_tiles.set_cellv(location + Vector2(x, -y), -1)

