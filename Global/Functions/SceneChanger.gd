extends CanvasLayer



onready var animation_player = $AnimationPlayer
onready var black = $Node/Black

func change_scene(path, var sound = ""):
	if sound == "door":
		$SoundEffects.stream = Sounds.door_open
		$SoundEffects.play()
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))
	if sound == "door":
		$SoundEffects.stream = Sounds.door_close
		$SoundEffects.play()
	animation_player.play_backwards("fade")
