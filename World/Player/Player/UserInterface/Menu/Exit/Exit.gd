extends Control


func _on_Save_pressed():
	Sounds.play_small_select_sound()
	PlayerData.save_player_data()
	MapData.save_map_data()

func _on_Exit_pressed():
	Sounds.play_small_select_sound()
	SceneChanger.goto_scene("res://MainMenu/MainMenu.tscn")
