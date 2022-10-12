extends Node2D

var rng = RandomNumberGenerator.new()
var type
var location
var is_player

func _ready():
	rng.randomize()
	set_random_texture()

func set_random_texture():
	rng.randomize()
	Tiles.remove_invalid_tiles(location)
	type = rng.randi_range(1,4)
	$Flower.texture = load("res://Assets/Images/Forage/flower"+ str(type) +".png")

func _on_Btn_mouse_entered():
	set_mouse_cursor_type()

func _on_Btn_mouse_exited():
	Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))

func _on_Btn_pressed():
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
		Tiles.set_valid_tiles(location)
		$Flower.hide()
		$Btn.disabled = true
		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))
		Server.player_node.harvest_forage("flower"+str(type))
		yield(get_tree().create_timer(0.6), "timeout")
		PlayerInventory.add_item_to_hotbar("flower", 1, null)
		queue_free()

func set_mouse_cursor_type():
	if not $Btn.disabled:
		if $DetectPlayer.get_overlapping_areas().size() >= 1:
			Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/harvest.png"))
		else:
			Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/harvest transparent.png"))


func _on_DetectPlayer_area_entered(area):
	if $Btn.is_hovered():
		set_mouse_cursor_type()

func _on_DetectPlayer_area_exited(area):
	if $Btn.is_hovered():
		set_mouse_cursor_type()

