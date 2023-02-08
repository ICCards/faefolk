extends Node
#
onready var Bear = load("res://World/Animals/Bear.tscn")
onready var Bunny = load("res://World/Animals/Bunny.tscn")
onready var Duck = load("res://World/Animals/Duck.tscn")
onready var Boar = load("res://World/Animals/Boar.tscn")
onready var Deer = load("res://World/Animals/Deer.tscn")
onready var Wolf = load("res://World/Animals/Wolf.tscn")
onready var BabyBirdBoss = load("res://World/Enemies/BabyBirdBoss.tscn")

onready var Enemies = get_node("../../Enemies")

var spawn_thread := Thread.new()
var remove_thread := Thread.new()

const NUM_WIND_CURSE_ENEMIES = 25

func _ready():
	PlayerData.connect("play_wind_curse", self ,"spawn_wind_curse_mobs")



func spawn_wind_curse_mobs():
	for i in range(NUM_WIND_CURSE_ENEMIES):
		var babyBird = BabyBirdBoss.instance()
		babyBird.global_position = return_baby_bird_pos()
		Enemies.call_deferred("add_child", babyBird)
		yield(get_tree().create_timer(3.0), "timeout")

var radius = Vector2(750,0)
var step = 2 * PI

func return_baby_bird_pos():
	var center = Server.player_node.position
	var spawn_pos = center + radius.rotated(step * (rand_range(1,360)))
	return spawn_pos

func initialize():
	yield(get_tree().create_timer(2.0), "timeout")
	spawn_thread.start(self,"_whoAmI")
	remove_thread.start(self,"_whoAmI2")
	$SpawnAnimalTimer.start()


func _on_SpawnAnimalTimer_timeout():
	if not spawn_thread.is_active():
		spawn_thread.start(self,"_whoAmI")
	if not remove_thread.is_active():
		remove_thread.start(self,"_whoAmI2")

func _whoAmI():
	call_deferred("spawn_animals")

func _whoAmI2():
	call_deferred("remove_animals")

func remove_animals():
	for node in Enemies.get_children():
		if Server.world.is_changing_scene:
			var value = remove_thread.wait_to_finish()
			return
		if is_instance_valid(node):
			var player_pos = Server.player_node.position
			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_REMOVE_OBJECT*32:
				node.call_deferred("queue_free")
				yield(get_tree(), "idle_frame")
	yield(get_tree().create_timer(2.0), "timeout")
	var value = remove_thread.wait_to_finish()

func spawn_animals():
	var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
	if Server.world.is_changing_scene:
		var value = spawn_thread.wait_to_finish()
		return
	for id in MapData.world["animal"]:
		var loc = Util.string_to_vector2(MapData.world["animal"][id]["l"])
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not Enemies.has_node(id) and MapData.world["animal"].has(id):
				spawn_animal(MapData.world, id)
	yield(get_tree().create_timer(1.0), "timeout")
	var value = spawn_thread.wait_to_finish()


func spawn_animal(map, id):
	var animal_name = map["animal"][id]["n"]
	var location = map["animal"][id]["l"]
	match animal_name:
		"bunny":
			var animal = Bunny.instance()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.variety = map["animal"][id]["v"]
			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
			Enemies.call_deferred("add_child", animal)
		"duck":
			var animal = Duck.instance()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.variety = map["animal"][id]["v"]
			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
			Enemies.call_deferred("add_child", animal)
		"bear":
			var animal = Bear.instance()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
			Enemies.call_deferred("add_child", animal)
		"boar":
			var animal = Boar.instance()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
			Enemies.call_deferred("add_child", animal)
		"wolf":
			var animal = Wolf.instance()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
			Enemies.call_deferred("add_child", animal)
		"deer":
			var animal = Deer.instance()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
			Enemies.call_deferred("add_child", animal)
	yield(get_tree(), "idle_frame")
#
