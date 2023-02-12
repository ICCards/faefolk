extends Node2D

const LENGTH_OF_TRANSITION = 60.0

var tween = get_tree().create_tween()

func _ready():
	PlayerData.connect("set_day",Callable(self,"play_set_day"))
	PlayerData.connect("set_night",Callable(self,"play_set_night"))
	if PlayerData.player_data:
		if PlayerData.player_data["time_hours"] >= 18 or PlayerData.player_data["time_hours"] < 6:
			$Clouds.set_deferred("self_modulate", Color("00ffffff"))
			$LargeClouds.set_deferred("self_modulate", Color("00ffffff"))

func _physics_process(delta):
	if Server.player_node:
		show()
		if Tiles.forest_tiles.get_cellv(Tiles.forest_tiles.local_to_map(Server.player_node.position)) != -1:
			$FallingLeaf.emitting = true
		else: 
			$FallingLeaf.emitting = false
	else:
		hide()

func play_set_day():
	tween.tween_property($Clouds, "self_modulate", Color("ffffff"), LENGTH_OF_TRANSITION)
	tween.tween_property($LargeClouds, "self_modulate", Color("ffffff"), LENGTH_OF_TRANSITION)

func play_set_night():
	tween.tween_property($Clouds, "self_modulate", Color("00ffffff"), LENGTH_OF_TRANSITION)
	tween.tween_property($LargeClouds, "self_modulate", Color("00ffffff"), LENGTH_OF_TRANSITION)
