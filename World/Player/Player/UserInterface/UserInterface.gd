extends CanvasLayer

var holding_item = null

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Menu = preload("res://World/Player/Player/UserInterface/Menu/Menu.tscn")
onready var Hotbar = preload("res://World/Player/Player/UserInterface/Hotbar/Hotbar.tscn")
onready var Workbench = preload("res://World/Player/Player/UserInterface/Workbench/Workbench.tscn")
onready var Stove = preload("res://World/Player/Player/UserInterface/Stove/Stove.tscn")
onready var GrainMill = preload("res://World/Player/Player/UserInterface/GrainMill/GrainMill.tscn")
onready var Furnace = preload("res://World/Player/Player/UserInterface/Furnace/Furnace.tscn")
onready var Chest = preload("res://World/Player/Player/UserInterface/Chest/Chest.tscn")

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
	add_hotbar_clock_and_stats()


func _input(event):
	if Server.player_node.state == MOVEMENT and holding_item == null and \
		not PlayerInventory.chatMode and not PlayerInventory.viewMapMode:
		if event.is_action_pressed("open_menu") and not PlayerInventory.interactive_screen_mode:
			toggle_menu()
		elif event.is_action_pressed("action") and not PlayerInventory.viewInventoryMode:
			if PlayerInventory.chest_id:
				toggle_chest()
			elif PlayerInventory.workbench_id:
				toggle_workbench(PlayerInventory.workbench_id)
			elif PlayerInventory.stove_id:
				toggle_stove()
			elif PlayerInventory.furnace_id:
				toggle_furnace()
				#PlayerInventory.furnace_node.set_furnace_active()
			elif PlayerInventory.grain_mill_id:
				toggle_grain_mill()
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

func toggle_chest():
	if not has_node("Chest"):
		var chest = Chest.instance()
		add_child(chest)
		close_hotbar_clock_and_stats()
	else:
		close_chest()

func toggle_furnace():
	if not has_node("Furnace"):
		var furnace = Furnace.instance()
		add_child(furnace)
		close_hotbar_clock_and_stats()
	else:
		close_furnace()

func close_hotbar_clock_and_stats():
	PlayerInventory.interactive_screen_mode = true
	$Hotbar.hide()
	$CurrentTime.hide()
	$PlayerStatsUI.hide()


func add_hotbar_clock_and_stats():
	PlayerInventory.interactive_screen_mode = false
	$Hotbar.initialize_hotbar()
	$CurrentTime.show()
	$PlayerStatsUI.show()


func toggle_menu():
	if not $Menu.visible:
		$Hotbar.hide()
		$CurrentTime.hide()
		$PlayerStatsUI.hide()
		PlayerInventory.viewInventoryMode = true
		$Menu.initialize()
	else:
		PlayerInventory.viewInventoryMode = false
		$Hotbar.initialize_hotbar()
		$CurrentTime.show()
		$PlayerStatsUI.show()
		$Menu.hide()
		drop_items()


func toggle_grain_mill():
	if not has_node("GrainMill"):
		var grainMill = GrainMill.instance()
		add_child(grainMill)
		close_hotbar_clock_and_stats()
	else:
		close_grain_mill()


func toggle_workbench(level):
	if not has_node("Workbench"):
		var workbench = Workbench.instance()
		workbench.level = level
		add_child(workbench)
		close_hotbar_clock_and_stats()
	else:
		close_workbench()

func toggle_stove():
	if not has_node("Stove"):
		var stove = Stove.instance()
		add_child(stove)
		close_hotbar_clock_and_stats()
	else:
		close_stove()
		
func close_furnace():
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node("Furnace").destroy()
		drop_items()

func close_grain_mill():
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node("GrainMill").destroy()
		drop_items()

func close_workbench():
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node("Workbench").destroy()
		drop_items()

func close_stove():
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node("Stove").destroy()
		drop_items()

func close_chest():
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node("Chest").destroy()
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



