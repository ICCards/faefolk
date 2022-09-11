extends Control

var object_tiles
var level

func initialize():
	if has_node("/root/World/Players/" +  str(Server.player_id)):
		object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
		var player_pos = get_node("/root/World/Players/" +  str(Server.player_id)).get_position()
		if object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(0, -32))) == PlaceObject.Placables.GRAIN_MILL1 or \
		object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(-32, -32))) == PlaceObject.Placables.GRAIN_MILL1:
			level = 1
			$UpgradeButton.visible = true
		elif object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(0, -32))) == PlaceObject.Placables.GRAIN_MILL2 or \
		object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(-32, -32))) == PlaceObject.Placables.GRAIN_MILL2:
			level = 2
			$UpgradeButton.visible = true
		elif object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(0, -32))) == PlaceObject.Placables.GRAIN_MILL3 or \
		object_tiles.get_cellv(object_tiles.world_to_map(player_pos + Vector2(-32, -32))) == PlaceObject.Placables.GRAIN_MILL3:
			level = 3
			$UpgradeButton.visible = false

func _on_UpgradeButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	upgrade_grain_mill()
	
func upgrade_grain_mill():
	var playerPos = get_node("/root/World/Players/" +  str(Server.player_id)).get_position()
	PlaceObject.upgrade_grain_mill(playerPos)