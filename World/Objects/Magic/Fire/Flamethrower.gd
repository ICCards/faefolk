extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -10)
	sound_effects.play()
	$Hitbox.tool_name = "flamethrower"
	$Fire.emitting = true
	$Smoke.emitting = true
	$AnimationPlayer.play("play")
	$Flamethrower.play("start")
	yield($Flamethrower, "animation_finished")
	$Flamethrower.play("loop")
	yield(get_tree().create_timer(3.0), "timeout")
	$Flamethrower.play("start", true)
	fade_out_sound()
	$Fire.emitting = false
	$Smoke.emitting = false
	yield($Flamethrower, "animation_finished")
	queue_free()

func fade_out_sound():
	$Tween.interpolate_property(sound_effects, "volume_db", Sounds.return_adjusted_sound_db("sound", -10), -80, 1.5, 1, Tween.EASE_IN, 0)
	$Tween.start()
