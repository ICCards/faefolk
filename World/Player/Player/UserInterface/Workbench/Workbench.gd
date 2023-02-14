extends Control

const MAX_SCROLL_SIZE = 34

var level

var crafting_item
var hovered_item

var level_1_items = ["wood axe", "wood pickaxe", "wood hoe", "wood sword", "stone axe", "stone pickaxe", "stone hoe", "stone sword","stone watering can", "wood fishing rod", "scythe", "arrow"]
var level_2_items = ["bronze axe", "bronze pickaxe", "bronze hoe", "bronze sword", "bronze watering can", "stone fishing rod", "bow"]

@onready var SlotClass = load("res://InventoryLogic/Slot.gd")
@onready var InventoryItem = load("res://InventoryLogic/InventoryItem.tscn")

func _ready():
	initialize()

func initialize():
	initialize_crafting()
	#Server.player_node.actions.destroy_placable_object()
	hovered_item = null
	crafting_item = null
	$MenuTitle.text = "Workbench #" + str(level) + ":"
	show()

func initialize_crafting():
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()
	$CraftingMenuWorkbench.initialize()


func destroy():
	set_physics_process(false)
	$ItemDescription.set_physics_process(false)
	$ItemDescription.queue_free()
	$CraftingItemDescription.queue_free()
	$ItemNameBox.queue_free()
	queue_free()


func _physics_process(delta):
	if hovered_item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		$ItemDescription.item_name = hovered_item
		$ItemDescription.initialize()
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
	else:
		$ItemDescription.hide()
	if crafting_item and not find_parent("UserInterface").holding_item:
		if $CraftingMenuWorkbench/Items.get_node(crafting_item+"/button").disabled:
			$CraftingItemDescription.hide()
			$ItemNameBox.show()
			$ItemNameBox.position = get_local_mouse_position() + Vector2(20 , 25)
		else:
			$ItemNameBox.hide()
			$CraftingItemDescription.show()
			$CraftingItemDescription.item_name = crafting_item
			$CraftingItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
			$CraftingItemDescription.initialize()
	else:
		$ItemNameBox.hide()
		$CraftingItemDescription.hide()


#func adjusted_item_description():
#	var height = float($ItemDescription.height) * 2.4
#	var pos = $ItemDescription.position.y
#	var max_pos = 720 - height
#	if get_local_mouse_position().y < 720:
#		return get_local_mouse_position()
#	else:
#		return Vector2(get_local_mouse_position().x , max_pos.y)


func entered_crafting_area(item_name):
	crafting_item = item_name
	var tween = get_tree().create_tween()
	tween.tween_property($CraftingMenuWorkbench/Items.get_node(item_name), "scale", Vector2(1.1, 1.1), 0.1)



func exited_crafting_area(item_name):
	crafting_item = null
	var tween = get_tree().create_tween()
	tween.tween_property($CraftingMenuWorkbench/Items.get_node(item_name), "scale", Vector2(1.0, 1.0), 0.1)


func craft(item_name):
	if not get_parent().holding_item and PlayerData.isSufficientMaterialToCraft(item_name):
		find_parent("UserInterface").holding_item = return_crafted_item(item_name)
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		PlayerData.craft_item(item_name)
	elif find_parent("UserInterface").holding_item:
		if find_parent("UserInterface").holding_item.item_name == "arrow" and PlayerData.isSufficientMaterialToCraft(item_name):
			PlayerData.craft_item(item_name)
			find_parent("UserInterface").holding_item.add_item_quantity(1)
	initialize_crafting()

func return_crafted_item(item_name):
	var inventoryItem = InventoryItem.instantiate()
	inventoryItem.set_item(item_name, 1, Stats.return_max_tool_health(item_name))
	find_parent("UserInterface").add_child(inventoryItem)
	return inventoryItem

func _on_ExitBtn_pressed():
	get_parent().close_workbench()


func _on_Slider_value_changed(value):
	$CraftingMenuWorkbench.scroll_vertical = ((100-value))/100*MAX_SCROLL_SIZE
