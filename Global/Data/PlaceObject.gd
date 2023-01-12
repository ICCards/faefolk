extends Node

onready var PlantedCrop  = load("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = load("res://World/Objects/Tiles/TileObjectHurtBox.tscn")
onready var BuildingTileObjectHurtBox = load("res://World/Objects/Tiles/BuildingTileObjectHurtBox.tscn")
onready var PlayerHouseObject = load("res://World/Objects/Farm/PlayerHouse.tscn")
onready var SleepingBag = load("res://World/Objects/Tiles/SleepingBag.tscn")
onready var DoorFront = load("res://World/Objects/Tiles/DoorFront.tscn")
onready var DoorSide = load("res://World/Objects/Tiles/DoubleDoorSide.tscn")
onready var Rug  = load("res://World/Objects/Misc/Rug.tscn")


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

var PlacableObjects 

func place_seed_in_world(id, item_name, location, days):
	PlacableObjects = Server.world.get_node("PlacableObjects")
	Tiles.remove_valid_tiles(location)
	var plantedCrop = PlantedCrop.instance()
	plantedCrop.name = str(id)
	plantedCrop.id = str(id)
	plantedCrop.initialize(item_name, location, days, false, false)
	PlacableObjects.call_deferred("add_child", plantedCrop, true)
	plantedCrop.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0, 16)


func place_building_object_in_world(id, item_name, variety , location):
	PlacableObjects = Server.world.get_node("PlacableObjects")
	rng.randomize()
	match item_name:
		"wall":
			var object = BuildingTileObjectHurtBox.instance()
			object.name = str(id)
			object.location = location
			object.item_name = item_name
			object.tier = variety
			object.id = str(id)
			PlacableObjects.call_deferred("add_child", object, true)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(16, 16)
			Tiles.remove_valid_tiles(location, Vector2(1,1))
		"foundation":
			var object = BuildingTileObjectHurtBox.instance()
			object.name = str(id)
			object.location = location
			object.item_name = item_name
			object.id = str(id)
			object.tier = variety
			PlacableObjects.call_deferred("add_child", object, true)
			object.global_position = Tiles.wall_tiles.map_to_world(location) + Vector2(16, 16)


func remove_valid_tiles(item_name,direction, location):
	item_name = Util.return_adjusted_item_name(item_name)
	if direction == "left" or direction == "right":
		Tiles.remove_valid_tiles(location, Vector2(Constants.dimensions_dict[item_name].y, Constants.dimensions_dict[item_name].x))
	else:
		Tiles.remove_valid_tiles(location, Constants.dimensions_dict[item_name])
		
func place_object_in_world(id, item_name, direction, location):
	PlacableObjects = Server.world.get_node("PlacableObjects")
	var tileObjectHurtBox = TileObjectHurtBox.instance()
	tileObjectHurtBox.name = str(id)
	tileObjectHurtBox.item_name = item_name
	tileObjectHurtBox.location = location
	tileObjectHurtBox.direction = direction
	tileObjectHurtBox.id = id
	PlacableObjects.call_deferred("add_child", tileObjectHurtBox, true)
	tileObjectHurtBox.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
	remove_valid_tiles(item_name, direction, location)
	match item_name:
		"wood gate":
			tileObjectHurtBox.queue_free()
		"round table1":
			Tiles.object_tiles.set_cellv(location, 175)
		"round table2": 
			Tiles.object_tiles.set_cellv(location, 176)
		"round table3":
			Tiles.object_tiles.set_cellv(location, 177)
		"round table4":
			Tiles.object_tiles.set_cellv(location, 178)
		"bed1":
			Tiles.object_tiles.set_cellv(location, 167)
		"bed2":
			Tiles.object_tiles.set_cellv(location, 168)
		"bed3":
			Tiles.object_tiles.set_cellv(location, 169)
		"bed4":
			Tiles.object_tiles.set_cellv(location, 170)
		"bed5":
			Tiles.object_tiles.set_cellv(location, 171)
		"bed6":
			Tiles.object_tiles.set_cellv(location, 172)
		"bed7":
			Tiles.object_tiles.set_cellv(location, 173)
		"bed8":
			Tiles.object_tiles.set_cellv(location, 174)
		"table1":
			if direction == "left" or direction == "right":
				Tiles.object_tiles.set_cellv(location, 159)
			else:
				Tiles.object_tiles.set_cellv(location, 160)
		"table2":
			if direction == "left" or direction == "right":
				Tiles.object_tiles.set_cellv(location, 161)
			else:
				Tiles.object_tiles.set_cellv(location, 162)
		"table3":
			if direction == "left" or direction == "right":
				Tiles.object_tiles.set_cellv(location, 163)
			else:
				Tiles.object_tiles.set_cellv(location, 164)
		"table4":
			if direction == "left" or direction == "right":
				Tiles.object_tiles.set_cellv(location, 165)
			else:
				Tiles.object_tiles.set_cellv(location, 166)
		"large rug1":
			Tiles.object_tiles.set_cellv(location, 135)
		"large rug2":
			Tiles.object_tiles.set_cellv(location, 136)
		"large rug3":
			Tiles.object_tiles.set_cellv(location, 137)
		"large rug4":
			Tiles.object_tiles.set_cellv(location, 138)
		"large rug5":
			Tiles.object_tiles.set_cellv(location, 139)
		"large rug6":
			Tiles.object_tiles.set_cellv(location, 140)
		"large rug7":
			Tiles.object_tiles.set_cellv(location, 141)
		"large rug8":
			Tiles.object_tiles.set_cellv(location, 142)
		"medium rug1":
			Tiles.object_tiles.set_cellv(location, 143)
		"medium rug2":
			Tiles.object_tiles.set_cellv(location, 144)
		"medium rug3":
			Tiles.object_tiles.set_cellv(location, 145)
		"medium rug4":
			Tiles.object_tiles.set_cellv(location, 146)
		"medium rug5":
			Tiles.object_tiles.set_cellv(location, 147)
		"medium rug6":
			Tiles.object_tiles.set_cellv(location, 148)
		"medium rug7":
			Tiles.object_tiles.set_cellv(location, 149)
		"medium rug8":
			Tiles.object_tiles.set_cellv(location, 150)
		"small rug1":
			Tiles.object_tiles.set_cellv(location, 151)
		"small rug2":
			Tiles.object_tiles.set_cellv(location, 152)
		"small rug3":
			Tiles.object_tiles.set_cellv(location, 153)
		"small rug4":
			Tiles.object_tiles.set_cellv(location, 154)
		"small rug5":
			Tiles.object_tiles.set_cellv(location, 155)
		"small rug6":
			Tiles.object_tiles.set_cellv(location, 156)
		"small rug7":
			Tiles.object_tiles.set_cellv(location, 157)
		"small rug8":
			Tiles.object_tiles.set_cellv(location, 158)
		"furnace":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 35)
				"up":
					Tiles.object_tiles.set_cellv(location,  39)
				"left":
					Tiles.object_tiles.set_cellv(location, 38)
				"right":
					Tiles.object_tiles.set_cellv(location, 37)
		"chair1":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 97)
				"up":
					Tiles.object_tiles.set_cellv(location,  98)
				"left":
					Tiles.object_tiles.set_cellv(location, 95)
				"right":
					Tiles.object_tiles.set_cellv(location, 96)
		"chair2":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 101)
				"up":
					Tiles.object_tiles.set_cellv(location,  102)
				"left":
					Tiles.object_tiles.set_cellv(location, 99)
				"right":
					Tiles.object_tiles.set_cellv(location, 100)
		"chair3":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 105)
				"up":
					Tiles.object_tiles.set_cellv(location, 106)
				"left":
					Tiles.object_tiles.set_cellv(location, 103)
				"right":
					Tiles.object_tiles.set_cellv(location, 104)
		"chair4":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 109)
				"up":
					Tiles.object_tiles.set_cellv(location, 110)
				"left":
					Tiles.object_tiles.set_cellv(location, 107)
				"right":
					Tiles.object_tiles.set_cellv(location, 108)
		"chair5":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 113)
				"up":
					Tiles.object_tiles.set_cellv(location, 114)
				"left":
					Tiles.object_tiles.set_cellv(location, 111)
				"right":
					Tiles.object_tiles.set_cellv(location, 112)
		"chair6":
			Tiles.remove_valid_tiles(location)
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 117)
				"up":
					Tiles.object_tiles.set_cellv(location, 118)
				"left":
					Tiles.object_tiles.set_cellv(location, 115)
				"right":
					Tiles.object_tiles.set_cellv(location, 116)
		"dresser":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 76)
				"up":
					Tiles.object_tiles.set_cellv(location,  76)
				"left":
					Tiles.object_tiles.set_cellv(location, 78)
				"right":
					Tiles.object_tiles.set_cellv(location, 77)
		"couch1":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 79)
				"up":
					Tiles.object_tiles.set_cellv(location,  82)
				"left":
					Tiles.object_tiles.set_cellv(location, 81)
				"right":
					Tiles.object_tiles.set_cellv(location, 80)
		"couch2":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 83)
				"up":
					Tiles.object_tiles.set_cellv(location,  84)
				"left":
					Tiles.object_tiles.set_cellv(location, 85)
				"right":
					Tiles.object_tiles.set_cellv(location, 86)
		"couch3":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 87)
				"up":
					Tiles.object_tiles.set_cellv(location,  88)
				"left":
					Tiles.object_tiles.set_cellv(location, 89)
				"right":
					Tiles.object_tiles.set_cellv(location, 90)
		"couch4":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 91)
				"up":
					Tiles.object_tiles.set_cellv(location,  92)
				"left":
					Tiles.object_tiles.set_cellv(location, 93)
				"right":
					Tiles.object_tiles.set_cellv(location, 94)
		"armchair1":
			Tiles.remove_valid_tiles(location, Vector2(2,2))
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 121)
				"up":
					Tiles.object_tiles.set_cellv(location, 122)
				"left":
					Tiles.object_tiles.set_cellv(location, 119)
				"right":
					Tiles.object_tiles.set_cellv(location, 120)
		"armchair2":
			Tiles.remove_valid_tiles(location, Vector2(2,2))
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 125)
				"up":
					Tiles.object_tiles.set_cellv(location, 126)
				"left":
					Tiles.object_tiles.set_cellv(location, 123)
				"right":
					Tiles.object_tiles.set_cellv(location, 124)
		"armchair3":
			Tiles.remove_valid_tiles(location, Vector2(2,2))
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 129)
				"up":
					Tiles.object_tiles.set_cellv(location, 130)
				"left":
					Tiles.object_tiles.set_cellv(location, 127)
				"right":
					Tiles.object_tiles.set_cellv(location, 128)
		"armchair4":
			Tiles.remove_valid_tiles(location, Vector2(2,2))
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 133)
				"up":
					Tiles.object_tiles.set_cellv(location, 134)
				"left":
					Tiles.object_tiles.set_cellv(location, 131)
				"right":
					Tiles.object_tiles.set_cellv(location, 132)
		"stool":
			Tiles.object_tiles.set_cellv(location, 72)
		"table":
			Tiles.object_tiles.set_cellv(location, 74)
		"well":
			Tiles.object_tiles.set_cellv(location, 75)
		"tool cabinet":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 30)
				"up":
					Tiles.object_tiles.set_cellv(location, 31)
				"left":
					Tiles.object_tiles.set_cellv(location, 33)
				"right":
					Tiles.object_tiles.set_cellv(location, 34)
		"wood door":
			tileObjectHurtBox.queue_free()
			var object = DoorFront.instance()
			object.location = location
			object.tier = "wood"
			object.id = str(id)
			object.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
			Server.world.call_deferred("add_child", object, true)
		"wood door side":
			tileObjectHurtBox.queue_free()
			var object = DoorSide.instance()
			object.location = location
			object.tier = "wood"
			object.id = str(id)
			object.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
			PlacableObjects.call_deferred("add_child", object, true)
		"metal door":
			tileObjectHurtBox.queue_free()
			var object = DoorFront.instance()
			object.location = location
			object.tier = "metal"
			object.id = str(id)
			object.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
			PlacableObjects.call_deferred("add_child", object, true)
		"metal door side":
			tileObjectHurtBox.queue_free()
			var object = DoorSide.instance()
			object.location = location
			object.tier = "metal"
			object.id = str(id)
			object.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
			PlacableObjects.call_deferred("add_child", object, true)
		"armored door":
			tileObjectHurtBox.queue_free()
			var object = DoorFront.instance()
			object.location = location
			object.tier = "armored"
			object.id = str(id)
			object.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
			PlacableObjects.call_deferred("add_child", object, true)
		"armored door side":
			tileObjectHurtBox.queue_free()
			var object = DoorSide.instance()
			object.location = location
			object.tier = "armored"
			object.id = str(id)
			object.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(0,32)
			PlacableObjects.call_deferred("add_child", object, true)
		"torch":
			Tiles.remove_valid_tiles(location, Vector2(1,1))
			Tiles.object_tiles.set_cellv(location, 179)
		"campfire":
			Tiles.object_tiles.set_cellv(location, 40)
		"wood fence":
			Tiles.fence_tiles.set_cellv(location, 0)
			Tiles.fence_tiles.update_bitmask_area(location)
		"wood barrel":
			Tiles.object_tiles.set_cellv(location, Placables.BARREL)
		"wood box":
			Tiles.object_tiles.set_cellv(location, Placables.BOX)
		"brewing table #1":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 180)
				"up":
					Tiles.object_tiles.set_cellv(location, 181)
				"right":
					Tiles.object_tiles.set_cellv(location, 182)
				"left":
					Tiles.object_tiles.set_cellv(location, 183)
		"brewing table #2":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 184)
				"up":
					Tiles.object_tiles.set_cellv(location, 185)
				"right":
					Tiles.object_tiles.set_cellv(location, 186)
				"left":
					Tiles.object_tiles.set_cellv(location, 187)
		"brewing table #3":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, 188)
				"up":
					Tiles.object_tiles.set_cellv(location, 189)
				"right":
					Tiles.object_tiles.set_cellv(location, 190)
				"left":
					Tiles.object_tiles.set_cellv(location, 191)
		"workbench #1":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.WORKBENCH1)
				"up":
					Tiles.object_tiles.set_cellv(location, 41)
				"right":
					Tiles.object_tiles.set_cellv(location, 43)
				"left":
					Tiles.object_tiles.set_cellv(location, 42)
		"workbench #2":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.WORKBENCH2)
				"up":
					Tiles.object_tiles.set_cellv(location, 44)
				"right":
					Tiles.object_tiles.set_cellv(location, 46)
				"left":
					Tiles.object_tiles.set_cellv(location, 45)
		"workbench #3":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.WORKBENCH3)
				"up":
					Tiles.object_tiles.set_cellv(location, 47)
				"right":
					Tiles.object_tiles.set_cellv(location, 49)
				"left":
					Tiles.object_tiles.set_cellv(location, 48)
		"grain mill #1":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.GRAIN_MILL1)
				"up":
					Tiles.object_tiles.set_cellv(location, 53)
				"right":
					Tiles.object_tiles.set_cellv(location, 54)
				"left":
					Tiles.object_tiles.set_cellv(location, 55)
		"grain mill #2":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.GRAIN_MILL2)
				"up":
					Tiles.object_tiles.set_cellv(location, 50)
				"right":
					Tiles.object_tiles.set_cellv(location, 51)
				"left":
					Tiles.object_tiles.set_cellv(location, 52)
		"grain mill #3":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.GRAIN_MILL3)
				"up":
					Tiles.object_tiles.set_cellv(location, 56)
				"right":
					Tiles.object_tiles.set_cellv(location, 57)
				"left":
					Tiles.object_tiles.set_cellv(location, 58)
		"stove #1":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.STOVE1)
				"up":
					Tiles.object_tiles.set_cellv(location, 59)
				"right":
					Tiles.object_tiles.set_cellv(location, 60)
				"left":
					Tiles.object_tiles.set_cellv(location, 61)
		"stove #2":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.STOVE2)
				"up":
					Tiles.object_tiles.set_cellv(location, 62)
				"right":
					Tiles.object_tiles.set_cellv(location, 63)
				"left":
					Tiles.object_tiles.set_cellv(location, 64)
		"stove #3":
			match direction:
				"down":
					Tiles.object_tiles.set_cellv(location, Placables.STOVE3)
				"up":
					Tiles.object_tiles.set_cellv(location, 65)
				"right":
					Tiles.object_tiles.set_cellv(location, 66)
				"left":
					Tiles.object_tiles.set_cellv(location, 67)
		"sleeping bag":
			tileObjectHurtBox.queue_free()
			var sleepingBag = SleepingBag.instance()
			sleepingBag.direction = direction
			sleepingBag.location = location
			sleepingBag.id = id
			PlacableObjects.call_deferred("add_child", sleepingBag, true)
			sleepingBag.global_position = Tiles.valid_tiles.map_to_world(location) 
		"display table":
			Tiles.fence_tiles.set_cellv(location, 1)
			Tiles.remove_valid_tiles(location)
			Tiles.fence_tiles.update_bitmask_area(location)


