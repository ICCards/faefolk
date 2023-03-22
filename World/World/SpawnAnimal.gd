extends Node
#
@onready var Bear = load("res://World/Animals/Bear.tscn")
@onready var Bunny = load("res://World/Animals/Bunny.tscn")
@onready var Duck = load("res://World/Animals/Duck.tscn")
@onready var Boar = load("res://World/Animals/Boar.tscn")
@onready var Deer = load("res://World/Animals/Deer.tscn")
@onready var Wolf = load("res://World/Animals/Wolf.tscn")
@onready var BabyBirdBoss = load("res://World/Enemies/BabyBirdBoss.tscn")
@onready var Mob = load("res://World/Enemies/mob.tscn")

@onready var Enemies = get_node("../../Enemies")
var rng = RandomNumberGenerator.new()

var spawn_thread := Thread.new()
var remove_thread := Thread.new()

const NUM_WIND_CURSE_ENEMIES = 25

func _ready():
	PlayerData.connect("play_wind_curse",Callable(self,"spawn_wind_curse_mobs"))


func spawn_wind_curse_mobs():
	for i in range(NUM_WIND_CURSE_ENEMIES):
		var babyBird = BabyBirdBoss.instantiate()
		babyBird.global_position = return_baby_bird_pos()
		Enemies.call_deferred("add_child", babyBird)
		await get_tree().create_timer(3.0).timeout

var radius = Vector2(750,0)
var step = 2 * PI

func return_baby_bird_pos():
	var center = Server.player_node.position
	var spawn_pos = center + radius.rotated(step * (randf_range(1,360)))
	return spawn_pos

func initialize():
	await get_tree().create_timer(2.0).timeout
	spawn_thread.start(Callable(self,"_whoAmI"))
	remove_thread.start(Callable(self,"_whoAmI2"))
	$SpawnAnimalTimer.start()


func _on_spawn_animal_timer_timeout():
	if not spawn_thread.is_started():
		spawn_thread.start(Callable(self,"_whoAmI"))
	if not remove_thread.is_started():
		remove_thread.start(Callable(self,"_whoAmI2"))

func _whoAmI():
	call_deferred("spawn_animals")

func _whoAmI2():
	call_deferred("remove_animals")

func remove_animals():
	for node in Enemies.get_children():
		if Server.world.is_changing_scene:
			var value = remove_thread.wait_to_finish()
			return
		if node.get_children()[1]:
			var player_loc = Server.player_node.position/16
			if player_loc.distance_to(node.get_children()[1].position/16) > Constants.DISTANCE_TO_REMOVE_OBJECT:
				node.call_deferred("queue_free")
				await get_tree().process_frame
	await get_tree().create_timer(2.0).timeout
	var value = remove_thread.wait_to_finish()

func spawn_animals():
	var player_loc = Server.player_node.position / 16
	if Server.world.is_changing_scene:
		var value = spawn_thread.wait_to_finish()
		return
	for id in MapData.world["animal"]:
		var loc = Util.string_to_vector2(MapData.world["animal"][id]["l"])
		if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
			if not Enemies.has_node(id) and MapData.world["animal"].has(id):
				spawn_mob(MapData.world, id)
	print("NUM ANIMALS = " + str(Enemies.get_children().size()) )
	await get_tree().create_timer(1.0).timeout
	var value = spawn_thread.wait_to_finish()

func spawn_mob(map,id):
	var mob = Mob.instantiate()
	mob.name = id
	mob.map = map
	mob.id = id
	Enemies.call_deferred("add_child", mob)




