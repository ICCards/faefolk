extends Node

@onready var FurnaceSmoke = load("res://World/Building/Tiles/Attached nodes/furnace_smoke.tscn")

var is_opening_door: bool = false

func open_crate():
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(1,0))
func close_crate():
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(0,0))

func open_barrel():
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(1,2))
func close_barrel():
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(0,2))


func open_chest():
	match get_parent().direction:
		"down":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"])
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"]+Vector2i(2,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"]+Vector2i(4,0))
		"up":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"])
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"]+Vector2i(2,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"]+Vector2i(4,0))
		"left":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"])
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"]+Vector2i(1,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"]+Vector2i(2,0))
		"right":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"])
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"]+Vector2i(-1,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"]+Vector2i(-3,0))

func close_chest():
	match get_parent().direction:
		"down":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"]+Vector2i(4,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"]+Vector2i(2,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"])
		"up":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"]+Vector2i(4,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"]+Vector2i(2,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"])
		"left":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"]+Vector2i(2,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"]+Vector2i(1,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"])
		"right":
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"]+Vector2i(-3,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"]+Vector2i(-1,0))
			await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"])


func toggle_furnace_smoke(is_active):
	if is_active:
		if not has_node("FurnaceSmoke"):
			var furnaceSmoke = FurnaceSmoke.instantiate()
			call_deferred("add_child", furnaceSmoke)
	else:
		if has_node("FurnaceSmoke"):
			get_node("FurnaceSmoke").queue_free()
	

func toggle_lamp():
	if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety]:
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety]+Vector2i(1,0))
		get_node("../PointLight2D").set_deferred("enabled", true)
	else:
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety])
		get_node("../PointLight2D").set_deferred("enabled", false)

func toggle_fireplace():
	if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety]:
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety]+Vector2i(2,0))
		get_node("../PointLight2D").set_deferred("enabled", true)
		turn_on_fireplace()
	else:
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety])
		get_node("../PointLight2D").set_deferred("enabled", false)
		get_node("../SoundEffects").stop()
#
func toggle_gate():
	match get_parent().item_name:
		"wood gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.rotatable_object_atlas_tiles["wood gate"]["down"]:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(4,67))
					get_parent().movement_collision.set_deferred("disabled",true)
				else:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["wood gate"]["down"])
					get_parent().movement_collision.set_deferred("disabled",false)
			else:
				if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.rotatable_object_atlas_tiles["wood gate"]["right"]:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(8,66))
					get_parent().movement_collision.set_deferred("disabled",true)
				else:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["wood gate"]["right"])
					get_parent().movement_collision.set_deferred("disabled",false)
		"stone gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.rotatable_object_atlas_tiles["stone gate"]["down"]:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(4,72))
					get_parent().movement_collision.set_deferred("disabled",true)
				else:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["stone gate"]["down"])
					get_parent().movement_collision.set_deferred("disabled",false)
			else:
				if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.rotatable_object_atlas_tiles["stone gate"]["right"]:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(8,71))
					get_parent().movement_collision.set_deferred("disabled",true)
				else:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["stone gate"]["right"])
					get_parent().movement_collision.set_deferred("disabled",false)
		"metal gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.rotatable_object_atlas_tiles["metal gate"]["down"]:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(4,77))
					get_parent().movement_collision.set_deferred("disabled",true)
				else:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["metal gate"]["down"])
					get_parent().movement_collision.set_deferred("disabled",false)
			else:
				if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.rotatable_object_atlas_tiles["metal gate"]["right"]:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(8,77))
					get_parent().movement_collision.set_deferred("disabled",true)
				else:
					Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["metal gate"]["right"])
					get_parent().movement_collision.set_deferred("disabled",false)


func turn_on_fireplace():
	get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Fire/start.mp3")
	get_parent().sound_effects.play()
	await get_parent().sound_effects.finished
	get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Fire/crackle.mp3")
	get_parent().sound_effects.play()
	
	
func toggle_door():
	if not is_opening_door:
		is_opening_door = true
		if get_parent().direction == "down" or get_parent().direction == "up":
			if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["down"]: # open door
				get_parent().door_opened = true
				get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
				get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
				get_parent().sound_effects.play()
				get_parent().movement_collision.set_deferred("disabled", true)
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["down"]+Vector2i(2,0))
			else: # close door
				get_parent().door_opened = false
				get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
				get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
				get_parent().sound_effects.play()
				get_parent().movement_collision.set_deferred("disabled", false)
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["down"])
		else:
			if Tiles.object_tiles.get_cell_atlas_coords(0,get_parent().location) == Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"]: # open door
				get_parent().door_opened = true
				get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
				get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
				get_parent().sound_effects.play()
				get_parent().movement_collision.set_deferred("disabled", true)
				Tiles.object_tiles.set_cell(0,get_parent().location+Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"]+Vector2i(3,0))
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"]+Vector2i(1,0))
			else:
				get_parent().door_opened = false
				get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
				get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
				get_parent().sound_effects.play()
				get_parent().movement_collision.set_deferred("disabled", false)
				Tiles.object_tiles.set_cell(0,get_parent().location+Vector2i(0,-1),0,Vector2i(-1,-1))
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"])
	is_opening_door = false
