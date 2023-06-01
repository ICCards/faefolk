extends Control

@onready var SlotClass = load("res://InventoryLogic/Slot.gd")
@onready var hotbar_slots = $HotbarSlots
@onready var slots = hotbar_slots.get_children()
var item = null
var adjusted_pos = Vector2(0,0)


func _ready():
	PlayerData.HotbarSlots = hotbar_slots
	for i in range(slots.size()):
		PlayerData.connect("active_item_updated",Callable(slots[i],"refresh_style"))
		slots[i].connect("gui_input",Callable(self,"slot_gui_input").bind(slots[i]))
		slots[i].connect("mouse_entered",Callable(self,"hovered_slot").bind(slots[i]))
		slots[i].connect("mouse_exited",Callable(self,"exited_slot").bind(slots[i]))
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	Stats.connect("tool_health_change_hotbar",Callable(self,"update_tool_health"))
	
func hovered_slot(slot):
	if slot.item:
		item = slot.item.item_name

func exited_slot(slot):
	item = null

func _physics_process(delta):
	if not visible or Server.isLoaded == false:
		return
	adjusted_description_position()
	if item and find_parent("UserInterface").holding_item == null:
		$ItemDescription.show()
		$ItemDescription.item_name = item
		$ItemDescription.initialize()
		$ItemDescription.position = adjusted_pos
	else:
		$ItemDescription.hide()


func adjusted_description_position():
	await get_tree().process_frame
	if item:
		var item_category = JsonData.item_data[item]["ItemCategory"]
		var lines = $ItemDescription/Body/ItemDescription.get_line_count()
		if lines == 8:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -130)
		elif lines == 7:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -106)
		elif lines == 6:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -84)
		elif lines == 5:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -60)
		elif lines == 4:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -38)
		elif lines == 3:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -14)
		else:
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, 7)
		if item_category == "Food" or item_category == "Fish" or item_category == "Crop":
			adjusted_pos += Vector2(0, -58)

func update_tool_health():
	var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
	if PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2] == 0 and item_name != "stone watering can" and item_name != "bronze watering can" and item_name != "gold watering can":
		slots[PlayerData.active_item_slot].removeFromSlot()
		PlayerData.remove_item(slots[PlayerData.active_item_slot])
		await get_tree().create_timer(0.15).timeout
		$SoundEffects.stream = Sounds.tool_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
		$SoundEffects.play()
	else:
		slots[PlayerData.active_item_slot].initialize_item(PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0], PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][1], PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2])


func initialize_hotbar():
	show()
	item = null
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerData.player_data["hotbar"].has(str(i)):
			slots[i].initialize_item(PlayerData.player_data["hotbar"][str(i)][0], PlayerData.player_data["hotbar"][str(i)][1], PlayerData.player_data["hotbar"][str(i)][2])
	PlayerData.emit_signal("active_item_updated")

func slot_gui_input(event: InputEvent, slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if Server.player_node.state == 0:
				Sounds.play_hotbar_slot_selected_sound()
				PlayerData.hotbar_slot_selected(slot)


func _on_SwitchHotbarBtn_pressed():
	get_parent().switch_hotbar()
