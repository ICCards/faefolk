extends Node2D

func _on_Doorway_area_entered(_area):
	Server.player_node = Server.world.get_node("Players/"+Server.player_id)
	Server.world = null
	Server.isLoaded = false
	SceneChanger.goto_scene("res://World/InsidePlayerHouse/InsidePlayerHome.tscn")

onready var tween = $Tween
func set_house_transparent():
	tween.interpolate_property($HouseSprite, "modulate",
		$HouseSprite.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func set_house_visible():
	tween.interpolate_property($HouseSprite, "modulate",
		$HouseSprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	

func _on_BehindHouseArea_area_entered(_area):
	set_house_transparent()


func _on_BehindHouseArea_area_exited(_area):
	set_house_visible()
