extends Node2D

func _ready():
	pass 





func _on_Doorway_area_entered(area):
	SceneChanger.change_scene("res://InsidePlayerHouse/InsidePlayerHome.tscn", "door")
