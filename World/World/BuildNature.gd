extends Node


var rng := RandomNumberGenerator.new()
var trees_thread := Thread.new()
var ores_thread := Thread.new()
var grass_thread := Thread.new()
var forage_thread := Thread.new()
var remove_objects_thread := Thread.new()
var remove_grass_thread := Thread.new()
var navigation_thread := Thread.new()
var placeable_thread := Thread.new()
var remove_placeable_thread := Thread.new()
var crop_thread := Thread.new()
var current_chunks = []

@onready var navTiles: TileMap = get_node("../../TerrainTiles/NavigationTiles")
@onready var GrassObjects = get_node("../../GrassObjects")
@onready var NatureObjects = get_node("../../NatureObjects")
@onready var ForageObjects = get_node("../../ForageObjects")
@onready var PlaceableObjects = get_node("../../PlaceableObjects")


func initialize():
	place_farming_tiles()
#	placeable_thread.start(Callable(self,"whoAmIPlaceable").bind(null))
#	crop_thread.start(Callable(self,"whoAmICrop").bind(null))
	$SpawnNatureTimer.start()



func place_farming_tiles():
	for chunk in get_node("../../").world:
		for loc in get_node("../../").world[chunk]["tile"].keys():
			get_node("../../FarmingTiles/HoedTiles").set_cells_terrain_connect(0,[loc],0,0)
			if get_node("../../").world[chunk]["tile"][loc] == "w":
				get_node("../../FarmingTiles/WateredTiles").set_cells_terrain_connect(0,[loc],0,0)


func whoAmIPlaceable(value):
	call_deferred("spawn_placeables")

func whoAmICrop(value):
	call_deferred("spawn_crops")

func spawn_forage():
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = forage_thread.wait_to_finish()
			return
		var map = get_node("../../").world[chunk] #MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["forage"]:
			var player_loc = Server.player_node.position / 16
			var location = map["forage"][id]["l"]
			var type = map["forage"][id]["n"]
			var variety = map["forage"][id]["n"]
			var first_placement =  map["forage"][id]["f"]
			if player_loc.distance_to(location) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not ForageObjects.has_node(id) and get_node("../../").world[chunk]["forage"].has(id):
					PlaceObject.place_forage_in_world(id,variety,location,first_placement)
	var value = forage_thread.wait_to_finish()


func spawn_placeables():
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = forage_thread.wait_to_finish()
			return
		var map = get_node("../../").world[chunk]
		for id in map["placeable"]:
			if not PlaceableObjects.has_node(str(id)) and get_node("../../").world[chunk]["placeable"].has(id):
				PlaceObject.place("placeable",id,map["placeable"][id])
#			var item_name = map["placeable"][id]["n"]
#			var location = map["placeable"][id]["l"]
#			var variety = map["placeable"][id]["v"]
#			var direction = map["placeable"][id]["d"]
#			if not PlaceableObjects.has_node(id):
#				if item_name == "wall" or item_name == "foundation" or item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
#					PlaceObject.place_building_object_in_world(id,item_name,direction,variety,location,map["placeable"][id]["h"])
#				else:
#					PlaceObject.place_object_in_world(id,item_name,direction,location,variety)
	var value = placeable_thread.wait_to_finish()

func spawn_crops():
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = forage_thread.wait_to_finish()
			return
		var map = get_node("../../").world[chunk]
		for id in map["crop"]:
			if not PlaceableObjects.has_node(id) and get_node("../../").world[chunk]["crop"].has(id):
				var item_name = map["crop"][id]["n"]
				var location = map["crop"][id]["l"]
				var days_until_harvest = map["crop"][id]["dh"]
				var days_without_water = map["crop"][id]["dww"]
				var regrowth_phase = map["crop"][id]["rp"]
				PlaceObject.place_seed_in_world(id,item_name,location,days_until_harvest,days_without_water,regrowth_phase)
		for loc in map["tile"]:
			Tiles.hoed_tiles.set_cells_terrain_connect(0,[loc],0,0)
			if map["tile"][loc] == "w":
				Tiles.watered_tiles.set_cells_terrain_connect(0,[loc],0,0)
	var value = crop_thread.wait_to_finish()


func _whoAmI(_value):
	call_deferred("remove_nature")

func _whoAmI5(_value):
	call_deferred("remove_grass")

func _whoAmI2(_value):
	call_deferred("spawn_trees")

func _whoAmI3(_value):
	call_deferred("spawn_ores")

func _whoAmI4(_value):
	call_deferred("spawn_grass")

func _whoAmI6(_value):
	call_deferred("spawn_forage")

func _whoAmI7(_value):
	call_deferred("set_nav")

func _whoAmI8(_value):
	call_deferred("spawn_placeables")
	
func _whoAmI9(_value):
	call_deferred("remove_placeables")


func _on_spawn_nature_timer_timeout():
	if not Server.world.is_changing_scene:
		current_chunks = get_parent().current_chunks
		spawn_nature()

func spawn_nature():
	if not remove_objects_thread.is_started():
		remove_objects_thread.start(Callable(self,"_whoAmI").bind(null))
	if not remove_grass_thread.is_started():
		remove_grass_thread.start(Callable(self,"_whoAmI5").bind(null))
	if not trees_thread.is_started():
		trees_thread.start(Callable(self,"_whoAmI2").bind(null))
	if not ores_thread.is_started():
		ores_thread.start(Callable(self,"_whoAmI3").bind(null))
	if not grass_thread.is_started():
		grass_thread.start(Callable(self,"_whoAmI4").bind(null))
	if not forage_thread.is_started():
		forage_thread.start(Callable(self,"_whoAmI6").bind(null))
	if not navigation_thread.is_started():
		navigation_thread.start(Callable(self,"_whoAmI7").bind(null))
	if not placeable_thread.is_started():
		placeable_thread.start(Callable(self,"_whoAmI8").bind(null))
	if not remove_placeable_thread.is_started():
		remove_placeable_thread.start(Callable(self,"_whoAmI9").bind(null))
#	print("NUM NATURE OBJECTS = " +str(NatureObjects.get_children().size()))
#	print("NUM GRASS OBJECTS = " +str(GrassObjects.get_children().size()))
#	print("NUM FORAGE OBJECTS = " +str(ForageObjects.get_children().size()))


func remove_nature():
	var player_loc = Server.player_node.position/16
	for node in NatureObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_objects_thread.wait_to_finish()
			return
		if is_instance_valid(node) and not node.destroyed:
			if player_loc.distance_to(node.position/16) > Constants.DISTANCE_TO_REMOVE_OBJECT:
				node.call_deferred("queue_free")
				await get_tree().process_frame
	for node in ForageObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_objects_thread.wait_to_finish()
			return
		if is_instance_valid(node):
			if player_loc.distance_to(node.position/16) > Constants.DISTANCE_TO_REMOVE_OBJECT:
				node.call_deferred("queue_free")
				await get_tree().process_frame
	var value = remove_objects_thread.wait_to_finish()

func remove_placeables():
	var player_loc = Server.player_node.position/16
	for node in PlaceableObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_placeable_thread.wait_to_finish()
			return
		if is_instance_valid(node): #and not node.destroyed:
			if player_loc.distance_to(node.position/16) > Constants.DISTANCE_TO_REMOVE_OBJECT:
				node.call_deferred("queue_free")
				await get_tree().process_frame
	var value = remove_placeable_thread.wait_to_finish()

func remove_grass():
	var player_loc = Server.player_node.position/16
	for node in GrassObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_grass_thread.wait_to_finish()
			return
		if is_instance_valid(node) and not node.destroyed:
			if player_loc.distance_to(node.position/16) > Constants.DISTANCE_TO_REMOVE_OBJECT:
				node.call_deferred("queue_free")
				await get_tree().process_frame
	#print("RemOVED GRASS")
	var value = remove_grass_thread.wait_to_finish()

func spawn_trees():
	var player_loc = Server.player_node.position / 16
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = trees_thread.wait_to_finish()
			return
		var map = get_node("../../").world[chunk]  #MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tree"]:
			var loc = map["tree"][id]["l"]
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and get_node("../../").world[chunk]["tree"].has(id):
					var biome = map["tree"][id]["b"]
					var phase = map["tree"][id]["p"]
					var health = map["tree"][id]["h"]
					var variety = map["tree"][id]["v"]
					PlaceObject.place_tree_in_world(id,variety,loc,biome,health,phase)
					await get_tree().process_frame
		for id in map["log"]:
			var loc = map["log"][id]["l"]
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and get_node("../../").world[chunk]["log"].has(id):
					var biome = map["tree"][id]["b"]
					var variety = map["log"][id]["v"]
					if biome == "desert":
						PlaceObject.place_cactus_in_world(id,variety,loc)
					else:
						PlaceObject.place_log_in_world(id,variety,loc)
					await get_tree().process_frame
		for id in map["stump"]:
			var loc = map["stump"][id]["l"]
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and get_node("../../").world[chunk]["stump"].has(id):
					var variety= map["stump"][id]["v"]
					var health = map["stump"][id]["h"]
					PlaceObject.place_stump_in_world(id,variety,loc,health)
					await get_tree().process_frame
	var value = trees_thread.wait_to_finish()

func spawn_ores():
	var player_loc = Server.player_node.position / 16
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = ores_thread.wait_to_finish()
			return
		var map = get_node("../../").world[chunk]
		for id in map["ore_large"]:
			var loc = map["ore_large"][id]["l"]
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and get_node("../../").world[chunk]["ore_large"].has(id):
					var health = map["ore_large"][id]["h"]
					var variety = map["ore_large"][id]["v"]
					PlaceObject.place_large_ore_in_world(id,variety,loc,health)
					await get_tree().process_frame
		for id in map["ore"]:
			var loc = map["ore"][id]["l"]
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and get_node("../../").world[chunk]["ore"].has(id):
					var health = map["ore"][id]["h"]
					var variety = map["ore"][id]["v"]
					PlaceObject.place_small_ore_in_world(id,variety,loc,health)
					await get_tree().process_frame
	var value = ores_thread.wait_to_finish()

var count = 0
func spawn_grass():
	var player_loc = Server.player_node.position / 16
	for chunk in current_chunks:
		var map = get_node("../../").world[chunk] # MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tall_grass"]:
			if Server.world.is_changing_scene:
				var value = grass_thread.wait_to_finish()
				return
			var type = map["tall_grass"][id]["n"]
			var loc = map["tall_grass"][id]["l"]
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not GrassObjects.has_node(id) and get_node("../../").world[chunk]["tall_grass"].has(id):
					Tiles.add_navigation_tiles(loc)
					count += 1
					if type == "weed":
						PlaceObject.place_weed_in_world(id,map["tall_grass"][id]["v"],loc)
					else:
						PlaceObject.place_tall_grass_in_world(id,map["tall_grass"][id]["b"],loc,map["tall_grass"][id]["fh"],map["tall_grass"][id]["bh"])
					if count == 20:
						await get_tree().process_frame
						count = 0
	await get_tree().create_timer(1.0).timeout
	var value = grass_thread.wait_to_finish()


func set_nav():
	pass
	if Server.player_node:
		var player_loc = Server.player_node.position/16
		navTiles.clear()
		for y in range(40):
			for x in range(60):
				var loc = player_loc+Vector2(-30,-20)+Vector2(x,y)
				if Tiles.isValidNavigationTile(loc):
					navTiles.set_cell(0,loc,0,Vector2i(0,0))
		await get_tree().create_timer(0.5).timeout
		var value = navigation_thread.wait_to_finish()


