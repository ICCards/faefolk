extends Node

onready var TorchObject = preload("res://World/Objects/AnimatedObjects/TorchObject.tscn")
onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouse.tscn")

onready var valid_tiles
onready var fence_tiles 
onready var object_tiles
onready var path_tiles 
var rng = RandomNumberGenerator.new()

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
	match item_name:
		"torch":
			var torchObject = TorchObject.instance()
			torchObject.name = str(id)
			torchObject.initialize(location)
			Server.world.call_deferred("add_child", torchObject, true)
			torchObject.position = valid_tiles.map_to_world(location) + Vector2(16, 22)
			valid_tiles.set_cellv(location, -1)
		"wood fence":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = valid_tiles.map_to_world(location) + Vector2(16, 16)
			fence_tiles.set_cellv(location, 0)
			fence_tiles.update_bitmask_region()
			valid_tiles.set_cellv(location, -1)
		"wood barrel":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 0)
			valid_tiles.set_cellv(location, -1)
		"wood box":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 1)
			valid_tiles.set_cellv(location, -1)
		"wood chest":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 2)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"stone chest":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 5)
			valid_tiles.set_cellv(location, -1)
			valid_tiles.set_cellv(location + Vector2(1, 0), -1)
		"house":
			var playerHouseObject = PlayerHouseObject.instance()
			playerHouseObject.name = str(id)
			Server.player_house_position = location
			Server.world.call_deferred("add_child", playerHouseObject, true)
			playerHouseObject.global_position = fence_tiles.map_to_world(location) + Vector2(6,6)
			set_player_house_invalid_tiles(location)
		"wood path1":
			path_tiles.set_cellv(location, 0)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"wood path2":
			path_tiles.set_cellv(location, 1)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path1":
			path_tiles.set_cellv(location, 2)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path2":
			path_tiles.set_cellv(location, 3)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path3":
			path_tiles.set_cellv(location, 4)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path4":
			path_tiles.set_cellv(location, 5)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			Server.world.call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
	
func set_player_house_invalid_tiles(location):
	for x in range(8):
		for y in range(4):
			valid_tiles.set_cellv(location + Vector2(x, -y), -1)

