extends CanvasLayer

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

var holding_item = null

@onready var SaveAndExitDialogue = load("res://World3D/Player/Player/UserInterface/SaveAndExit/SaveAndExit.tscn")
@onready var Menu = load("res://World3D/Player/Player/UserInterface/Menu/Menu.tscn")
@onready var Hotbar = load("res://World3D/Player/Player/UserInterface/Hotbar/Hotbar.tscn")
@onready var Workbench = load("res://World3D/Player/Player/UserInterface/Workbench/Workbench.tscn")
@onready var Stove = load("res://World3D/Player/Player/UserInterface/Stove/Stove.tscn")
@onready var GrainMill = load("res://World3D/Player/Player/UserInterface/GrainMill/GrainMill.tscn")
@onready var Furnace = load("res://World3D/Player/Player/UserInterface/Furnace/Furnace.tscn")
@onready var Chest = load("res://World3D/Player/Player/UserInterface/Chest/Chest.tscn")
@onready var Tool_cabinet = load("res://World3D/Player/Player/UserInterface/Tool cabinet/Tool cabinet.tscn")
@onready var Campfire = load("res://World3D/Player/Player/UserInterface/Campfire/Campfire.tscn")
@onready var BrewingTable = load("res://World3D/Player/Player/UserInterface/BrewingTable/BrewingTable.tscn")

var items_to_drop = []

var rng = RandomNumberGenerator.new()

var object_name
var object_level
var object_id

var is_opening_chest: bool = false

var game_state: GameState

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
	await get_tree().create_timer(0.25).timeout
	$Menu.hide()
	initialize_furnaces_campfires_and_stoves()
	add_hotbar_clock_and_stats()

func initialize_furnaces_campfires_and_stoves():
	for id in PlayerData.player_data["furnaces"]:
		var furnace = Furnace.instantiate()
		furnace.name = str(id)
		furnace.id = id
		add_child(furnace)
		furnace.check_if_furnace_active()
		furnace.hide()
	for id in PlayerData.player_data["stoves"]:
		var stove = Stove.instantiate()
		stove.name = str(id)
		stove.id = id
		add_child(stove)
		stove.check_valid_recipe()
		stove.hide()
	for id in PlayerData.player_data["campfires"]:
		var campfire = Campfire.instantiate()
		campfire.name = str(id)
		campfire.id = id
		add_child(campfire)
		campfire.check_valid_recipe()
		campfire.hide()



func save_player_data(exit_to_main_menu):
	$LoadingIndicator.show()
	PlayerData.player_data["current_save_location"] = str(Server.player_node.position/32)
	PlayerData.player_data["current_save_scene"] = get_tree().current_scene.filename
	game_state = GameState.new()
	game_state.world_state = MapData.world
	game_state.cave_state = MapData.caves
	game_state.player_state = PlayerData.player_data
	game_state.save_state()
	await get_tree().create_timer(2.0).timeout
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/save/save-game.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	$LoadingIndicator.hide()
	if exit_to_main_menu:
		SceneChanger.goto_scene("res://MainMenu/MainMenu.tscn")

func switch_hotbar():
	if Server.player_node.state == MOVEMENT:
		Sounds.play_small_select_sound()
		if $Hotbar.visible:
			PlayerData.normal_hotbar_mode = false
			$Hotbar.hide()
			$CombatHotbar.initialize()
			$PlayerDataUI/EnergyBars.hide()
		else:
			PlayerData.normal_hotbar_mode = true
			$Hotbar.initialize_hotbar()
			$CombatHotbar.hide()
			$PlayerDataUI/EnergyBars.show()
		get_node("../../").set_held_object()


func _input(event):
	if Server.player_node.state == MOVEMENT and holding_item == null and not PlayerData.viewMapMode and not Server.world.is_changing_scene:
		if event.is_action_pressed("ui_cancel") and not PlayerData.interactive_screen_mode and not PlayerData.viewInventoryMode:
			toggle_save_and_exit()
		elif event.is_action_pressed("open_menu") and not PlayerData.interactive_screen_mode and not PlayerData.viewSaveAndExitMode:
			toggle_menu()
		elif event.is_action_pressed("toggle_hotbar") and not PlayerData.interactive_screen_mode and not PlayerData.viewSaveAndExitMode and not PlayerData.viewInventoryMode:
			switch_hotbar()
		elif Input.is_action_just_released("scroll_up") and not PlayerData.viewMapMode:
			PlayerData.active_item_scroll_up()
		elif Input.is_action_just_released("scroll_down") and not PlayerData.viewMapMode:
			PlayerData.active_item_scroll_down()
		elif event.is_action_pressed("slot1"):
			PlayerData.slot_selected(0)
		elif event.is_action_pressed("slot2"):
			PlayerData.slot_selected(1)
		elif event.is_action_pressed("slot3"):
			PlayerData.slot_selected(2)
		elif event.is_action_pressed("slot4"):
			PlayerData.slot_selected(3)
		elif event.is_action_pressed("slot5"):
			PlayerData.slot_selected(4)
		elif event.is_action_pressed("slot6"):
			PlayerData.slot_selected(5)
		elif event.is_action_pressed("slot7"):
			PlayerData.slot_selected(6)
		elif event.is_action_pressed("slot8"):
			PlayerData.slot_selected(7)
		elif event.is_action_pressed("slot9"):
			PlayerData.slot_selected(8)
		elif event.is_action_pressed("slot10"):
			PlayerData.slot_selected(9)


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
			"campfire":
				close_campfire(object_id)
	close_hotbar_clock_and_stats()
	if holding_item:
		InstancedScenes.initiateInventoryItemDrop([holding_item.item_name, holding_item.item_quantity, holding_item.item_health], Server.player_node.position)
		holding_item.queue_free()
		holding_item = null


func toggle_brewing_table(id,level):
	if not has_node(id):
		play_open_menu_sound()
		var brewingTable = BrewingTable.instantiate()
		brewingTable.name = str(id)
		brewingTable.id = id
		add_child(brewingTable)
		close_hotbar_clock_and_stats()
	elif has_node(id) and not get_node(id).visible:
		play_open_menu_sound()
		get_node(id).initialize()
		close_hotbar_clock_and_stats()
	else:
		close_brewing_table(id)


func toggle_save_and_exit():
	if has_node("SaveAndExit"):
		Sounds.play_deselect_sound()
		PlayerData.viewSaveAndExitMode = false
		get_node("SaveAndExit").queue_free()
	else:
		Sounds.play_big_select_sound()
		var saveAndExit = SaveAndExitDialogue.instantiate()
		add_child(saveAndExit)
		PlayerData.viewSaveAndExitMode = true


func respawn():
	add_hotbar_clock_and_stats()

func toggle_tc(id):
	if not has_node("Tool cabinet"):
		play_open_menu_sound()
		var tc = Tool_cabinet.instantiate()
		tc.id = id
		add_child(tc)
		close_hotbar_clock_and_stats()
	else:
		close_tc(id)

func toggle_chest(id):
	if not is_opening_chest:
		if not has_node("Chest"):
			sound_effects.stream = load("res://Assets/Sound/Sound effects/chest/open.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
			sound_effects.play()
			PlayerData.interactive_screen_mode = true
			is_opening_chest = true
			Server.world.get_node("PlacableObjects/"+id).open_chest()
			await get_tree().create_timer(0.5).timeout
			is_opening_chest = false
			var chest = Chest.instantiate()
			chest.id = id
			add_child(chest)
			close_hotbar_clock_and_stats()
		else:
			close_chest(id)

func close_hotbar_clock_and_stats():
	PlayerData.interactive_screen_mode = true
	$CombatHotbar.hide()
	$Hotbar.hide()
	$PlayerDataUI.hide()
	$CombatHotbar.hide()


func add_hotbar_clock_and_stats():
	PlayerData.HotbarSlots = $Hotbar/HotbarSlots
	PlayerData.interactive_screen_mode = false
	if PlayerData.normal_hotbar_mode:
		$CombatHotbar.hide()
		$Hotbar.initialize_hotbar()
		$PlayerDataUI.show()
		$PlayerDataUI/EnergyBars.show()
		PlayerData.InventorySlots = $Menu/Pages/inventory/InventorySlots
	else:
		$CombatHotbar.initialize()
		$Hotbar.hide()
		$PlayerDataUI.show()
		$PlayerDataUI/EnergyBars.hide()
		PlayerData.InventorySlots = $Menu/Pages/inventory/InventorySlots

func toggle_menu():
	if not $Menu.visible:
		Sounds.play_big_select_sound()
		show_menu()
	else:
		Sounds.play_deselect_sound()
		hide_menu()


func show_menu():
	$CombatHotbar.hide()
	$Hotbar.hide()
	$PlayerDataUI.hide()
	PlayerData.viewInventoryMode = true
	$Menu.initialize()

func hide_menu():
	PlayerData.viewInventoryMode = false
	if PlayerData.normal_hotbar_mode:
		$PlayerDataUI.show()
		$PlayerDataUI/EnergyBars.show()
		$Hotbar.initialize_hotbar()
	else:
		$PlayerDataUI.show()
		$PlayerDataUI/EnergyBars.hide()
		$CombatHotbar.initialize()
	PlayerData.HotbarSlots = $Hotbar/HotbarSlots
	$Menu.hide()
	drop_items()
	get_node("../../").set_held_object()

func toggle_grain_mill(id, level):
	if not has_node("GrainMill"):
		play_open_menu_sound()
		var grainMill = GrainMill.instantiate()
		grainMill.level = level
		grainMill.id = id
		add_child(grainMill)
		close_hotbar_clock_and_stats()
	else:
		close_grain_mill()


func toggle_workbench(level):
	if not has_node("Workbench"):
		play_open_menu_sound()
		var workbench = Workbench.instantiate()
		workbench.level = level
		add_child(workbench)
		close_hotbar_clock_and_stats()
	else:
		close_workbench()


func toggle_furnace(id):
	if not has_node(id):
		play_open_menu_sound()
		var furnace = Furnace.instantiate()
		furnace.name = str(id)
		furnace.id = id
		add_child(furnace)
		close_hotbar_clock_and_stats()
	elif has_node(id) and not get_node(id).visible:
		play_open_menu_sound()
		get_node(id).initialize()
		close_hotbar_clock_and_stats()
	else:
		close_furnace(id)


func toggle_stove(id, level):
	if not has_node(id):
		play_open_menu_sound()
		var stove = Stove.instantiate()
		stove.name = str(id)
		stove.level = level
		stove.id = id
		add_child(stove)
		close_hotbar_clock_and_stats()
	elif has_node(id) and not get_node(id).visible:
		play_open_menu_sound()
		get_node(id).level = level
		get_node(id).initialize()
		close_hotbar_clock_and_stats()
	else:
		close_stove(id)


func toggle_campfire(id):
	if not has_node(id):
		play_open_menu_sound()
		var stove = Campfire.instantiate()
		stove.name = str(id)
		stove.id = id
		add_child(stove)
		close_hotbar_clock_and_stats()
	elif has_node(id) and not get_node(id).visible:
		play_open_menu_sound()
		get_node(id).initialize()
		close_hotbar_clock_and_stats()
	else:
		close_campfire(id)


func close_campfire(id):
	if not holding_item and has_node(id):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node(id).hide()
		drop_items()
		
func close_brewing_table(id):
	if not holding_item and has_node(id):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node(id).hide()
		drop_items()

func close_furnace(id):
	if not holding_item and has_node(id):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node(id).hide()
		drop_items()

func close_grain_mill():
	if not holding_item and has_node("GrainMill"):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node("GrainMill").destroy()
		drop_items()

func close_workbench():
	if not holding_item and has_node("Workbench"):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node("Workbench").destroy()
		drop_items()

func close_stove(id):
	if not holding_item and has_node(id):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node(id).hide()
		drop_items()

func close_chest(id):
	if not holding_item and has_node("Chest"):
		sound_effects.stream = load("res://Assets/Sound/Sound effects/chest/closed.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
		sound_effects.play()
		Server.world.get_node("PlacableObjects/"+id).close_chest()
		add_hotbar_clock_and_stats()
		get_node("Chest").destroy()
		drop_items()

func close_tc(id):
	if not holding_item and has_node("Tool cabinet"):
		Sounds.play_deselect_sound()
		add_hotbar_clock_and_stats()
		get_node("Tool cabinet").destroy()
		drop_items()

func drop_items():
	await get_tree().create_timer(0.25).timeout
	for i in range(items_to_drop.size()):
		InstancedScenes.initiateInventoryItemDrop(items_to_drop[i], Server.player_node.position)
	items_to_drop = []
	
	
func play_open_menu_sound():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/backpackIN.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()


func show_set_button_dialogue():
	if not $EnterNewKey.visible:
		$EnterNewKey.show()
		
func hide_set_button_dialogue():
	if $EnterNewKey.visible:
		$EnterNewKey.hide()

