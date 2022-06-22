extends Control


var hovered_button = ""
func _play_hover_effect(button_name):
	if hovered_button != button_name:
		$SoundEffects.stream = Sounds.button_hover
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()

func _on_PlayArea_mouse_entered():
	_play_hover_effect("play")
	$Tween.interpolate_property($Play, "scale",
		$Play.get_scale(), Vector2(1.035, 1.035), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Play, "position",
		$Play.get_position(), Vector2(0, -5),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_OptionsArea_mouse_entered():
	_play_hover_effect("options")
	$Tween.interpolate_property($Options, "scale",
		$Options.get_scale(), Vector2(1.035, 1.035), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Options, "position",
		$Options.get_position(), Vector2(0, -10),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_QuitArea_mouse_entered():
	_play_hover_effect("quit")
	$Tween.interpolate_property($Quit, "scale",
		$Play.get_scale(), Vector2(1.035, 1.035), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Quit, "position",
		$Quit.get_position(), Vector2(0, -15),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_PlayArea_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($Play, "scale",
		$Play.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Play, "position",
		$Play.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	

func _on_OptionsArea_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($Options, "scale",
		$Options.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Options, "position",
		$Options.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_QuitArea_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($Quit, "scale",
		$Quit.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Quit, "position",
		$Quit.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_PlayArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		$SoundEffects.stream = Sounds.button_select
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()
		SceneChanger.change_scene("res://World/World.tscn")


func _on_OptionsArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		get_parent().toggle_menu_open()
		$SoundEffects.stream = Sounds.button_select
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()


func _on_QuitArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		$SoundEffects.stream = Sounds.button_select
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()
		get_tree().quit()
