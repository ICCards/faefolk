extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var is_hostile: bool = false

func _ready():
	$Tween.interpolate_property($Light2D, "color", Color("00ffffff"), Color("ffffff"), 1.0, 1, Tween.EASE_IN, 0)
	$Tween.start()
	$Hitbox.tool_name = "whirlwind spell"
	if is_hostile:
		z_index = -1
		$Hitbox.set_collision_mask(128+2048+8+16)
		$AnimationPlayer.play("enemy")
	else:
		$AnimationPlayer.play("player")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 16)
	sound_effects.play()
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func fade_out():
	fade_out_sound()
	$Tween.interpolate_property($AnimatedSprite, "modulate:a", 1.0, 0.0, 1.0, 3, 1)
	$Tween.start()


func fade_out_sound():
	$Tween.interpolate_property(sound_effects, "volume_db", Sounds.return_adjusted_sound_db("sound", 16), -80, 1.0, 1, Tween.EASE_IN, 0)
	$Tween.interpolate_property($Light2D, "color", Color("ffffff"), Color("00ffffff"), 1.0, 1, Tween.EASE_IN, 0)
	$Tween.start()
