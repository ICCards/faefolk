extends Control

func _on_PlayButton_pressed():
	SceneChanger.change_scene("res://World/World.tscn")

func _on_OptionsButton_pressed():
	Global.randomizeAttributes()

func _on_QuitButton_pressed():
	get_tree().quit()
