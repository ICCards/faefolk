extends CanvasLayer
var holding_item = null
var hovered_item = null

func _process(delta):
	if hovered_item != null:
		print(hovered_item.item_name)


func initialize_user_interface():
	$Hotbar.visible = true
	$PlayerStatsUI.visible = true
	$CurrentTime.visible = true

func _input(event):
	if event.is_action_pressed("open_menu") and holding_item == null and \
	not PlayerInventory.openChestMode and not PlayerInventory.chatMode:
		toggle_inventory()
	elif event.is_action_pressed("action") and holding_item == null and \
	not PlayerInventory.viewInventoryMode and PlayerInventory.is_inside_chest_area and \
	not PlayerInventory.chatMode:
		open_chest()
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()

func toggle_inventory():
	$Inventory/CraftingMenu.reset()
	$Inventory.initialize_inventory()
	$Hotbar.initialize_hotbar()
	PlayerInventory.viewInventoryMode = !PlayerInventory.viewInventoryMode
	$Inventory.visible = !$Inventory.visible
	
	
func open_chest():
	$OpenChest.initialize_inventory()
	$OpenChest.initialize_chest_data()
	$Hotbar.initialize_hotbar()
	PlayerInventory.openChestMode = !PlayerInventory.openChestMode
	$OpenChest.visible = !$OpenChest.visible
	if PlayerInventory.openChestMode == true:
		$SoundEffects.stream = Sounds.chest_open
		$SoundEffects.play()
