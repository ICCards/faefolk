extends Node2D

func _on_Doorway_area_entered(area):
	SceneChanger.change_scene("res://InsidePlayerHouse/InsidePlayerHome.tscn", "door")




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
	



func _on_BehindHouseArea_area_entered(area):
	set_house_transparent()


func _on_BehindHouseArea_area_exited(area):
	set_house_visible()
