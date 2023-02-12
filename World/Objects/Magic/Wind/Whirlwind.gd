extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var is_hostile: bool = false

var tween = get_tree().create_tween()

func _ready():
	tween.tween_property($PointLight2D, "color", Color("ffffff"), 1.0)
	$Hitbox.tool_name = "whirlwind spell"
	if is_hostile:
		z_index = -1
		$Hitbox.set_collision_mask(128+2048+8+16)
		$AnimationPlayer.play("enemy")
	else:
		$AnimationPlayer.play("player")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 16)
	sound_effects.play()
	await $AnimationPlayer.animation_finished
	queue_free()

func fade_out():
	fade_out_sound()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 1.0)

func fade_out_sound():
	tween.tween_property(sound_effects, "volume_db", -80, 1.0)
	tween.tween_property($PointLight2D, "color", Color("00ffffff"), 1.0)
