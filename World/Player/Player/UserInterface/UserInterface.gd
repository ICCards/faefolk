extends CanvasLayer

var holding_item = null

func _ready():
	initialize_user_interface()

func initialize_user_interface():
	$Hotbar.visible = true
	$PlayerStatsUI.visible = true
	$CurrentTime.visible = true

func _input(event):
	if event.is_action_pressed("open_menu") and holding_item == null and \
	not PlayerInventory.interactive_screen_mode and not PlayerInventory.chatMode and not PlayerInventory.viewMapMode:
		toggle_inventory()
	elif event.is_action_pressed("action") and holding_item == null and not PlayerInventory.viewInventoryMode and not PlayerInventory.chatMode:
		if PlayerInventory.is_inside_chest_area:
			open_chest()
		elif PlayerInventory.is_inside_workbench_area:
			open_workbench()
		elif PlayerInventory.is_inside_stove_area:
			open_stove()
		elif PlayerInventory.is_inside_grain_mill_area:
			open_grain_mill()
#		elif PlayerInventory.is_inside_sleeping_bag_area:
#			sleep()
	if event.is_action_pressed("scroll_up") and not PlayerInventory.viewMapMode:
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down") and not PlayerInventory.viewMapMode:
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
	PlayerInventory.interactive_screen_mode = !PlayerInventory.interactive_screen_mode
	$OpenChest.visible = !$OpenChest.visible
	if PlayerInventory.interactive_screen_mode == true:
		$SoundEffects.stream = Sounds.chest_open
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		$SoundEffects.play()


func open_grain_mill():
	$GrainMill.initialize()
	$GrainMill.visible = !$GrainMill.visible
	PlayerInventory.interactive_screen_mode = !PlayerInventory.interactive_screen_mode
	toggle_stats_and_time()

func open_workbench():
	$Workbench.initialize()
	$Workbench.visible = !$Workbench.visible
	PlayerInventory.interactive_screen_mode = !PlayerInventory.interactive_screen_mode
	toggle_stats_and_time()
	
func open_stove():
	$Stove.initialize()
	$Stove.visible = !$Stove.visible
	PlayerInventory.interactive_screen_mode = !PlayerInventory.interactive_screen_mode
	toggle_stats_and_time()
	
func toggle_stats_and_time():
	$CurrentTime.visible = !$CurrentTime.visible
	$PlayerStatsUI.visible = !$PlayerStatsUI.visible

