extends Node2D


var rng = RandomNumberGenerator.new()
var type
var location
var types = ["starfish", "baby starfish"]
var variety # 1 or 2

func _ready():
	randomize()
	type = types[variety-1]
	set_texture()

func set_texture():
	$Starfish.texture = load("res://Assets/Images/Forage/"+ str(type) +".png")

func _on_Btn_mouse_entered():
	set_mouse_cursor_type()

func _on_Btn_mouse_exited():
	Input.set_custom_mouse_cursor(Images.normal_mouse)

func _on_Btn_pressed():
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
		MapData.world["forage"].erase(name)
		PlayerData.player_data["collections"]["forage"][type] += 1
		Tiles.add_valid_tiles(location)
		$Starfish.hide()
		$Btn.disabled = true
		Input.set_custom_mouse_cursor(Images.normal_mouse)
		Server.player_node.actions.harvest_forage(str(type))
		yield(get_tree().create_timer(0.6), "timeout")
		PlayerData.add_item_to_hotbar(type, 1, null)
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
