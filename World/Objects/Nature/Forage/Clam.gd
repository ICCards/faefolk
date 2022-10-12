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
	type = rng.randi_range(1,3)
	$Clam.texture = load("res://Assets/Images/Forage/clam"+ str(type) +".png")

func _on_Btn_mouse_entered():
	if not $Btn.disabled:
		set_mouse_cursor_type()

func _on_Btn_mouse_exited():
	Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))

func _on_Btn_pressed():
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
		Tiles.set_valid_tiles(location)
		$Clam.hide()
		$Btn.disabled = true
		$MovementCollision/CollisionShape2D.disabled = true
		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))
		Server.player_node.harvest_forage("clam"+str(type))
		yield(get_tree().create_timer(0.6), "timeout")
		PlayerInventory.add_item_to_hotbar("clam", 1, null)
		if Util.chance(1):
			PlayerInventory.add_item_to_hotbar("pearl", 1, null)
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
