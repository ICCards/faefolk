extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	$Hitbox.tool_name = "blizzard"
	$AnimationPlayer.play("play")
	yield(get_tree().create_timer(10.0), "timeout")
	queue_free()


func fade_out_sound():
	$Tween.interpolate_property(sound_effects, "volume_db", Sounds.return_adjusted_sound_db("sound", -14), -80, 1.0, 1, Tween.EASE_IN, 0)
	$Tween.start()
