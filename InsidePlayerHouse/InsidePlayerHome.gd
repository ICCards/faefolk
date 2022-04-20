extends Node2D


var is_moving_object


func _on_Doorway_area_entered(area):
	SceneChanger.change_scene("res://World/World.tscn", "door")
