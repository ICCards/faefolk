extends CanvasLayer

var holding_item = null

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Menu = preload("res://World/Player/Player/UserInterface/Menu/Menu.tscn")
onready var Hotbar = preload("res://World/Player/Player/UserInterface/Hotbar/Hotbar.tscn")

var items_to_drop = []

var rng = RandomNumberGenerator.new()

enum {
	MOVEMENT, 
	SWINGING,
	EATING,
	FISHING,
	HARVESTING,
	DYING,
	SLEEPING
}

func _ready():
	initialize_user_interface()

func initialize_user_interface():
	$Hotbar.visible = true

func _input(event):
	if Server.player_node.state == MOVEMENT and holding_item == null and \
		not PlayerInventory.interactive_screen_mode and not PlayerInventory.chatMode and not PlayerInventory.viewMapMode:
		if event.is_action_pressed("open_menu"):
			toggle_menu()
		elif event.is_action_pressed("action"):
			if PlayerInventory.is_inside_chest_area:
				toggle_chest()
			elif PlayerInventory.is_inside_workbench_area:
				toggle_workbench()
	#			elif PlayerInventory.is_inside_stove_area:
	#				open_stove()
	#			elif PlayerInventory.is_inside_grain_mill_area:
	#				open_grain_mill()
		#		elif PlayerInventory.is_inside_sleeping_bag_area:
		#			sleep()
		if Input.is_action_just_released("scroll_up") and not PlayerInventory.viewMapMode:
			PlayerInventory.active_item_scroll_up()
		elif Input.is_action_just_released("scroll_down") and not PlayerInventory.viewMapMode:
			PlayerInventory.active_item_scroll_down()
		elif event.is_action_pressed("slot1"):
			PlayerInventory.active_item_slot = 0
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot2"):
			PlayerInventory.active_item_slot = 1
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot3"):
			PlayerInventory.active_item_slot = 2
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot4"):
			PlayerInventory.active_item_slot = 3
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot5"):
			PlayerInventory.active_item_slot = 4
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot6"):
			PlayerInventory.active_item_slot = 5
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot7"):
			PlayerInventory.active_item_slot = 6
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot8"):
			PlayerInventory.active_item_slot = 7
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot9"):
			PlayerInventory.active_item_slot = 8
			PlayerInventory.emit_signal("active_item_updated")
		elif event.is_action_pressed("slot10"):
			PlayerInventory.active_item_slot = 9
			PlayerInventory.emit_signal("active_item_updated")

#func toggle_menu():
#	toggle_hotbar()
#	if has_node("Menu"):
#		get_node("Menu").queue_free()
#		PlayerInventory.viewInventoryMode = false
#		drop_items()
#	else:
#		var menu = Menu.instance()
#		add_child(menu)
#		menu.rect_position = Vector2(138,39)
#		PlayerInventory.viewInventoryMode = true
#
#func toggle_hotbar():
#	if has_node("Hotbar"):
#		get_node("Hotbar").queue_free()
#	else:
#		var hotbar = Hotbar.instance()
#		add_child(hotbar)
#		hotbar.rect_position = Vector2(512,507)


func toggle_menu():
	if not $Menu.visible:
		get_node("../../Area2Ds/PickupZone/CollisionShape2D").disabled = true
		$PlayerStatsUI.hide()
		$Menu.show()
		$Hotbar.hide()
		$Menu.initialize()
		PlayerInventory.viewInventoryMode = true
	else:
		get_node("../../Area2Ds/PickupZone/CollisionShape2D").disabled = false
		$PlayerStatsUI.show()
		$Menu.hide()
		$Hotbar.show()
		$Hotbar.initialize_hotbar()
		PlayerInventory.InventorySlots = $Menu/Inventory/InventorySlots
		PlayerInventory.viewInventoryMode = false
		drop_items()
		
func drop_items():
	yield(get_tree().create_timer(0.25), "timeout")
	for i in range(items_to_drop.size()):
		drop_item(items_to_drop[i][0], items_to_drop[i][1], items_to_drop[i][2])
	items_to_drop = []
	
func drop_item(item_name, quantity, health):
	rng.randomize()
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name, quantity, health)
	Server.world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = Server.player_node.global_position + Vector2(rng.randi_range(-12, 12), rng.randi_range(-12, 12))

func toggle_chest():
	if not $OpenChest.visible:
		$OpenChest.initialize()
		$PlayerStatsUI.hide()
		$SoundEffects.stream = Sounds.chest_open
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		$SoundEffects.play()
	else:
		print("THISxxxx")
		$PlayerStatsUI.show()
		$OpenChest.hide()
		$Hotbar.initialize_hotbar()
	$Hotbar.visible  =!$Hotbar.visible
	PlayerInventory.interactive_screen_mode = !PlayerInventory.interactive_screen_mode


func open_grain_mill():
	$GrainMill.initialize()
	$GrainMill.visible = !$GrainMill.visible
	PlayerInventory.interactive_screen_mode = !PlayerInventory.interactive_screen_mode
	toggle_stats_and_time()

func toggle_workbench():
	if not $Workbench.visible:
		$Workbench.initialize()
		$Hotbar.hide()
	else:
		$Hotbar.show()
		$Hotbar.initialize_hotbar()
		$Workbench.hide()
		drop_items()
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

