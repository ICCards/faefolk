extends Node

onready var TreeObject = preload("res://World/Objects/Nature/Trees/TreeObject.tscn")
onready var DesertTree = preload("res://World/Objects/Nature/Trees/DesertTree.tscn")
onready var Log = preload("res://World/Objects/Nature/Trees/Log.tscn")
onready var Stump = preload("res://World/Objects/Nature/Trees/Stump.tscn")
onready var LargeOre = preload("res://World/Objects/Nature/Ores/LargeOre.tscn")
onready var SmallOre = preload("res://World/Objects/Nature/Ores/SmallOre.tscn")
onready var TallGrass = preload("res://World/Objects/Nature/Grasses/TallGrass.tscn")
onready var Weed = preload("res://World/Objects/Nature/Grasses/Weed.tscn")
onready var Flower = preload("res://World/Objects/Nature/Forage/Flower.tscn")

const oreTypes = ["stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "stone1", "stone2", "bronze ore", "iron ore", "bronze ore", "iron ore", "gold ore"]
const treeTypes = ['A','B', 'C', 'D', 'E']
var rng = RandomNumberGenerator.new()

var trees_thread := Thread.new()
var ores_thread := Thread.new()
var grass_thread := Thread.new()
var flower_thread := Thread.new()
var remove_objects_thread := Thread.new()
var remove_grass_thread := Thread.new()
var navigation_thread := Thread.new()
var current_chunks = []

onready var navTiles = get_node("../../Navigation2D/NavTiles")
onready var GrassObjects = get_node("../../GrassObjects")
onready var NatureObjects = get_node("../../NatureObjects")

var is_destroyed: bool = false
	
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
	call_deferred("spawn_flowers")
	
func _whoAmI7(_value):
	call_deferred("set_nav")
	
	
func _whoAmI8(_value):
	call_deferred("set_player_quadrant")

func _on_SpawnNature_timeout():
	if not is_destroyed:
		current_chunks = get_parent().current_chunks
		spawn_nature()
	
func spawn_nature():
	if not remove_objects_thread.is_active():
		remove_objects_thread.start(self, "_whoAmI", null)
	if not remove_grass_thread.is_active():
		remove_grass_thread.start(self, "_whoAmI5", null)
	if not trees_thread.is_active():
		trees_thread.start(self, "_whoAmI2", null)
	if not ores_thread.is_active():
		ores_thread.start(self, "_whoAmI3", null)
	if not grass_thread.is_active():
		grass_thread.start(self, "_whoAmI4", null)
	if not flower_thread.is_active():
		flower_thread.start(self, "_whoAmI6", null)
	if not navigation_thread.is_active():
		navigation_thread.start(self, "_whoAmI7", null)


func remove_nature():
	for node in NatureObjects.get_children():
		if is_destroyed:
			var value = remove_objects_thread.wait_to_finish()
			return
		if is_instance_valid(node):
			var player_pos = Server.player_node.position
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_SPAWN_OBJECT*32:
				NatureObjects.remove_child(node)
				#node.queue_free()
				yield(get_tree().create_timer(0.01), "timeout")
	var value = remove_objects_thread.wait_to_finish()

func remove_grass():
	for node in GrassObjects.get_children():
		if is_destroyed:
			var value = remove_grass_thread.wait_to_finish()
			return
		if is_instance_valid(node):
			var player_pos = Server.player_node.position
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_SPAWN_OBJECT*32:
				GrassObjects.remove_child(node)
				yield(get_tree().create_timer(0.01), "timeout")
	var value = remove_grass_thread.wait_to_finish()

func spawn_trees():
	var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
	for chunk in current_chunks:
		if is_destroyed:
			var value = trees_thread.wait_to_finish()
			return
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tree"]:
			var loc = Util.string_to_vector2(map["tree"][id]["l"]) + Vector2(1,0)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id):
					Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
					var biome = map["tree"][id]["b"]
					if biome == "desert":
						var object = DesertTree.instance()
						var pos = Tiles.valid_tiles.map_to_world(loc)
						object.health = map["tree"][id]["h"]
						object.position = pos + Vector2(0, -8)
						object.name = id
						object.location = loc
						NatureObjects.call_deferred("add_child",object,true)
						yield(get_tree().create_timer(0.01), "timeout")
					else:
						treeTypes.shuffle()
						var object = TreeObject.instance()
						var pos = Tiles.valid_tiles.map_to_world(loc)
						object.biome = biome
						object.health = map["tree"][id]["h"]
						object.variety = treeTypes.front()
						object.location = loc
						object.position = pos + Vector2(0, -8)
						object.name = id
						NatureObjects.call_deferred("add_child",object,true)
						yield(get_tree().create_timer(0.01), "timeout")
		yield(get_tree().create_timer(0.1), "timeout")
		for id in map["log"]:
			var loc = Util.string_to_vector2(map["log"][id]["l"])
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id):
					Tiles.remove_valid_tiles(loc)
					var variety = rng.randi_range(0, 11)
					var object = Log.instance()
					object.name = id
					object.variety = variety
					object.location = loc
					object.position = Tiles.valid_tiles.map_to_world(loc) + Vector2(16, 16)
					NatureObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
		yield(get_tree().create_timer(0.1), "timeout")
		for id in map["stump"]:
			var loc = Util.string_to_vector2(map["stump"][id]["l"]) + Vector2(1,0)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id):
					Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
					treeTypes.shuffle()
					var object = Stump.instance()
					object.variety = treeTypes.front()
					object.location = loc
					object.health = map["stump"][id]["h"]
					object.name = id
					object.position = Tiles.valid_tiles.map_to_world(loc) + Vector2(4,0)
					NatureObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
	var value = trees_thread.wait_to_finish()

func spawn_ores():
	for chunk in current_chunks:
		if is_destroyed:
			var value = ores_thread.wait_to_finish()
			return
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["ore_large"]:
			var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
			var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id):
					Tiles.remove_valid_tiles(loc+Vector2(-1,0), Vector2(2,2))
					oreTypes.shuffle()
					var object = LargeOre.instance()
					object.health = map["ore_large"][id]["h"]
					object.name = id
					object.variety = oreTypes.front()
					object.location = loc
					object.position = Tiles.valid_tiles.map_to_world(loc) 
					NatureObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
		yield(get_tree().create_timer(0.1), "timeout")
		for id in map["ore"]:
			var loc = Util.string_to_vector2(map["ore"][id]["l"])
			var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not NatureObjects.has_node(id):
					Tiles.remove_valid_tiles(loc)
					oreTypes.shuffle()
					var object = SmallOre.instance()
					object.health = map["ore"][id]["h"]
					object.name = id
					object.variety = oreTypes.front()
					object.location = loc
					object.position = Tiles.valid_tiles.map_to_world(loc) + Vector2(16, 24)
					NatureObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
	var value = ores_thread.wait_to_finish()


func spawn_flowers():
	for chunk in current_chunks:
		if is_destroyed:
			var value = flower_thread.wait_to_finish()
			return
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["flower"]:
			var loc = Util.string_to_vector2(map["flower"][id]["l"])
			var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not GrassObjects.has_node(id):
					Tiles.add_navigation_tiles(loc)
					if Util.chance(50):
						var object = Weed.instance()
						object.name = id
						object.location = loc
						object.position = Tiles.valid_tiles.map_to_world(loc) + Vector2(16, 32)
						GrassObjects.call_deferred("add_child",object,true)
					else:
						var object = Flower.instance()
						object.name = id
						object.location = loc
						object.position = Tiles.valid_tiles.map_to_world(loc)
						GrassObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
	var value = flower_thread.wait_to_finish()

func spawn_grass():
	for chunk in current_chunks:
		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
		for id in map["tall_grass"]:
			if is_destroyed:
				var value = grass_thread.wait_to_finish()
				return
			var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
			var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
				if not GrassObjects.has_node(id):
					Tiles.add_navigation_tiles(loc)
					var object = TallGrass.instance()
					object.loc = loc
					object.biome = map["tall_grass"][id]["b"]
					object.name = id
					object.position = Tiles.valid_tiles.map_to_world(loc) + Vector2(8, 32)
					GrassObjects.call_deferred("add_child",object,true)
					yield(get_tree().create_timer(0.01), "timeout")
	var value = grass_thread.wait_to_finish()


func set_nav():
	var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
	navTiles.clear()
	for y in range(40):
		for x in range(60):
			var loc = player_loc+Vector2(-30,-20)+Vector2(x,y)
			if Tiles.isValidNavigationTile(loc):
				#if navTiles.get_cellv(loc) != 0:
				navTiles.set_cellv(loc,0)
#			else:
#				#if navTiles.get_cellv(loc) != -1:
#				navTiles.set_cellv(loc,-1)
	yield(get_tree().create_timer(0.25), "timeout")
	var value = navigation_thread.wait_to_finish()
