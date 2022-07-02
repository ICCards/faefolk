extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
onready var placable_object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
onready var valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")
onready var path_tiles = get_node("/root/World/PlacableTiles/PathTiles")

var location
var item_name
var occupied_tiles


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
	item_name == "fire pedestal tall":
		$Light2D.enabled = true
	elif item_name == "house":
		queue_free()
		
func PlayEffect(_player_id):
	valid_tiles.set_cellv(location, 0)
	if item_name == "wood chest" or item_name == "stone chest":
		placable_object_tiles.set_cellv(location, -1)
		valid_tiles.set_cellv(location + Vector2(1,0),0)
	if item_name == "wood fence":
		fence_tiles.set_cellv(location, -1)
		fence_tiles.update_bitmask_region()
	elif item_name == "wood path" or item_name == "stone path":
		path_tiles.set_cellv(location, -1)
	else:
		placable_object_tiles.set_cellv(location, -1)
	if item_name == "stone path":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	yield($SoundEffects, "finished")
	queue_free()

func set_dimensions():
	if item_name == "wood chest" or item_name == "stone chest":
		$OpenChestArea/CollisionShape2D.disabled = false
		scale.x = 2.0
		position = position +  Vector2(16, 0)

func _on_HurtBox_area_entered(area):
	var data = {"id": name, "n": "decorations","t":"ON_HIT","name":item_name,"item":"placable"}
	print("sending ON_HIT")
	Server.action("ON_HIT", data)
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	valid_tiles.set_cellv(Vector2(location), 0)
	if item_name == "stone path":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()

	if item_name == "wood chest" or item_name == "stone chest":
		valid_tiles.set_cellv(Vector2(location + Vector2(1,0)), 0)
		drop_items_in_chest()
	if item_name == "wood fence":
		fence_tiles.set_cellv(location, -1)
		fence_tiles.update_bitmask_region()
	elif item_name == "wood path" or item_name == "stone path":
		path_tiles.set_cellv(location, -1)
	else:
		placable_object_tiles.set_cellv(location, -1)
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
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


func _on_OpenChestArea_area_entered(area):
	PlayerInventory.is_inside_chest_area = true

func _on_OpenChestArea_area_exited(area):
	PlayerInventory.is_inside_chest_area = false
