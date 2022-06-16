extends CanvasLayer
var holding_item = null

func _input(event):
	if event.is_action_pressed("inventory") and holding_item == null and not PlayerInventory.openChestMode:
		toggle_inventory()
	elif event.is_action_pressed("open_door") and holding_item == null and not PlayerInventory.viewInventoryMode:
		open_chest()
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()

func toggle_inventory():
	PlayerInventory.viewInventoryMode = !PlayerInventory.viewInventoryMode
	$Inventory.visible = !$Inventory.visible
	$Inventory.initialize_inventory()
	
func open_chest():
	PlayerInventory.openChestMode = !PlayerInventory.openChestMode
	$OpenChest.visible = !$OpenChest.visible
