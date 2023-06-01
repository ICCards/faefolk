extends Node2D

const LENGTH_OF_TRANSITION = 60.0


func _ready():
	PlayerData.connect("set_sunrise",Callable(self,"play_set_day"))
	PlayerData.connect("set_sunset",Callable(self,"play_set_night"))

func initialize():
	if get_node("../").server_data["time_hours"] >= 22 or get_node("../").server_data["time_hours"] < 6: # night time
		$Clouds.set_deferred("self_modulate", Color("00ffffff"))
		$LargeClouds.set_deferred("self_modulate", Color("00ffffff"))

func _physics_process(delta):
	if Server.player_node:
		show()
		if Tiles.forest_tiles.get_cell_atlas_coords(0,Tiles.forest_tiles.local_to_map(Server.player_node.position)) != Vector2i(-1,-1):
			$FallingLeaf.emitting = true
		else: 
			$FallingLeaf.emitting = false
	else:
		hide()

func play_set_day():
	var tween = get_tree().create_tween()
	tween.tween_property($Clouds, "self_modulate", Color("ffffff"), LENGTH_OF_TRANSITION)
	tween.tween_property($LargeClouds, "self_modulate", Color("ffffff"), LENGTH_OF_TRANSITION)

func play_set_night():
	var tween = get_tree().create_tween()
	tween.tween_property($Clouds, "self_modulate", Color("00ffffff"), LENGTH_OF_TRANSITION)
	tween.tween_property($LargeClouds, "self_modulate", Color("00ffffff"), LENGTH_OF_TRANSITION)
