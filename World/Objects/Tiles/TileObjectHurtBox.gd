extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

var rng = RandomNumberGenerator.new()
var location
var item_name
var id
var direction


func _ready():
	set_dimensions()


func PlayEffect(_player_id):
	$Light2D.enabled = false
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	Tiles.reset_valid_tiles(location, item_name)
	if item_name == "stone path" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	yield($SoundEffects, "finished")
	queue_free()

func set_dimensions():
	rng.randomize()
	id = str(rng.randi_range(0, 100000))
	name = str(id)
	if item_name == "wood chest" or item_name == "stone chest":
		$Position2D/InteractiveArea/CollisionShape2D.disabled = false
		$Position2D/StaticBody2D/CollisionShape2D.disabled = false
		$Position2D/InteractiveArea.object_name = "chest"
		$Position2D/InteractiveArea.object_level = ""
		$Position2D/InteractiveArea.name = str(id)
		PlayerInventory.chests[id] = {}
		$Position2D.scale.x = 2.0
		match direction:
			"left":
				$Position2D.rotation_degrees = 90
				if item_name == "wood chest":
					$Chest.frames = preload("res://Assets/Images/Animations/chest/wood/left.tres")
				else:
					$Chest.frames = preload("res://Assets/Images/Animations/chest/stone/Left.tres")
				$Chest.flip_h = false
				$Chest.position = Vector2(18,0)
				$Position2D.position = Vector2(16, -32)
				$Chest.position = Vector2(16, -32)
				Tiles.remove_invalid_tiles(location, Vector2(1,2))
			"right":
				if item_name == "wood chest":
					$Chest.frames = preload("res://Assets/Images/Animations/chest/wood/left.tres")
				else:
					$Chest.frames = preload("res://Assets/Images/Animations/chest/stone/Left.tres")
				$Chest.flip_h = true
				$Position2D.rotation_degrees = 270
				$Position2D.position = Vector2(16, -32)
				$Chest.position = Vector2(16, -32)
				Tiles.remove_invalid_tiles(location, Vector2(1,2))
			"up":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 180
				$Chest.position = Vector2(32,-32)
				if item_name == "wood chest":
					$Chest.frames = preload("res://Assets/Images/Animations/chest/wood/up.tres")
				else:
					$Chest.frames = preload("res://Assets/Images/Animations/chest/stone/Up.tres")
				Tiles.remove_invalid_tiles(location, Vector2(2,1))
			"down":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 0
				$Chest.position = Vector2(32,-32)
				if item_name == "wood chest":
					$Chest.frames = preload("res://Assets/Images/Animations/chest/wood/down.tres")
				else:
					$Chest.frames = preload("res://Assets/Images/Animations/chest/stone/Down.tres")
				Tiles.remove_invalid_tiles(location, Vector2(2,1))
		$Chest.animation = "open"
		$Chest.show()
	elif item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3":
		$Position2D/InteractiveArea/CollisionShape2D.disabled = false
		$Position2D/InteractiveArea.object_name = "workbench"
		$Position2D/InteractiveArea.object_level = item_name.substr(11)
		$Position2D/InteractiveArea.name = str(id)
		$Position2D.scale.x = 2.0
		match direction:
			"left":
				$Position2D.rotation_degrees = 90
				$Position2D.position = Vector2(16, -32)
			"right":
				$Position2D.rotation_degrees = 270
				$Position2D.position = Vector2(16, -32)
			"up":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 180
			"down":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 0
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		$Position2D/InteractiveArea/CollisionShape2D.disabled = false
		$Position2D/InteractiveArea.object_name = "stove"
		$Position2D/InteractiveArea.object_level = item_name.substr(7)
		$Position2D/InteractiveArea.name = str(id)
		PlayerInventory.stoves[id] = {}
		$Position2D.scale.x = 2.0
		match direction:
			"left":
				$Position2D.rotation_degrees = 90
				$Position2D.position = Vector2(16, -32)
			"right":
				$Position2D.rotation_degrees = 270
				$Position2D.position = Vector2(16, -32)
			"up":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 180
			"down":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 0
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		$Position2D/InteractiveArea/CollisionShape2D.disabled = false
		$Position2D/InteractiveArea.object_name = "grain mill"
		$Position2D/InteractiveArea.object_level = item_name.substr(12)
		$Position2D/InteractiveArea.name = str(id)
		PlayerInventory.grain_mills[id] = {}
		$Position2D.scale.x = 2.0
		match direction:
			"left":
				$Position2D.rotation_degrees = 90
				$Position2D.position = Vector2(16, -32)
			"right":
				$Position2D.rotation_degrees = 270
				$Position2D.position = Vector2(16, -32)
			"up":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 180
			"down":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 0
	elif item_name == "furnace":
		$Position2D/InteractiveArea/CollisionShape2D.disabled = false
		$Position2D/InteractiveArea.object_name = "furnace"
		$Position2D/InteractiveArea.object_level = ""
		$Position2D/InteractiveArea.name = str(id)
		PlayerInventory.furnaces[id] = {}
		match direction:
			"left":
				$Position2D.rotation_degrees = 90
			"right":
				$Position2D.rotation_degrees = 270
			"up":
				$Position2D.rotation_degrees = 180
			"down":
				$Position2D.rotation_degrees = 0
	elif item_name == "tool cabinet":
		$Position2D/InteractiveArea/CollisionShape2D.disabled = false
		$Position2D/InteractiveArea.object_name = "tool cabinet"
		$Position2D/InteractiveArea.object_level = ""
		$Position2D/InteractiveArea.name = str(id)
		PlayerInventory.tool_cabinets[id] = {}
		$Position2D.scale.x = 2.0
		match direction:
			"left":
				$Position2D.rotation_degrees = 90
				$Position2D.position = Vector2(16, -32)
			"right":
				$Position2D.rotation_degrees = 270
				$Position2D.position = Vector2(16, -32)
			"up":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 180
			"down":
				$Position2D.position = Vector2(32, -16)
				$Position2D.rotation_degrees = 0



func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	$Light2D.enabled = false
	$Chest.hide()
	if has_node(id):
		get_node(id+ "/CollisionShape2D").set_deferred("disabled", true)
	$Position2D/HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$Position2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$Position2D/DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	var data = {"id": name, "n": "decorations","t":"ON_HIT","name":item_name,"item":"placable"}
	Server.action("ON_HIT", data)
	if item_name == "stone path" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	elif item_name == "wood chest" or item_name == "stone chest":
		drop_items_in_chest()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		drop_items_in_grain_mill()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		drop_items_in_stove()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	elif item_name == "furnace":
		drop_items_in_furnace()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	var dimensions = Constants.dimensions_dict[item_name]
	if direction == "left" or direction == "right":
		Tiles.set_valid_tiles(location, Vector2(dimensions.y, dimensions.x))
	else:
		Tiles.set_valid_tiles(location, dimensions)
	Tiles.object_tiles.set_cellv(location, -1)
	Tiles.fence_tiles.set_cellv(location, -1)
	Tiles.fence_tiles.update_bitmask_area(location)
	InstancedScenes.intitiateItemDrop(item_name, position, 1)
	yield($SoundEffects, "finished")
	queue_free()


func drop_items_in_stove():
	for item in PlayerInventory.stoves[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.stoves[id][item], position)
	PlayerInventory.stoves.erase(id)

func drop_items_in_grain_mill():
	for item in PlayerInventory.grain_mills[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.grain_mills[id][item], position)
	PlayerInventory.grain_mills.erase(id)

func drop_items_in_chest():
	for item in PlayerInventory.chests[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.chests[id][item], position)
	PlayerInventory.chests.erase(id)

func drop_items_in_furnace():
	for item in PlayerInventory.furnaces[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.furnaces[id][item], position)
	PlayerInventory.furnaces.erase(id)


func _on_DetectObjectOverPathBox_area_entered(area):
	if item_name == "wood path" or item_name == "stone path":
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)

func _on_DetectObjectOverPathBox_area_exited(area):
	if item_name == "wood path" or item_name == "stone path":
		yield(get_tree().create_timer(0.25), "timeout")
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)


func open_chest():
	$Chest.play("open")
	
func close_chest():
	yield(get_tree().create_timer(0.2), "timeout")
	$Chest.play("open", true)
