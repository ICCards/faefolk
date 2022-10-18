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
onready var Tool_cabinet = preload("res://World/Player/Player/UserInterface/Tool cabinet/Tool cabinet.tscn")

var items_to_drop = []

var rng = RandomNumberGenerator.new()

var object_name
var object_level
var object_id

var is_opening_chest: bool = false

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
	$Menu.hide()
	add_hotbar_clock_and_stats()


func _input(event):
	if Server.player_node.state == MOVEMENT and holding_item == null and \
		not PlayerInventory.chatMode and not PlayerInventory.viewMapMode:
		if event.is_action_pressed("open_menu") and not PlayerInventory.interactive_screen_mode:
			toggle_menu()
		elif event.is_action_pressed("action") and not PlayerInventory.viewInventoryMode:
			if object_id:
				match object_name:
					"workbench":
						toggle_workbench(object_level)
					"grain mill":
						toggle_grain_mill(object_id, object_level)
					"stove":
						toggle_stove(object_id, object_level)
					"chest":
						toggle_chest(object_id)
					"furnace":
						toggle_furnace(object_id)
					"tool cabinet":
						toggle_tc(object_id)
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
	elif PlayerInventory.viewMapMode:
		$MapLabels.show()
		return
	$MapLabels.hide()


func death():
	if $Menu.visible:
		hide_menu()
	else:
		match object_name:
			"workbench":
				close_workbench()
			"grain mill":
				close_grain_mill()
			"stove":
				close_stove(object_id)
			"chest":
				close_chest(object_id)
			"furnace":
				close_furnace(object_id)
	close_hotbar_clock_and_stats()
	if holding_item:
		InstancedScenes.initiateInventoryItemDrop([holding_item.item_name, holding_item.item_quantity, holding_item.item_health], Server.player_node.position)
		holding_item.queue_free()
		holding_item = null

func respawn():
	add_hotbar_clock_and_stats()

func toggle_tc(id):
	if not has_node("Tool cabinet"):
		var tc = Tool_cabinet.instance()
		tc.id = id
		add_child(tc)
		close_hotbar_clock_and_stats()
	else:
		close_tc(id)

func toggle_chest(id):
	if not is_opening_chest:
		if not has_node("Chest"):
			PlayerInventory.interactive_screen_mode = true
			is_opening_chest = true
			Server.world.get_node("PlacableObjects/"+id).open_chest()
			yield(get_tree().create_timer(0.5), "timeout")
			is_opening_chest = false
			var chest = Chest.instance()
			chest.id = id
			add_child(chest)
			close_hotbar_clock_and_stats()
		else:
			close_chest(id)

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
		show_menu()
	else:
		hide_menu()


func show_menu():
	$Hotbar.hide()
	$CurrentTime.hide()
	$PlayerStatsUI.hide()
	PlayerInventory.viewInventoryMode = true
	$Menu.initialize()

func hide_menu():
	PlayerInventory.viewInventoryMode = false
	$Hotbar.initialize_hotbar()
	$CurrentTime.show()
	$PlayerStatsUI.show()
	$Menu.hide()
	drop_items()

func toggle_grain_mill(id, level):
	if not has_node("GrainMill"):
		var grainMill = GrainMill.instance()
		grainMill.level = level
		grainMill.id = id
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


func toggle_furnace(id):
	if not has_node(id):
		var furnace = Furnace.instance()
		furnace.name = str(id)
		furnace.id = id
		add_child(furnace)
		close_hotbar_clock_and_stats()
	elif has_node(id) and not get_node(id).visible:
		get_node(id).initialize()
		close_hotbar_clock_and_stats()
	else:
		close_furnace(id)


func toggle_stove(id, level):
	if not has_node(id):
		var stove = Stove.instance()
		stove.name = str(id)
		stove.level = level
		stove.id = id
		add_child(stove)
		close_hotbar_clock_and_stats()
	elif has_node(id) and not get_node(id).visible:
		get_node(id).initialize()
		close_hotbar_clock_and_stats()
	else:
		close_stove(id)
		


func close_furnace(id):
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node(id).hide()
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

func close_stove(id):
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node(id).hide()
		drop_items()

func close_chest(id):
	if not holding_item:
		Server.world.get_node("PlacableObjects/"+id).close_chest()
		add_hotbar_clock_and_stats()
		get_node("Chest").destroy()
		drop_items()

func close_tc(id):
	if not holding_item:
		add_hotbar_clock_and_stats()
		get_node("Tool cabinet").destroy()
		drop_items()

func drop_items():
	yield(get_tree().create_timer(0.25), "timeout")
	for i in range(items_to_drop.size()):
		InstancedScenes.initiateInventoryItemDrop(items_to_drop[i], Server.player_node.position)
	items_to_drop = []
	




