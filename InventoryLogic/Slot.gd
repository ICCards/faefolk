extends Panel

var default_text = null #preload("res://Assets/Images/Inventory UI/item_slot_default_background.png")
var empty_text = null #preload("res://Assets/Images/Inventory UI/item_slot_empty_background.png")
var selected_text = preload("res://Assets/Images/Inventory UI/selected_hotbar.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://InventoryLogic/InventoryItem.tscn")
var item = null
var slot_index

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

var slotType = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_text
	empty_style.texture = empty_text
	selected_style.texture = selected_text
	
	refresh_style()

func refresh_style():
	if slotType == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
	elif item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
		

func pickFromSlot():
	remove_child(item)
	find_parent("UserInterface").add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	find_parent("UserInterface").remove_child(item)
	add_child(item)

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

func removeFromSlot():
	remove_child(item)
	item = null

