extends Control


func _on_PlayButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.play()
	DayNightTimer.start_day_timer()
	SceneChanger.change_scene("res://World/PlayerFarm/PlayerFarm.tscn")

func _on_OptionsButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.play()

func _on_QuitButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.play()
	get_tree().quit()

var hovered_button = ""
var soundActiveFlag = false
func _play_hover_effect(name):
	if hovered_button != name:
		$SoundEffects.stream = Sounds.button_hover
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



func _on_Area2D_mouse_entered():
	print("entered play button")
	#$Sprite.scale = Vector2(1.2, 1.2)
	$Tween.interpolate_property($Sprite, "scale",
		$Sprite.get_scale(), Vector2(1.05, 1.05), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	

#	tween.interpolate_property($TreeSprites/TreeBottom, "modulate",
#		$TreeSprites/TreeBottom.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()



func _on_Area2D_mouse_exited():
	$Tween.interpolate_property($Sprite, "scale",
		$Sprite.get_scale(), Vector2(1, 1), 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
