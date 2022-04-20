extends Control

func _on_PlayButton_pressed():
	$SoundEffects.stream = Global.button_select
	$SoundEffects.play()
	SceneChanger.change_scene("res://World/World.tscn")

func _on_OptionsButton_pressed():
	$SoundEffects.stream = Global.button_select
	$SoundEffects.play()
	Global.randomizeAttributes()

func _on_QuitButton_pressed():
	$SoundEffects.stream = Global.button_select
	$SoundEffects.play()
	get_tree().quit()

var hovered_button = ""
var soundActiveFlag = false
func _play_hover_effect(name):
	if hovered_button != name:
		$SoundEffects.stream = Global.button_hover
		$SoundEffects.play()
		soundActiveFlag = true
		hovered_button = name
		yield($SoundEffects, "finished")
		soundActiveFlag = false
		
		
func _on_PlayButton_mouse_entered():
	_play_hover_effect("play")


func _on_PlayButton_mouse_exited():
	hovered_button = ""

func _on_OptionsButton_mouse_entered():
	_play_hover_effect("options")

func _on_OptionsButton_mouse_exited():
	hovered_button = ""


func _on_QuitButton_mouse_entered():
	_play_hover_effect("quit")


func _on_QuitButton_mouse_exited():
	hovered_button = ""


