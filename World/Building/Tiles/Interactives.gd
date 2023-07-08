extends Node

@onready var FurnaceSmoke = load("res://World/Building/Tiles/Attached nodes/furnace_smoke.tscn")

func open_crate(init):
	if not init:
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
		get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
		get_parent().sound_effects.play()
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(1,0))
	
func close_crate():
	get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
	get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	get_parent().sound_effects.play()
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(0,0))


func open_barrel(init):
	if not init:
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/gate/open.mp3")
		get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
		get_parent().sound_effects.play()
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(1,2))

func close_barrel():
	get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/gate/close.mp3")
	get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	get_parent().sound_effects.play()
	get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Vector2i(0,2))


func open_chest(init):
	if not init:
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/chest/open.mp3")
		get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
		get_parent().sound_effects.play()
	match get_parent().direction:
		"down":
			if not init:
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"])
				await get_tree().create_timer(0.2).timeout
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"]+Vector2i(2,0))
				await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["down"]+Vector2i(4,0))
		"up":
			if not init:
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"])
				await get_tree().create_timer(0.2).timeout
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"]+Vector2i(2,0))
				await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["up"]+Vector2i(4,0))
		"left":
			if not init:
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"])
				await get_tree().create_timer(0.2).timeout
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"]+Vector2i(1,0))
				await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["left"]+Vector2i(2,0))
		"right":
			if not init:
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"])
				await get_tree().create_timer(0.2).timeout
				get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"]+Vector2i(-1,0))
				await get_tree().create_timer(0.2).timeout
			get_node("../ObjectTiles").set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles["chest"][get_parent().variety]["right"]+Vector2i(-3,0))

func close_chest():
	get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/chest/closed.mp3")
	get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	get_parent().sound_effects.play()
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


func turn_on_furnace():
	if not get_parent().has_node("FurnaceSmoke"):
		var furnaceSmoke = FurnaceSmoke.instantiate()
		get_parent().call_deferred("add_child", furnaceSmoke)

func turn_off_furnace():
	if get_parent().has_node("FurnaceSmoke"):
		get_parent().get_node("FurnaceSmoke").queue_free()

func toggle_lamp():
	get_parent().opened_or_light_toggled = not get_parent().opened_or_light_toggled
	MapData.world[Util.return_chunk_from_location(get_parent().location)]["placeable"][get_parent().name]["o"] = get_parent().opened_or_light_toggled
	if get_parent().opened_or_light_toggled:
		turn_on_lamp(false)
	else:
		turn_off_lamp()

func turn_on_lamp(init):
	Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety]+Vector2i(1,0))
	get_node("../PointLight2D").set_deferred("enabled", true)

func turn_off_lamp():
	Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety])
	get_node("../PointLight2D").set_deferred("enabled", false)


func toggle_gate():
	get_parent().opened_or_light_toggled = not get_parent().opened_or_light_toggled
	MapData.world[Util.return_chunk_from_location(get_parent().location)]["placeable"][get_parent().name]["o"] = get_parent().opened_or_light_toggled
	if get_parent().opened_or_light_toggled:
		open_gate(false)
	else:
		close_gate()

func open_gate(init):
	get_parent().movement_collision.set_deferred("disabled",true)
	match get_parent().item_name:
		"wood gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(4,67))
			else:
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(8,66))
		"stone gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(4,72))
			else:
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(8,71))
		"metal gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(4,77))
			else:
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Vector2i(8,76))

func close_gate():
	get_parent().movement_collision.set_deferred("disabled",false)
	match get_parent().item_name:
		"wood gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["wood gate"]["down"])
			else:
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["wood gate"]["right"])
		"stone gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["stone gate"]["down"])
			else:
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["stone gate"]["right"])
		"metal gate":
			if get_parent().direction == "down" or get_parent().direction == "up":
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["metal gate"]["down"])
			else:
				Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.rotatable_object_atlas_tiles["metal gate"]["right"])


func toggle_fireplace():
	get_parent().opened_or_light_toggled = not get_parent().opened_or_light_toggled
	MapData.world[Util.return_chunk_from_location(get_parent().location)]["placeable"][get_parent().name]["o"] = get_parent().opened_or_light_toggled
	if get_parent().opened_or_light_toggled:
		turn_on_fireplace(false)
	else:
		turn_off_fireplace()

func turn_on_fireplace(init):
	Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety]+Vector2i(2,0))
	get_node("../PointLight2D").set_deferred("enabled", true)
	if not init:
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Fire/start.mp3")
		get_parent().sound_effects.play()
		await get_parent().sound_effects.finished
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Fire/crackle.mp3")
		get_parent().sound_effects.play()
	
func turn_off_fireplace():
	Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_object_atlas_tiles[get_parent().item_name][get_parent().variety])
	get_node("../PointLight2D").set_deferred("enabled", false)
	get_node("../SoundEffects").stop()


func toggle_door():
	get_parent().door_opened = not get_parent().door_opened
	MapData.world[Util.return_chunk_from_location(get_parent().location)]["placeable"][get_parent().name]["o"] = get_parent().door_opened
	if get_parent().door_opened:
		open_door(false)
	else:
		close_door()
		

func open_door(init):
	get_parent().movement_collision.set_deferred("disabled", true)
	if get_parent().direction == "down" or get_parent().direction == "up":
		if not init:
			get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
			get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
			get_parent().sound_effects.play()
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["down"]+Vector2i(2,0))
	else:
		if not init:
			get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorOpen.mp3")
			get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
			get_parent().sound_effects.play()
		Tiles.object_tiles.set_cell(0,get_parent().location+Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"]+Vector2i(3,0))
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"]+Vector2i(1,0))

func close_door():
	get_parent().movement_collision.set_deferred("disabled", false)
	if get_parent().direction == "down" or get_parent().direction == "up":
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
		get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		get_parent().sound_effects.play()
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["down"])
	else:
		get_parent().sound_effects.stream = load("res://Assets/Sound/Sound effects/Door/doorClose.mp3")
		get_parent().sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		get_parent().sound_effects.play()
		Tiles.object_tiles.set_cell(0,get_parent().location+Vector2i(0,-1),0,Vector2i(-1,-1))
		Tiles.object_tiles.set_cell(0,get_parent().location,0,Constants.customizable_rotatable_object_atlas_tiles[get_parent().item_name][get_parent().variety]["right"])
