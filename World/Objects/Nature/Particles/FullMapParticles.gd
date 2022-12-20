extends Node2D

func _ready():
	PlayerData.connect("set_day", self, "play_set_day")
	PlayerData.connect("set_night", self, "play_set_night")
	if PlayerData.player_data["time_hours"] >= 18 or PlayerData.player_data["time_hours"] < 6:
		$Clouds.emitting = false
		$LargeClouds.emitting = false


func _process(delta):
	if not PlayerData.viewMapMode and Server.player_node:
		show()
		var forest = get_node("/root/World/GeneratedTiles/DarkGreenGrassTiles")
		if forest.get_cellv(forest.world_to_map(Server.player_node.position)) != -1:
			$FallingLeaf.emitting = true
		else: 
			$FallingLeaf.emitting = false
	else:
		hide()

func play_set_day():
	$Clouds.emitting = true
	$LargeClouds.emitting = true

func play_set_night():
	$Clouds.emitting = false
	$LargeClouds.emitting = false
