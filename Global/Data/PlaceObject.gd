extends Node

onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var BuildingTileObjectHurtBox = preload("res://World/Objects/Tiles/BuildingTileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouse.tscn")
onready var SleepingBag = preload("res://World/Objects/Tiles/SleepingBag.tscn")
onready var TentDown = preload("res://World/Objects/Farm/TentDown.tscn")
onready var TentUp = preload("res://World/Objects/Farm/TentUp.tscn")
onready var TentRight = preload("res://World/Objects/Farm/TentRight.tscn")
onready var TentLeft = preload("res://World/Objects/Farm/TentLeft.tscn")
onready var StoneDoubleDoor = preload("res://World/Objects/Tiles/DoorFront.tscn")
onready var StoneDoubleDoorSide = preload("res://World/Objects/Tiles/DoubleDoorSide.tscn")
onready var Rug  = preload("res://World/Objects/Misc/Rug.tscn")

onready var valid_tiles
onready var fence_tiles 
onready var object_tiles
onready var light_tiles
onready var path_tiles 
onready var foundation_tiles
onready var wall_tiles
onready var building_tiles
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
	null,
	FIRE_PEDESTAL_TALL,
	FIRE_PEDESTAL,
	CAMPFIRE,
	TENT_VERTICAL,
	TENT_HORIZONTAL,
	TENT_ENLARGED,
}

enum Lights {
	null,
	FIRE_PEDESTAL,
	TALL_FIRE_PEDESTAL,
	TORCH,
	CAMPFIRE
}


func place_seed_in_world(id, item_name, location, days):
	valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	valid_tiles.set_cellv(location, -1)
	var plantedCrop = PlantedCrop.instance()
	plantedCrop.name = str(id)
	plantedCrop.initialize(item_name, location, 0, false, false)
	Server.world.add_child(plantedCrop, true)
	plantedCrop.global_position = valid_tiles.map_to_world(location) + Vector2(0, 16)
	
	
func place_building_object_in_world(id, item_name, location):
	rng.randomize()
	match item_name:
		"wall":
			var object = BuildingTileObjectHurtBox.instance()
			object.name = str(id)
			object.location = location
			object.item_name = item_name
			object.tier = "twig"
			object.id = rng.randi_range(0, 10000)
			Server.world.call_deferred("add_child", object, true)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(16, 16)
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
		"door front":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var object = StoneDoubleDoor.instance()
			object.location = location
			object.tier = "wood"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"door side":
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var object = StoneDoubleDoorSide.instance()
			object.location = location
			object.tier = "wood"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"foundation":
			var object = BuildingTileObjectHurtBox.instance()
			object.name = str(id)
			object.location = location
			object.item_name = item_name
			object.tier = "twig"
			Server.world.call_deferred("add_child", object, true)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(16, 16)


func place_object_in_world(id, item_name, location):
	fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
	object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
	light_tiles = get_node("/root/World/PlacableTiles/LightTiles")
	#building_tiles = get_node("/root/World/PlacableTiles/BuildingTiles")
	#wall_tiles = get_node("/root/World/PlacableTiles/WallTiles")
	
	var tileObjectHurtBox = TileObjectHurtBox.instance()
	tileObjectHurtBox.name = str(id)
	tileObjectHurtBox.initialize(item_name, location)
	Server.world.call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
	match item_name:
		"double door":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var object = StoneDoubleDoor.instance()
			object.global_position = fence_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"double door side":
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var object = StoneDoubleDoorSide.instance()
			object.global_position = fence_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"torch":
			var object = Rug.instance()
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
#			Tiles.remove_invalid_tiles(location, Vector2(1,1))
#			light_tiles.set_cellv(location, Lights.TORCH)
		"campfire":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			light_tiles.set_cellv(location, Lights.CAMPFIRE)
		"fire pedestal":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			light_tiles.set_cellv(location, Lights.FIRE_PEDESTAL)
		"tall fire pedestal":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			light_tiles.set_cellv(location, Lights.TALL_FIRE_PEDESTAL)
		"wood fence":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			fence_tiles.set_cellv(location, 0)
			fence_tiles.update_bitmask_area(location)
		"wood barrel":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			object_tiles.set_cellv(location, Placables.BARREL)
		"wood box":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			object_tiles.set_cellv(location, Placables.BOX)
		"wood chest":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.WOOD_CHEST)
		"stone chest":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.STONE_CHEST)
		"house":
			Tiles.remove_invalid_tiles(location, Vector2(8,4))
			var playerHouseObject = PlayerHouseObject.instance()
			playerHouseObject.name = str(id)
			Server.player_house_position = location
			Server.player_house_id = str(id)
			Server.world.get_node("PlacableTiles").call_deferred("add_child", playerHouseObject, true)
			playerHouseObject.global_position = fence_tiles.map_to_world(location) + Vector2(6,6)
		"workbench #1":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.WORKBENCH1)
		"workbench #2":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.WORKBENCH2)
		"workbench #3":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.WORKBENCH3)
		"grain mill #1":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.GRAIN_MILL1)
		"grain mill #2":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.GRAIN_MILL2)
		"grain mill #3":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.GRAIN_MILL3)
		"stove #1":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.STOVE1)
		"stove #2":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.STOVE2)
		"stove #3":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			object_tiles.set_cellv(location, Placables.STOVE3)
		"tent down":
			Tiles.remove_invalid_tiles(location, Vector2(4,4))
			var tent = TentDown.instance()
			tent.name = str(id)
			tent.global_position = fence_tiles.map_to_world(location)
			Server.world.call_deferred("add_child", tent, true)
		"tent up":
			Tiles.remove_invalid_tiles(location, Vector2(4,4))
			var tent = TentUp.instance()
			tent.name = str(id)
			tent.global_position = fence_tiles.map_to_world(location)
			Server.world.call_deferred("add_child", tent, true)
		"tent right":
			Tiles.remove_invalid_tiles(location, Vector2(6,3))
			var tent = TentRight.instance()
			tent.name = str(id)
			tent.global_position = fence_tiles.map_to_world(location)
			Server.world.call_deferred("add_child", tent, true)
		"tent left":
			Tiles.remove_invalid_tiles(location, Vector2(6,3))
			var tent = TentLeft.instance()
			tent.name = str(id)
			tent.global_position = fence_tiles.map_to_world(location)
			Server.world.call_deferred("add_child", tent, true)
		"sleeping bag down":
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var sleepingBag = SleepingBag.instance()
			sleepingBag.direction = "down"
			Server.world.add_child(sleepingBag, true)
			sleepingBag.global_position = valid_tiles.map_to_world(location) 
		"sleeping bag up":
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var sleepingBag = SleepingBag.instance()
			sleepingBag.direction = "up"
			Server.world.add_child(sleepingBag, true)
			sleepingBag.global_position = valid_tiles.map_to_world(location) 
		"sleeping bag right":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var sleepingBag = SleepingBag.instance()
			sleepingBag.direction = "right"
			Server.world.add_child(sleepingBag, true)
			sleepingBag.global_position = valid_tiles.map_to_world(location) 
		"sleeping bag left":
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var sleepingBag = SleepingBag.instance()
			sleepingBag.direction = "left"
			Server.world.add_child(sleepingBag, true)
			sleepingBag.global_position = valid_tiles.map_to_world(location) 

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

