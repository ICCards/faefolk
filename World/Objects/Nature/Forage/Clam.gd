extends Node2D

var type
var location
var types = ["pink", "red", "blue"]
var pearl_types = ["pink", "white", "blue"]
var variety # 1 2 or 3

func _ready():
	type = types[variety-1]
	set_texture() 

func set_texture():
	$Clam.texture = load("res://Assets/Images/Forage/" + str(type) + " clam.png")

func _on_Btn_mouse_entered():
	if not $Btn.disabled:
		set_mouse_cursor_type()

func _on_Btn_mouse_exited():
	Input.set_custom_mouse_cursor(Images.normal_mouse)

func _on_Btn_pressed():
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
		MapData.world["forage"].erase(name)
		PlayerData.player_data["collections"]["forage"][str(type)+" clam"] += 1
		Tiles.add_valid_tiles(location)
		$Clam.hide()
		$Btn.disabled = true
		$MovementCollision/CollisionShape2D.disabled = true
		Input.set_custom_mouse_cursor(Images.normal_mouse)
		Server.player_node.actions.harvest_forage(str(type)+" clam")
		yield(get_tree().create_timer(0.6), "timeout")
		PlayerData.add_item_to_hotbar(str(type) + " clam", 1, null)
		if Util.chance(1):
			pearl_types.shuffle()
			PlayerData.add_item_to_hotbar(pearl_types[0]+" pearl", 1, null)
			PlayerData.player_data["collections"]["forage"][pearl_types[0]+" pearl"] += 1
		queue_free()

func set_mouse_cursor_type():
	if not $Btn.disabled:
		if $DetectPlayer.get_overlapping_areas().size() >= 1:
			Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/harvest.png"))
		else:
			Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/harvest transparent.png"))


func _on_DetectPlayer_area_entered(area):
	if $Btn.is_hovered():
		set_mouse_cursor_type()

func _on_DetectPlayer_area_exited(area):
	if $Btn.is_hovered():
		set_mouse_cursor_type()
