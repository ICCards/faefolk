extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

var location
var item_name

func initialize(_name, loc):
	item_name = _name
	location = loc
	
func _ready():
	set_dimensions()
	if item_name == "wood path1" or item_name == "wood path2":
		item_name = "wood path"
	elif item_name == "stone path1" or item_name == "stone path2" or  item_name == "stone path3" or item_name == "stone path4": 
		item_name = "stone path"
	if item_name == "wood path":
		$TypeOfTileArea.set_collision_mask(512)
	elif item_name == "stone path":
		$TypeOfTileArea.set_collision_mask(1024)
	elif item_name == "torch" or \
	item_name == "campfire" or \
	item_name == "fire pedestal" or \
	item_name == "tall fire pedestal":
		$Light2D.enabled = true
	elif item_name == "house" or item_name.substr(0, 12) == "sleeping bag" or item_name.substr(0, 4) == "tent":
		queue_free()
		
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
	if item_name == "wood chest" or item_name == "stone chest":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 65536
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "workbench":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 131072
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "stove":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 262144
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "grain mill":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 524288
		scale.x = 2.0
		position = position +  Vector2(16, 0)

func _on_HurtBox_area_entered(area):
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
	drop_item(item_name, 1)
	yield($SoundEffects, "finished")
	queue_free()


func drop_items_in_chest():
	for item in PlayerInventory.chest.keys():
		drop_item(PlayerInventory.chest[item][0], PlayerInventory.chest[item][1])
	PlayerInventory.clear_chest_data()

func drop_item(item_name, quantity):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name, quantity)
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
