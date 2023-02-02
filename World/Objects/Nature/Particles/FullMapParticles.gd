extends Node2D

func _ready():
	PlayerData.connect("set_day", self, "play_set_day")
	PlayerData.connect("set_night", self, "play_set_night")
	if PlayerData.player_data:
		if PlayerData.player_data["time_hours"] >= 18 or PlayerData.player_data["time_hours"] < 6:
			$Clouds.set_deferred("emitting", false)
			$LargeClouds.set_deferred("emitting", false)

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
	$Clouds.set_deferred("emitting", true)
	$LargeClouds.set_deferred("emitting", true)

func play_set_night():
	$Clouds.set_deferred("emitting", false)
	$LargeClouds.set_deferred("emitting", false)
