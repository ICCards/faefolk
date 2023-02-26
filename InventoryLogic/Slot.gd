extends Panel

var default_text = null #load("res://Assets/Images/Inventory UI/slot.png")
var empty_text = null #load("res://Assets/Images/Inventory UI/slot.png")
var selected_text = load("res://Assets/Images/User interface/hotbars/selected slot.png")
var locked_text = null #load("res://Assets/Images/Inventory UI/slot locked.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null
var locked_style: StyleBoxTexture = null

var ItemClass = load("res://InventoryLogic/InventoryItem.tscn")
var item = null
var slot_index

enum SlotType {
	HOTBAR = 0,
	HOTBAR_INVENTORY,
	INVENTORY,
	CHEST,
	LOCKED,
	GRAIN_MILL,
	FURNACE,
	STOVE,
	CAMPFIRE,
	CRAFTING,
	COMBAT_HOTBAR,
	COMBAT_HOTBAR_INVENTORY,
	BARREL
}

var slotType = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	locked_style = StyleBoxTexture.new()
	default_style.texture = default_text
	empty_style.texture = empty_text
	selected_style.texture = selected_text
	locked_style.texture = locked_text
	refresh_style()

func refresh_style():
	if slotType == SlotType.HOTBAR and PlayerData.active_item_slot == slot_index:
		set('theme_override_styles/panel', selected_style)
	elif slotType == SlotType.COMBAT_HOTBAR and PlayerData.active_item_slot_combat_hotbar == slot_index:
		set('theme_override_styles/panel', selected_style)
	elif item == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', default_style)

func pickFromSlot():
	remove_child(item)
	find_parent("UserInterface").add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	find_parent("UserInterface").remove_child(item)
	add_child(item)

func initialize_item(item_name, item_quantity, item_health):
	if item == null:
		item = ItemClass.instantiate()
		add_child(item)
		item.set_item(item_name, item_quantity, item_health)
	else:
		item.set_item(item_name, item_quantity, item_health)
	refresh_style()

func removeFromSlot():
	remove_child(item)
	item = null

