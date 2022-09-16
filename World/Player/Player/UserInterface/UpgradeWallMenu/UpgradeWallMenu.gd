extends Control


onready var cam = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id +  "/Camera2D")

var buttons = ["twig", "wood", "stone", "metal", "armored", "demolish"]
var current_index = -1
var location
var tile_node

func _ready():
	hide()

func initialize(_loc, _node):
	current_index = -1
	location = _loc
	tile_node = _node
	show()
	$Circle/AnimationPlayer.play("zoom")
	cam.set_process_input(false)
	PlayerInventory.viewInventoryMode = true


func destroy():
	cam.set_process_input(true) 
	hide()
	if is_instance_valid(tile_node):
		tile_node.remove_icon()
	if current_index != -1:
		change_tile()
		current_index = -1
	
func change_tile():
	Server.world.play_upgrade_building_effect(location)
	var new_tier = buttons[current_index]
	tile_node.tier = new_tier
	tile_node.set_type()


func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] == "hammer":
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and PlayerInventory.viewInventoryMode:
				if not event.is_pressed():
					destroy()
					yield(get_tree().create_timer(0.25), "timeout")
					PlayerInventory.viewInventoryMode = false
