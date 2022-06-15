extends CanvasLayer
var holding_item = null

func _input(event):
	if event.is_action_pressed("inventory") and holding_item == null:
		toggle_inventory()
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()

func toggle_inventory():
	PlayerInventory.viewInventoryMode = !PlayerInventory.viewInventoryMode
	$Inventory.visible = !$Inventory.visible
	$Inventory.initialize_inventory()
