extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 16)
	sound_effects.play()
	$Hitbox.tool_name = "whirlwind spell"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func fade_out():
	fade_out_sound()
	$Tween.interpolate_property($AnimatedSprite, "modulate:a", 1.0, 0.0, 1.0, 3, 1)
	$Tween.start()


func fade_out_sound():
	$Tween.interpolate_property(sound_effects, "volume_db", Sounds.return_adjusted_sound_db("sound", 16), -80, 1.0, 1, Tween.EASE_IN, 0)
	$Tween.start()
