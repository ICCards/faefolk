extends Control

var hovered_item

func initialize():
	show()
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()

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
	PlayerData.interactive_screen_mode = false
	hide()
