extends Node2D

const LENGTH_OF_TRANSITION = 60.0


func _ready():
	PlayerData.connect("set_day", self, "play_set_day")
	PlayerData.connect("set_night", self, "play_set_night")
	if PlayerData.player_data:
		if PlayerData.player_data["time_hours"] >= 18 or PlayerData.player_data["time_hours"] < 6:
			$Clouds.set_deferred("self_modulate", Color("00ffffff"))
			$LargeClouds.set_deferred("self_modulate", Color("00ffffff"))

func _physics_process(delta):
	if Server.player_node:
		show()
		if Tiles.forest_tiles.get_cellv(Tiles.forest_tiles.world_to_map(Server.player_node.position)) != -1:
			$FallingLeaf.emitting = true
		else: 
			$FallingLeaf.emitting = false
	else:
		hide()

func play_set_day():
	$Tween.interpolate_property($Clouds, "self_modulate",
		Color("00ffffff"), Color("ffffff"), LENGTH_OF_TRANSITION,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($LargeClouds, "self_modulate",
		Color("00ffffff"), Color("ffffff"), LENGTH_OF_TRANSITION,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func play_set_night():
	$Tween.interpolate_property($Clouds, "self_modulate",
		Color("ffffff"), Color("00ffffff"), LENGTH_OF_TRANSITION,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($LargeClouds, "self_modulate",
		Color("ffffff"), Color("00ffffff"), LENGTH_OF_TRANSITION,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
