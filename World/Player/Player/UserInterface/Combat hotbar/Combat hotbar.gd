extends Control

const SlotClass = preload("res://InventoryLogic/Slot.gd")
#onready var hotbar_slots = $HotbarSlots
#onready var slots = hotbar_slots.get_children()
var item = null
#var adjusted_pos = Vector2(0,0)
#
enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	CHEST
}
#
#func _ready():
#	for i in range(slots.size()):
#		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
#		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
#		slots[i].connect("mouse_entered", self, "hovered_slot", [slots[i]])
#		slots[i].connect("mouse_exited", self, "exited_slot", [slots[i]])
#		slots[i].slotType = SlotClass.SlotType.HOTBAR
#		slots[i].slot_index = i
#	initialize_hotbar()
#	Stats.connect("tool_health_change", self, "update_tool_health")
	
#func hovered_slot(slot: SlotClass):
#	Server.player_node.destroy_placable_object()
#	if slot.item:
#		slot.item.hover_item()
#		item = slot.item.item_name
#
#func exited_slot(slot: SlotClass):
#	item = null
#	if slot.item and not (slot.slotType == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot.slot_index):
#		slot.item.exit_item()

#func _physics_process(delta):
#	if not visible:
#		return
#	adjusted_description_position()
#	if item and find_parent("UserInterface").holding_item == null:
#		$ItemDescription.item_category = JsonData.item_data[item]["ItemCategory"]
#		$ItemDescription.show()
#		$ItemDescription.item_name = item
#		$ItemDescription.initialize()
#		$ItemDescription.position = adjusted_pos
#	else:
#		$ItemDescription.hide()

#
#func adjusted_description_position():
#	yield(get_tree(), "idle_frame")
#	if item:
#		var item_category = JsonData.item_data[item]["ItemCategory"]
#		var lines = $ItemDescription/Body/ItemDescription.get_line_count()
#		if lines == 8:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -288)
#		elif lines == 7:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -260)
#		elif lines == 6:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -236)
#		elif lines == 5:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -210)
#		elif lines == 4:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -184)
#		elif lines == 3:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -158)
#		else:
#			adjusted_pos = Vector2(get_local_mouse_position().x + 45, -134)
#		if item_category == "Food" or item_category == "Fish" or item_category == "Crop":
#			adjusted_pos += Vector2(0, -64)

#func update_tool_health():
#	if PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] == 0 and PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] != "stone watering can":
#		slots[PlayerInventory.active_item_slot].removeFromSlot()
#		PlayerInventory.remove_item(slots[PlayerInventory.active_item_slot])
#		yield(get_tree().create_timer(0.1), "timeout")
#		$SoundEffects.stream = Sounds.tool_break
#		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -18)
#		$SoundEffects.play()
#	else:
#		slots[PlayerInventory.active_item_slot].initialize_item(PlayerInventory.hotbar[PlayerInventory.active_item_slot][0], PlayerInventory.hotbar[PlayerInventory.active_item_slot][1], PlayerInventory.hotbar[PlayerInventory.active_item_slot][2])


#func initialize_hotbar():
#	show()
#	PlayerInventory.HotbarSlots = $HotbarSlots
#	item = null
#	for i in range(slots.size()):
#		if slots[i].item != null:
#			slots[i].removeFromSlot()
#		if PlayerInventory.hotbar.has(i):
#			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1], PlayerInventory.hotbar[i][2])
#	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
#		slots[PlayerInventory.active_item_slot].item.set_init_hovered()
#
#
#func slot_gui_input(event: InputEvent, slot: SlotClass):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT && event.pressed:
#			if Server.player_node.state == 0:
#				PlayerInventory.hotbar_slot_selected(slot)
