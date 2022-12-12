extends Control


func _on_Save_pressed():
	PlayerData.save_player_data()

func _on_Exit_pressed():
	SceneChanger.goto_scene("res://MainMenu/MainMenu.tscn")
