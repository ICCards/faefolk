extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var rng := RandomNumberGenerator.new()
var thread := Thread.new()

var location
var item_name
var id
var direction
var is_preset_object_string: String = ""

var is_player_sitting: bool = false

var temp_health = 3

func _ready():
	if Constants.object_atlas_tiles.keys().has(item_name):
		$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Constants.object_atlas_tiles[item_name])
	else:
		$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Constants.rotatable_atlas_tiles[item_name][direction])
	call_deferred("set_dimensions")

func set_dimensions():
	rng.randomize()
	item_name = Util.return_adjusted_item_name(item_name)
	$Marker2D.scale = Constants.dimensions_dict[item_name]
	if item_name == "campfire" or item_name == "torch":
		$PointLight2D.enabled = true
		if item_name == "campfire":
			$Marker2D/CampfireInteractiveArea/CollisionShape2D.disabled = false
			$Marker2D/CampfireInteractiveArea.object_name = "campfire"
			$Marker2D/CampfireInteractiveArea.name = str(id)
			if PlayerData.player_data["campfires"].has(id):
				pass
			else:
				PlayerData.player_data["campfires"][id] = {}
	elif item_name == "wood box":
		$Marker2D/CampfireInteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/CampfireInteractiveArea.object_name = item_name
		$Marker2D/CampfireInteractiveArea.name = str(id)
		if PlayerData.player_data["chests"].has(id):
			pass
		else:
			PlayerData.player_data["chests"][id] = {}
	elif item_name == "wood barrel":
		$Marker2D/CampfireInteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/CampfireInteractiveArea.object_name = item_name
		$Marker2D/CampfireInteractiveArea.name = str(id)
		if PlayerData.player_data["wood_barrels"].has(id):
			pass
		else:
			PlayerData.player_data["wood_barrels"][id] = {}
#	elif item_name == "wood chest" or item_name == "stone chest":
#		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
#		$Marker2D/InteractiveArea.object_name = "chest"
#		$Marker2D/InteractiveArea.object_level = ""
#		$Marker2D/InteractiveArea.name = str(id)
#		if PlayerData.player_data["chests"].has(id):
#			pass
#		else:
#			PlayerData.player_data["chests"][id] = {}
#		match direction:
#			"left":
#				$Marker2D.rotation_degrees = 90
#				if item_name == "wood chest":
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/wood/left.tres")
#				else:
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/stone/Left.tres")
#				$ChestPos/Chest.flip_h = false
#				$ChestPos/Chest.position = Vector2(18,0)
#				$Marker2D.position = Vector2(16, -32)
#				$ChestPos/Chest.position = Vector2(16, -32)
#				Tiles.remove_valid_tiles(location, Vector2(1,2))
#			"right":
#				if item_name == "wood chest":
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/wood/left.tres")
#				else:
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/stone/Left.tres")
#				$ChestPos/Chest.flip_h = true
#				$Marker2D.rotation_degrees = 270
#				$Marker2D.position = Vector2(16, -32)
#				$ChestPos/Chest.position = Vector2(16, -32)
#				Tiles.remove_valid_tiles(location, Vector2(1,2))
#			"up":
#				$Marker2D.position = Vector2(32, -16)
#				$Marker2D.rotation_degrees = 180
#				$ChestPos/Chest.position = Vector2(32,-32)
#				if item_name == "wood chest":
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/wood/up.tres")
#				else:
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/stone/Up.tres")
#				Tiles.remove_valid_tiles(location, Vector2(2,1))
#			"down":
#				$Marker2D.position = Vector2(32, -16)
#				$Marker2D.rotation_degrees = 0
#				$ChestPos/Chest.position = Vector2(32,-32)
#				if item_name == "wood chest":
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/wood/down.tres")
#				else:
#					$ChestPos/Chest.sprite_frames = load("res://Assets/Images/Animations/chest/stone/Down.tres")
#				Tiles.remove_valid_tiles(location, Vector2(2,1))
#		$ChestPos/Chest.animation = "open"
#		$ChestPos/Chest.show()
	elif item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/InteractiveArea.object_name = "workbench"
		$Marker2D/InteractiveArea.object_level = item_name.substr(11)
		$Marker2D/InteractiveArea.name = str(id)
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
				$Marker2D.position = Vector2(16, -32)
			"right":
				$Marker2D.rotation_degrees = 270
				$Marker2D.position = Vector2(16, -32)
			"up":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 0
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/InteractiveArea.object_name = "stove"
		$Marker2D/InteractiveArea.object_level = item_name.substr(7)
		$Marker2D/InteractiveArea.name = str(id)
		if PlayerData.player_data["stoves"].has(id):
			pass
		else:
			PlayerData.player_data["stoves"][id] = {}
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
				$Marker2D.position = Vector2(16, -32)
			"right":
				$Marker2D.rotation_degrees = 270
				$Marker2D.position = Vector2(16, -32)
			"up":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 0
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/InteractiveArea.object_name = "grain mill"
		$Marker2D/InteractiveArea.object_level = item_name.substr(12)
		$Marker2D/InteractiveArea.name = str(id)
		if PlayerData.player_data["grain_mills"].has(id):
			pass
		else:
			PlayerData.player_data["grain_mills"][id] = {}
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
				$Marker2D.position = Vector2(16, -32)
			"right":
				$Marker2D.rotation_degrees = 270
				$Marker2D.position = Vector2(16, -32)
			"up":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 0
#	elif item_name == "brewing table #1" or item_name == "brewing table #2" or item_name == "brewing table #3":
#		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
#		$Marker2D/InteractiveArea.object_name = "brewing table"
#		$Marker2D/InteractiveArea.object_level = item_name.substr(12)
#		$Marker2D/InteractiveArea.name = str(id)
#		if PlayerData.player_data["brewing_tables"].has(id):
#			pass
#		else:
#			PlayerData.player_data["brewing_tables"][id] = {}
#		match direction:
#			"left":
#				$Marker2D.rotation_degrees = 90
#				$Marker2D.position = Vector2(16, -32)
#			"right":
#				$Marker2D.rotation_degrees = 270
#				$Marker2D.position = Vector2(16, -32)
#			"up":
#				$Marker2D.position = Vector2(32, -16)
#				$Marker2D.rotation_degrees = 180
#			"down":
#				$Marker2D.position = Vector2(32, -16)
#				$Marker2D.rotation_degrees = 0
	elif item_name == "furnace":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/InteractiveArea.object_name = "furnace"
		$Marker2D/InteractiveArea.object_level = ""
		$Marker2D/InteractiveArea.name = str(id)
		if PlayerData.player_data["furnaces"].has(id):
			pass
		else:
			PlayerData.player_data["furnaces"][id] = {}
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
			"right":
				$Marker2D.rotation_degrees = 270
			"up":
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.rotation_degrees = 0
	elif item_name == "tool cabinet":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/InteractiveArea.object_name = "tool cabinet"
		$Marker2D/InteractiveArea.object_level = ""
		$Marker2D/InteractiveArea.name = str(id)
		if PlayerData.player_data["chests"].has(id):
			pass
		else:
			PlayerData.player_data["chests"][id] = {}
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
				$Marker2D.position = Vector2(16, -32)
			"right":
				$Marker2D.rotation_degrees = 270
				$Marker2D.position = Vector2(16, -32)
			"up":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 0
	elif item_name == "dresser":
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
				$Marker2D.position = Vector2(16, -32)
			"right":
				$Marker2D.rotation_degrees = 270
				$Marker2D.position = Vector2(16, -32)
			"up":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.position = Vector2(32, -16)
				$Marker2D.rotation_degrees = 0
	elif item_name == "well":
		$Marker2D.position = Vector2(48, -32)
	elif item_name == "couch":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
				$Marker2D.position = Vector2(32, -48)
			"right":
				$Marker2D.rotation_degrees = 270
				$Marker2D.position =  Vector2(32, -48)
			"up":
				$Marker2D.position = Vector2(48, -32)
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.position = Vector2(48, -32)
				$Marker2D.rotation_degrees = 0
	elif item_name == "table":
		if direction == "left" or direction == "right":
			$Marker2D.rotation_degrees = 90
			$Marker2D.position = Vector2(32, -48)
		else:
			$Marker2D.position = Vector2(48, -32)
			$Marker2D.rotation_degrees = 180
	elif item_name == "armchair":
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		$Marker2D.position =  Vector2(32, -32)
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
			"right":
				$Marker2D.rotation_degrees = 270
			"up":
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.rotation_degrees = 0
	elif item_name == "chair":
		$Marker2D/InteractiveArea.object_direction = direction
		$Marker2D/InteractiveArea.object_position = return_adjusted_chair_position(direction)
		$Marker2D/InteractiveArea.object_name = "chair"
		$Marker2D/InteractiveArea/CollisionShape2D.disabled = false
		match direction:
			"left":
				$Marker2D.rotation_degrees = 90
			"right":
				$Marker2D.rotation_degrees = 270
			"up":
				$Marker2D.rotation_degrees = 180
			"down":
				$Marker2D.rotation_degrees = 0
	elif item_name == "bed":
		$Marker2D.position =  Vector2(32, -32)
		$Marker2D/BedInteractiveArea/CollisionShape2D.disabled = false
		$Marker2D/BedInteractiveArea.object_name = "bed"
		$Marker2D/BedInteractiveArea.object_position = position + Vector2(32,-32)
	elif item_name == "medium rug":
		$Marker2D.position =  Vector2(32, -32)
	elif item_name == "large rug":
		$Marker2D.position =  Vector2(64, -48)
	#thread.wait_to_finish()


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
		$PointLight2D.set_deferred("enabled", false)
		$ChestPos/Chest.call_deferred("hide")
		$FurnaceSmoke.call_deferred("hide")
		if $Marker2D.has_node(str(id)):
			$Marker2D.get_node(id+ "/CollisionShape2D").set_deferred("disabled", true)
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$Marker2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
		$Marker2D/DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
		$Marker2D/BedInteractiveArea/CollisionShape2D.set_deferred("disabled", true)
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
		Tiles.object_tiles.call_deferred("set_cellv",location, -1)
		Tiles.fence_tiles.call_deferred("set_cellv",location, -1)
		Tiles.fence_tiles.call_deferred("update_bitmask_area",location)
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


func open_chest():
	match item_name:
		"wood chest":
			match direction:
				"DOWN":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,9))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(2,9))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(4,9))


func close_chest():
	match item_name:
		"wood chest":
			match direction:
				"DOWN":
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(4,9))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(2,9))
					await get_tree().create_timer(0.2).timeout
					$ObjectTiles.set_cell(0,Vector2i(0,-1),0,Vector2i(0,9))


func _on_ResetTempHealthTimer_timeout():
	temp_health = 3



