extends Node2D


onready var miniMap = $Map
var player 
var direction

enum Tiles {
	DIRT,
	GRASS,
	DARK_GRASS,
	WATER
}

func initialize():
	$Map/Player/MiniCam.current = true
	
func set_inactive():
	$Map/Player/MiniCam.current = false


#func _process(delta):
#	player = get_node("/root/World/Players/" + Server.player_id)
#	$Map/Player.position =  player.position
#	set_direction(player.direction)
	
func _process(delta):
	#player = get_node("/root/World/Players/" + Server.player_id)
	$Map/Player.position =  Vector2(100, 100) #player.position
	set_direction("DOWN")

func set_direction(direction):
	match direction:
		"RIGHT":
			$Map/Player.rotation_degrees = 0
		"LEFT":
			$Map/Player.rotation_degrees = 180
		"DOWN":
			$Map/Player.rotation_degrees = 90
		"UP":
			$Map/Player.rotation_degrees = -90

func _ready():
	pass
	buildMap(Server.generated_map)

func buildMap(map):
	for id in map["dirt"]:
		var loc = Util.string_to_vector2(map["dirt"][id]["l"])
		miniMap.set_cellv(loc, Tiles.DIRT)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["dark_grass"]:
		var loc = Util.string_to_vector2(map["dark_grass"][id])
		miniMap.set_cellv(loc , Tiles.GRASS)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["grass"]:
		var loc = Util.string_to_vector2(map["grass"][id])
		miniMap.set_cellv(loc , Tiles.DARK_GRASS)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["water"]:
		var loc = Util.string_to_vector2(map["water"][id])
		miniMap.set_cellv(loc , Tiles.WATER)
	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["tree"]:
#		var loc = Util.string_to_vector2(map["tree"][id]["l"])
#		treeTypes.shuffle()
#		var variety = treeTypes.front()
#		var object = TreeObject.instance()
#		object.health = map["tree"][id]["h"]
#		object.initialize(variety, loc)
#		object.position = sand.map_to_world(loc) + Vector2(0, -8)
#		object.name = id
#		$NatureObjects.add_child(object,true)
#	print("LOADED TREES")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["log"]:
#		var loc = Util.string_to_vector2(map["log"][id]["l"])
#		validTiles.set_cellv(loc, -1)
#		rng.randomize()
#		var variety = rng.randi_range(0, 11)
#		var object = BranchObject.instance()
#		object.name = id
#		object.health = map["log"][id]["h"]
#		object.initialize(variety,loc)
#		object.position = sand.map_to_world(loc) + Vector2(16, 16)
#		$NatureObjects.add_child(object,true)
#	print("LOADED LOGS")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["stump"]:
#		var loc = Util.string_to_vector2(map["stump"][id]["l"])
#		treeTypes.shuffle()
#		var variety = treeTypes.front()
#		var object = StumpObject.instance()
#		object.health = map["stump"][id]["h"]
#		object.name = id
#		object.initialize(variety,loc)
#		object.position = sand.map_to_world(loc) + Vector2(4,0)
#		$NatureObjects.add_child(object,true)
#	print("LOADED STUMPS")
#	get_node("loadingScreen").set_phase("Building ore")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["ore_large"]:
#		var loc = Util.string_to_vector2(map["ore_large"][id]["l"])
#		oreTypes.shuffle()
#		var variety = oreTypes.front()
#		var object = OreObject.instance()
#		object.health = map["ore_large"][id]["h"]
#		object.name = id
#		object.initialize(variety,loc)
#		object.position = sand.map_to_world(loc) 
#		$NatureObjects.add_child(object,true)
#	print("LOADED LARGE OrE")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["ore"]:
#		var loc = Util.string_to_vector2(map["ore"][id]["l"])
#		oreTypes.shuffle()
#		var variety = oreTypes.front()
#		var object = SmallOreObject.instance()
#		object.health = map["ore"][id]["h"]
#		object.name = id
#		object.initialize(variety,loc)
#		object.position = sand.map_to_world(loc) + Vector2(16, 24)
#		$NatureObjects.add_child(object,true)
#	get_node("loadingScreen").set_phase("Building tall grass")
#	yield(get_tree().create_timer(0.5), "timeout")
#	var count = 0
#	for id in map["tall_grass"]:
#		var loc = Util.string_to_vector2(map["tall_grass"][id]["l"])
#		count += 1
#		tall_grass_types.shuffle()
#		var variety = tall_grass_types.front()
#		var object = TallGrassObject.instance()
#		object.name = id
#		object.initialize(variety)
#		object.position = sand.map_to_world(loc) + Vector2(16, 32)
#		$NatureObjects.add_child(object,true)
#		if count == 130:
#			yield(get_tree().create_timer(0.25), "timeout")
#			count = 0
#	get_node("loadingScreen").set_phase("Building flowers")
#	yield(get_tree().create_timer(0.5), "timeout")
#	for id in map["flower"]:
#		var loc = Util.string_to_vector2(map["flower"][id]["l"])
#		var object = FlowerObject.instance()
#		object.position = sand.map_to_world(loc) + Vector2(16, 32)
#		$NatureObjects.add_child(object,true)
