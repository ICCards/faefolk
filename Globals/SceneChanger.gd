extends CanvasLayer



onready var animation_player = $AnimationPlayer
onready var black = $Node/Black

func change_scene(path, delay = 0.0):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("fade")
