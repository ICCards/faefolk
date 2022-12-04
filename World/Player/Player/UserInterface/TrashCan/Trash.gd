extends Control


onready var sound_effects: AudioStreamPlayer = $SoundEffects


func _on_TrashButton_mouse_entered():
	open_trash_can()

func _on_TrashButton_mouse_exited():
	close_trash_can()

func _on_TrashButton_pressed():
	if find_parent("UserInterface").holding_item:
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/UI/trash/trashcan.wav")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null

func open_trash_can():
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/UI/trash/trashcanlid.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	$Tween.interpolate_property($Top, "rotation_degrees",
		$Top.rotation_degrees, 90, 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func close_trash_can():
	$Tween.interpolate_property($Top, "rotation_degrees",
		$Top.rotation_degrees, 0, 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
