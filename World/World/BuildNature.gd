extends Node

@onready var TreeObject = load("res://World/Objects/Nature/Trees/TreeObject.tscn")
@onready var DesertTree = load("res://World/Objects/Nature/Trees/DesertTree.tscn")
@onready var Log = load("res://World/Objects/Nature/Trees/Log.tscn")
@onready var Stump = load("res://World/Objects/Nature/Trees/Stump.tscn")
@onready var LargeOre = load("res://World/Objects/Nature/Ores/LargeOre.tscn")
@onready var SmallOre = load("res://World/Objects/Nature/Ores/SmallOre.tscn")
@onready var TallGrass = load("res://World/Objects/Nature/Grasses/TallGrass.tscn")
@onready var Weed = load("res://World/Objects/Nature/Grasses/Weed.tscn")

var rng := RandomNumberGenerator.new()
var trees_thread := Thread.new()
var ores_thread := Thread.new()
var grass_thread := Thread.new()
var forage_thread := Thread.new()
var remove_objects_thread := Thread.new()
var remove_grass_thread := Thread.new()
var navigation_thread := Thread.new()
var placable_thread := Thread.new()
var crop_thread := Thread.new()
var current_chunks = []

@onready var navTiles = get_node("../../Node2D/NavTiles")
@onready var GrassObjects = get_node("../../GrassObjects")
@onready var NatureObjects = get_node("../../NatureObjects")
@onready var ForageObjects = get_node("../../ForageObjects")


func initialize():
	await get_tree().idle_frame
	placable_thread.start(Callable(self,"whoAmIPlacable").bind(null))
	crop_thread.start(Callable(self,"whoAmICrop").bind(null))
	$SpawnNatureTimer.start()
	
	
func whoAmIPlacable(value):
	call_deferred("spawn_placables")
	
func whoAmICrop(value):
	call_deferred("spawn_crops")
	
func spawn_forage():
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = forage_thread.wait_to_finish()
			return
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["forage"]:
			var player_loc = Tiles.valid_tiles.local_to_map(Server.player_node.position)
			var location = Util.string_to_vector2(map["forage"][id]["l"])
			var type = map["forage"][id]["n"]
			var variety = map["forage"][id]["n"]
			var first_placement =  map["forage"][id]["f"]
			if player_loc.distance_to(location) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not ForageObjects.has_node(id) and MapData.world["forage"].has(id):
					PlaceObject.place_forage_in_world(id,variety,location,first_placement)
	var value = forage_thread.wait_to_finish()


func spawn_placables():
	for id in MapData.world["placable"]:
		var item_name = MapData.world["placable"][id]["n"]
		var location = Util.string_to_vector2(MapData.world["placable"][id]["l"])
		if item_name == "wall" or item_name == "foundation":
			PlaceObject.place_building_object_in_world(id,item_name,MapData.world["placable"][id]["v"],location,MapData.world["placable"][id]["h"])
		else:
			PlaceObject.place_object_in_world(id,item_name,MapData.world["placable"][id]["d"],location)
	placable_thread.wait_to_finish()

func spawn_crops():
	for id in MapData.world["crop"]:
		var item_name = MapData.world["crop"][id]["n"]
		var location = Util.string_to_vector2(MapData.world["crop"][id]["l"])
		var days_until_harvest = MapData.world["crop"][id]["dh"]
		var days_without_water = MapData.world["crop"][id]["dww"]
		var regrowth_phase = MapData.world["crop"][id]["rp"]
		PlaceObject.place_seed_in_world(id,item_name,location,days_until_harvest,days_without_water,regrowth_phase)
	for id in MapData.world["tile"]:
		var loc = Util.string_to_vector2(id)
		Tiles.hoed_tiles.set_cellv(loc, 0)
		if MapData.world["tile"][id] == "w":
			Tiles.watered_tiles.set_cellv(loc, 0)
		Tiles.hoed_tiles.update_bitmask_region()
		Tiles.watered_tiles.update_bitmask_region()
	crop_thread.wait_to_finish()


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
	

func _on_SpawnNature_timeout():
	if not Server.world.is_changing_scene:
		current_chunks = get_parent().current_chunks
		spawn_nature()

func spawn_nature():
	if not remove_objects_thread.is_alive():
		remove_objects_thread.start(Callable(self,"_whoAmI").bind(null))
	if not remove_grass_thread.is_alive():
		remove_grass_thread.start(Callable(self,"_whoAmI5").bind(null))
	if not trees_thread.is_alive():
		trees_thread.start(Callable(self,"_whoAmI2").bind(null))
	if not ores_thread.is_alive():
		ores_thread.start(Callable(self,"_whoAmI3").bind(null))
	if not grass_thread.is_alive():
		grass_thread.start(Callable(self,"_whoAmI4").bind(null))
	if not forage_thread.is_alive():
		forage_thread.start(Callable(self,"_whoAmI6").bind(null))
	if not navigation_thread.is_alive():
		navigation_thread.start(Callable(self,"_whoAmI7").bind(null))


func remove_nature():
	var player_pos = Server.player_node.position
	for node in NatureObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_objects_thread.wait_to_finish()
			return
		if is_instance_valid(node) and not node.destroyed:
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_REMOVE_OBJECT*32:
				node.call_deferred("remove_from_world")
				await get_tree().idle_frame
	for node in ForageObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_objects_thread.wait_to_finish()
			return
		if is_instance_valid(node):
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_REMOVE_OBJECT*32:
				node.call_deferred("remove_from_world")
				await get_tree().idle_frame
	await get_tree().idle_frame
	var value = remove_objects_thread.wait_to_finish()


func remove_grass():
	var player_pos = Server.player_node.position
	for node in GrassObjects.get_children():
		if Server.world.is_changing_scene:
			var value = remove_grass_thread.wait_to_finish()
			return
		if is_instance_valid(node) and not node.destroyed:
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_REMOVE_OBJECT*32:
				node.call_deferred("remove_from_world")
				await get_tree().idle_frame
	var value = remove_grass_thread.wait_to_finish()

func spawn_trees():
	var player_loc = Tiles.valid_tiles.local_to_map(Server.player_node.position)
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = trees_thread.wait_to_finish()
			return
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tree"]:
			var loc = Util.string_to_vector2(map["tree"][id]["l"]) + Vector2(1,0)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world["tree"].has(id):
					var biome = map["tree"][id]["b"]
					if biome == "desert":
						pass
#						var object = DesertTree.instantiate()
#						var pos = Tiles.valid_tiles.map_to_local(loc)
#						object.health = MapData.world["tree"][id]["h"]
#						object.position = pos + Vector2(0, -8)
#						object.name = id
#						object.location = loc
#						NatureObjects.call_deferred("add_child",object,true)
#						await get_tree().create_timer(0.01).timeout
					else:
						var phase = MapData.world["tree"][id]["p"]
						var health = MapData.world["tree"][id]["h"]
						var variety = MapData.world["tree"][id]["v"]
						PlaceObject.place_tree_in_world(id,variety,loc,biome,health,phase)
						await get_tree().idle_frame
		for id in map["log"]:
			var loc = Util.string_to_vector2(map["log"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world["log"].has(id):
					Tiles.remove_valid_tiles(loc)
					var object = Log.instantiate()
					object.name = id
					object.variety = MapData.world["log"][id]["v"]
					object.location = loc
					object.position = Tiles.valid_tiles.map_to_local(loc) + Vector2(16, 16)
					NatureObjects.call_deferred("add_child",object,true)
					await get_tree().idle_frame
		for id in map["stump"]:
			var loc = Util.string_to_vector2(map["stump"][id]["l"]) + Vector2(1,0)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world["stump"].has(id):
					Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
					var object = Stump.instantiate()
					object.variety = MapData.world["stump"][id]["v"]
					object.location = loc
					object.health = MapData.world["stump"][id]["h"]
					object.name = id
					object.position = Tiles.valid_tiles.map_to_local(loc) + Vector2(4,0)
					NatureObjects.call_deferred("add_child",object,true)
					await get_tree().idle_frame
	await get_tree().idle_frame
	var value = trees_thread.wait_to_finish()

func spawn_ores():
	var player_loc = Tiles.valid_tiles.local_to_map(Server.player_node.position)
	for chunk in current_chunks:
		if Server.world.is_changing_scene:
			var value = ores_thread.wait_to_finish()
			return
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["ore_large"]:
			var loc = Util.string_to_vector2(map["ore_large"][id]["l"]) + Vector2(1,0)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world["ore_large"].has(id):
					Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
					var object = LargeOre.instantiate()
					object.health = MapData.world["ore_large"][id]["h"]
					object.name = id
					if Util.chance(50):
						object.variety = "stone1" 
					else: 
						object.variety = "stone2"  #MapData.world["ore_large"][id]["v"]
					object.location = loc
					object.position = Tiles.valid_tiles.map_to_local(loc) 
					NatureObjects.call_deferred("add_child",object,true)
					await get_tree().idle_frame
		for id in map["ore"]:
			var loc = Util.string_to_vector2(map["ore"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id) and MapData.world["ore"].has(id):
					Tiles.remove_valid_tiles(loc)
					var object = SmallOre.instantiate()
					object.health = map["ore"][id]["h"]
					object.name = id
					#object.variety = MapData.world["ore"][id]["v"]
					if Util.chance(50):
						object.variety = "stone1" 
					else: 
						object.variety = "stone2"
					object.location = loc
					object.position = Tiles.valid_tiles.map_to_local(loc) + Vector2(16, 24)
					NatureObjects.call_deferred("add_child",object,true)
					await get_tree().idle_frame
	await get_tree().idle_frame
	var value = ores_thread.wait_to_finish()

var count = 0
func spawn_grass():
	var player_loc = Tiles.valid_tiles.local_to_map(Server.player_node.position)
	for chunk in current_chunks:
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tall_grass"]:
			if Server.world.is_changing_scene:
				var value = grass_thread.wait_to_finish()
				return
			var type = map["tall_grass"][id]["n"]
			var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not GrassObjects.has_node(id) and MapData.world["tall_grass"].has(id):
					Tiles.add_navigation_tiles(loc)
					count += 1
					if type == "weed":
						var object = Weed.instantiate()
						object.name = id
						object.variety = map["tall_grass"][id]["v"]
						object.location = loc
						object.position = Tiles.valid_tiles.map_to_local(loc) + Vector2(16, 32)
						GrassObjects.call_deferred("add_child",object,true)
					else:
						var object = TallGrass.instantiate()
						object.loc = loc
						object.biome = map["tall_grass"][id]["b"]
						object.name = id
						object.position = Tiles.valid_tiles.map_to_local(loc) + Vector2(8, 32)
						GrassObjects.call_deferred("add_child",object,true)
					if count == 20:
						await get_tree().idle_frame
						count = 0
	await get_tree().create_timer(1.0).timeout
	var value = grass_thread.wait_to_finish()


func set_nav():
	if Server.player_node:
		var player_loc = Tiles.valid_tiles.local_to_map(Server.player_node.position)
		navTiles.call_deferred("clear")
		for y in range(40):
			for x in range(60):
				var loc = player_loc+Vector2(-30,-20)+Vector2(x,y)
				if Tiles.isValidNavigationTile(loc):
					navTiles.call_deferred("set_cellv",loc,0)
					#navTiles.set_cellv(loc,0)
		await get_tree().create_timer(0.5).timeout
		var value = navigation_thread.wait_to_finish()
