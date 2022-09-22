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
	if item_name == "torch" or item_name == "campfire" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$Light2D.enabled = true
	elif item_name == "wood chest" or item_name == "stone chest":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 65536
		$InteractiveArea.name = id
		PlayerInventory.chests[id] = {}
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 131072
		$InteractiveArea.name = item_name
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 262144
		$InteractiveArea.name = item_name
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 524288
		$InteractiveArea.name = str(item_name.substr(12) + " " + id)
		PlayerInventory.grain_mills[id] = {}
		scale.x = 2.0
		position = position +  Vector2(16, 0)



func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	$Light2D.enabled = false
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	var data = {"id": name, "n": "decorations","t":"ON_HIT","name":item_name,"item":"placable"}
	Server.action("ON_HIT", data)
	if item_name == "stone path" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	elif item_name == "wood chest" or item_name == "stone chest":
		drop_items_in_chest()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	Tiles.reset_valid_tiles(location, item_name)
	drop_item(item_name, 1, null)
	yield($SoundEffects, "finished")
	queue_free()


func drop_items_in_chest():
	for item in PlayerInventory.chests[id].keys():
		drop_item(PlayerInventory.chests[id][item][0], PlayerInventory.chests[id][item][1], PlayerInventory.chests[id][item][2])
	PlayerInventory.chests.erase(id)

func drop_item(item_name, quantity, health):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name, quantity, health)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 


func _on_DetectObjectOverPathBox_area_entered(area):
	if item_name == "wood path" or item_name == "stone path":
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)


func _on_DetectObjectOverPathBox_area_exited(area):
	if item_name == "wood path" or item_name == "stone path":
		yield(get_tree().create_timer(0.25), "timeout")
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)

func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
