extends Control

@onready var SlotClass = load("res://InventoryLogic/Slot.gd")
@onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")

var id
var hovered_item

func _ready():
	initialize()

func initialize():
	Server.player_node.actions.destroy_placeable_object()
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()
	$ChestSlots.initialize_slots()

func destroy():
	set_physics_process(false)
	$ItemDescription.queue_free()
	queue_free()

func _physics_process(delta):
	if hovered_item and not find_parent("UserInterface").holding_item:
		$ItemDescription.item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		$ItemDescription.item_name = hovered_item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()

func _on_ExitBtn_pressed():
	get_parent().close_chest(id)
