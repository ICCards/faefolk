extends Node2D


var rng = RandomNumberGenerator.new()
var variety
var location

func _ready():
	rng.randomize()
	set_random_texture()

func set_random_texture():
	$Mushroom.texture = load("res://Assets/Images/Forage/Mushroom/"+ str(variety) +".png")

func _on_Btn_mouse_entered():
	set_mouse_cursor_type()

func _on_Btn_mouse_exited():
	Input.set_custom_mouse_cursor(Images.normal_mouse)

func _on_Btn_pressed():
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
		PlayerData.player_data["collections"]["forage"]["mushroom"] += 1
		Tiles.add_valid_tiles(location)
		$Mushroom.hide()
		$Btn.disabled = true
		Input.set_custom_mouse_cursor(Images.normal_mouse)
		Server.player_node.actions.harvest_forage("Mushroom/"+str(variety))
		MapData.remove_object("mushroom", name)
		yield(get_tree().create_timer(0.6), "timeout")
		PlayerData.add_item_to_hotbar("mushroom", 1, null)
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
