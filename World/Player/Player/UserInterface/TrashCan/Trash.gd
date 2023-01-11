extends Control

onready var sound_effects: AudioStreamPlayer = $SoundEffects

func initialize():
	show()
	$Top.rotation_degrees = 0

func _on_TrashButton_mouse_entered():
	open_trash_can()

func _on_TrashButton_mouse_exited():
	close_trash_can()

func _on_TrashButton_pressed():
	if find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/trash/trashcan.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
		if get_parent().name == "Workbench" or get_parent().name == "crafting":
			get_parent().initialize_crafting()

func open_trash_can():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/trash/trashcanlid.mp3")
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


func _on_BackgroundButton_pressed():
	if find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/throwDownITem.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		find_parent("UserInterface").items_to_drop.append([find_parent("UserInterface").holding_item.item_name, find_parent("UserInterface").holding_item.item_quantity, find_parent("UserInterface").holding_item.item_health])
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
		if get_parent().name == "Workbench" or get_parent().name == "crafting":
			get_parent().initialize_crafting()
