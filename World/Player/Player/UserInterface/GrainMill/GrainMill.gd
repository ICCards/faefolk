extends Control

var hovered_item = null
var dragging = false
var id
var level

func _ready():
	initialize()

func initialize():
	Server.player_node.actions.destroy_placeable_object()
	$MenuTitle/Label.text = "Grain mill #" + str(level)
	show()
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()

func destroy():
	set_physics_process(false)
	$ItemDescription.queue_free()
	queue_free()

func craft():
	if $GrainMillSlots/WheatSlot.item:
		add_to_yield_slot("wheat flour")
		if $GrainMillSlots/WheatSlot.item.item_quantity -1 != 0:
			$GrainMillSlots/WheatSlot.item.decrease_item_quantity(1)
			PlayerData.add_item_quantity($GrainMillSlots/WheatSlot, -1, id)
		else:
			$GrainMillSlots/WheatSlot.removeFromSlot()
			PlayerData.remove_item($GrainMillSlots/WheatSlot, id)
	elif $GrainMillSlots/CornSlot.item:
		add_to_yield_slot("corn flour")
		if $GrainMillSlots/CornSlot.item.item_quantity -1 != 0:
			$GrainMillSlots/CornSlot.item.decrease_item_quantity(1)
			PlayerData.add_item_quantity($GrainMillSlots/CornSlot, -1, id)
		else:
			$GrainMillSlots/CornSlot.removeFromSlot()
			PlayerData.remove_item($GrainMillSlots/CornSlot, id)
	elif $GrainMillSlots/SugarCaneSlot.item:
		add_to_yield_slot("sugar")
		if $GrainMillSlots/SugarCaneSlot.item.item_quantity -1 != 0:
			$GrainMillSlots/SugarCaneSlot.item.decrease_item_quantity(1)
			PlayerData.add_item_quantity($GrainMillSlots/SugarCaneSlot, -1, id)
		else:
			$GrainMillSlots/SugarCaneSlot.removeFromSlot()
			PlayerData.remove_item($GrainMillSlots/SugarCaneSlot, id)

func add_to_yield_slot(item_name):
	if not $GrainMillSlots/YieldSlot.item:
		$GrainMillSlots/YieldSlot.initialize_item(item_name, 1, null)
		PlayerData.player_data["grain_mills"][id]["3"] = [item_name, 1, null]
	else:
		PlayerData.add_item_quantity($GrainMillSlots/YieldSlot, 1, id)
		$GrainMillSlots/YieldSlot.item.add_item_quantity(1)

func _physics_process(delta):
	if hovered_item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		$ItemDescription.item_name = hovered_item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()


func _on_ExitBtn_pressed():
	get_parent().close_grain_mill()
