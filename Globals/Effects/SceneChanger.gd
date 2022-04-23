extends CanvasLayer



onready var animation_player = $AnimationPlayer
onready var black = $Node/Black

func change_scene(path, var sound = ""):
	if sound == "door":
		$SoundEffects.stream = Global.door_open
		$SoundEffects.play()
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	if sound == "door":
		$SoundEffects.stream = Global.door_close
		$SoundEffects.play()
	animation_player.play_backwards("fade")
