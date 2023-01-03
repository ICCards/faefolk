extends Control

onready var SlotClass = load("res://InventoryLogic/Slot.gd")
onready var hotbar_slots = $HotbarSlots
onready var slots = hotbar_slots.get_children()
var item = null
var adjusted_pos = Vector2(0,0)

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	CHEST
}

func _ready():
	yield(get_tree(), "idle_frame")
	for i in range(slots.size()):
		PlayerData.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "hovered_slot", [slots[i]])
		slots[i].connect("mouse_exited", self, "exited_slot", [slots[i]])
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()
	Stats.connect("tool_health_change", self, "update_tool_health")
	
func hovered_slot(slot):
	Server.player_node.actions.destroy_placable_object()
	if slot.item:
		#slot.item.hover_item()
		item = slot.item.item_name

func exited_slot(slot):
	item = null
#	if slot.item and not (slot.slotType == SlotType.HOTBAR and PlayerData.active_item_slot == slot.slot_index):
#		slot.item.exit_item()

func _physics_process(delta):
	if not visible:
		return
	adjusted_description_position()
	if item and find_parent("UserInterface").holding_item == null:
		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
		$ItemDescription.show()
		$ItemDescription.item_name = item
		$ItemDescription.initialize()
		$ItemDescription.position = adjusted_pos
	else:
		$ItemDescription.hide()


func adjusted_description_position():
	yield(get_tree(), "idle_frame")
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
			adjusted_pos = Vector2(get_local_mouse_position().x + 45, 7) #-134)
		if item_category == "Food" or item_category == "Fish" or item_category == "Crop":
			adjusted_pos += Vector2(0, -84)

func update_tool_health():
	var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
	if PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2] == 0 and item_name != "stone watering can" and item_name != "bronze watering can" and item_name != "gold watering can":
		slots[PlayerData.active_item_slot].removeFromSlot()
		PlayerData.remove_item(slots[PlayerData.active_item_slot])
		yield(get_tree().create_timer(0.1), "timeout")
		$SoundEffects.stream = Sounds.tool_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
	else:
		slots[PlayerData.active_item_slot].initialize_item(PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0], PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][1], PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2])


func initialize_hotbar():
	show()
	PlayerData.HotbarSlots = $HotbarSlots
	item = null
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].removeFromSlot()
		if PlayerData.player_data["hotbar"].has(str(i)):
			slots[i].initialize_item(PlayerData.player_data["hotbar"][str(i)][0], PlayerData.player_data["hotbar"][str(i)][1], PlayerData.player_data["hotbar"][str(i)][2])
	if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		slots[PlayerData.active_item_slot].item.set_init_hovered()
	PlayerData.emit_signal("active_item_updated")

func slot_gui_input(event: InputEvent, slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if Server.player_node.state == 0:
				PlayerData.hotbar_slot_selected(slot)
