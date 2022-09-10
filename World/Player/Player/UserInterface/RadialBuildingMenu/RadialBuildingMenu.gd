extends Control


onready var cam = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id +  "/Camera2D")

var buildings = ["wall", "double door", "foundation", "nada", "nothin", "nothin"]
var current_item = -1

func _ready():
	hide()

func radial_menu_off():
	cam.set_process_input(true) 
	hide()
	if current_item != -1:
		Server.player_node.current_building_item = buildings[current_item]


func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] == "blueprint":
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
				if event.is_pressed():
					show()
					Server.player_node.destroy_placable_object()
					$Circle/AnimationPlayer.play("zoom")
					cam.set_process_input(false)
					PlayerInventory.viewInventoryMode = true
				else:
					radial_menu_off()
					PlayerInventory.viewInventoryMode = false
