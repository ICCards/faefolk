extends Node2D


var rng = RandomNumberGenerator.new()
var variety
var location

var harvested = false

func _ready():
	rng.randomize()
	set_random_texture()

func set_random_texture():
	$Mushroom.texture = load("res://Assets/Images/Forage/Mushroom/"+ str(variety) +".png")
	
func _input(event):
	if event.is_action_pressed("action") and $DetectPlayer.get_overlapping_areas().size() >= 1:
		PlayerData.player_data["collections"]["forage"]["mushroom"] += 1
		Tiles.add_valid_tiles(location)
		$Mushroom.hide()
		Server.player_node.actions.harvest_forage("Mushroom/"+str(variety))
		MapData.remove_object("mushroom", name)
		yield(get_tree().create_timer(0.6), "timeout")
		PlayerData.add_item_to_hotbar("mushroom", 1, null)
		queue_free()

#func _on_Btn_mouse_entered():
#	set_mouse_cursor_type()
#
#func _on_Btn_mouse_exited():
#	Input.set_custom_mouse_cursor(Images.normal_mouse)

#func _on_Btn_pressed():
#	if $DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
#		PlayerData.player_data["collections"]["forage"]["mushroom"] += 1
#		Tiles.add_valid_tiles(location)
#		$Mushroom.hide()
#		$Btn.disabled = true
#		Input.set_custom_mouse_cursor(Images.normal_mouse)
#		Server.player_node.actions.harvest_forage("Mushroom/"+str(variety))
#		MapData.remove_object("mushroom", name)
#		yield(get_tree().create_timer(0.6), "timeout")
#		Input.set_custom_mouse_cursor(Images.normal_mouse)
#		PlayerData.add_item_to_hotbar("mushroom", 1, null)
#		queue_free()

#func _physics_process(delta):
#	if $DetectPlayer.get_overlapping_areas().size() >= 1:
#		$Btn.disabled = false
#		if $Btn.is_hovered():
#			set_mouse_cursor_type()
#	else:
#		$Btn.disabled = true

#func _on_DetectPlayer_area_entered(area):
#	if $Btn.is_hovered():
#		set_mouse_cursor_type()
#
#func _on_DetectPlayer_area_exited(area):
#	if $Btn.is_hovered():
#		Input.set_custom_mouse_cursor(Images.normal_mouse)
