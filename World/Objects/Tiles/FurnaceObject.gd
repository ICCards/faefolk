extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var furnace_active = false
var direction
var rng = RandomNumberGenerator.new()
var id

func _ready():
	id = rng.randi_range(0,100000)
	$Position2D/InteractiveArea.name = str(id)
	PlayerInventory.furnaces[id] = {}
	print(PlayerInventory.furnaces)
	set_direction()
	
func set_direction():
	match direction:
		"down":
			$Furnace.texture = preload("res://Assets/Images/placable_object_preview/furnace/down.png")
		"up":
			$Furnace.texture = preload("res://Assets/Images/placable_object_preview/furnace/up.png")
			$Position2D.rotation_degrees = 180
		"left":
			$Furnace.texture = preload("res://Assets/Images/placable_object_preview/furnace/left.png")
			$Position2D.rotation_degrees = 90
		"right":
			$Furnace.texture = preload("res://Assets/Images/placable_object_preview/furnace/right.png")
			$Position2D.rotation_degrees = -90

func set_furnace_active():
	if not furnace_active:
		furnace_active = true
		if direction == "down":
			$Fire.show()
		$FireLight.enabled = true
		$Smoke.show()
		$SmeltTimer.start()


func _on_HurtBox_area_entered(area):
	PlayerInventory.furnaces.erase(id)
	drop_item("furnace", 1, null)
	queue_free()


func drop_item(item_name, quantity, health):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name, quantity, health)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 


func _on_SmeltTimer_timeout():
	furnace_active = false
	$Fire.hide()
	$FireLight.enabled = false
	$Smoke.hide()
