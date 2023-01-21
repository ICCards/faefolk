extends Node
#
#onready var Bear = load("res://World/Animals/Bear.tscn")
#onready var Bunny = load("res://World/Animals/Bunny.tscn")
#onready var Duck = load("res://World/Animals/Duck.tscn")
#onready var Boar = load("res://World/Animals/Boar.tscn")
#onready var Deer = load("res://World/Animals/Deer.tscn")
#onready var Wolf = load("res://World/Animals/Wolf.tscn")
#
#onready var Enemies = get_node("../../Enemies")
#
#var spawn_thread := Thread.new()
#var remove_thread := Thread.new()
#
#var current_chunks = []
#
##func initialize():
##	yield(get_tree().create_timer(2.0), "timeout")
##	spawn_thread.start(self,"_whoAmI3")
#	#$SpawnAnimalTimer.start()
#
#func _whoAmI3():
#	call_deferred("spawn_all_animals")
#
#func _on_SpawnAnimalTimer_timeout():
#	if not spawn_thread.is_active():
#		current_chunks = get_parent().current_chunks
#		spawn_thread.start(self,"_whoAmI")
##	if not remove_thread.is_active():
##		remove_thread.start(self,"_whoAmI2")
#
#func _whoAmI():
#	call_deferred("spawn_animals")
#
#func _whoAmI2():
#	call_deferred("remove_animals")
#
#
#func remove_animals():
#	for node in Enemies.get_children():
#		if Server.world.is_changing_scene:
#			var value = remove_thread.wait_to_finish()
#			return
#		if is_instance_valid(node):
#			var player_pos = Server.player_node.position
#			if player_pos.distance_to(node.position) > Constants.DISTANCE_TO_SPAWN_OBJECT*32:
#				Enemies.remove_child(node)
#				yield(get_tree().create_timer(0.1), "timeout")
#	yield(get_tree().create_timer(2.0), "timeout")
#	var value = remove_thread.wait_to_finish()
#
#
#func spawn_all_animals():
#	for id in MapData.world["animal"]:
#		spawn_animal(MapData.world, id)
#
#func spawn_animals():
#	var player_loc = Tiles.valid_tiles.world_to_map(Server.player_node.position)
#	for chunk in current_chunks:
#		if Server.world.is_changing_scene:
#			var value = spawn_thread.wait_to_finish()
#			return
#		var map = MapData.return_chunk(chunk[0], chunk.substr(1,-1))
#		for id in map["animal"]:
#			var loc = Util.string_to_vector2(map["animal"][id]["l"])
#			if player_loc.distance_to(loc) < Constants.DISTANCE_TO_SPAWN_OBJECT:
#				if not Enemies.has_node(id) and MapData.world["animal"].has(id):
#					spawn_animal(map, id)
#					yield(get_tree().create_timer(0.1), "timeout")
#	yield(get_tree().create_timer(1.0), "timeout")
#	var value = spawn_thread.wait_to_finish()
#
#
#func spawn_animal(map, id):
#	var animal_name = map["animal"][id]["n"]
#	var location = map["animal"][id]["l"]
#	match animal_name:
#		"bunny":
#			var animal = Bunny.instance()
#			animal.name = id
#			animal.health = map["animal"][id]["h"]
#			animal.variety = map["animal"][id]["v"]
#			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
#			Enemies.call_deferred("add_child", animal)
#		"duck":
#			var animal = Duck.instance()
#			animal.name = id
#			animal.health = map["animal"][id]["h"]
#			animal.variety = map["animal"][id]["v"]
#			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
#			Enemies.call_deferred("add_child", animal)
#		"bear":
#			var animal = Bear.instance()
#			animal.name = id
#			animal.health = map["animal"][id]["h"]
#			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
#			Enemies.call_deferred("add_child", animal)
#		"boar":
#			var animal = Boar.instance()
#			animal.name = id
#			animal.health = map["animal"][id]["h"]
#			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
#			Enemies.call_deferred("add_child", animal)
#		"wolf":
#			var animal = Wolf.instance()
#			animal.name = id
#			animal.health = map["animal"][id]["h"]
#			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
#			Enemies.call_deferred("add_child", animal)
#		"deer":
#			var animal = Deer.instance()
#			animal.name = id
#			animal.health = map["animal"][id]["h"]
#			animal.global_position = Tiles.valid_tiles.map_to_world(location) + Vector2(16, 16)
#			Enemies.call_deferred("add_child", animal)
#	yield(get_tree(), "idle_frame")
#
