extends Control

onready var object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
var level

func initialize():
	var player_pos = get_node("/root/World/Players/" +  str(Server.player_id)).get_position()
	if object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(0, -32))) == PlaceObject.Placables.WORKBENCH1 or \
	object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(-32, -32))) == PlaceObject.Placables.WORKBENCH1:
		level = 1
	elif object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(0, -32))) == PlaceObject.Placables.WORKBENCH2 or \
	object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(-32, -32))) == PlaceObject.Placables.WORKBENCH2:
		level = 2
	elif object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(0, -32))) == PlaceObject.Placables.WORKBENCH3 or \
	object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(-32, -32))) == PlaceObject.Placables.WORKBENCH3:
		level = 3
		$UpgradeButton.visible = false


func _on_UpgradeButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	upgrade_workbench()
	
func upgrade_workbench():
	var playerPos = get_node("/root/World/Players/" +  str(Server.player_id)).get_position()
	PlaceObject.upgrade_workbench(playerPos)
