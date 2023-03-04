extends Node2D

@onready var InteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/interactive_area.tscn")
@onready var CampfireInteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/campfire_interactive_area.tscn")
@onready var BedInteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/bed_interactive_area.tscn")
@onready var FurnaceSmoke = load("res://World/Building/Tiles/Attached nodes/furnace_smoke.tscn")

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var rng := RandomNumberGenerator.new()
var thread := Thread.new()

var location
var item_name
var id
var direction
var variety


var is_player_sitting: bool = false

var temp_health = 3

func _ready():
	if Constants.object_atlas_tiles.keys().has(item_name):
		if Util.isStorageItem(item_name):
			$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Constants.object_atlas_tiles[item_name])
	elif Constants.autotile_object_atlas_tiles.keys().has(item_name):
		pass
	elif Constants.customizable_rotatable_object_atlas_tiles.keys().has(item_name):
		if Util.isStorageItem(item_name):
			$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles[item_name][variety][direction])
	elif Constants.customizable_object_atlas_tiles.keys().has(item_name):
		if Util.isStorageItem(item_name):
			$ObjectTiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety])
	else:
		if Util.isStorageItem(item_name):
			$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Constants.rotatable_object_atlas_tiles[item_name][direction])
	set_dimensions()


func _physics_process(delta):
	if PlayerData.normal_hotbar_mode:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			if item_name == "blueprint" and Server.player_node.current_building_item == "":
				if $Marker2D/Btn.is_hovered():
					Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/grabber.png"))

func set_dimensions():
	rng.randomize()
	item_name = Util.return_adjusted_item_name(item_name)
	$Marker2D.scale = Constants.dimensions_dict[item_name]
	if direction == "left" or direction == "right":
		$Marker2D.position.y = (Constants.dimensions_dict[item_name].x - 1) * -8
	else:
		$Marker2D.position.x = (Constants.dimensions_dict[item_name].x - 1) * 8
	match direction:
		"left":
			$Marker2D.rotation_degrees = 90
		"up":
			$Marker2D.rotation_degrees = 180
		"right":
			$Marker2D.rotation_degrees = 270
	if item_name == "wood chest" or item_name == "stone chest":
		add_interactive_area_node("chest",id)
		if PlayerData.player_data["chests"].has(id):
			pass
		else:
			PlayerData.player_data["chests"][id] = {}
	elif item_name == "crate":
		add_campfire_interactive_area_node("crate", id)
		if PlayerData.player_data["chests"].has(id):
			pass
		else:
			PlayerData.player_data["chests"][id] = {}
	elif item_name == "barrel":
		add_campfire_interactive_area_node("barrel", id)
		if PlayerData.player_data["barrels"].has(id):
			pass
		else:
			PlayerData.player_data["barrels"][id] = {}
	elif item_name == "lamp":
		add_campfire_interactive_area_node("lamp",id)
	elif item_name == "fireplace":
		add_interactive_area_node("fireplace",id)
	elif item_name == "torch":
		$PointLight2D.set_deferred("enabled", true)
	elif item_name == "campfire":
		add_campfire_interactive_area_node("campfire", id)
		$PointLight2D.set_deferred("enabled", true)
		if PlayerData.player_data["campfires"].has(id):
			pass
		else:
			PlayerData.player_data["campfires"][id] = {}
	elif item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3":
		add_interactive_area_node("workbench",id,item_name.left(-1))
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		add_interactive_area_node("stove",id,item_name.right(1))
		if PlayerData.player_data["stoves"].has(id):
			pass
		else:
			PlayerData.player_data["stoves"][id] = {}
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		add_interactive_area_node("grain mill",id,item_name.right(1))
		if PlayerData.player_data["grain_mills"].has(id):
			pass
		else:
			PlayerData.player_data["grain_mills"][id] = {}
	elif item_name == "brewing table #1" or item_name == "brewing table #2" or item_name == "brewing table #3":
		add_interactive_area_node("brewing table",id,item_name.right(1))
		if PlayerData.player_data["brewing_tables"].has(id):
			pass
		else:
			PlayerData.player_data["brewing_tables"][id] = {}
	elif item_name == "furnace":
		add_interactive_area_node("furnace",id)
		if PlayerData.player_data["furnaces"].has(id):
			pass
		else:
			PlayerData.player_data["furnaces"][id] = {}
	elif item_name == "tool cabinet":
		add_interactive_area_node(item_name,id)
		if PlayerData.player_data["chests"].has(id):
			pass
		else:
			PlayerData.player_data["chests"][id] = {}
	elif item_name == "bed":
		add_bed_interactive_area_node()
	elif item_name == "chair":
		add_interactive_area_node("chair",id)


func add_interactive_area_node(object_name,id,level = null):
	var interactiveAreaNode = InteractiveAreaNode.instantiate()
	interactiveAreaNode.object_level = level
	interactiveAreaNode.object_name = object_name
	interactiveAreaNode.name = id
	$Marker2D.call_deferred("add_child", interactiveAreaNode)

func add_campfire_interactive_area_node(object_name,id):
	var campfireInteractiveAreaNode = CampfireInteractiveAreaNode.instantiate()
	campfireInteractiveAreaNode.object_name = object_name
	campfireInteractiveAreaNode.name = id
	$Marker2D.call_deferred("add_child", campfireInteractiveAreaNode)
	
func add_bed_interactive_area_node():
	var bedInteractiveAreaNode = BedInteractiveAreaNode.instantiate()
	bedInteractiveAreaNode.object_name = "bed"
	bedInteractiveAreaNode.name = id
	$Marker2D.call_deferred("add_child", bedInteractiveAreaNode)

func return_adjusted_chair_position(direction):
	match item_name:
		"chair":
			match direction:
				"down":
					return position+Vector2(16,0)
				"up":
					return position+Vector2(16,-32)
				"left":
					return position+Vector2(-4,0)
				"right":
					return position+Vector2(36,0)
		"armchair":
			match direction:
				"down":
					return position+Vector2(32,0)
				"up":
					return position+Vector2(32,-48)
				"left":
					return position+Vector2(8,0)
				"right":
					return position+Vector2(56,0)
		"couch":
			match direction:
				"down":
					if Server.player_node.position.x - 32 > position.x:
						return position+Vector2(64,0)
					else:
						return position+Vector2(32,0)
				"up":
					return position+Vector2(32,-48)
				"left":
					if Server.player_node.position.y + 48 < position.y:
						return position+Vector2(8,-32)
					else:
						return position+Vector2(8,0)
				"right":
					return position+Vector2(56,0)
				

func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if check_if_has_items() and temp_health != 0:
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound",0))
		sound_effects.call_deferred("play")
		$AnimationPlayer.call_deferred("play","shake")
		temp_health -= 1
		$ResetTempHealthTimer.call_deferred("start")
	else:
#		$PointLight2D.set_deferred("enabled", false)
#		$FurnaceSmoke.call_deferred("hide")
		if $Marker2D.has_node(str(id)):
			$Marker2D.get_node(id+ "/CollisionShape2D").set_deferred("disabled", true)
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$Marker2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
		if item_name == "wood chest" or item_name == "stone chest" or item_name == "tool cabinet":
			drop_items_in_chest()
			$SoundEffects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break wood.mp3"))
		elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
			drop_items_in_grain_mill()
			$SoundEffects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
			drop_items_in_stove()
			$SoundEffects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		elif item_name == "furnace":
			drop_items_in_furnace()
			$SoundEffects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		elif item_name == "campfire":
			drop_items_in_campfire()
			$SoundEffects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		else: 
			$SoundEffects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break wood.mp3"))
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -16))
		$SoundEffects.call_deferred("play")
		var dimensions = Constants.dimensions_dict[item_name]
		if direction == "left" or direction == "right":
			Tiles.add_valid_tiles(location, Vector2(dimensions.y, dimensions.x))
		else:
			Tiles.add_valid_tiles(location, dimensions)
		Tiles.object_tiles.erase_cell(0,location)
		InstancedScenes.intitiateItemDrop(item_name, position, 1)
		MapData.remove_placable(id)
		await $SoundEffects.finished
		queue_free()

func check_if_has_items():
	if item_name == "wood chest" or item_name == "stone chest" or item_name == "wood box" or item_name == "tool cabinet":
		return PlayerData.player_data["chests"][id].keys().size() > 0
	elif item_name == "furnace":
		return PlayerData.player_data["furnaces"][id].keys().size() > 0
	elif item_name == "wood barrel":
		return PlayerData.player_data["wood_barrels"][id].keys().size() > 0
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		return PlayerData.player_data["stoves"][id].keys().size() > 0
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		return PlayerData.player_data["grain_mills"][id].keys().size() > 0
	elif item_name == "campfire":
		return PlayerData.player_data["campfires"][id].keys().size() > 0
	return false

func drop_items_in_campfire():
	for item in PlayerData.player_data["campfires"][id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["campfires"][id][item], position)
	PlayerData.player_data["campfires"].erase(id)

func drop_items_in_stove():
	for item in PlayerData.player_data["stoves"][id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["stoves"][id][item], position)
	PlayerData.player_data["stoves"].erase(id)

func drop_items_in_grain_mill():
	for item in PlayerData.player_data["grain_mills"][id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["grain_mills"][id][item], position)
	PlayerData.player_data["grain_mills"].erase(id)

func drop_items_in_chest():
	for item in PlayerData.player_data["chests"][id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["chests"][id][item], position)
	PlayerData.player_data["chests"].erase(id)

func drop_items_in_furnace():
	for item in PlayerData.player_data["furnaces"][id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["furnaces"][id][item], position)
	PlayerData.player_data["furnaces"].erase(id)


func open_crate():
	$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(1,0))
func close_crate():
	$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,0))

func open_barrel():
	$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(1,2))
func close_barrel():
	$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,2))



func open_chest():
	match item_name:
		"wood chest":
			match direction:
				"down":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(2,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(4,12))
				"up":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(6,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(8,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(10,12))
				"left":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(12,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(13,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(14,11))
				"right":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(19,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(18,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(16,11))
		"stone chest":
			match direction:
				"down":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(2,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(4,15))
				"up":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(6,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(8,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(10,15))
				"left":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(12,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(13,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(14,14))
				"right":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(19,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(18,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(16,14))

func close_chest():
	match item_name:
		"wood chest":
			match direction:
				"down":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(4,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(2,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,12))
				"up":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(10,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(8,12))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(6,12))
				"left":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(14,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(13,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(12,11))
				"right":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(16,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(18,11))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(19,11))
		"stone chest":
			match direction:
				"down":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(4,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(2,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,15))
				"up":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(10,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(8,15))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(6,15))
				"left":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(14,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(13,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(12,14))
				"right":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(16,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(18,14))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(19,14))


func toggle_furnace_smoke(is_active):
	print("TOGGLE FURNACE SMOKE")
	if is_active:
		if not has_node("FurnaceSmoke"):
			var furnaceSmoke = FurnaceSmoke.instantiate()
			call_deferred("add_child", furnaceSmoke)
	else:
		if has_node("FurnaceSmoke"):
			get_node("FurnaceSmoke").queue_free()
	

func toggle_lamp():
	if Tiles.object_tiles.get_cell_atlas_coords(0,location) == Constants.customizable_object_atlas_tiles[item_name][variety]:
		Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety]+Vector2i(1,0))
		$PointLight2D.set_deferred("enabled", true)
	else:
		Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety])
		$PointLight2D.set_deferred("enabled", false)

func toggle_fireplace():
	if Tiles.object_tiles.get_cell_atlas_coords(0,location) == Constants.customizable_object_atlas_tiles[item_name][variety]:
		Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety]+Vector2i(2,0))
		$PointLight2D.set_deferred("enabled", true)
		turn_on_fireplace()
	else:
		Tiles.object_tiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety])
		$PointLight2D.set_deferred("enabled", false)
		$SoundEffects.stop()

func turn_on_fireplace():
	$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Fire/start.mp3")
	$SoundEffects.play()
	await $SoundEffects.finished
	$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Fire/crackle.mp3")
	$SoundEffects.play()

func _on_ResetTempHealthTimer_timeout():
	temp_health = 3

func _on_btn_pressed():
	if PlayerData.normal_hotbar_mode:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			if item_name == "blueprint" and Server.player_node.current_building_item == "":
				Tiles.object_tiles.erase_cell(0,location)
				MapData.remove_placable(id)
				Server.player_node.actions.move_placable_object(item_name,location)
				Sounds.play_pick_up_placeable_object()
				queue_free()
	

func _on_btn_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/cursor.png"))
