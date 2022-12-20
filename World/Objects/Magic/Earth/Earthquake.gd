extends Node2D

onready var sound_effects: AudioStreamPlayer = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	yield(get_tree().create_timer(3.0), "timeout")
	Server.player_node.get_node("Camera2D").start_shake()
	$Hitbox.tool_name = "earthquake"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	fade_out_sound()
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()


func fade_out_sound():
	$Tween.interpolate_property(sound_effects, "volume_db", Sounds.return_adjusted_sound_db("sound", -8), -80, 1.0, 1, Tween.EASE_IN, 0)
	$Tween.start()
