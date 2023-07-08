extends Node

@onready var Mob = load("res://World/Enemies/mob.tscn")
@onready var Enemies = get_node("../../Enemies")
var rng = RandomNumberGenerator.new()

var spawn_thread := Thread.new()
var remove_thread := Thread.new()

var current_chunks = []


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
		if is_instance_valid(node):
			var player_loc = Server.player_node.position/16
			if player_loc.distance_to(node.get_children()[1].position/16) > Constants.DISTANCE_TO_REMOVE_OBJECT:
				node.call_deferred("queue_free")
				await get_tree().process_frame
		await get_tree().create_timer(0.5).timeout
	var value = remove_thread.wait_to_finish()

func spawn_animals():
	current_chunks = get_parent().current_chunks
	for chunk in current_chunks:
		var player_loc = Server.player_node.position / 16
		if Server.world.is_changing_scene:
			var value = spawn_thread.wait_to_finish()
			return
		for id in MapData.world[chunk]["animal"]:
			if not Enemies.has_node(id) and MapData.world[chunk]["animal"].has(id):
				spawn_mob(chunk, id)
				await get_tree().process_frame
		await get_tree().create_timer(0.5).timeout
	var value = spawn_thread.wait_to_finish()

func spawn_mob(chunk,id):
	var mob = Mob.instantiate()
	mob.name = id
	mob.chunk = chunk
	mob.id = id
	Enemies.call_deferred("add_child", mob)




