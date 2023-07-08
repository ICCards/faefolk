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
var old_navigation_locs = []
var new_navigation_locs = []

@onready var GrassObjects = get_node("../../GrassObjects")
@onready var NatureObjects = get_node("../../NatureObjects")
@onready var ForageObjects = get_node("../../ForageObjects")
@onready var PlaceableObjects = get_node("../../PlaceableObjects")


func initialize():
	place_farming_tiles()
	$SpawnNatureTimer.start()


func place_farming_tiles():
	for chunk in MapData.world:
		for loc in MapData.world[chunk]["tile"].keys():
			get_node("../../FarmingTiles/HoedTiles").set_cells_terrain_connect(0,[loc],0,0)
			if MapData.world[chunk]["tile"][loc] == "w":
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
		var map = MapData.world[chunk] #MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["forage"]:
			var player_loc = Server.player_node.position / 16
			var location = Util.string_to_vector2(map["forage"][id]["l"])
			var type = map["forage"][id]["n"]
			var variety = map["forage"][id]["n"]
			var first_placement =  map["forage"][id]["f"]
			if player_loc.distance_to(location) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not ForageObjects.has_node(id) and MapData.world[chunk]["forage"].has(id):
					PlaceObject.place_forage_in_world(id,variety,location,first_placement)
	var value = forage_thread.wait_to_finish()


func spawn_placeables():
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = placeable_thread.wait_to_finish()
			return
		var map = MapData.world[chunk]
		for id in map["placeable"]:
			var player_loc = Server.player_node.position / 16
			if not PlaceableObjects.has_node(str(id)) and MapData.world[chunk]["placeable"].has(id):
				PlaceObject.place("placeable",id,map["placeable"][id])
				await get_tree().process_frame
		for id in map["crop"]:
			var location = Util.string_to_vector2(map["crop"][id]["l"])
			if not PlaceableObjects.has_node(id) and MapData.world[chunk]["crop"].has(id):
				PlaceObject.place("crop",id,map["crop"][id])
				await get_tree().process_frame
	var value = placeable_thread.wait_to_finish()

#func spawn_crops():
#	for chunk in current_chunks:
#		if Server.world.is_changing_scene:
#			var value = forage_thread.wait_to_finish()
#			return
#		var map = MapData.world[chunk]
#		for id in map["crop"]:
#			if not PlaceableObjects.has_node(id) and MapData.world[chunk]["crop"].has(id):
#				var item_name = map["crop"][id]["n"]
#				var location = Util.string_to_vector2(map["crop"][id]["l"])
#				var days_until_harvest = map["crop"][id]["dh"]
#				var days_without_water = map["crop"][id]["dww"]
#				var regrowth_phase = map["crop"][id]["rp"]
#				PlaceObject.place_seed_in_world(id,item_name,location,days_until_harvest,days_without_water,regrowth_phase)
#		for loc in map["tile"]:
#			Tiles.hoed_tiles.set_cells_terrain_connect(0,[loc],0,0)
#			if map["tile"][loc] == "w":
#				Tiles.watered_tiles.set_cells_terrain_connect(0,[loc],0,0)
#	var value = crop_thread.wait_to_finish()


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
	call_deferred("update_navigation")
	

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
	await get_tree().process_frame
	if not remove_grass_thread.is_started():
		remove_grass_thread.start(Callable(self,"_whoAmI5").bind(null))
	await get_tree().process_frame
	if not trees_thread.is_started():
		trees_thread.start(Callable(self,"_whoAmI2").bind(null))
	await get_tree().process_frame
	if not ores_thread.is_started():
		ores_thread.start(Callable(self,"_whoAmI3").bind(null))
	await get_tree().process_frame
	if not grass_thread.is_started():
		grass_thread.start(Callable(self,"_whoAmI4").bind(null))
	await get_tree().process_frame
	if not forage_thread.is_started():
		forage_thread.start(Callable(self,"_whoAmI6").bind(null))
	await get_tree().process_frame
	if not placeable_thread.is_started():
		placeable_thread.start(Callable(self,"_whoAmI8").bind(null))
	await get_tree().process_frame
	if not remove_placeable_thread.is_started():
		remove_placeable_thread.start(Callable(self,"_whoAmI9").bind(null))
	await get_tree().process_frame
	if not navigation_thread.is_started():
		navigation_thread.start(Callable(self,"_whoAmI7").bind(null))


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
		var map = MapData.world[chunk]  #MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tree"]:
			var loc = Util.string_to_vector2(map["tree"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world[chunk]["tree"].has(id):
					var biome = map["tree"][id]["b"]
					var phase = map["tree"][id]["p"]
					var health = map["tree"][id]["h"]
					var variety = map["tree"][id]["v"]
					PlaceObject.place_tree_in_world(id,variety,loc,biome,health,phase)
					await get_tree().process_frame
		for id in map["log"]:
			var loc = Util.string_to_vector2(map["log"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world[chunk]["log"].has(id):
					var biome = map["log"][id]["b"]
					var variety = map["log"][id]["v"]
					if biome == "desert":
						PlaceObject.place_cactus_in_world(id,variety,loc)
					else:
						PlaceObject.place_log_in_world(id,variety,loc)
					await get_tree().process_frame
		for id in map["stump"]:
			var loc = Util.string_to_vector2(map["stump"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world[chunk]["stump"].has(id):
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
		var map = MapData.world[chunk]
		for id in map["ore_large"]:
			var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world[chunk]["ore_large"].has(id):
					var health = map["ore_large"][id]["h"]
					var variety = map["ore_large"][id]["v"]
					PlaceObject.place_large_ore_in_world(id,variety,loc,health)
					await get_tree().process_frame
		for id in map["ore"]:
			var loc = Util.string_to_vector2(map["ore"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world[chunk]["ore"].has(id):
					var health = map["ore"][id]["h"]
					var variety = map["ore"][id]["v"]
					PlaceObject.place_small_ore_in_world(id,variety,loc,health)
					await get_tree().process_frame
	var value = ores_thread.wait_to_finish()

var count = 0
func spawn_grass():
	var player_loc = Server.player_node.position / 16
	for chunk in current_chunks:
		var map = MapData.world[chunk] # MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tall_grass"]:
			if Server.world.is_changing_scene:
				var value = grass_thread.wait_to_finish()
				return
			var type = map["tall_grass"][id]["n"]
			var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not GrassObjects.has_node(id) and MapData.world[chunk]["tall_grass"].has(id):
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



func update_navigation():
	var player_loc = Vector2i(Server.player_node.position/16)
#	if old_navigation_locs == []: # init
	for y in range(40):
		for x in range(60):
			var loc = player_loc+Vector2i(-30,-20)+Vector2i(x,y)
			old_navigation_locs.append(loc)
#			if Tiles.isValidNavigationTile(loc):
			Tiles.nav_tiles.set_cell(0,loc,0,Vector2i(0,0))
#	else:
#		new_navigation_locs = []
#		for y in range(40):
#			for x in range(60):
#				var loc = player_loc+Vector2i(-30,-20)+Vector2i(x,y)
#				new_navigation_locs.append(loc)
#				if not old_navigation_locs.has(loc):
#					if Tiles.isValidNavigationTile(loc):
#						Tiles.nav_tiles.set_cell(0,loc,0,Vector2i(0,0))
#			await get_tree().process_frame
#		for loc in old_navigation_locs:
#			if not new_navigation_locs.has(loc):
#				Tiles.nav_tiles.set_cell(0,loc,0,Vector2i(-1,-1))
#		old_navigation_locs = new_navigation_locs
	var value = navigation_thread.wait_to_finish()
	
	



