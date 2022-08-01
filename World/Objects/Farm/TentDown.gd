extends Node2D


func _on_Entrance_area_entered(area):
	SceneChanger.goto_scene("res://World/InsidePlayerHouse/InsidePlayerTent.tscn")
