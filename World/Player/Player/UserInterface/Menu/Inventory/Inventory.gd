extends Control

var hovered_item = null

func _ready():
	$CompositeSprites/AnimationPlayer.play("loop")

func initialize():
	show()
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()
	PlayerData.InventorySlots = $InventorySlots
	hovered_item = null

func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func _physics_process(delta):
	if not visible:
		return
	if hovered_item and not find_parent("UserInterface").holding_item:
		get_node("../ItemDescription").show()
		get_node("../ItemDescription").item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		get_node("../ItemDescription").item_name = hovered_item
		get_node("../ItemDescription").initialize()
	else:
		get_node("../ItemDescription").hide()
