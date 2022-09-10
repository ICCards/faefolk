extends Control


onready var cam = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id +  "/Camera2D")

var buttons = ["twig", "wood", "stone", "metal", "armored", "demolish"]
var current_index = -1
var location
var autotile_cord
var tile_node

func _ready():
	hide()

func initialize(_loc, _cord, _node):
	current_index = -1
	location = _loc
	autotile_cord = _cord
	tile_node = _node
	show()
	Server.player_node.destroy_placable_object()
	$Circle/AnimationPlayer.play("zoom")
	cam.set_process_input(false)
	PlayerInventory.viewInventoryMode = true


func radial_menu_off():
	cam.set_process_input(true) 
	hide()
	if current_index != -1:
		change_tile()

func change_tile():
	var new_tier = buttons[current_index]
	tile_node.tier = new_tier
	tile_node.set_type()
	match new_tier:
		"twig":
			Tiles.wall_tiles.set_cell(location.x, location.y, 0, false, false, false, autotile_cord )
		"wood":
			Tiles.wall_tiles.set_cell(location.x, location.y, 1, false, false, false, autotile_cord )
		"stone":
			Tiles.wall_tiles.set_cell(location.x, location.y, 2, false, false, false, autotile_cord )
		"metal":
			Tiles.wall_tiles.set_cell(location.x, location.y, 3, false, false, false, autotile_cord )
		"armored":
			Tiles.wall_tiles.set_cell(location.x, location.y, 4, false, false, false, autotile_cord )
		"demolish":
			Tiles.wall_tiles.set_cell(location.x, location.y, -1)

func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] == "hammer":
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
				if not event.is_pressed():
					radial_menu_off()
					PlayerInventory.viewInventoryMode = false
