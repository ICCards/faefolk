extends Node

onready var PlantedCrop  = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var BuildingTileObjectHurtBox = preload("res://World/Objects/Tiles/BuildingTileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouse.tscn")
onready var SleepingBag = preload("res://World/Objects/Tiles/SleepingBag.tscn")
onready var DoorFront = preload("res://World/Objects/Tiles/DoorFront.tscn")
onready var DoorSide = preload("res://World/Objects/Tiles/DoubleDoorSide.tscn")
onready var Rug  = preload("res://World/Objects/Misc/Rug.tscn")
onready var Furnace = preload("res://World/Objects/Tiles/FurnaceObject.tscn")


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
	FURNACE_DOWN,
	FURNACE_UP,
	FURNACE_LEFT,
	FURNACE_RIGHT
}

enum Lights {
	null,
	FIRE_PEDESTAL,
	TALL_FIRE_PEDESTAL,
	TORCH,
	CAMPFIRE
}


func place_seed_in_world(id, item_name, location, days):
	Tiles.valid_tiles.set_cellv(location, -1)
	var plantedCrop = PlantedCrop.instance()
	plantedCrop.name = str(id)
	plantedCrop.initialize(item_name, location, JsonData.crop_data[item_name]["DaysToGrow"], false, false)
	Server.world.get_node("Placables").add_child(plantedCrop, true)
	plantedCrop.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0, 16)
	
	
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
			Server.world.get_node("Placables").call_deferred("add_child", object, true)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(16, 16)
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
		"foundation":
			var object = BuildingTileObjectHurtBox.instance()
			object.name = str(id)
			object.location = location
			object.item_name = item_name
			object.tier = "twig"
			Server.world.get_node("Placables").call_deferred("add_child", object, true)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(16, 16)


func place_object_in_world(id, item_name, direction, location):
	var tileObjectHurtBox = TileObjectHurtBox.instance()
	tileObjectHurtBox.name = str(id)
	tileObjectHurtBox.item_name = item_name
	tileObjectHurtBox.location = location
	tileObjectHurtBox.direction = direction
	Server.world.get_node("Placables").call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
	match item_name:
		"furnace":
#			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
#			var furnace = Furnace.instance()
#			furnace.direction = direction
#			furnace.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
#			Server.world.call_deferred("add_child", furnace, true)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 35)
				"up":
					Tiles.object_tiles.set_cellv(location,  39)
				"left":
					Tiles.object_tiles.set_cellv(location, 38)
				"right":
					Tiles.object_tiles.set_cellv(location, 37)
		"tool cabinet":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 30)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location,  31)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 33)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 34)
		"wood door":
			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var object = DoorFront.instance()
			object.location = location
			object.tier = "wood"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"wood door side":
			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var object = DoorSide.instance()
			object.location = location
			object.tier = "wood"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"metal door":
			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var object = DoorFront.instance()
			object.location = location
			object.tier = "metal"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"metal door side":
			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var object = DoorSide.instance()
			object.location = location
			object.tier = "metal"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"armored door":
			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(2,1))
			var object = DoorFront.instance()
			object.location = location
			object.tier = "armored"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"armored door side":
			tileObjectHurtBox.queue_free()
			Tiles.remove_invalid_tiles(location, Vector2(1,2))
			var object = DoorSide.instance()
			object.location = location
			object.tier = "armored"
			object.id = rng.randi_range(0, 10000)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"torch":
			var object = Rug.instance()
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
#			Tiles.remove_invalid_tiles(location, Vector2(1,1))
#			light_tiles.set_cellv(location, Lights.TORCH)
		"campfire":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			Tiles.object_tiles.set_cellv(location, 40)
		"fire pedestal":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			Tiles.light_tiles.set_cellv(location, Lights.FIRE_PEDESTAL)
		"tall fire pedestal":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			Tiles.light_tiles.set_cellv(location, Lights.TALL_FIRE_PEDESTAL)
		"wood fence":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			Tiles.fence_tiles.set_cellv(location, 0)
			Tiles.fence_tiles.update_bitmask_area(location)
		"wood barrel":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			Tiles.object_tiles.set_cellv(location, Placables.BARREL)
		"wood box":
			Tiles.remove_invalid_tiles(location, Vector2(1,1))
			Tiles.object_tiles.set_cellv(location, Placables.BOX)
		"workbench #1":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.WORKBENCH1)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 41)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 43)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 42)
		"workbench #2":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.WORKBENCH2)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 44)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 46)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 45)
		"workbench #3":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.WORKBENCH3)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 47)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 49)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 48)
		"grain mill #1":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.GRAIN_MILL1)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 53)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 54)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 55)
		"grain mill #2":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.GRAIN_MILL2)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 50)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 51)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 52)
		"grain mill #3":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.GRAIN_MILL3)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 56)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 57)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 58)
		"stove #1":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.STOVE1)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 59)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 60)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 61)
		"stove #2":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.STOVE2)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 62)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 63)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 64)
		"stove #3":
			match direction:
				"down":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, Placables.STOVE3)
				"up":
					Tiles.remove_invalid_tiles(location, Vector2(2,1))
					Tiles.object_tiles.set_cellv(location, 65)
				"right":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 66)
				"left":
					Tiles.remove_invalid_tiles(location, Vector2(1,2))
					Tiles.object_tiles.set_cellv(location, 67)
		"sleeping bag":
			var sleepingBag = SleepingBag.instance()
			sleepingBag.direction = direction
			Server.world.add_child(sleepingBag, true)
			sleepingBag.global_position = Tiles.valid_tiles.map_to_world(location) 
			if direction == "up" or direction == "down":
				Tiles.remove_invalid_tiles(location, Vector2(1,2))
			else:
				Tiles.remove_invalid_tiles(location, Vector2(2,1))
		"display table":
			Tiles.fence_tiles.set_cellv(location, 1)
			Tiles.remove_invalid_tiles(location)
			Tiles.fence_tiles.update_bitmask_area(location)


