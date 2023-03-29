extends Control

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

var id
var level

var hovered_item
var ingredients = []


func _ready():
	initialize()

func destroy():
	set_physics_process(false)
	$ItemDescription.queue_free()
	queue_free()

func _physics_process(delta):
	if hovered_item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		$ItemDescription.item_name = hovered_item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()

func initialize():
	show()
	Server.player_node.actions.destroy_placeable_object()
	$MenuTitle/Label.text = "Brewing table #" + str(level)
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()


func _on_exit_btn_pressed():
	get_parent().close_stove(id)
