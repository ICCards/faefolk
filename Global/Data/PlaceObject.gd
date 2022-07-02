extends Node

onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouse.tscn")

onready var valid_tiles
onready var fence_tiles 
onready var object_tiles
onready var path_tiles 
onready var animated_tiles
var rng = RandomNumberGenerator.new()

enum Placables { 
	BARREL, 
	BOX, 
	WOOD_CHEST, 
	STONE_CHEST, 
	CRAFTING_TABLE1, CRAFTING_TABLE2, CRAFTING_TABLE3,
	MACHINE1, MACHINE2, MACHINE3,
	KICTHEN1, KITCHEN2, KITCHEN3,
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
	print("planted seed")
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
	animated_tiles = get_node("/root/World/PlacableTiles/AnimatedTiles")
	
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
		"fire pedestal tall":
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
		"crafting table":
			object_tiles.set_cellv(location, Placables.CRAFTING_TABLE1)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"machine":
			object_tiles.set_cellv(location, Placables.MACHINE1)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"kitchen":
			object_tiles.set_cellv(location, Placables.KICTHEN1)
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


func set_player_house_invalid_tiles(location):
	for x in range(8):
		for y in range(4):
			valid_tiles.set_cellv(location + Vector2(x, -y), -1)

