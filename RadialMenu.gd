extends Control


onready var cam = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id +  "/Camera2D")

var buildings = ["wall", "door", "double door", "floor", "nothin", "nothin"]
var current_item = -1

func _ready():
	hide()

func radial_menu_off():
	cam.set_process_input(true)
	hide()
	if current_item != -1:
		get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id).current_building_item = buildings[current_item]


func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] == "blueprint":
			if event.is_action_pressed("radial_menu"):
				$Circle/AnimationPlayer.play("zoom")
				cam.set_process_input(false)
				show()
			if event.is_action_released("radial_menu"):
				radial_menu_off()
