extends CanvasLayer



func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.init_inventory()
		
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	if event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
